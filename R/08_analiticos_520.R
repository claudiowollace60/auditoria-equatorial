# 08_analiticos_520.R - NBC TA 520: procedimentos analiticos substantivos com expectativa independente (dados publicos DFP 2025) - PT 19
source("R/00_config.R")
mat <- read.csv(file.path(DIR$res, "02_materialidade_adotada.csv")); LIM <- mat$valor_mil[2]   # limiar de investigacao = materialidade de execucao
# (a) Expectativa da amortizacao do intangivel por classe: custo medio (Nota 14.1: 2024 e 2025) x taxa media da Nota 14
cm <- function(a, b) (a + b) / 2
tx_dc <- sum(c(291810,172904,1196831,1714448,2786062,1199957) * c(.0333,.0333,.0333,.0333,.0417,.0333)) / 7362012
exp_tab <- data.frame(
  classe = c("Distribuicao - Em servico (bruto)","Distribuicao - Obrigacoes especiais (reduz amortizacao)","Distribuicao - Direito de concessao",
             "Saneamento - Direito de concessao CSA","Geracao - Direito de autorizacao"),
  custo_medio_mil = c(cm(44650571,50099884), cm(6929251,8299661), cm(7208332,7208332), cm(1213182,999146+0), cm(2385402,2385402)),
  taxa = c(.0423,.0423,tx_dc,.0288,.0322),
  registrado_mil = c(2974983, 572927, 269976, 34700, 76722))
exp_tab$esperado_mil <- round(exp_tab$custo_medio_mil * exp_tab$taxa)
exp_tab$diferenca_mil <- exp_tab$registrado_mil - exp_tab$esperado_mil
exp_tab$dif_pct <- round(100 * exp_tab$diferenca_mil / exp_tab$esperado_mil, 1)
exp_tab$acima_limiar <- abs(exp_tab$diferenca_mil) > LIM
liq <- data.frame(classe = "Distribuicao - Em servico, liquido de obrigacoes especiais",
  custo_medio_mil = NA, taxa = NA, registrado_mil = 2974983 - 572927,
  esperado_mil = exp_tab$esperado_mil[1] - exp_tab$esperado_mil[2])
liq$diferenca_mil <- liq$registrado_mil - liq$esperado_mil; liq$dif_pct <- round(100 * liq$diferenca_mil / liq$esperado_mil, 1); liq$acima_limiar <- abs(liq$diferenca_mil) > LIM
exp_tab <- rbind(exp_tab, liq)
exp_tab$conclusao <- ifelse(exp_tab$acima_limiar, "Diferenca acima do limiar: nao explicada com dados publicos - solicitar abertura de taxas/baixas/transferencias (PT19, pendencia P-19-1)", "Dentro do limiar: expectativa corrobora o registrado")
write.csv(exp_tab, file.path(DIR$res, "21_analitico_amortizacao.csv"), row.names = FALSE, fileEncoding = "UTF-8")

# (b) Indices 2025 x 2024 (dados publicos)
ind <- data.frame(
  indice = c("Crescimento da ROL","PECLD / contas a receber bruto","Prazo medio de recebimento (dias, CR liquido circ.+nc / ROL)","Intangivel / Ativo total",
             "Caixa / Ativo circulante","Capital circulante liquido (R$ mil)","Divida bruta (emprest.+deb.) / PL","Receita de construcao / ROL","Amortizacao e depreciacao (DFC) / ROL"),
  v2025 = c(52073804/43760753-1, 4288252/14603816, (9491337+824227)/52073804*365, 31729991/109603944, 2659827/26604996, 26604996-17803899,
            (20978503+33493260)/28327947, (10601331+105029)/52073804, 2754796/52073804),
  v2024 = c(NA, 3997455/13421251, (8538999+884797)/43760753*365, 32373681/116412092, 3306364/28527347, 28527347-19605210,
            (26904571+28922507)/29887586, (8377887+155580)/43760753, 2185353/43760753))
ind$variacao_rel_pct <- round(100 * (ind$v2025 / ind$v2024 - 1), 1)
ind[, c("v2025","v2024")] <- lapply(ind[, c("v2025","v2024")], function(x) round(x, 4))
ind$leitura <- c("ROL +19% a/a: receita de construcao (+25%), parcela A e CDE (Nota 27)","Estavel; cobertura do PECLD sobre o bruto cerca de 29%","Prazo medio de recebimento cai de ~79 para ~72 dias",
  "Peso do Intangivel sobe: ativo total cai 5,9% (venda da transmissao) e Intangivel cai 2,0% (impairment de R$ 2,66 bi e transferencias)","Queda de caixa; liquidez ainda positiva","CCL positivo nos dois anos: sem indicio de continuidade (PT24)",
  "Alavancagem sobre PL; covenants contratuais sao liquida/EBITDA (Nota 18.6)","Receita de construcao tem margem proxima de zero (ICPC 01)","Despesa de amortizacao acompanha crescimento da base")
write.csv(ind, file.path(DIR$res, "22_analitico_indices.csv"), row.names = FALSE, fileEncoding = "UTF-8")

# (c) Receita de construcao x investimento: expectativa = transferencias para ativo de contrato (Nota 14.1) + adicoes imobilizado nao disponiveis -> registrado como limitacao
print(exp_tab[, c("classe","registrado_mil","esperado_mil","diferenca_mil","dif_pct","acima_limiar")]); print(ind[, 1:4])
