# 10_programas_minutas.R - programas de auditoria por area, minutas e lista de pendencias
source("R/00_config.R")
rd <- function(f) read.csv(file.path(DIR$res, f), stringsAsFactors = FALSE)
mat <- rd("02_materialidade_adotada.csv"); MG <- mat$valor_mil[1]; ME <- mat$valor_mil[2]
mp <- rd("16_mus_avaliacao_stringer_pos_correcao.csv"); mo <- rd("16_mus_avaliacao_stringer_original.csv")
LSO <- as.numeric(mo$superavaliacao[mo$medida == "Limite superior total (R$ mil)"]); LSP <- as.numeric(mp$superavaliacao[mp$medida == "Limite superior total (R$ mil)"])
prog <- function(arq, titulo, saldo, riscos, afirm, passos) {
  tb <- c("| # | Procedimento | Tipo | Natureza | PT |", "|---|---|---|---|---|",
          sapply(seq_along(passos), function(i) sprintf("| %d | %s | %s | %s | %s |", i, passos[[i]][1], passos[[i]][2], passos[[i]][3], passos[[i]][4])))
  writeLines(c(paste0("# Programa de auditoria - ", titulo), "", paste0("**Entidade:** ", ENTIDADE, " | **Exercício:** ", EXERCICIO, " | **Preparador:** matrícula ", MATRICULA, " | **Data:** ", DATA_ELAB),
    paste0("**Saldo (DFP, R$ mil):** ", saldo), paste0("**Materialidade (PT 320):** global R$ ", fmt(MG), " mil; execução R$ ", fmt(ME), " mil."),
    paste0("**Riscos:** ", riscos), paste0("**Afirmações:** ", afirm), "", tb, "", "**Revisão:** PENDENTE"),
    file.path(DIR$prog, arq), useBytes = TRUE)
}
R <- "Realizado com evidência pública"; P <- "Planejado por falta de acesso"; S <- "Simulado para fins didáticos"
prog("01_receitas.md", "Receitas", "ROL 52.073.804 (DRE p.11); receita não faturada 1.546.475 (KAM p.4)",
 "Corte de receita não faturada (estimativa); receita de construção (margem zero); parcela A e CDE.", "Ocorrência, corte, valorização.",
 list(c("Recalcular ROL conforme Nota 27 (p.103) e conciliar com a DRE","Reconciliação","R","PT 520"),
      c("Expectativa independente da receita de construção versus investimento (adições + transferências Nota 14.1)","Analítico","R","PT 520"),
      c("Testar corte de receita não faturada em amostra de ciclos de leitura","Detalhes","P","PT 501"),
      c("Confirmar parcela A / CDE com ANEEL e CCEE","Confirmação","P","PT 505"),
      c("Testar lançamentos manuais de receita (burla)","Detalhes","S","PT 240")) |> lapply(function(x) {x[3] <- switch(x[3], R=R, P=P, S=S); x}))
prog("02_disponibilidades.md", "Disponibilidades (caixa e equivalentes)", "2.659.827 (BP p.10; Nota 4)",
 "Existência e restrições de saldos; aplicações a valor justo.", "Existência, direitos, apresentação.",
 list(c("Conciliar Nota 4 ao BP e à DFC","Reconciliação","R","PT 500"),
      c("Confirmar saldos bancários e aplicações","Confirmação","P","PT 505"),
      c("Testar cut-off de transferências no fim do exercício","Detalhes","P","PT 505"),
      c("Avaliar restrição/garantia (Nota 18.3)","Inquirição","P","PT 250")) |> lapply(function(x) {x[3] <- switch(x[3], R=R, P=P, S=S); x}))
prog("03_estoques.md", "Estoques (almoxarifado)", "291.436 (BP p.10); base de IR diferido sobre provisão para perdas de estoques: 64.285 (Nota 21)",
 "Obsolescência; valorização ao custo médio; segregação de obras em curso.", "Existência, valorização.",
 list(c("Obter razão do almoxarifado e recalcular custo médio em amostra","Detalhes","P","PT 501"),
      c("Acompanhar inventário físico e fazer test counts","Observação","P","PT 501"),
      c("Avaliar provisão para perdas: base de cálculo e histórico","Estimativa","P","PT 540"),
      c("Analítico: giro do almoxarifado (291.436 em 2025 versus 150.896 em 2024, +93%)","Analítico","R","PT 520")) |> lapply(function(x) {x[3] <- switch(x[3], R=R, P=P, S=S); x}))
