
# Auditoria 1 — Matriz de cobertura das NBC TA
# Matrícula: 242010937
# Projeto didático baseado nas demonstrações de 2025.
# A matriz não comprova auditoria real nem atendimento integral às normas.

codigos <- c(
  "EC", "200", "210", "220", "230", "240", "250",
  "260", "265", "300", "315", "320", "330", "402",
  "450", "500", "501", "505", "510", "520", "530",
  "540", "550", "560", "570", "580", "600"
)

temas <- c(
  "Estrutura Conceitual",
  "Objetivos gerais do auditor independente",
  "Termos do trabalho de auditoria",
  "Gestão de qualidade da auditoria",
  "Documentação de auditoria",
  "Responsabilidade do auditor relativa a fraude",
  "Consideração de leis e regulamentos",
  "Comunicação com os responsáveis pela governança",
  "Comunicação de deficiências de controle interno",
  "Planejamento da auditoria",
  "Identificação e avaliação dos riscos de distorção relevante",
  "Materialidade no planejamento e execução",
  "Respostas do auditor aos riscos avaliados",
  "Auditoria de entidade que utiliza organização prestadora de serviços",
  "Avaliação das distorções identificadas",
  "Evidência de auditoria",
  "Considerações específicas para itens selecionados",
  "Confirmações externas",
  "Trabalhos iniciais — saldos iniciais",
  "Procedimentos analíticos",
  "Amostragem em auditoria",
  "Estimativas contábeis",
  "Partes relacionadas",
  "Eventos subsequentes",
  "Continuidade operacional",
  "Representações formais",
  "Considerações especiais — auditorias de grupo"
)

areas <- c(
  "Transversal", "Transversal", "Aceitação e contratação", "Qualidade",
  "Papéis de trabalho", "Fraude", "Conformidade legal", "Governança",
  "Controles internos", "Planejamento", "Riscos", "Materialidade",
  "Respostas aos riscos", "Prestadores de serviços", "Distorções",
  "Evidências", "Itens específicos", "Confirmações", "Saldos iniciais",
  "Análise comparativa", "População e amostra", "Estimativas",
  "Partes relacionadas", "Eventos subsequentes", "Continuidade",
  "Representações", "Auditoria de grupo"
)

procedimentos <- c(
  "Relacionar conceitos fundamentais às etapas do trabalho.",
  "Documentar objetivos, alcance e limitações da simulação.",
  "Descrever precondições e termos hipotéticos do trabalho.",
  "Descrever requisitos de qualidade pertinentes ao planejamento.",
  "Organizar papéis de trabalho e referências cruzadas.",
  "Identificar riscos de fraude e respostas planejadas.",
  "Considerar aspectos legais e regulatórios pertinentes.",
  "Planejar comunicações hipotéticas com a governança.",
  "Descrever hipoteticamente deficiências e sua comunicação.",
  "Documentar estratégia e plano de auditoria.",
  "Mapear riscos por conta, afirmação e divulgação.",
  "Documentar os parâmetros ilustrativos de materialidade.",
  "Relacionar riscos aos procedimentos planejados.",
  "Avaliar conceitualmente riscos ligados a prestadores de serviços.",
  "Avaliar diferenças identificadas na simulação.",
  "Documentar a natureza e as limitações da evidência sintética.",
  "Avaliar a aplicabilidade de procedimentos específicos.",
  "Planejar confirmações externas; não realizadas.",
  "Descrever procedimentos para saldos iniciais, se aplicável.",
  "Documentar análises quantitativas sobre a base sintética.",
  "Documentar população, seleção e limitações da amostra ilustrativa.",
  "Planejar a avaliação de métodos, dados e premissas.",
  "Considerar identificação e divulgação de partes relacionadas.",
  "Planejar análise de eventos subsequentes.",
  "Considerar procedimentos de continuidade operacional.",
  "Planejar representações formais; nenhuma foi obtida.",
  "Considerar responsabilidades em auditoria de grupo."
)

normas <- data.frame(
  codigo = codigos,
  tema = temas,
  area_aplicacao = areas,
  procedimento_previsto = procedimentos,
  status = rep("Pendente de documentação específica", length(codigos)),
  evidencia = rep("A documentar ou confirmar", length(codigos)),
  limitacao = rep(
    "A descrição no relatório não comprova, isoladamente, atendimento integral à norma.",
    length(codigos)
  ),
  stringsAsFactors = FALSE
)

# Normas com atividades já documentadas no relatório e/ou resultados.
# O status indica documentação parcial, não cumprimento integral da norma.
documentadas <- c(
  "EC", "200", "230", "300", "315", "320", "330", "450", "500", "520", "530"
)

normas$status[normas$codigo %in% documentadas] <-
  "Documentação parcial; revisão pendente"

normas$evidencia[normas$codigo == "EC"] <-
  "Seções 2, 3 e 11 do relatório; conferir referência à Estrutura Conceitual"

normas$evidencia[normas$codigo == "200"] <-
  "Seções 2, 6, 11 e 12 do relatório"

normas$evidencia[normas$codigo == "230"] <-
  "Seção 8; arquivos de papéis de trabalho e resultados"

normas$evidencia[normas$codigo == "300"] <-
  "Seções 5, 6 e 9; programas de auditoria"

normas$evidencia[normas$codigo == "315"] <-
  "Seção 5; matriz de riscos e afirmações"

normas$evidencia[normas$codigo == "320"] <-
  "Seção 5; parâmetros ilustrativos de materialidade"

normas$evidencia[normas$codigo == "330"] <-
  "Seções 5 e 9; procedimentos planejados relacionados aos riscos"

normas$evidencia[normas$codigo == "450"] <-
  "Seções 6 e 7; resultados de exceções na base sintética"

normas$evidencia[normas$codigo == "500"] <-
  "Base sintética de 500.000 registros; resultados CSV; seções 6 a 8"

normas$evidencia[normas$codigo == "520"] <-
  "Seções 6 e 7; testes analíticos sobre dados sintéticos"

normas$evidencia[normas$codigo == "530"] <-
  "Seção 6.6; amostra ilustrativa de 100 registros e limitações"

# Mantém as limitações explícitas para as normas com testes sintéticos.
normas$limitacao[normas$codigo %in% c("450", "500", "520", "530")] <-
  paste(
    "Procedimentos limitados a dados sintéticos;",
    "não constituem evidência sobre registros reais."
  )

if (!dir.exists("resultados")) {
  dir.create("resultados", recursive = TRUE)
}

write.csv(
  normas,
  "resultados/08_matriz_cobertura_NBC_TA.csv",
  row.names = FALSE,
  na = "",
  fileEncoding = "UTF-8"
)

cat("Matriz de cobertura atualizada.\n")
cat("Referências registradas:", nrow(normas), "\n")
cat(
  "Com documentação parcial:",
  sum(normas$status == "Documentação parcial; revisão pendente"),
  "\n"
)
cat("Arquivo: resultados/08_matriz_cobertura_NBC_TA.csv\n")
cat("Atenção: documentação parcial não equivale a atendimento integral.\n")


