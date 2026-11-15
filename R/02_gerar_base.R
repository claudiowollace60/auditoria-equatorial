# 02_gerar_base.R - base SIMULADA de registros do Intangivel (Nota 14), reconciliada linha a linha
# com a DFP 2025 da Equatorial S.A. (consolidado). Natureza: Simulado para fins didaticos.
source("R/00_config.R")
set.seed(SEED)

# Linhas da Nota 14 (PDF p.63): custo, amortizacao acumulada, obrigacoes vinculadas (R$ mil), taxa anual, n registros
L <- data.frame(
  linha = c("Dist - Em servico","DC - Maranhao","DC - Para","DC - Alagoas","DC - Piaui","DC - CEEE-D","DC - CEA",
            "Dist - Outros","San - DC CSA","San - Outros","Ger - Direito de exploracao","Ger - Direito de autorizacao","Ger - Outros"),
  segmento = c(rep("Distribuicao",8), rep("Saneamento",2), rep("Geracao",3)),
  custo = c(50098143,291810,172904,1196831,1714448,2786062,1199957,110226,735477,13262,2991127,2385402,77327),
  amort = c(-22916858,-218760,-170902,-270303,-415912,-522382,-163326,-19526,-96341,2081,-3156542,-294103,-13515),
  obrig = c(-3786596,rep(0,12)),
  taxa  = c(0.0423,0.0333,0.0333,0.0333,0.0333,0.0417,0.0333,0.10,0.0288,NA,0.0678,0.0322,0.10),
  n     = c(430000,6000,3000,8000,10000,12000,6000,20000,5000,2000,10000,5000,8000))
stopifnot(sum(L$custo) == 63772976, sum(L$amort) == -28256389, sum(L$obrig) == -3786596,
          sum(L$custo + L$amort + L$obrig) == 31729991, sum(L$n) >= 500000)

dist_sim <- c("Equatorial Maranhao","Equatorial Para","Equatorial Piaui","Equatorial Alagoas","Equatorial Goias","CEEE-D","CEA")
dist_pes <- c(.20,.19,.13,.12,.20,.10,.06)

gera_linha <- function(r) {
  n <- r$n
  # custo por registro: lognormal escalado para somar exatamente o custo da linha (em R$ mil, 3 casas = R$ 1)
  x <- rlnorm(n, 0, 1.15); c0 <- x / sum(x) * r$custo
  custo <- round(c0, 3); custo[which.max(custo)] <- custo[which.max(custo)] + round(r$custo - sum(custo), 3)
  if (!is.na(r$taxa)) {
    r_alvo <- -r$amort / r$custo; a_alvo <- r_alvo / r$taxa           # idade media-alvo (anos)
    vida <- 1 / r$taxa                                              # vida util em anos
    if (r_alvo < 1) {                                               # fracao amortizada ~ Beta com media r_alvo (limitada a 100%)
      u <- rbeta(n, 4 * r_alvo, 4 * (1 - r_alvo)); u <- pmin(pmax(u, 0.002), 1)
      for (it in 1:6) {                                             # ajusta media para fechar a amortizacao sem passar de 100%
        alvo <- r_alvo * sum(custo); atual <- sum(custo * u)
        livre <- u < 1; if (!any(livre) || abs(alvo - atual) < 1e-6) break
        u[livre] <- pmin(pmax(u[livre] * (1 + (alvo - atual) / sum(custo[livre] * u[livre])), 0.002), 1)
      }
      idade <- u * vida
    } else {                                                        # linhas em que a DFP mostra amortizacao >= custo (Direito de exploracao)
      idade <- runif(n, 0.2, 2 * a_alvo - 0.2); idade <- idade * (-r$amort) / sum(custo * r$taxa * idade)
    }
    am <- -round(custo * r$taxa * idade, 3)
    am[which.max(custo * (idade < vida * 0.999 | r_alvo >= 1))] <- am[which.max(custo * (idade < vida * 0.999 | r_alvo >= 1))] + round(r$amort - sum(am), 3)
    dt <- DATA_BASE - round(idade * 365.25)
    taxa <- rep(r$taxa, n)
  } else {                                   # San - Outros: amortizacao acumulada positiva na DFP (anomalia da propria nota)
    am <- round(custo / sum(custo) * r$amort, 3); am[1] <- am[1] + round(r$amort - sum(am), 3)
    dt <- DATA_BASE - sample(200:3000, n, TRUE); taxa <- rep(NA_real_, n)
  }
  ob <- rep(0, n)
  if (r$obrig != 0) {                         # obrigacoes vinculadas: rateio em ~35% dos registros
    sel <- sample.int(n, round(.35 * n)); w <- runif(length(sel)) * custo[sel]
    ob[sel] <- round(w / sum(w) * r$obrig, 3); ob[sel[1]] <- ob[sel[1]] + round(r$obrig - sum(ob), 3)
  }
  data.frame(linha_nota14 = r$linha, segmento = r$segmento, custo_mil = custo, amort_acum_mil = am,
             obrig_vinc_mil = ob, taxa_anual = taxa, data_incorporacao = dt)
}
b <- do.call(rbind, lapply(seq_len(nrow(L)), function(i) gera_linha(L[i, ])))
b$id_registro <- sprintf("INT-%06d", seq_len(nrow(b)))
b$unidade_negocio <- ifelse(b$linha_nota14 == "Dist - Em servico", sample(dist_sim, nrow(b), TRUE, dist_pes),
                     ifelse(grepl("^DC - ", b$linha_nota14), sub("DC - ", "", b$linha_nota14), b$segmento))