prog("04_imobilizado_intangivel.md", "Imobilizado e Intangível (conta-alvo)", "Intangível 31.729.991; Imobilizado 6.540.907 (BP p.10; Notas 13-14)",
 "Capitalização indevida, vida útil, impairment, classificação entre linhas, obrigações vinculadas.", "Existência, valorização, classificação, apresentação.",
 list(c("Reconciliar Nota 14, Nota 14.1 e BP; investigar diferenças (1.741; 156.591)","Reconciliação","R","PT 500"),
      c("Testes aritméticos na base (8 testes) e comparação inserido x detectado","Detalhes","S","PT 500"),
      c(sprintf("MUS: itens-chave >= J e amostra; Stringer (LS pré %s; pós %s; ME %s)", fmt(LSO), fmt(LSP), fmt(ME)),"Amostragem","S","PT 530"),
      c("Analítico de amortização por classe (expectativa x registrado)","Analítico","R","PT 520"),
      c("Teste de classificação entre linhas (E9): inspeção de cadastro/obras","Detalhes","P","PT 330"),
      c("Sensibilidade das taxas de amortização (+/-10%, +/-20%)","Estimativa","S","PT 540")) |> lapply(function(x) {x[3] <- switch(x[3], R=R, P=P, S=S); x}))
prog("05_passivos.md", "Passivos (dívida, provisões, tributos)", "Empréstimos 20.978.503; debêntures 33.493.260; provisão para riscos judiciais 4.749.734 (BP p.10; Notas 18, 19, 23)",
 "Subavaliação de provisões; covenants; classificação circulante/não circulante.", "Integridade, obrigações, apresentação.",
 list(c("Recalcular encargos e conciliar Nota 18.2 ao BP","Reconciliação","R","PT 500"),
      c("Verificar covenants (dívida líquida/EBITDA ≤ 4,5) – Nota 18.6","Inquirição","R","PT 570"),
      c("Confirmar saldos com credores e debenturistas","Confirmação","P","PT 505"),
      c("Cartas de advogados e teste de probabilidade das provisões judiciais","Detalhes","P","PT 501"),
      c("Pesquisar passivos não registrados em janeiro/2026","Detalhes","P","PT 560")) |> lapply(function(x) {x[3] <- switch(x[3], R=R, P=P, S=S); x}))
prog("06_estimativas.md", "Estimativas contábeis (impairment, PECLD, vida útil)", "Impairment 3.391.261; PECLD 4.288.252 (Notas 6, 16)",
 "Viés da administração; premissas de WACC/crescimento; horizonte da autorização.", "Valorização, apresentação.",
 list(c("Ler Nota 16: UGCs, WACC (8,00% Echo; 8,49% CSA; 8,03% distribuidoras), valor recuperável","Inquirição","R","PT 315"),
      c("Sensibilidade WACC x g e horizonte (simulada, calibrada ao valor recuperável)","Estimativa","S","PT 540"),
      c("Recalcular PECLD: 29,4% do bruto (4.288.252 / 14.603.816) versus 29,8% em 2024","Analítico","R","PT 520"),
      c("Obter modelo de fluxo de caixa da administração e testar premissas","Estimativa","P","PT 540"),
      c("Avaliar divulgação da diferença de 156.591 no impairment","Divulgação","R","PT 500")) |> lapply(function(x) {x[3] <- switch(x[3], R=R, P=P, S=S); x}))

dir.create(DIR$min, showWarnings = FALSE)
writeLines(c("# Estrutura didática de relatório (SIMULADA) - NÃO é opinião de auditor", "",
 "*Este documento ilustra a estrutura de relatório (NBC TA 700/705/706/701) para fins didáticos. O preparador não é auditor independente da companhia e não emite opinião.*", "",
 "## Conclusão do trabalho didático",
 paste0("Com base em dados públicos e dados sintéticos, os testes identificaram distorções na base sintética do Intangível (R$ ", fmt(855050), " mil de diferença contra a Nota 14), explicadas em R$ 854.668 mil pelos testes. Nenhuma opinião é expressa sobre as demonstrações da Equatorial S.A."), "",
 "## Principais assuntos (a partir do relatório do auditor da companhia, EY, 25/03/2026)",
 "1. Redução ao valor recuperável (Nota 16): perda de R$ 3.391.261 mil; respostas: PT 540 e PT 315.",
 "2. Receita de energia distribuída e não faturada: R$ 1.546.475 mil; respostas: PT 520 e programa de receitas.", "",
 "## Limitações", "Acesso apenas público; base sintética; testes de controles e confirmações não executados.", "", "Revisão: PENDENTE"),
 file.path(DIR$min, "relatorio_didatico.md"), useBytes = TRUE)
