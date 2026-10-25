
# PT 500 e PT 530 — avaliação das exceções simuladas
# Matrícula: 242010937
# Uso exclusivamente didático; dados sintéticos.

base <- read.csv(
  gzfile("dados/base_ativo_concessao_sintetica.csv.gz"),
  stringsAsFactors = FALSE,
  na.strings = ""
)

erros_inseridos <- read.csv(
  "dados/controle_erros_inseridos.csv",
  stringsAsFactors = FALSE
)

# Reproduzir o critério usado no teste de recálculo
base$diferenca_rec_mil <- round(
  base$saldo_registrado_mil - base$saldo_recalculado_mil, 2
)

detectados <- base[
  abs(base$diferenca_rec_mil) > 0.01,
  c("id_registro", "diferenca_rec_mil")
]

# Comparar os IDs dos erros inseridos com os IDs detectados
comparacao <- merge(
  erros_inseridos,
  detectados,
  by = "id_registro",
  all = TRUE,
  suffixes = c("_inserida", "_detectada")
)

comparacao$inserido <- !is.na(comparacao$diferenca_inserida_mil)
comparacao$detectado <- !is.na(comparacao$diferenca_rec_mil)

verdadeiro_positivo <- sum(comparacao$inserido & comparacao$detectado)
nao_detectado <- sum(comparacao$inserido & !comparacao$detectado)
falso_positivo <- sum(!comparacao$inserido & comparacao$detectado)

avaliacao <- data.frame(
  indicador = c(
    "Erros de recálculo inseridos",
    "Erros inseridos detectados",
    "Erros inseridos não detectados",
    "Exceções detectadas não presentes no registro de erros"
  ),
  quantidade = c(
    nrow(erros_inseridos),
    verdadeiro_positivo,
    nao_detectado,
    falso_positivo
  )
)

if (!dir.exists("resultados")) {
  dir.create("resultados", recursive = TRUE)
}

write.csv(
  avaliacao,
  "resultados/05_avaliacao_deteccao.csv",
  row.names = FALSE
)

write.csv(
  comparacao,
  "resultados/06_comparacao_erros_inseridos_detectados.csv",
  row.names = FALSE
)

print(avaliacao, row.names = FALSE)

cat(
  "\nResultados salvos na pasta resultados/.\n",
  "A comparação avalia apenas os erros de recálculo registrados.\n",
  "Não representa achados reais da companhia.\n"
)
