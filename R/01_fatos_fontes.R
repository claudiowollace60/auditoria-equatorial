# 01_fatos_fontes.R - fatos extraidos da DFP 2025 (com pagina) e controle de fontes
source("R/00_config.R")
doc <- "Demonstracoes Financeiras Anuais Completas - Equatorial S.A. (exercicio 2025)"
f <- function(id, conta, v25, v24, pg, nota, obs = "")
  data.frame(id_fato = id, conta = conta, valor_2025_mil = v25, valor_2024_mil = v24,
             documento = doc, pagina_pdf = pg, pagina_impressa = pg - 2, referencia = nota, observacao = obs)
fatos <- rbind(
 f("F01","Receita operacional liquida (consolidado)",52073804,43760753,11,"DRE"),
 f("F02","Resultado antes do IR e CS (consolidado)",2455004,2743305,11,"DRE"),
 f("F03","Lucro liquido do exercicio (consolidado)",2503931,3767805,11,"DRE"),
 f("F04","Total do ativo (consolidado)",109603944,116412092,10,"BP"),
 f("F05","Patrimonio liquido total (consolidado)",28327947,29887586,10,"BP"),
 f("F06","Intangivel (consolidado) - maior conta do ativo nao circulante; conta-alvo do trabalho",31729991,32373681,10,"BP / Nota 14","Instrucao do P2: conta-alvo = Intangivel"),
 f("F07","Ativo financeiro da concessao",19135756,15865088,10,"BP / Nota 12"),
 f("F08","Imobilizado",6540907,7579662,10,"BP / Nota 13"),
 f("F09","Caixa e equivalentes de caixa",2659827,3306364,10,"BP / Nota 4"),
 f("F10","Contas a receber de clientes - circulante",9491337,8538999,10,"BP / Nota 6"),
 f("F11","Almoxarifado",291436,150896,10,"BP"),
 f("F12","Total do ativo circulante",26604996,28527347,10,"BP"),
 f("F13","Total do passivo circulante",17803899,19605210,10,"BP"),
 f("F14","Emprestimos e financiamentos (circ.+ nao circ.)",20978503,26904571,74,"Nota 18.2"),
 f("F15","Debentures (circ. 913.945 + nao circ. 32.579.315)",33493260,28922507,10,"BP / Nota 19"),
 f("F16","Provisao para riscos judiciais (circ. 1.551.426 + nao circ. 3.198.308)",4749734,5301015,10,"BP / Nota 23"),
 f("F17","Intangivel - custo (Nota 14)",63772976,NA,63,"Nota 14"),
 f("F18","Intangivel - amortizacao acumulada (Nota 14)",-28256389,NA,63,"Nota 14"),
 f("F19","Intangivel - obrigacoes vinculadas a concessao (Nota 14)",-3786596,NA,63,"Nota 14"),
 f("F20","Intangivel - valor liquido (Nota 14)",31729991,NA,63,"Nota 14"),
 f("F21","Intangivel - Em servico Distribuicao: custo 14 vs 14.1",50098143,50099884,63,"Nota 14 vs 14.1","Diferenca de 1.741 no custo e na amortizacao (efeito liquido nulo)"),
 f("F22","Intangivel - amortizacao do exercicio (Nota 14.1)",-2964751,NA,65,"Nota 14.1"),
 f("F23","Perda por impairment no intangivel (Nota 14.1)",-2659780,NA,65,"Nota 14.1","Mais-valia Echo 2.359.265 + CSA 300.515"),
 f("F24","Impairment total declarado (Nota 16)",3391261,0,68,"Nota 16"),
 f("F25","Impairment - componentes (CSA 308.806 + Echo 879.781 + mais-valia 2.359.265)",3547852,0,68,"Nota 16","Diferenca de 156.591 em relacao ao total declarado"),
 f("F26","Mais-valia Echo Participacoes - valor recuperavel",4053163,NA,69,"Nota 16"),
 f("F27","WACC antes de impostos - Echo Participacoes",8.00,NA,69,"Nota 16.1","percentual a.a."),
 f("F28","Contas a receber bruto (Nota 6)",14603816,13421251,42,"Nota 6.1"),
 f("F29","PECLD (Nota 6)",-4288252,-3997455,42,"Nota 6.1"),
 f("F30","Receita de construcao - distribuicao",10601331,8377887,103,"Nota 27"),
 f("F31","Receita de construcao - saneamento",105029,155580,103,"Nota 27"),
 f("F32","Receita nao faturada (KAM)",1546475,1318952,4,"Relatorio do auditor / Nota 6"),
 f("F33","Covenant divida liquida/EBITDA (limite <= 4,5; apurado entre 1,8 e 2,8)",4.5,NA,77,"Nota 18.6","limite contratual"),
 f("F34","Amortizacao e depreciacao (DFC)",2754796,NA,14,"DFC")
)
write.csv(fatos, file.path(DIR$fontes, "fatos_dfp_2025.csv"), row.names = FALSE, fileEncoding = "UTF-8")

