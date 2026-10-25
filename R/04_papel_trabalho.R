

# Auditoria 1 — Papel de trabalho PT 500/530
# Equatorial Energia Distribuição S.A.
# Matrícula: 242010937
# Uso acadêmico: dados sintéticos, sem evidência de auditoria real.

if (!file.exists("dados/base_ativo_concessao_sintetica.csv.gz")) {
  stop("Execute primeiro R/01_gerar_base.R.")
}

base <- read.csv(
  gzfile("dados/base_ativo_concessao_sintetica.csv.gz"),
  stringsAsFactors = FALSE,
  na.strings = ""
)

# Referências das demonstrações financeiras de 2025 (R$ mil)
saldo_bruto_mil <- 21062007
obrigacoes_especiais_mil <- -5862808
saldo_referencia_mil <- saldo_bruto_mil + obrigacoes_especiais_mil

# 1. Conciliação dos saldos registrados com os valores publicados
ativo_bruto_observado <- sum(
  base$saldo_registrado_mil[
    base$natureza == "Ativo financeiro bruto"
  ],
  na.rm = TRUE
)

obrigacoes_observadas <- sum(
  base$saldo_registrado_mil[
    base$natureza == "Obrigação especial vinculada"
  ],
  na.rm = TRUE
)

saldo_liquido_observado <- sum(
  base$saldo_registrado_mil,
  na.rm = TRUE
)

# 2. Identificação de diferenças individuais sintéticas
base$diferenca_rec_mil <- round(
  base$saldo_registrado_mil - base$saldo_recalculado_mil,
  2
)

base$excecao_rec <- abs(base$diferenca_rec_mil) > 0.01

quantidade_diferencas <- sum(base$excecao_rec, na.rm = TRUE)

# Diferença agregada com sinal: diferenças positivas e negativas
# podem compensar-se parcialmente.
saldo_recalculado_total <- sum(
  base$saldo_recalculado_mil,
  na.rm = TRUE
)

diferenca_agregada <- round(
  saldo_liquido_observado - saldo_recalculado_total,
  2
)

# 3. Exceções documentais e de período, exclusivamente sintéticas
base$excecao_documento <- is.na(base$documento_suporte) |
  base$status_documento == "Ausente"

datas <- as.Date(base$data_base)

base$excecao_data <- is.na(datas) |
  datas < as.Date("2025-01-01") |
  datas > as.Date("2025-12-31")

quantidade_documentos_ausentes <- sum(
  base$excecao_documento,
  na.rm = TRUE
)

quantidade_datas_fora <- sum(
  base$excecao_data,
  na.rm = TRUE
)

# Tabela de resultados separados
resultados_pt <- data.frame(
  etapa = c(
    "1. Conciliação do ativo financeiro bruto",
    "1. Conciliação das obrigações especiais",
    "1. Conciliação do saldo líquido de referência",
    "2. Diferenças individuais de recálculo",
    "2. Diferença agregada entre registrado e recalculado",
    "3. Documentos de suporte ausentes",
    "3. Datas fora do exercício de 2025"
  ),
  resultado = c(
    paste0(
      "Registrado: ", ativo_bruto_observado,
      " R$ mil; referência publicada: ", saldo_bruto_mil,
      " R$ mil; diferença: ",
      round(ativo_bruto_observado - saldo_bruto_mil, 2), " R$ mil"
    ),
    paste0(
      "Registrado: ", obrigacoes_observadas,
      " R$ mil; referência publicada: ", obrigacoes_especiais_mil,
      " R$ mil; diferença: ",
      round(obrigacoes_observadas - obrigacoes_especiais_mil, 2),
      " R$ mil"
    ),
    paste0(
      "Registrado: ", saldo_liquido_observado,
      " R$ mil; referência publicada: ", saldo_referencia_mil,
      " R$ mil; diferença: ",
      round(saldo_liquido_observado - saldo_referencia_mil, 2),
      " R$ mil"
    ),
    paste0(
      quantidade_diferencas,
      " registros sintéticos com diferença individual de recálculo"
    ),
    paste0(
      diferenca_agregada,
      " R$ mil; resultado da simulação, não representa erro real da companhia"
    ),
    paste0(
      quantidade_documentos_ausentes,
      " registros sintéticos; documentação real não examinada"
    ),
    paste0(
      quantidade_datas_fora,
      " registros sintéticos; documentação real não examinada"
    )
  ),
  natureza = c(
    "Conciliação com referência pública",
    "Conciliação com referência pública",
    "Conciliação com referência pública",
    "Simulação didática",
    "Simulação didática",
    "Simulação didática",
    "Simulação didática"
  ),
  stringsAsFactors = FALSE
)