b$valor_liquido_mil <- round(b$custo_mil + b$amort_acum_mil + b$obrig_vinc_mil, 3)
b$origem_dado <- "SINTETICO"
b <- b[, c("origem_dado","id_registro","segmento","linha_nota14","unidade_negocio","data_incorporacao","taxa_anual",
           "custo_mil","amort_acum_mil","obrig_vinc_mil","valor_liquido_mil")]
b <- b[sample.int(nrow(b)), ]; b$id_registro <- sprintf("INT-%06d", seq_len(nrow(b)))   # embaralha e renumera
rownames(b) <- NULL
gabarito <- b                                   # base limpa (nao publicada como evidencia; usada como "valor auditado simulado")

# ---------- insercao de erros (log = gabarito de erros) ----------
log <- list(); add <- function(tipo, idx, desc, detectavel_por) {
  log[[length(log) + 1]] <<- data.frame(tipo_erro = tipo, id_registro = b$id_registro[idx], descricao = desc, desenhado_para = detectavel_por)
}
ok <- which(!is.na(b$taxa_anual) & b$custo_mil > 0 & b$linha_nota14 != "Ger - Direito de exploracao")
pool <- sample(ok, 1430); take <- function(k) { r <- head(pool, k); pool <<- tail(pool, -length(r)); r }
# E1 duplicidade (linha inteira duplicada com mesmo id) - 150
i <- take(150); dup <- b[i, ]; add("E1_duplicidade", i, "registro duplicado no fim da base (mesmo id_registro)", "teste de duplicidade de id")
# E2 liquido nao fecha (custo+amort+obrig) - 200
i <- take(200); b$valor_liquido_mil[i] <- b$valor_liquido_mil[i] + round(runif(length(i), 5, 400), 3)
add("E2_liquido_inconsistente", i, "valor liquido diferente de custo+amortizacao+obrigacoes", "teste de recalculo do liquido")
# E3 superamortizacao (amort > custo em linha que nao deveria) - 150
i <- take(150); b$amort_acum_mil[i] <- -b$custo_mil[i] * runif(length(i), 1.05, 1.5)
b$valor_liquido_mil[i] <- b$custo_mil[i] + b$amort_acum_mil[i] + b$obrig_vinc_mil[i]
add("E3_superamortizacao", i, "amortizacao acumulada maior que o custo", "teste amort > custo")
# E4 data futura - 100
i <- take(100); b$data_incorporacao[i] <- DATA_BASE + sample(30:400, length(i), TRUE)
add("E4_data_futura", i, "data de incorporacao posterior a 31/12/2025", "teste de corte/data")
# E5 taxa fora da faixa da linha - 150
i <- take(150); b$taxa_anual[i] <- b$taxa_anual[i] * sample(c(0.5, 2, 3), length(i), TRUE)
add("E5_taxa_incorreta", i, "taxa anual diferente da taxa da linha na Nota 14", "teste de taxa vs nota")
# E6 sinal invertido da amortizacao - 100
i <- take(100); b$amort_acum_mil[i] <- -b$amort_acum_mil[i]; b$valor_liquido_mil[i] <- b$custo_mil[i] + b$amort_acum_mil[i] + b$obrig_vinc_mil[i]
add("E6_sinal_invertido", i, "amortizacao acumulada com sinal positivo", "teste de sinal")
# E7 outlier de valor (custo x 50) - 80
i <- take(80); b$custo_mil[i] <- b$custo_mil[i] * 50; b$valor_liquido_mil[i] <- b$custo_mil[i] + b$amort_acum_mil[i] + b$obrig_vinc_mil[i]
add("E7_outlier_valor", i, "custo multiplicado por 50 (digitacao/escala)", "teste de valores atipicos")
# E8 NAO DETECTAVEL POR DESENHO: subamortizacao coerente (taxa e amortizacao recalculada, dentro da tolerancia de taxa da linha)
i <- take(300); nt <- b$taxa_anual[i] * 0.97                                   # -3%: dentro da tolerancia de 5% do teste de taxa
age <- as.numeric(DATA_BASE - b$data_incorporacao[i]) / 365.25
b$taxa_anual[i] <- nt; b$amort_acum_mil[i] <- -round(b$custo_mil[i] * nt * age, 3)
b$valor_liquido_mil[i] <- b$custo_mil[i] + b$amort_acum_mil[i] + b$obrig_vinc_mil[i]
add("E8_subamortizacao_coerente", i, "taxa 3% menor e amortizacao recalculada de forma coerente (passa nos testes aritmeticos)", "NENHUM (so analitico/estimativa)")
# E9 NAO DETECTAVEL POR DESENHO: ativo classificado em linha errada (valores coerentes; linhas com a mesma taxa 3,33%)
dc <- c("DC - Maranhao","DC - Para","DC - Alagoas","DC - Piaui","DC - CEA")
cand <- setdiff(which(b$linha_nota14 %in% dc & !is.na(b$taxa_anual) & b$custo_mil > 0), unlist(lapply(log, function(z) match(z$id_registro, b$id_registro))))
i <- sample(cand, 200)
novo <- vapply(b$linha_nota14[i], function(l) sample(setdiff(dc, l), 1), ""); b$linha_nota14[i] <- novo
b$unidade_negocio[i] <- sub("DC - ", "", novo)
add("E9_classificacao_incorreta", i, "registro de uma concessao classificado em outra com a mesma taxa (valores coerentes)", "NENHUM (requer evidencia externa)")
# cria inclusoes
b <- rbind(b, dup)
errlog <- do.call(rbind, log)
errlog$valor_distorcao_mil <- NA_real_
errlog$valor_distorcao_mil <- {
  g <- setNames(gabarito$valor_liquido_mil, gabarito$id_registro)
  cur <- setNames(b$valor_liquido_mil[!duplicated(b$id_registro)], b$id_registro[!duplicated(b$id_registro)])
  d <- cur[errlog$id_registro] - g[errlog$id_registro]
  ifelse(errlog$tipo_erro == "E1_duplicidade", g[errlog$id_registro], d)
}
errlog$valor_distorcao_mil <- round(as.numeric(errlog$valor_distorcao_mil), 3)
errlog$id_registro_ref <- errlog$id_registro
write.csv(b, gzfile(file.path(DIR$dados, "base_intangivel_2025.csv.gz")), row.names = FALSE)
write.csv(gabarito, gzfile(file.path(DIR$dados, "gabarito_base_limpa.csv.gz")), row.names = FALSE)
write.csv(errlog, file.path(DIR$dados, "log_erros_inseridos.csv"), row.names = FALSE)

