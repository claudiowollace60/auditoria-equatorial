
# Auditoria 1 — testes preliminares sobre base sintética.
# Os resultados não constituem auditoria real das demonstrações.

if (!file.exists("dados/base_ativo_concessao_sintetica.csv.gz")) {
  stop("Execute primeiro R/01_gerar_base.R.")
}

base <- read.csv(
  gzfile("dados/base_ativo_concessao_sintetica.csv.gz"),
  stringsAsFactors = FALSE,
  na.strings = ""
)

base$data_base <- as.Date(base$data_base)

saldo_bruto_mil <- 21062007
obrigacoes_especiais_mil <- -5862808
saldo_referencia_mil <- saldo_bruto_mil + obrigacoes_especiais_mil

# Testes de integridade da população
integridade <- data.frame(
  teste = c(
    "Quantidade mínima de registros",
    "IDs únicos",
    "Conciliação do ativo financeiro bruto",
    "Conciliação das obrigações especiais",
    "Conciliação do saldo líquido"
  ),
  resultado = c(
    ifelse(nrow(base) >= 500000, "OK", "EXCEÇÃO"),
    ifelse(!anyDuplicated(base$id_registro), "OK", "EXCEÇÃO"),
    ifelse(
      abs(sum(base$saldo_registrado_mil[
        base$natureza == "Ativo financeiro bruto"
      ]) - saldo_bruto_mil) < 0.01,
      "OK", "EXCEÇÃO"
    ),
    ifelse(
      abs(sum(base$saldo_registrado_mil[
        base$natureza == "Obrigação especial vinculada"
      ]) - obrigacoes_especiais_mil) < 0.01,
      "OK", "EXCEÇÃO"
    ),
    ifelse(
      abs(sum(base$saldo_registrado_mil) -
            saldo_referencia_mil) < 0.01,
      "OK", "EXCEÇÃO"
    )
  ),
  detalhe = c(
    paste("Linhas:", nrow(base)),
    paste("IDs duplicados:", sum(duplicated(base$id_registro))),
    paste(
      "Ativo bruto:",
      sum(base$saldo_registrado_mil[
        base$natureza == "Ativo financeiro bruto"
      ]),
      "| Referência:", saldo_bruto_mil
    ),
    paste(
      "Obrigações especiais:",
      sum(base$saldo_registrado_mil[
        base$natureza == "Obrigação especial vinculada"
      ]),
      "| Referência:", obrigacoes_especiais_mil
    ),
    paste(
      "Saldo líquido:", sum(base$saldo_registrado_mil),
      "| Referência:", saldo_referencia_mil,
      "| Diferença:",
      round(sum(base$saldo_registrado_mil) -
              saldo_referencia_mil, 2)
    )
  ),
  stringsAsFactors = FALSE
)

# Testes analíticos simulados
base$diferenca_rec_mil <- round(
  base$saldo_registrado_mil - base$saldo_recalculado_mil, 2
)

base$excecao_rec <- abs(base$diferenca_rec_mil) > 0.01

base$excecao_documento <- is.na(base$documento_suporte) |
  base$status_documento == "Ausente"

base$excecao_data <- is.na(base$data_base) |
  base$data_base < as.Date("2025-01-01") |
  base$data_base > as.Date("2025-12-31")

resumo_excecoes <- data.frame(
  tipo_excecao = c(
    "Diferença entre saldo registrado e recálculo",
    "Documento de suporte ausente",
    "Data fora do exercício de 2025"
  ),
  quantidade = c(
    sum(base$excecao_rec),
    sum(base$excecao_documento),
    sum(base$excecao_data)
  ),
  classificacao = "SIMULADO PARA FINS DIDATICOS",
  stringsAsFactors = FALSE
)

# Amostra aleatória ilustrativa de 100 registros.
# O tamanho deverá ser justificado posteriormente no PT 530.
set.seed(242010937)

tamanho_amostra <- min(100L, nrow(base))

amostra <- base[
  sample(seq_len(nrow(base)), tamanho_amostra, replace = FALSE),
]

amostra$metodo_selecao <-
  "Amostragem aleatória simples sem reposição - ilustrativa"

if (!dir.exists("resultados")) {
  dir.create("resultados", recursive = TRUE)
}

write.csv(
  integridade,
  "resultados/01_integridade_populacao.csv",
  row.names = FALSE
)

write.csv(
  resumo_excecoes,
  "resultados/02_resumo_excecoes.csv",
  row.names = FALSE
)

write.csv(
  amostra,
  "resultados/03_amostra_ilustrativa.csv",
  row.names = FALSE
)

# Exporta registros sinalizados para investigação simulada
excecoes <- base[
  base$excecao_rec |
    base$excecao_documento |
    base$excecao_data,
]

write.csv(
  excecoes,
  "resultados/04_registros_para_investigacao.csv",
  row.names = FALSE
)

cat("\n--- INTEGRIDADE DA POPULAÇÃO ---\n")
print(integridade, row.names = FALSE)

cat("\n--- RESUMO DAS EXCEÇÕES SIMULADAS ---\n")
print(resumo_excecoes, row.names = FALSE)

cat("\nAmostra ilustrativa exportada:", nrow(amostra), "registros.\n")
cat("ATENÇÃO: as exceções são artificiais; avaliar no papel de trabalho.\n")
