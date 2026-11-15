# 06_mus.R - NBC TA 530: amostragem por unidade monetaria (MUS) no Intangivel + avaliacao (Stringer) - PT 20 / PT 14
source("R/00_config.R")
set.seed(SEED + 6)
b   <- read.csv(file.path(DIR$dados, "base_intangivel_2025.csv.gz"), stringsAsFactors = FALSE)
gab <- read.csv(file.path(DIR$dados, "gabarito_base_limpa.csv.gz"), stringsAsFactors = FALSE)
mat <- read.csv(file.path(DIR$res, "02_materialidade_adotada.csv"))
ME  <- mat$valor_mil[grepl("Erro tol", mat$item)]
conf <- 0.95; RF <- round(qgamma(conf, 1), 2)                      # fator de confianca 3,00 (zero erros esperados)
J <- ME / RF
# valor "auditado simulado" = base limpa (gabarito); linha duplicada nao existe na base limpa => auditado = 0
b$linha <- seq_len(nrow(b)); b$dup2 <- duplicated(b$id_registro)
b$auditado_mil <- gab$valor_liquido_mil[match(b$id_registro, gab$id_registro)]; b$auditado_mil[b$dup2] <- 0

stringer <- function(tt, J, conf = .95) {
  tt <- sort(tt[tt > 0], decreasing = TRUE); m <- length(tt)
  R <- qgamma(conf, 0:m + 1); basic <- R[1] * J
  inc <- if (m) sum(J * tt * (R[-1] - R[-(m + 1)])) else 0
  c(erros = m, precisao_basica = basic, incremento = inc, limite_superior = basic + inc, melhor_estimativa = J * sum(tt))
}
run_mus <- function(pop, tag, seed) {
  set.seed(seed)
  pos <- pop[pop$valor_liquido_mil > 0, ]; zer <- sum(pop$valor_liquido_mil == 0); neg <- pop[pop$valor_liquido_mil < 0, ]
  V <- sum(pos$valor_liquido_mil)
  chave <- pos[pos$valor_liquido_mil >= J, ]; resto <- pos[pos$valor_liquido_mil < J, ]
  Vr <- sum(resto$valor_liquido_mil); n_mus <- ceiling(Vr / J)
  inicio <- runif(1, 0, J); cum <- cumsum(resto$valor_liquido_mil); pontos <- inicio + (0:(n_mus - 1)) * J
  idx <- unique(pmin(findInterval(pontos, c(0, cum), left.open = TRUE), nrow(resto))); amostra <- resto[idx, ]
  param <- data.frame(parametro = c("Populacao positiva (R$ mil)","Registros positivos","Registros com liquido = 0 (totalmente amortizados)","Registros com liquido < 0",
    "Soma liquido < 0 (R$ mil)","Erro toleravel ME (R$ mil)","Nivel de confianca","Fator de confianca (zero erros esperados)","Intervalo de amostragem J = ME/FC (R$ mil)",
    "Itens-chave >= J (100%)","Valor dos itens-chave (R$ mil)","Valor do restante (R$ mil)","Tamanho da amostra MUS (restante)","Partida aleatoria","Semente"),
    valor = c(round(V,1), nrow(pos), zer, nrow(neg), round(sum(neg$valor_liquido_mil),1), ME, conf, RF, round(J,1), nrow(chave), round(sum(chave$valor_liquido_mil),1),
              round(Vr,1), nrow(amostra), round(inicio,2), seed))
  write.csv(param, file.path(DIR$res, paste0("14_mus_parametros_", tag, ".csv")), row.names = FALSE, fileEncoding = "UTF-8")
  if (nrow(chave)) chave$estrato <- "Item-chave (100%)"; amostra$estrato <- "Amostra MUS"
  sel <- rbind(chave, amostra)
  sel$diferenca_mil <- round(sel$valor_liquido_mil - sel$auditado_mil, 3)
  sel$taint <- ifelse(sel$valor_liquido_mil != 0, sel$diferenca_mil / sel$valor_liquido_mil, 0)
  write.csv(sel[, c("id_registro","linha_nota14","estrato","valor_liquido_mil","auditado_mil","diferenca_mil","taint")],
            file.path(DIR$res, paste0("15_mus_amostra_selecionada_", tag, ".csv")), row.names = FALSE)
  am <- sel[sel$estrato == "Amostra MUS", ]
  over <- stringer(am$taint[am$taint > 0], J); under <- stringer(-am$taint[am$taint < 0], J)
  kc_o <- sum(sel$diferenca_mil[sel$estrato != "Amostra MUS" & sel$diferenca_mil > 0]); kc_u <- -sum(sel$diferenca_mil[sel$estrato != "Amostra MUS" & sel$diferenca_mil < 0])
  ls_o <- over["limite_superior"] + kc_o; ls_u <- under["limite_superior"] + kc_u
  aval <- data.frame(medida = c("Erros na amostra (n)","Precisao basica (R$ mil)","Incremento por erros (R$ mil)","Limite superior de erro da amostra (R$ mil)",
    "Melhor estimativa projetada (R$ mil)","Erro conhecido em itens-chave (R$ mil)","Limite superior total (R$ mil)","Erro toleravel ME (R$ mil)","Conclusao"),
    superavaliacao = c(over["erros"], round(over[c("precisao_basica","incremento","limite_superior","melhor_estimativa")],1), round(kc_o,1), round(ls_o,1), ME,
      ifelse(ls_o > ME, "LS > ME: nao ha base para concluir que o saldo esta livre de distorcao relevante; propor ajuste e ampliar testes","LS <= ME: amostra suporta a conclusao")),
    subavaliacao = c(under["erros"], round(under[c("precisao_basica","incremento","limite_superior","melhor_estimativa")],1), round(kc_u,1), round(ls_u,1), ME,
      ifelse(ls_u > ME, "LS > ME: ampliar testes","LS <= ME: amostra suporta a conclusao")))
  write.csv(aval, file.path(DIR$res, paste0("16_mus_avaliacao_stringer_", tag, ".csv")), row.names = FALSE, fileEncoding = "UTF-8")
  cat("\n==", tag, "== n =", nrow(amostra), "chave =", nrow(chave), "erros(sobre) =", over["erros"], "LS_sobre =", round(ls_o,1), "LS_sub =", round(ls_u,1), "\n")
  invisible(list(param = param, aval = aval, sel = sel))
}
# 1) populacao como registrada (com erros)
r1 <- run_mus(b, "original", SEED + 6)
# 2) populacao apos corrigir os registros sinalizados pelos testes aritmeticos (PT 15): E8 e E9 permanecem
fl <- unique(read.csv(file.path(DIR$res, "06_registros_sinalizados.csv"))$id_registro)
bc <- b[!(b$dup2), ]; k <- bc$id_registro %in% fl
bc$valor_liquido_mil[k] <- gab$valor_liquido_mil[match(bc$id_registro[k], gab$id_registro)]
r2 <- run_mus(bc, "pos_correcao", SEED + 7)

g <- expand.grid(ME = c(ME, ME/2, mat$valor_mil[1]), conf = c(.90, .95, .99))
pos0 <- b[b$valor_liquido_mil > 0, ]
g$FC <- round(qgamma(g$conf, 1), 2); g$J <- round(g$ME / g$FC, 0)
g$n_aprox <- mapply(function(j) ceiling(sum(pos0$valor_liquido_mil[pos0$valor_liquido_mil < j]) / j) + sum(pos0$valor_liquido_mil >= j), g$J)
g$ME_rotulo <- ifelse(g$ME == ME, "ME = execucao", ifelse(g$ME == mat$valor_mil[1], "ME = global", "ME = execucao/2"))
write.csv(g, file.path(DIR$res, "17_mus_sensibilidade_n.csv"), row.names = FALSE, fileEncoding = "UTF-8")
print(r1$param); print(r1$aval); print(r2$aval); print(g)
