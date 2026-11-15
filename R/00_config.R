# 00_config.R - parametros globais do projeto (rodar a partir da raiz do projeto)
Sys.setlocale("LC_ALL","C.UTF-8")
options(stringsAsFactors = FALSE, scipen = 999)
MATRICULA   <- "242010937"
DATA_ELAB   <- "2026-11-11"
SEED        <- 242010937          # semente unica do projeto (reprodutibilidade)
ENTIDADE    <- "Equatorial S.A. (holding; antiga Equatorial Energia S.A.) - consolidado"
EXERCICIO   <- 2025
UNID        <- "R$ mil"
DATA_BASE   <- as.Date("2025-12-31")
DIR <- list(dados="dados", res="resultados", pt="papeis_trabalho", fontes="fontes",
            prog="programas_auditoria", min="minutas", dos="dossie")
for (d in DIR) dir.create(d, showWarnings = FALSE, recursive = TRUE)
fmt <- function(x, d = 0) formatC(x, format = "f", digits = d, big.mark = ".", decimal.mark = ",")
