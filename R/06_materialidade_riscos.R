
# Auditoria 1 — Materialidade e avaliação de riscos
# Matrícula: 242010937
# Critérios acadêmicos ilustrativos; não são dados reais da auditoria.

if (!dir.exists("resultados")) {
  dir.create("resultados", recursive = TRUE)
}

# Valores publicados na Nota Explicativa 11 — demonstrações de 2025
# Unidade: R$ mil
ativo_financeiro_bruto <- 21062007
obrigacoes_especiais <- -5862808
ativo_financeiro_liquido <- ativo_financeiro_bruto + obrigacoes_especiais

# Premissa metodológica ilustrativa:
# usar 1% do saldo líquido como referência preliminar.
# O percentual foi escolhido para fins acadêmicos e deve ser justificado.
percentual_materialidade <- 0.01

materialidade_global <- abs(ativo_financeiro_liquido) *
  percentual_materialidade

# Materialidade de execução ilustrativa:
# 75% da materialidade global, como premissa acadêmica.
percentual_execucao <- 0.75
materialidade_execucao <- materialidade_global * percentual_execucao

# Limite ilustrativo para acumulação de distorções claramente triviais:
# 5% da materialidade global.
percentual_trivial <- 0.05
limite_trivial <- materialidade_global * percentual_trivial

calculos <- data.frame(
  indicador = c(
    "Ativo financeiro bruto",
    "Obrigações especiais",
    "Ativo financeiro líquido de referência",
    "Percentual ilustrativo de materialidade",
    "Materialidade global preliminar",
    "Percentual ilustrativo de materialidade de execução",
    "Materialidade de execução preliminar",
    "Percentual ilustrativo para itens claramente triviais",
    "Limite preliminar para itens claramente triviais"
  ),
  valor = c(
    ativo_financeiro_bruto,
    obrigacoes_especiais,
    ativo_financeiro_liquido,
    percentual_materialidade * 100,
    materialidade_global,
    percentual_execucao * 100,
    materialidade_execucao,
    percentual_trivial * 100,
    limite_trivial
  ),
  unidade = c(
    "R$ mil", "R$ mil", "R$ mil", "%", "R$ mil",
    "%", "R$ mil", "%", "R$ mil"
  ),
  premissa = c(
    "Valor de referência da demonstração publicada",
    "Valor de referência da demonstração publicada",
    "Bruto menos obrigações especiais",
    "Premissa acadêmica; não fornecida pelo professor",
    "Saldo líquido multiplicado pelo percentual escolhido",
    "Premissa acadêmica ilustrativa",
    "Materialidade global multiplicada pelo percentual de execução",
    "Premissa acadêmica ilustrativa",
    "Materialidade global multiplicada pelo percentual trivial"
  ),
  stringsAsFactors = FALSE
)

# Mapeamento preliminar de riscos e afirmações.
# Os riscos são hipóteses para planejamento, não achados reais.
riscos <- data.frame(
  area = c(
    "Mensuração do ativo financeiro",
    "Existência e direitos",
    "Integridade dos registros",
    "Corte de operações",
    "Apresentação e divulgação",
    "Obrigações especiais vinculadas"
  ),
  afirmacao = c(
    "Avaliação",
    "Existência e direitos e obrigações",
    "Integridade",
    "Corte",
    "Apresentação e divulgação",
    "Classificação e avaliação"
  ),
  risco_hipotetico = c(
    "Premissas de mensuração inadequadas ou cálculo incorreto",
    "Registro sem suporte suficiente ou direito não demonstrado",
    "Operações relevantes não registradas na população",
    "Registro em período contábil inadequado",
    "Divulgação incompleta ou classificação inadequada",
    "Dedução ou classificação incorreta das obrigações especiais"
  ),
  resposta_planejada = c(
    "Inspecionar premissas e recalcular valores, se houver evidência disponível",
    "Inspecionar documentação original; não disponível nesta simulação",
    "Conciliar população e saldo de referência; reconhecer a limitação da base sintética",
    "Testar datas e documentos em registros disponíveis; nesta etapa, apenas simulação",
    "Comparar demonstrações e notas explicativas publicadas",
    "Recalcular a conciliação entre ativo bruto, obrigações e saldo líquido"
  ),
  status = "Planejado; não representa execução real",
  stringsAsFactors = FALSE
)

write.csv(
  calculos,
  "resultados/09_materialidade.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

write.csv(
  riscos,
  "resultados/10_matriz_riscos.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

cat("Arquivos de materialidade e riscos criados.\n")
cat("Saldo líquido de referência (R$ mil):",
    format(ativo_financeiro_liquido, big.mark = ".", decimal.mark = ","), "\n")
cat("Materialidade global ilustrativa (R$ mil):",
    format(materialidade_global, big.mark = ".", decimal.mark = ","), "\n")
cat("Materialidade de execução ilustrativa (R$ mil):",
    format(materialidade_execucao, big.mark = ".", decimal.mark = ","), "\n")
cat("Arquivos: resultados/09_materialidade.csv e resultados/10_matriz_riscos.csv\n")
cat("ATENÇÃO: percentuais são premissas acadêmicas, não parâmetros oficiais.\n")
