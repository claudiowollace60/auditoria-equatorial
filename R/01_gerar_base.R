
# Auditoria 1 — Equatorial Energia Distribuição S.A.
# Matrícula: 242010937
# PT 500/530: geração de população sintética para fins didáticos.
# ATENÇÃO: os registros não são dados reais da companhia.

set.seed(242010937)

# Diretórios do projeto
dirs <- c("dados", "resultados", "fontes", "dossie", "normas", "R")
for (d in dirs) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
}

# Referência: Nota Explicativa 11, demonstrações de 2025.
# Valores em R$ mil.
saldo_bruto_mil <- 21062007
obrigacoes_especiais_mil <- -5862808
saldo_referencia_mil <- saldo_bruto_mil + obrigacoes_especiais_mil

# População sintética de 500 mil registros
n <- 500000L
n_bruto <- 390000L

id <- sprintf("AF-%06d", seq_len(n))

componentes <- sample(
  c("Equatorial Maranhão", "Equatorial Pará", "Equatorial Piauí"),
  n, replace = TRUE, prob = c(0.30, 0.45, 0.25)
)

data_base <- as.Date("2025-01-01") +
  sample(0:364, n, replace = TRUE)

# Separação dos registros de ativo bruto e obrigações especiais
natureza <- sample(c(
  rep("Ativo financeiro bruto", n_bruto),
  rep("Obrigação especial vinculada", n - n_bruto)
))

tipo_registro <- sample(
  c("Atualização", "Transferência de ativo de contrato",
    "Baixa", "Reclassificação", "Saldo de abertura"),
  n, replace = TRUE,
  prob = c(0.18, 0.32, 0.05, 0.03, 0.42)
)

# Distribui os valores por componente e ajusta o arredondamento
# para que cada grupo concilie exatamente com a referência publicada.
valores <- numeric(n)

idx_bruto <- which(natureza == "Ativo financeiro bruto")
idx_obrig <- which(natureza == "Obrigação especial vinculada")

pesos_bruto <- stats::rgamma(length(idx_bruto), shape = 2.2, rate = 1)
valores[idx_bruto] <- round(
  pesos_bruto / sum(pesos_bruto) * saldo_bruto_mil, 2
)
valores[idx_bruto[length(idx_bruto)]] <- round(
  valores[idx_bruto[length(idx_bruto)]] +
    (saldo_bruto_mil - sum(valores[idx_bruto])), 2
)

pesos_obrig <- stats::rgamma(length(idx_obrig), shape = 2.2, rate = 1)
valores[idx_obrig] <- -round(
  pesos_obrig / sum(pesos_obrig) * abs(obrigacoes_especiais_mil), 2
)
valores[idx_obrig[length(idx_obrig)]] <- round(
  valores[idx_obrig[length(idx_obrig)]] +
    (obrigacoes_especiais_mil - sum(valores[idx_obrig])), 2
)

base <- data.frame(
  id_registro = id,
  componente = componentes,
  data_base = as.character(data_base),
  natureza = natureza,
  tipo_registro = tipo_registro,
  saldo_registrado_mil = valores,
  saldo_recalculado_mil = valores,
  documento_suporte = sprintf("DOC-SIM-%06d", seq_len(n)),
  status_documento = sample(
    c("Localizado na base sintética", "Ausente"),
    n, replace = TRUE, prob = c(0.992, 0.008)
  ),
  origem = "SINTETICO - NAO E DADO REAL DA COMPANHIA",
  stringsAsFactors = FALSE
)

# Insere 250 diferenças intencionais para testar os procedimentos
n_erros <- 250L
idx_erros <- sample(seq_len(n), n_erros, replace = FALSE)

diferencas <- sample(c(-1, 1), n_erros, replace = TRUE) *
  round(stats::runif(n_erros, min = 50, max = 2500), 2)

base$saldo_recalculado_mil[idx_erros] <- round(
  base$saldo_registrado_mil[idx_erros] + diferencas, 2
)