dic <- data.frame(campo = names(b), descricao = c(
 "Marca de dado SINTETICO (nao e registro real da companhia)","Identificador do registro (unidade de cadastro simulada)","Segmento (Distribuicao/Saneamento/Geracao) - Nota 14",
 "Linha da Nota 14 a que o registro pertence","Distribuidora (alocacao SIMULADA; a Nota 14 nao abre Em servico por distribuidora)",
 "Data de incorporacao (SIMULADA, calibrada para fechar a amortizacao da Nota 14)","Taxa anual de amortizacao (Nota 14)",
 "Custo (R$ mil)","Amortizacao acumulada (R$ mil; negativa)","Obrigacoes vinculadas a concessao (R$ mil; negativa)","Valor liquido = custo+amortizacao+obrigacoes (R$ mil)"),
 unidade = c("-","-","-","-","-","data","% a.a.", rep("R$ mil",4)))
write.csv(dic, file.path(DIR$dados, "dicionario_dados.csv"), row.names = FALSE, fileEncoding = "UTF-8")
prem <- data.frame(premissa = c(
 "Os totais por linha (custo, amortizacao acumulada, obrigacoes vinculadas) reproduzem a Nota 14 da DFP 2025 (PDF p.63) e somam R$ 31.729.991 mil.",
 "A abertura em registros individuais NAO existe na DFP: a distribuicao de valores (lognormal), as datas e a alocacao por distribuidora sao simuladas (natureza: Simulado para fins didaticos).",
 "Datas calibradas para que custo x taxa x idade reproduza a amortizacao acumulada de cada linha.",
 "Erros sao inseridos APOS a reconciliacao; o log fica em dados/log_erros_inseridos.csv (gabarito do professor/auditor).",
 "Os erros E8 e E9 foram desenhados para NAO serem detectaveis pelos testes aritmeticos (limitacao assumida na avaliacao)."))
write.csv(prem, file.path(DIR$dados, "premissas_base.csv"), row.names = FALSE, fileEncoding = "UTF-8")
# reconciliacao da base LIMPA com a DFP
rec <- aggregate(cbind(custo_mil, amort_acum_mil, obrig_vinc_mil, valor_liquido_mil) ~ linha_nota14, gabarito, sum)
cat("Registros base com erros:", nrow(b), "| limpa:", nrow(gabarito), "\n")
cat("Soma liquido base limpa:", fmt(sum(gabarito$valor_liquido_mil), 3), "(DFP: 31.729.991)\n")
cat("Erros inseridos:", nrow(errlog), "\n"); print(table(errlog$tipo_erro))