# Papel de trabalho
campos <- c(
  "Código",
  "Título",
  "Normas relacionadas",
  "Objetivo",
  "Conta/área examinada",
  "Fonte da população",
  "Tamanho da população",
  "Método de seleção",
  "Tamanho da amostra ilustrativa",
  "Procedimento executado",
  "1. Conciliação de saldos de referência",
  "2. Diferenças individuais e agregadas",
  "3. Exceções documentais e temporais",
  "Natureza da evidência",
  "Limitações",
  "Preparado por",
  "Matrícula",
  "Data de preparação",
  "Revisão"
)

descricoes <- c(
  "PT 500-530-01",
  "Integridade da população sintética e testes analíticos",
  "NBC TA 500 e NBC TA 530",
  "Documentar a conciliação da referência pública e avaliar testes analíticos simulados",
  "Ativo financeiro de concessão e obrigações especiais vinculadas",
  "Base sintética gerada em R; valores de referência das demonstrações financeiras de 2025",
  format(nrow(base), big.mark = ".", scientific = FALSE),
  "Amostragem aleatória simples sem reposição, apenas ilustrativa",
  "100 registros; amostra ilustrativa, não utilizada para inferência sobre a companhia",
  "Verificação de IDs, conciliação de saldos, recálculo, documentação simulada e datas",
  paste(
    "Ativo bruto:", ativo_bruto_observado,
    "R$ mil; obrigações especiais:", obrigacoes_observadas,
    "R$ mil; saldo líquido:", saldo_liquido_observado,
    "R$ mil; saldo líquido de referência:", saldo_referencia_mil,
    "R$ mil. Diferença da conciliação:",
    round(saldo_liquido_observado - saldo_referencia_mil, 2),
    "R$ mil."
  ),
  paste(
    quantidade_diferencas,
    "registros sintéticos com diferenças individuais.",
    "Diferença agregada entre registrado e recalculado:",
    diferenca_agregada,
    "R$ mil. Os valores recalculados foram alterados artificialmente",
    "para testar os procedimentos; não são erros reais da companhia."
  ),
  paste(
    quantidade_documentos_ausentes,
    "documentos de suporte simulados como ausentes;",
    quantidade_datas_fora,
    "datas sintéticas fora do exercício de 2025.",
    "Ambas as categorias exigiriam documentação original em uma auditoria real."
  ),
  "Procedimentos executados exclusivamente sobre dados sintéticos; não constituem evidência de auditoria real",
  "Sem acesso ao razão contábil, documentos originais, contratos, sistemas ou confirmações externas da companhia",
  "Estudante",
  "242010937",
  "2026-10-25",
  "Pendente de revisão"
)

papel <- data.frame(
  campo = campos,
  descricao = descricoes,
  stringsAsFactors = FALSE
)

if (!dir.exists("resultados")) {
  dir.create("resultados", recursive = TRUE)
}

write.csv(
  papel,
  "resultados/07_PT500_PT530.csv",
  row.names = FALSE,
  na = "",
  fileEncoding = "UTF-8"
)

write.csv(
  resultados_pt,
  "resultados/14_conciliacao_e_excecoes_separadas.csv",
  row.names = FALSE,
  na = "",
  fileEncoding = "UTF-8"
)

cat("Papel de trabalho atualizado.\n")
cat("Conciliação, diferenças individuais e outras exceções foram separadas.\n")
cat("Todos os resultados se referem à base sintética.\n\n")
print(resultados_pt, row.names = FALSE)