writeLines(c("# Minuta - Carta de recomendações à administração (SIMULADA)", "",
 "1. **Validação de valores atípicos no cadastro do Intangível** (E7: R$ 808.236 mil de distorção; deficiência significativa).",
 "2. **Bloqueio de duplicidade de ID** no cadastro patrimonial (E1: 150 registros duplicados).",
 "3. **Cálculo automático de amortização** com trava de amortização acumulada ≤ custo e sinal (E2, E3, E6).",
 "4. **Trava de data de incorporação** posterior ao fechamento (E4).",
 "5. **Parametrização de taxas** por classe, com aprovação (E5, E8).",
 "6. **Divulgação do impairment (Nota 16):** reconciliar o total declarado (R$ 3.391.261 mil) com os componentes (R$ 3.547.852 mil) e as Notas 14/14.1 (diferença de R$ 1.741 mil).", "",
 "Revisão: PENDENTE"), file.path(DIR$min, "carta_recomendacoes.md"), useBytes = TRUE)
writeLines(c("# Minuta - Carta de representação da administração (SIMULADA)", "",
 "À [Firma de auditoria], em 31/12/2025, reconhecemos nossa responsabilidade pela elaboração das demonstrações contábeis conforme CPC/IFRS e declaramos que:",
 "- Fornecemos todas as informações e acesso solicitados.", "- Todas as transações estão refletidas nas demonstrações.",
 "- As estimativas (impairment, PECLD, vida útil) usam premissas razoáveis e consistentes com a intenção da administração.",
 "- Partes relacionadas e eventos subsequentes foram integralmente divulgados.", "- Não há fraude conhecida envolvendo a administração.", "",
 "[Assinatura - fictícia]", "", "Revisão: PENDENTE"), file.path(DIR$min, "carta_representacao.md"), useBytes = TRUE)

writeLines(c("# Minuta didática - Carta de contratação de auditoria", "", "*Modelo didático (NBC TA 210). Não foi enviada nem assinada.*", "",
 "**Contratante (simulado):** Administração da Equatorial S.A. | **Auditor (simulado):** preparador, matrícula 242010937", "",
 "1. **Objetivo:** auditoria das demonstrações contábeis individuais e consolidadas do exercício findo em 31/12/2025, para expressar opinião sobre sua adequação (em trabalho real).",
 "2. **Alcance:** consolidado; conta-alvo Intangível (R$ 31.729.991 mil); procedimentos conforme NBC TA 200 a 600.",
 "3. **Responsabilidades da administração:** elaborar as DFs conforme CPC/IFRS; controle interno; fornecer acesso integral e carta de representações.",
 "4. **Responsabilidades do auditor:** obter segurança razoável; comunicar deficiências significativas; independência.",
 "5. **Estrutura do relatório:** conforme NBC TA 700 (R1), com principais assuntos de auditoria (NBC TA 701).",
 "6. **Precondições:** estrutura aplicável aceitável (CPC/IFRS); responsabilidades reconhecidas; acesso (NÃO atendido - fontes públicas apenas).", "",
 "[Assinaturas - fictícias, não simuladas]", "", "Revisão: PENDENTE"), file.path(DIR$min, "carta_contratacao.md"), useBytes = TRUE)
writeLines(c("# Minuta didática - Comunicação com os responsáveis pela governança", "",
 "*Não enviada. NBC TA 260 (R2).*", "",
 "1. **Alcance e época:** auditoria do consolidado 2025, conta-alvo Intangível; planejamento antes do fechamento e conclusão antes da emissão do relatório.",
 "2. **Riscos significativos:** impairment (R$ 3.391.261 mil; mais-valia Echo R$ 2.359.265 mil), amortização/vida útil, receita não faturada (R$ 1.546.475 mil) e provisões judiciais (R$ 4.749.734 mil).",
 "3. **Independência:** declaração didática de ausência de vínculo; sem serviços prestados à companhia.",
 "4. **Principais dificuldades:** acesso restrito a fontes públicas; base de dados sintética.",
 "5. **Deficiências significativas:** D01, D03, D10, D12 (matriz em resultados/26_matriz_deficiencias.csv).", "", "Revisão: PENDENTE"),
 file.path(DIR$min, "comunicacao_governanca.md"), useBytes = TRUE)
writeLines(c("# Modelos de solicitação de confirmação externa (NÃO ENVIADOS)", "",
 "*Controle em resultados/31_pt505_controle_circularizacao.csv. Vedado contatar terceiros (instruções do P2).*", "",
 "## Modelo A - Banco/credor", "Prezados, pedimos confirmar diretamente ao auditor, em 31/12/2025: saldo de caixa/aplicações, empréstimos, garantias e covenants. Resposta direta; não use este contato para outros fins.", "",
 "## Modelo B - Cliente", "Confirmar saldo a receber (faturado e vencido) em 31/12/2025 e eventuais disputas.", "",
 "## Modelo C - Advogado", "Informar processos em que a companhia é parte, valor, probabilidade de perda e opinião sobre a suficiência da provisão.", "",
 "## Tratamento de diferenças e alternativos", "Diferenças acima do trivial (R$ 13.000 mil): reconciliar com o razão e registrar no PT 450. Sem resposta: procedimentos alternativos conforme controle (recebimentos/pagamentos subsequentes, extratos, contratos)."),
 file.path(DIR$min, "modelos_circularizacao.md"), useBytes = TRUE)
