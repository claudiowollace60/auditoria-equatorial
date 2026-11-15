# 04_testes_base.R - NBC TA 330/500/520: testes na base e comparacao erros inseridos x detectados (PT 15, PT 12, PT 14)
source("R/00_config.R")
b   <- read.csv(file.path(DIR$dados, "base_intangivel_2025.csv.gz"), stringsAsFactors = FALSE)
log <- read.csv(file.path(DIR$dados, "log_erros_inseridos.csv"), stringsAsFactors = FALSE)
b$data_incorporacao <- as.Date(b$data_incorporacao)
taxa_linha <- c("Dist - Em servico"=0.0423,"DC - Maranhao"=0.0333,"DC - Para"=0.0333,"DC - Alagoas"=0.0333,"DC - Piaui"=0.0333,
                "DC - CEEE-D"=0.0417,"DC - CEA"=0.0333,"Dist - Outros"=0.10,"San - DC CSA"=0.0288,"Ger - Direito de exploracao"=0.0678,
                "Ger - Direito de autorizacao"=0.0322,"Ger - Outros"=0.10)
# taxa por linha de ORIGEM nao e observavel apos reclassificacao: o teste compara com a taxa da linha declarada no registro
TOL_LIQ <- 0.0015; TOL_TAXA <- 0.05; TOL_AMORT <- 0.01
idade <- as.numeric(DATA_BASE - b$data_incorporacao) / 365.25
T <- data.frame(id_registro = b$id_registro, row = seq_len(nrow(b)))
T$T1_duplicidade   <- duplicated(b$id_registro) | duplicated(b$id_registro, fromLast = TRUE)
T$T2_liquido       <- abs(b$valor_liquido_mil - (b$custo_mil + b$amort_acum_mil + b$obrig_vinc_mil)) > TOL_LIQ
excecao_dfp <- b$linha_nota14 %in% c("Ger - Direito de exploracao","San - Outros")     # linhas em que a propria DFP mostra amort > custo ou sinal positivo
T$T3_amort_gt_custo <- (-b$amort_acum_mil > b$custo_mil * 1.0000001) & !excecao_dfp
T$T4_data_futura   <- b$data_incorporacao > DATA_BASE
tl <- taxa_linha[b$linha_nota14]
T$T5_taxa_vs_nota  <- !is.na(b$taxa_anual) & !is.na(tl) & abs(b$taxa_anual / tl - 1) > TOL_TAXA
T$T6_sinal_amort   <- (b$amort_acum_mil > 0) & !excecao_dfp
lc <- log(pmax(b$custo_mil, 1e-6)); med <- ave(lc, b$linha_nota14, FUN = median); mad_ <- ave(lc, b$linha_nota14, FUN = mad)
T$T7_outlier_valor <- abs(lc - med) / mad_ > 4.5
exp_am <- -b$custo_mil * b$taxa_anual * idade
T$T8_recalculo_amort <- !is.na(exp_am) & !excecao_dfp & abs(b$amort_acum_mil - exp_am) > (TOL_AMORT * abs(exp_am) + b$custo_mil * b$taxa_anual / 365.25 + 0.01)
testes <- grep("^T[0-9]", names(T), value = TRUE)
T$qualquer <- rowSums(T[, testes]) > 0
res_testes <- data.frame(teste = testes, registros_sinalizados = colSums(T[, testes]))
write.csv(res_testes, file.path(DIR$res, "05_testes_base_sinalizados.csv"), row.names = FALSE)
write.csv(T[T$qualquer, ], file.path(DIR$res, "06_registros_sinalizados.csv"), row.names = FALSE)

# ---- comparacao inserido x detectado (id_registro) ----
ids_flag <- unique(T$id_registro[T$qualquer])
log$detectado <- log$id_registro %in% ids_flag
por_tipo <- aggregate(detectado ~ tipo_erro, log, function(x) c(n = length(x), tp = sum(x)))
por_tipo <- data.frame(tipo_erro = por_tipo$tipo_erro, inseridos = por_tipo$detectado[, "n"], detectados = por_tipo$detectado[, "tp"])
por_tipo$nao_detectados <- por_tipo$inseridos - por_tipo$detectados
por_tipo$recall_pct <- round(100 * por_tipo$detectados / por_tipo$inseridos, 1)
dist_abs <- tapply(abs(log$valor_distorcao_mil), log$tipo_erro, sum)
por_tipo$distorcao_total_mil <- round(as.numeric(dist_abs[por_tipo$tipo_erro]), 1)
dist_nd <- tapply(abs(log$valor_distorcao_mil) * !log$detectado, log$tipo_erro, sum)
por_tipo$distorcao_nao_detectada_mil <- round(as.numeric(dist_nd[por_tipo$tipo_erro]), 1)
write.csv(por_tipo, file.path(DIR$res, "07_inserido_vs_detectado_por_tipo.csv"), row.names = FALSE)
TP <- sum(log$detectado); FN <- sum(!log$detectado); FP <- length(setdiff(ids_flag, log$id_registro))
resumo <- data.frame(medida = c("Erros inseridos","Detectados (VP)","Nao detectados (FN)","Sinalizados que nao sao erros (FP)","Recall (%)","Precisao (%)"),
  valor = c(nrow(log), TP, FN, FP, round(100*TP/nrow(log),1), round(100*TP/(TP+FP),1)))
write.csv(resumo, file.path(DIR$res, "08_inserido_vs_detectado_resumo.csv"), row.names = FALSE)
# investigacao dos nao detectados (por que escaparam)
nd <- log[!log$detectado, ]
write.csv(nd, file.path(DIR$res, "09_erros_nao_detectados.csv"), row.names = FALSE)
cat("Sinalizados por teste:\n"); print(res_testes); print(por_tipo); print(resumo)
