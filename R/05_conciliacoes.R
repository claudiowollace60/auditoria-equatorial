# 05_conciliacoes.R - conciliacoes base x DFP, Nota 14 x 14.1 x BP, impairment (NBC TA 500/510/450) - PT 15, 18, 14
source("R/00_config.R")
b <- read.csv(file.path(DIR$dados, "base_intangivel_2025.csv.gz"), stringsAsFactors = FALSE)
log <- read.csv(file.path(DIR$dados, "log_erros_inseridos.csv"), stringsAsFactors = FALSE)
T <- read.csv(file.path(DIR$res, "06_registros_sinalizados.csv"), stringsAsFactors = FALSE)
n14 <- data.frame(
  linha_nota14 = c("Dist - Em servico","DC - Maranhao","DC - Para","DC - Alagoas","DC - Piaui","DC - CEEE-D","DC - CEA",
                   "Dist - Outros","San - DC CSA","San - Outros","Ger - Direito de exploracao","Ger - Direito de autorizacao","Ger - Outros"),
  dfp_liquido_mil = c(23394689,73050,2002,926528,1298536,2263680,1036631,90700,639136,15343,-165415,2091299,63812))
stopifnot(sum(n14$dfp_liquido_mil) == 31729991)
base_l <- aggregate(valor_liquido_mil ~ linha_nota14, b, sum)
r1 <- merge(n14, base_l, by = "linha_nota14", all.x = TRUE)
r1$diferenca_mil <- round(r1$valor_liquido_mil - r1$dfp_liquido_mil, 3)
r1$dif_pct <- round(100 * r1$diferenca_mil / abs(r1$dfp_liquido_mil), 2)
tot <- data.frame(linha_nota14 = "TOTAL", dfp_liquido_mil = sum(r1$dfp_liquido_mil), valor_liquido_mil = sum(r1$valor_liquido_mil),
                  diferenca_mil = round(sum(r1$diferenca_mil), 3), dif_pct = round(100 * sum(r1$diferenca_mil) / sum(r1$dfp_liquido_mil), 2))
r1 <- rbind(r1, tot); names(r1)[3] <- "base_liquido_mil"
write.csv(r1, file.path(DIR$res, "10_conciliacao_base_x_nota14.csv"), row.names = FALSE)

# explicacao da diferenca total pelos erros detectados (liquido) x nao detectados
ids_det <- unique(T$id_registro)
log$det <- log$id_registro %in% ids_det
expl <- data.frame(componente = c("Diferenca total base x DFP","Explicada por erros detectados","Residual (nao explicado pelos testes)"),
  valor_mil = c(tot$diferenca_mil, round(sum(log$valor_distorcao_mil[log$det]), 3), NA))
expl$valor_mil[3] <- round(expl$valor_mil[1] - expl$valor_mil[2], 3)
write.csv(expl, file.path(DIR$res, "11_explicacao_diferenca_base.csv"), row.names = FALSE)

# Nota 14 x 14.1 x Balanco
c2 <- data.frame(
  verificacao = c("BP (Intangivel) = Nota 14 total","Nota 14 total = Nota 14.1 total (2025)","Nota 14.1 2024 = BP 2024",
                  "Em servico: custo Nota 14 vs 14.1","Em servico: amortizacao Nota 14 vs 14.1","Em servico: liquido (apos obrigacoes) Nota 14 vs 14.1",
                  "Impairment no intangivel: Nota 14.1 (mais-valia + CSA)","Impairment total: componentes x total declarado Nota 16"),
  valor_a = c(31729991, 31729991, 32373681, 50098143, -22916858, 23394689, -2659780, 3547852),
  valor_b = c(31729991, 31729991, 32373681, 50099884, -22918599, 27181285-3786596, -(2359265+300515), 3391261))
c2$diferenca <- c2$valor_a - c2$valor_b
c2$conclusao <- ifelse(c2$diferenca == 0, "Concilia", "Diferenca - investigar")
c2$comentario <- c("PDF p.10 e p.63","PDF p.63 e p.65","PDF p.10 e p.65",
  "Diferenca de 1.741 (custo)","Diferenca de 1.741 (amortizacao): mesma diferenca, efeito liquido nulo",
  "Concilia em termos liquidos: 14 e 14.1 divergem apenas na abertura custo/amortizacao",
  "2.359.265 + 300.515 = 2.659.780","Componentes (CSA 308.806 + Echo 879.781 + mais-valia 2.359.265) excedem o total declarado em 156.591 - solicitar abertura a administracao")
write.csv(c2, file.path(DIR$res, "12_conciliacao_dfp_notas.csv"), row.names = FALSE, fileEncoding = "UTF-8")

# NBC TA 450 - acumulacao de distorcoes detectadas (factuais) e projecao do nao detectado
fact <- aggregate(valor_distorcao_mil ~ tipo_erro, log[log$det, ], function(x) round(sum(x), 1))
write.csv(fact, file.path(DIR$res, "13_distorcoes_detectadas_por_tipo.csv"), row.names = FALSE)
print(r1); print(expl); print(c2[, c(1, 4, 5)])