fontes <- data.frame(
 id_fonte = sprintf("S%02d", 1:9),
 documento = c(doc,
   "Relatório do auditor independente (Ernst & Young Auditores Independentes S/S Ltda.), parte da DFP 2025",
   "Orientações do trabalho P2 - Auditoria 1 (UnB), turma 02, 2026.2",
   "NBC TA e Estrutura Conceitual - lista de normas e versões (CFC)",
   "Portal de empresas da CVM (consulta externa de documentos)",
   "B3 - página do emissor EQTL3",
   "Portal de Relações com Investidores da Equatorial",
   "Nota 1 da DFP - denominação e código de negociação (Equatorial S.A.; EQTL3; Novo Mercado desde 2008)",
   "Notícias de mercado sobre EQTL3 (apenas contexto; não usadas como evidência de saldo)"),
 endereco_eletronico = c("https://api.mziq.com/mzfilemanager/v2/d/62b21cba-838c-49a4-aaef-e0fb2350c169/3aa51483-7588-83ea-e6a9-a0fce1eef634?origin=2 (link direto do PDF, hospedado pelo RI; página de origem: https://ri.equatorialenergia.com.br/informacoes-financeiras/central-de-resultados/)",
   "Mesmo arquivo (PDF p.3-9)",
   "Material da disciplina (Moodle/UnB)",
   "https://cfc.org.br/tecnica/normas-brasileiras-de-contabilidade/nbc-ta-de-auditoria-independente/ ; vigência da NBC TA 240 (R2) e 570 (R1): https://cfc.org.br/noticias/cfc-atualiza-normas-de-auditoria-sobre-fraudes-e-continuidade-operacional/ (notícia de 28/09/2026)",
   "https://www.rad.cvm.gov.br (acesso a confirmar)",
   "https://www.b3.com.br (acesso a confirmar)",
   "https://ri.equatorialenergia.com.br/informacoes-financeiras/central-de-resultados/ (página confirmada em 11/11/2026)",
   "Mesmo arquivo (PDF p.16)",
   "https://acionista.com.br (consulta por busca; página não recuperada)"),
 data_acesso = c("11/11/2026 (download informado pelo aluno)", DATA_ELAB, DATA_ELAB, DATA_ELAB, "não acessado", "não acessado", DATA_ELAB, DATA_ELAB, DATA_ELAB),
 pagina = c("conforme fatos_dfp_2025.csv", "3-9", "-", "página única", "-", "-", "-", "16", "-"),
 exercicio = c(2025, 2025, 2026, "vigentes em 2026", NA, NA, NA, 2025, 2026),
 uso = c("Todos os saldos e notas", "KAMs, data do relatório (25/03/2026)", "Estrutura exigida", "Versões das normas (matriz de cobertura)", "Localização futura de fatos relevantes (PT 560 planejado)", "Código de negociação", "Download da DFP", "Alterações de nome/código", "Contexto"))
fontes$observacao <- c("Fonte primária", "Fonte primária", "Instrução", "Consultada em 11/11/2026", "Planejado - não executado", "Planejado - não executado", "Planejado - não executado", "Fonte primária",
  "Sem recuperação do texto; não citada em nenhum cálculo")
write.csv(fontes, file.path(DIR$fontes, "controle_fontes.csv"), row.names = FALSE, fileEncoding = "UTF-8")
cat("OK 01:", nrow(fatos), "fatos\n")