# Insere documentos ausentes adicionais para fins didáticos
idx_doc_ausente <- sample(
  setdiff(seq_len(n), idx_erros), 1500L
)

base$status_documento[idx_doc_ausente] <- "Ausente"
base$documento_suporte[idx_doc_ausente] <- NA_character_

# Insere 75 datas fora do exercício de 2025
idx_data_fora <- sample(
  setdiff(seq_len(n), c(idx_erros, idx_doc_ausente)), 75L
)

base$data_base[idx_data_fora] <- as.character(
  as.Date("2024-12-31") -
    sample(1:90, length(idx_data_fora), replace = TRUE)
)

# Controle separado dos erros intencionais de recálculo
registro_erros <- data.frame(
  id_registro = id[idx_erros],
  diferenca_inserida_mil = diferencas,
  tipo_erro = "Diferenca intencional entre saldo registrado e recálculo",
  stringsAsFactors = FALSE
)

# Exporta a base sintética e o controle de erros
write.csv(
  base,
  gzfile("dados/base_ativo_concessao_sintetica.csv.gz"),
  row.names = FALSE, na = ""
)

write.csv(
  registro_erros,
  "dados/controle_erros_inseridos.csv",
  row.names = FALSE, na = ""
)

# Dicionário de variáveis
dicionario <- data.frame(
  variavel = c(
    "id_registro", "componente", "data_base", "natureza",
    "tipo_registro", "saldo_registrado_mil",
    "saldo_recalculado_mil", "documento_suporte",
    "status_documento", "origem"
  ),
  tipo = c(
    "Texto", "Texto", "Data ISO (texto)", "Texto", "Texto",
    "Numérico (R$ mil)", "Numérico (R$ mil)", "Texto/NA",
    "Texto", "Texto"
  ),
  descricao = c(
    "Identificador único sintético.",
    "Componente atribuído aleatoriamente para simulação.",
    "Data simulada associada ao registro.",
    "Classificação simulada do registro.",
    "Tipo de movimentação simulado.",
    "Valor registrado sintético.",
    "Valor independente para recálculo didático.",
    "Referência documental sintética, não real.",
    "Indica se o documento foi simulado como localizado ou ausente.",
    "Identifica explicitamente a natureza sintética dos dados."
  ),
  stringsAsFactors = FALSE
)

write.csv(
  dicionario,
  "dados/dicionario_variaveis.csv",
  row.names = FALSE
)

# Testes automáticos de integridade
stopifnot(nrow(base) >= 500000L)
stopifnot(!anyDuplicated(base$id_registro))

stopifnot(
  abs(sum(base$saldo_registrado_mil) -
        saldo_referencia_mil) < 0.01
)

stopifnot(
  abs(sum(base$saldo_registrado_mil[
    base$natureza == "Ativo financeiro bruto"
  ]) - saldo_bruto_mil) < 0.01
)

stopifnot(
  abs(sum(base$saldo_registrado_mil[
    base$natureza == "Obrigação especial vinculada"
  ]) - obrigacoes_especiais_mil) < 0.01
)

cat("Base sintética gerada.\n")
cat("Registros:", nrow(base), "\n")
cat("IDs duplicados:", sum(duplicated(base$id_registro)), "\n")
cat("Ativo financeiro bruto (R$ mil):",
    format(sum(base$saldo_registrado_mil[
      base$natureza == "Ativo financeiro bruto"
    ]), big.mark = ".", decimal.mark = ","), "\n")
cat("Obrigações especiais (R$ mil):",
    format(sum(base$saldo_registrado_mil[
      base$natureza == "Obrigação especial vinculada"
    ]), big.mark = ".", decimal.mark = ","), "\n")
cat("Saldo líquido de referência (R$ mil):",
    format(saldo_referencia_mil,
           big.mark = ".", decimal.mark = ","), "\n")
cat("Arquivos gerados na pasta dados/.\n")