pend <- data.frame(id = c("P-00","P-01","P-02","P-03","P-07","P-13","P-16","P-17","P-19-1","P-21","P-22","P-25","P-26","P-06"),
 descricao = c("Concluída: para 2025 valem a NBC TA 240 (R1) e a versão da 570 anterior à R1; as revisões de 25/09/2026 valem só a partir de períodos iniciados em 01/01/2027 (CFC, notícia de 28/09/2026). Resta conferir o número da resolução das versões anteriores","Concluída: link direto do PDF e data de download (11/11/2026) registrados em fontes/controle_fontes.csv","Obter carta de contratação","Obter política de qualidade/independência","Agendar comunicação com governança",
   "Obter relatórios SOC dos prestadores","Acompanhar inventário e obter cartas de advogados","Enviar confirmações externas","Obter abertura de taxas, baixas e transferências do Intangível (diferença de R$ 720.175 mil em Em serviço)",
   "Obter modelo de fluxo de caixa do impairment","Obter lista de partes relacionadas e razão","Obter carta de representação assinada","Identificar auditores dos componentes","Obter contratos de concessão e comunicações com a ANEEL"),
 pt = c("Matriz","PT 200","PT 210","PT 220","PT 260","PT 402","PT 501","PT 505","PT 520","PT 540","PT 550","PT 580","PT 600","PT 250"), situacao = "Aberta")
pend$situacao[pend$id %in% c("P-00","P-01")] <- "Concluída"
write.csv(pend, file.path(DIR$res, "pendencias.csv"), row.names = FALSE, fileEncoding = "UTF-8")
dir.create("docs", showWarnings = FALSE)
writeLines(c("# Conclusão integrada", "",
 "**Natureza:** conclusão de um trabalho didático. O preparador (matrícula 242010937) **não emitiu opinião profissional independente** sobre as demonstrações da Equatorial S.A.", "",
 "**Riscos identificados (PT 315):** 13 riscos mapeados por conta e afirmação; significativos: impairment (R$ 3.391.261 mil; mais-valia Echo R$ 2.359.265 mil), vida útil e amortização do Intangível, receita não faturada (R$ 1.546.475 mil) e provisões judiciais (R$ 4.749.734 mil, reversões de R$ 1.749.649 mil).", "",
 "**Procedimentos realizados e evidências:** (i) com evidência pública: reconciliações Balanço x Notas 14, 14.1 e 16, movimentação das provisões (Nota 23), partes relacionadas (Nota 9), eventos subsequentes (Nota 38; corte em 25/03/2026), analíticos, materialidade (0,5% da receita líquida = R$ 260.000 mil), continuidade operacional e grupo; (ii) em dados sintéticos: base de 525.150 registros do Intangível, oito testes, comparação de 1.430 erros inseridos com 930 detectados, MUS e sensibilidade; (iii) planejados por falta de acesso: testes de controles, confirmações, inventário, cartas de advogados, contratos de concessão e modelo de impairment da administração.", "",
 "**Resultados principais:** diferença de R$ 855.050 mil entre a base com erros e a Nota 14 (explicada em R$ 854.668 mil); MUS pré-correção com limite superior de R$ 1.724.180 mil (> R$ 195.000 mil) e pós-correção de R$ 194.723 mil; impairment sensível (taxa de desconto +1 p.p. = +R$ 321.085 mil); diferenças da própria DFP (R$ 1.741 mil entre Notas 14/14.1; R$ 156.591 mil no impairment) e amortização de Distribuição - Em serviço R$ 720.175 mil acima da expectativa.", "",
 "**Limitações:** acesso restrito a fontes públicas; base individual sintética (somente os totais por linha são reais); premissas de fluxo de caixa hipotéticas; erros E8/E9 não detectáveis por testes aritméticos; versões das normas 240 e 570 a confirmar para o exercício; revisão pendente em todos os PTs.", "",
 "**Conclusão:** os saldos públicos do Intangível são internamente coerentes (Balanço = Nota 14 = Nota 14.1), com exceções pontuais registradas; para concluir sobre estimativas, classificação e controles seria necessário acesso interno (P-00 a P-26). Nenhuma opinião é expressa."),
 "docs/conclusao_integrada.md", useBytes = TRUE)
cat("OK 10\n")
