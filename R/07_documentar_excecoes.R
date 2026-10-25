
# Auditoria 1 — Documentação das exceções simuladas
# Matrícula: 242010937
# Todos os registros examinados nesta etapa são sintéticos.

base_arquivo <- "dados/base_ativo_concessao_sintetica.csv.gz"
erros_arquivo <- "dados/controle_erros_inseridos.csv"

if (!file.exists(base_arquivo) || !file.exists(erros_arquivo)) {
  stop("Não encontrei a base ou o controle de erros. Confira a pasta dados/.")
}

base <- read.csv(
  gzfile(base_arquivo),
  stringsAsFactors = FALSE,
  na.strings = ""
)

erros_inseridos <- read.csv(
  erros_arquivo,
  stringsAsFactors = FALSE,
  na.strings = ""
)

# Identifica as diferenças entre saldo registrado e recálculo
base$diferenca_rec_mil <- round(
  base$saldo_registrado_mil - base$saldo_recalculado_mil, 2
)

base$excecao_rec <- abs(base$diferenca_rec_mil) > 0.01
base$excecao_documento <- is.na(base$documento_suporte) |
  base$status_documento == "Ausente"

data_base <- as.Date(base$data_base)

base$excecao_data <- is.na(data_base) |
  data_base < as.Date("2025-01-01") |
  data_base > as.Date("2025-12-31")

# Compara os erros de recálculo inseridos e os detectados
detectados <- base[
  base$excecao_rec,
  c("id_registro", "diferenca_rec_mil")
]

comparacao <- merge(
  erros_inseridos,
  detectados,
  by = "id_registro",
  all = TRUE,
  suffixes = c("_inserida", "_detectada")
)

comparacao$inserido <- !is.na(comparacao$diferenca_inserida_mil)
comparacao$detectado <- !is.na(comparacao$diferenca_rec_mil)

avaliacao <- data.frame(
  indicador = c(
    "Erros de recálculo inseridos",
    "Erros inseridos detectados",
    "Erros inseridos não detectados",
    "Exceções de recálculo não registradas como inseridas"
  ),
  quantidade = c(
    sum(comparacao$inserido),
    sum(comparacao$inserido & comparacao$detectado),
    sum(comparacao$inserido & !comparacao$detectado),
    sum(!comparacao$inserido & comparacao$detectado)
  ),
  classificacao = "SIMULADO - NAO E ACHADO REAL",
  stringsAsFactors = FALSE
)

# Registro consolidado das exceções por tipo
resumo <- data.frame(
  tipo_excecao = c(
    "Diferença de recálculo",
    "Documento de suporte ausente",
    "Data fora do exercício de 2025"
  ),
  quantidade = c(
    sum(base$excecao_rec),
    sum(base$excecao_documento),
    sum(base$excecao_data)
  ),
  natureza = "Sintética",
  conclusao = c(
    "Comparada com o controle de erros inseridos",
    "Exige documentação original para avaliação real; indisponível",
    "Exige validação de período com documentação original; indisponível"
  ),
  stringsAsFactors = FALSE
)

if (!dir.exists("resultados")) {
  dir.create("resultados", recursive = TRUE)
}

write.csv(
  avaliacao,
  "resultados/11_avaliacao_erros_inseridos_detectados.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

write.csv(
  comparacao,
  "resultados/12_comparacao_erros.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

write.csv(
  resumo,
  "resultados/13_resumo_excecoes_documentadas.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

cat("Documentação das exceções criada.\n")
print(avaliacao, row.names = FALSE)
cat("Arquivos salvos na pasta resultados/.\n")
cat("As exceções são sintéticas e não constituem achados reais.\n")
