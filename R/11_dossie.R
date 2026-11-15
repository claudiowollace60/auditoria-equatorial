# 11_dossie.R - monta o dossie (Markdown -> HTML -> PDF) com referencias cruzadas
source("R/00_config.R")
rd <- function(f) read.csv(file.path(DIR$res, f), stringsAsFactors = FALSE, check.names = FALSE)
tab <- function(d, dig = 1) {
  d[] <- lapply(d, function(x) if (is.numeric(x)) vapply(x, function(v) if (is.na(v)) "" else if (abs(v - round(v)) < 1e-9) formatC(v, format = "f", digits = 0, big.mark = ".", decimal.mark = ",") else formatC(v, format = "f", digits = dig, big.mark = ".", decimal.mark = ","), "") else as.character(x))
  c(paste0("| ", paste(names(d), collapse = " | "), " |"), paste0("|", paste(rep("---", ncol(d)), collapse = "|"), "|"),
    apply(d, 1, function(r) paste0("| ", paste(gsub("\\|", "/", r), collapse = " | "), " |")), "")
}
# figuras
tp <- rd("07_inserido_vs_detectado_por_tipo.csv")
png("dossie/figuras/fig_inserido_detectado.png", 1100, 600, res = 130); par(mar = c(4.5, 10, 3, 1))
m <- rbind(tp$detectados, tp$nao_detectados); colnames(m) <- sub("^E[0-9]_", "", tp$tipo_erro)
barplot(m, horiz = TRUE, las = 1, col = c("#2f855a", "#c53030"), main = "Erros inseridos: detectados x não detectados", xlab = "Registros")
legend("bottomright", c("Detectados", "Não detectados"), fill = c("#2f855a", "#c53030"), bty = "n"); dev.off()
sel <- rd("15_mus_amostra_selecionada_original.csv")
png("dossie/figuras/fig_mus_taint.png", 1100, 600, res = 130); par(mar = c(4.5, 4.8, 3, 1))
er <- sel[sel$taint != 0, ]
plot(er$valor_liquido_mil, er$taint * 100, log = "x", pch = 16, col = "#2b6cb0", xlab = "Valor contábil do item (R$ mil, escala log)", ylab = "Taint (% do valor)",
     main = "MUS pré-correção: itens com diferença na amostra"); abline(h = 0, lty = 2, col = "gray50"); dev.off()

mat <- rd("02_materialidade_adotada.csv"); bm <- rd("01_materialidade_benchmarks.csv")
pts <- rd("pts_27.csv"); cob <- rd("matriz_cobertura_nbc_ta.csv")
ev <- rd("07_inserido_vs_detectado_por_tipo.csv"); rs <- rd("08_inserido_vs_detectado_resumo.csv")
cn <- rd("10_conciliacao_base_x_nota14.csv"); c2 <- rd("12_conciliacao_dfp_notas.csv")
po <- rd("14_mus_parametros_original.csv"); ao <- rd("16_mus_avaliacao_stringer_original.csv"); ap <- rd("16_mus_avaliacao_stringer_pos_correcao.csv")
sg <- rd("17_mus_sensibilidade_n.csv"); um <- rd("19_sensibilidade_um_fator.csv"); vu <- rd("20_sensibilidade_vida_util.csv"); an <- rd("21_analitico_amortizacao.csv"); ind <- rd("22_analitico_indices.csv")
fx <- rd("../fontes/fatos_dfp_2025.csv"); fo <- rd("../fontes/controle_fontes.csv"); cj <- rd("00_justificativa_conta_alvo.csv")
mr <- rd("23_matriz_riscos.csv"); mrs <- rd("24_matriz_respostas_riscos.csv"); md <- rd("25_mapa_distorcoes.csv"); df <- rd("26_matriz_deficiencias.csv"); ae <- rd("27_avaliacao_evidencias.csv")
li <- rd("28_pt501_litigios.csv"); pr <- rd("29_pt550_partes_relacionadas.csv"); cp <- rd("30_pt600_componentes.csv"); cc <- rd("31_pt505_controle_circularizacao.csv"); pend <- rd("pendencias.csv")
just <- readLines(file.path(DIR$res, "04_materialidade_justificativa.txt"), encoding = "UTF-8")
nat <- as.data.frame(table(pts$natureza)); names(nat) <- c("Natureza", "Quantidade de PTs")
M <- c(
"---", "title: \"Dossiê de Auditoria - Equatorial S.A. (consolidado) - Exercício 2025\"",
paste0("subtitle: \"Auditoria 1 - P2 | Matrícula ", MATRICULA, " | Conta-alvo: Intangível | ", DATA_ELAB, "\""), "lang: pt-BR", "---", "",
"# 1. Sumário executivo", "",
"Este dossiê **substitui integralmente** o trabalho anterior, que usava valores de uma controlada (Equatorial Maranhão/Pará/Piauí) e uma materialidade de 1% de R$ 15.199.199 mil sem relação com o consolidado. A entidade correta é a **holding Equatorial S.A.** (antes Equatorial Energia S.A.), com demonstrações **consolidadas** de 31/12/2025.", "",
"| Item | Valor |", "|---|---|",
"| Receita operacional líquida (DRE p.11) | R$ 52.073.804 mil |", "| Total do ativo (BP p.10) | R$ 109.603.944 mil |",
"| **Conta-alvo: Intangível (BP p.10; Nota 14 p.63)** | **R$ 31.729.991 mil (28,9% do ativo)** |",
paste0("| Materialidade global / execução / trivial | R$ ", fmt(mat$valor_mil[1]), " / ", fmt(mat$valor_mil[2]), " / ", fmt(mat$valor_mil[3]), " mil |"),
paste0("| Base simulada | 525.150 registros (limpa: 525.000), reconciliada à Nota 14 |"),
paste0("| Erros inseridos / detectados | ", rs$valor[1], " / ", rs$valor[2], " (recall ", rs$valor[5], "%; precisão ", rs$valor[6], "%) |"),
paste0("| MUS pré-correção | ", sub("\\.0$", "", ao$superavaliacao[1]), " erros na amostra; LS R$ ", fmt(as.numeric(ao$superavaliacao[7])), " mil > ME R$ ", fmt(mat$valor_mil[5]), " mil |"),
paste0("| MUS pós-correção | 0 erros; LS R$ ", fmt(as.numeric(ap$superavaliacao[7])), " mil ≤ ME |"), "",
"**Natureza dos 27 PTs** (classificação oficial das instruções):", "", tab(nat), "",
"**Achados principais:** (i) diferença de R$ 855.050 mil entre a base e a Nota 14, explicada em R$ 854.668 mil pelos testes (PT 500); (ii) diferença de R$ 156.591 mil entre o total do impairment e seus componentes na DFP (PT 315/PT 500); (iii) diferença não explicada de R$ 720.175 mil na amortização de Distribuição - Em serviço (PT 520); (iv) impairment sensível: WACC +1 p.p. aumenta a perda em R$ 321.085 mil, acima da materialidade global (PT 540).", "",
"# 2. Entidade, escopo e fontes (PT 200, PT 230, PT 300)", "",
"**Identificação:** denominação atual **Equatorial S.A.** (anteriormente Equatorial Energia S.A., conforme a lista do professor); código de negociação **EQTL3** na B3, Novo Mercado desde 2008 (Nota 1, PDF p.16). A data da mudança de denominação não foi confirmada em fonte pública (pendência P-01). Auditor da companhia: Ernst & Young Auditores Independentes S/S Ltda.; relatório de 25/03/2026.", "",
"**Escolha da conta (instrução §3):** a conta de maior materialidade do ativo é o **Intangível**, 28,9% do ativo total, maior que o ativo financeiro da concessão (17,5%):", "", tab(cj), "",
"Fatos extraídos da DFP, com página do PDF (página impressa = PDF − 2):", "",
tab(fx[, c("id_fato","conta","valor_2025_mil","valor_2024_mil","pagina_pdf","referencia")]),
"# 3. Materialidade (PT 320)", "", "Seis benchmarks foram calculados e comparados (NBC TA 320):", "",
tab(bm[, c("base","valor_mil","mat_min_mil","mat_max_mil")]), "", tab(mat), "", paste0("> ", just), "",
"# 4. Base de dados simulada (PT 500, PT 230)", "",
"A base reproduz **linha a linha** a Nota 14 (custo R$ 63.772.976 mil; amortização R$ −28.256.389 mil; obrigações vinculadas R$ −3.786.596 mil; líquido R$ 31.729.991 mil). A abertura em registros individuais é **simulada** (semente 242010937). Dicionário e premissas: `dados/dicionario_dados.csv` e `dados/premissas_base.csv`.", "",
"# 5. Testes, erros inseridos e detectados (PT 240, PT 265, PT 450, PT 500)", "",
"Foram inseridos 1.430 erros em nove tipos (log em `dados/log_erros_inseridos.csv`). Os tipos **E8** e **E9** foram desenhados para escapar dos testes aritméticos.", "",
tab(ev), "", tab(rs), "", "![](figuras/fig_inserido_detectado.png)", "",
"**Leitura crítica (C5/C6):** o recall de 100% em E1-E7 é em parte circular, pois os testes foram desenhados a partir dos tipos inseridos. O resultado informativo é o que **escapa**: E8 e E9 (500 registros) só seriam encontrados com evidência externa ou procedimento analítico/estimativa.", "",
"# 6. Reconciliações (PT 500, PT 510)", "", "Base com erros x Nota 14, por linha:", "", tab(cn), "", "DFP: Balanço x Nota 14 x Nota 14.1 x Nota 16:", "", tab(c2[, c("verificacao","valor_a","valor_b","diferenca","conclusao")]), "",
"# 7. Amostragem por unidade monetária (PT 530, PT 450)", "", "Parâmetros (população como registrada):", "", tab(po), "", "Avaliação de Stringer - **pré-correção**:", "", tab(ao), "", "**Pós-correção** dos registros sinalizados:", "", tab(ap), "",
"![](figuras/fig_mus_taint.png)", "", "Sensibilidade do tamanho da amostra (executada):", "", tab(sg[, c("ME_rotulo","conf","FC","J","n_aprox")], 2), "",
"# 8. Estimativas e sensibilidade (PT 540)", "",
"Premissas **simuladas**: horizonte 20 anos, crescimento nominal 3,5%; fluxo calibrado ao valor recuperável de R$ 4.053.163 mil (Nota 16, p.69). Resultados de um fator:", "", tab(um), "", "Vida útil (taxas ±10%/±20% sobre a despesa esperada):", "", tab(vu), "", "![](figuras/fig_sens_wacc_g.png)", "",
"# 9. Procedimentos analíticos (PT 520)", "", tab(an[, c("classe","registrado_mil","esperado_mil","diferenca_mil","dif_pct","acima_limiar")]), "", tab(ind[, c("indice","v2025","v2024","variacao_rel_pct","leitura")], 4), "",
"# 10. Matriz de cobertura (Estrutura Conceitual e NBC TA 200-600) e papéis de trabalho", "", tab(cob[, c("pt","versao_norma","titulo","natureza","status_cobertura")]), "",
"Programas de auditoria: receitas, disponibilidades, estoques, imobilizado/intangível, passivos e estimativas (`programas_auditoria/01..06`). Minutas e modelos: `minutas/`. Índice e convenção: `docs/`.", "",
"# 11. Matrizes do roteiro", "",
"**PT 315 - matriz de riscos por conta e afirmação:**", "", tab(mr[, c("id","conta","afirmacao","risco_inerente","significativo","resposta")]), "",
"**PT 330 - respostas aos riscos (natureza, época, extensão):**", "", tab(mrs[, c("risco","teste","tipo","epoca","extensao","status","pt")]), "",
"**PT 450 - mapa de distorções:**", "", tab(md[, c("tipo_erro","inseridos","detectados","valor_distorcao_mil","status","efeito_quantitativo_x_materialidade")]), "",
"**PT 265 - deficiências (constatações x hipóteses):**", "", tab(df[, c("id","condicao","efeito_mil","tipo","significancia")]), "",
"**PT 500 - avaliação das evidências:**", "", tab(ae[, c("fonte","relevancia","confiabilidade","suficiencia")]), "",
"**PT 501 - litígios (Nota 23, executado):**", "", tab(li[, c("natureza","provisao_2024","adicoes","utilizacao","reversao","atualizacao","reclassificacao","provisao_2025_nota","diferenca")]), "",
"**PT 550 - partes relacionadas (Nota 9, executado):**", "", tab(pr[, c("grupo","saldo_2025","saldo_2024","resultado_2025")]), "",
"**PT 600 - componentes do grupo:**", "", tab(cp[, c("componente","intangivel_mil","pct_intangivel","significancia","materialidade_componente_mil")]), "",
"**PT 505 - controle de circularização (nada enviado):**", "", tab(cc[, c("id","destinatario","saldo_mil","status")]), "",
"# 12. Fontes", "", tab(fo[, c("id_fonte","documento","endereco_eletronico","data_acesso","pagina","exercicio")]), "",
"# 13. Conclusão integrada", "", paste(readLines("docs/conclusao_integrada.md", encoding = "UTF-8")[-1], collapse = "\n"), "",
"# 14. Pendências e limitações", "", tab(pend), "",
"Limitações: base individual simulada; premissas de fluxo e horizonte hipotéticas; versões das normas a confirmar no CFC; campos de revisão pendentes em todos os PTs.", "",
"# Anexo A - Papéis de trabalho (27: PT EC, PT 200 a PT 600)", "")
for (i in seq_len(nrow(pts))) {
  p <- pts[i, ]
  M <- c(M, paste0("## ", p$codigo, " - ", p$titulo), "", paste0("*", p$natureza, "* | ", p$norma_itens), "",
    paste0("**Objetivo:** ", p$objetivo), "", paste0("**Conta/processo/divulgação:** ", p$conta_processo_divulgacao), "",
    paste0("**Afirmações:** ", p$afirmacoes, " | **Riscos:** ", p$riscos), "", paste0("**População, fontes e critérios:** ", p$populacao_fontes_criterios), "",
    paste0("**Procedimentos:** ", p$procedimentos), "", paste0("**Evidências e referências:** ", p$evidencias_referencias), "",
    paste0("**Resultados:** ", p$resultados, " | **Exceções:** ", p$excecoes), "", paste0("**Conclusão:** ", p$conclusao, " | **Limitações:** ", p$limitacoes), "",
    paste0("*Preparador: ", p$preparador, " - ", p$data_elaboracao, " - Revisão: ", p$revisao, "*"), "")
}
writeLines(M, "dossie/dossie_P2.md", useBytes = TRUE)
css <- "@page{size:A4;margin:14mm}body{font-family:Georgia,serif;font-size:10.5pt;line-height:1.38;max-width:980px;margin:auto;padding:18px;color:#1a202c}h1{font-size:17pt;border-bottom:2px solid #2b6cb0;padding-bottom:3px;margin-top:26px}h2{font-size:12.5pt;color:#2b6cb0}table{border-collapse:collapse;font-size:8.5pt;width:100%;margin:8px 0}th,td{border:1px solid #cbd5e0;padding:3px 5px;vertical-align:top}th{background:#edf2f7}img{max-width:100%}blockquote{border-left:3px solid #2b6cb0;margin:8px 0;padding:2px 10px;color:#2d3748;background:#f7fafc}@media print{h1{page-break-before:auto}h2{page-break-after:avoid}table{page-break-inside:auto}tr{page-break-inside:avoid}}"
writeLines(css, "dossie/estilo.css")
system2("pandoc", c("dossie/dossie_P2.md", "-o", "dossie/dossie_P2.html", "--standalone", "--embed-resources", "--resource-path=dossie", "-c", "dossie/estilo.css", "--toc", "--toc-depth=1"))
cat("OK 11: dossie_P2.md/html\n")
