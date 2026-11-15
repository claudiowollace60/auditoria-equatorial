# 03_materialidade.R - NBC TA 320/450: materialidade para as demonstracoes contabeis como um todo (consolidado)
source("R/00_config.R")
fa <- read.csv(file.path(DIR$fontes, "fatos_dfp_2025.csv"))
v <- function(id, ano = 2025) fa[fa$id_fato == id, if (ano == 2025) "valor_2025_mil" else "valor_2024_mil"]
rol <- v("F01"); rol24 <- v("F01", 2024); lair <- v("F02"); lair24 <- v("F02", 2024)
ativo <- v("F04"); pl <- v("F05"); constr <- v("F30") + v("F31")
rol_ex <- rol - constr
bench <- data.frame(
  base = c("Receita operacional liquida (ROL)","ROL excl. receita de construcao (Nota 27)","Resultado antes de IR/CS (LAIR) 2025",
           "LAIR medio 2024-2025","Total do ativo","Patrimonio liquido"),
  valor_mil = c(rol, rol_ex, lair, mean(c(lair, lair24)), ativo, pl),
  pct_min = c(.005,.005,.05,.05,.005,.01), pct_max = c(.01,.01,.05,.05,.01,.02))
bench$mat_min_mil <- round(bench$valor_mil * bench$pct_min); bench$mat_max_mil <- round(bench$valor_mil * bench$pct_max)
bench$racional <- c(
 "Base estavel e relevante para usuarios de companhia aberta regulada (tarifa); faixa usual 0,5%-1%.",
 "Sensibilidade: receita de construcao (ICPC 01) tem margem proxima de zero; mostra o efeito de excluir.",
 "Faixa usual 5% do lucro; mas o LAIR esta deprimido por impairment de R$ 3,39 bi e por resultado financeiro (Nota 16/31): referencia instavel.",
 "Normalizacao simples por media de dois anos; reduz volatilidade, ainda sob efeito do impairment.",
 "Entidade intensiva em ativos (concessoes); faixa usual 0,5%-1% do ativo.",
 "Referencia complementar de usuarios (acionistas): 1%-2%.")
write.csv(bench, file.path(DIR$res, "01_materialidade_benchmarks.csv"), row.names = FALSE, fileEncoding = "UTF-8")

# Escolha: 0,5% da ROL, arredondada
global <- round(rol * .005, -3)                     # R$ 260.000 mil
exec   <- round(global * .75, -3)                   # materialidade de execucao (75%)
trivial <- round(global * .05, -3)                  # limite de distorcoes claramente triviais (5%)
especifica <- round(global * .50, -3)               # partes relacionadas / remuneracao / divulgacoes sensiveis (50%)
mat <- data.frame(
  item = c("Materialidade global (DFs como um todo)","Materialidade de execucao (75%)","Limite de distorcoes triviais (5%)",
           "Materialidade especifica (50%): partes relacionadas, covenants e divulgacao de impairment",
           "Erro tolerável (ME) para MUS no Intangivel = materialidade de execucao"),
  valor_mil = c(global, exec, trivial, especifica, exec),
  criterio = c("0,5% da ROL 2025 (R$ 52.073.804 mil), arredondada","75% da global","5% da global","50% da global","igual a execucao"))
write.csv(mat, file.path(DIR$res, "02_materialidade_adotada.csv"), row.names = FALSE, fileEncoding = "UTF-8")

# Comparativo: o que cada benchmark implicaria e cobertura (em % do Intangivel)
cmp <- data.frame(base = bench$base, mat_min = bench$mat_min_mil, mat_max = bench$mat_max_mil,
                  vs_adotada_pct_min = round(bench$mat_min_mil / global * 100, 1),
                  vs_adotada_pct_max = round(bench$mat_max_mil / global * 100, 1),
                  pct_do_intangivel_min = round(bench$mat_min_mil / v("F06") * 100, 3))
write.csv(cmp, file.path(DIR$res, "03_materialidade_comparativo.csv"), row.names = FALSE, fileEncoding = "UTF-8")
just <- c(
 "JUSTIFICATIVA (NBC TA 320 itens 10-11, A3-A8):",
 paste0("1. A materialidade e determinada para o CONSOLIDADO (todas as demonstracoes), nao para uma conta isolada. Base escolhida: ROL 2025 = R$ ", fmt(rol), " mil; percentual 0,5% = R$ ", fmt(rol*.005), " mil, arredondado para R$ ", fmt(global), " mil."),
 "2. O LAIR (R$ 2.455.004 mil) foi descartado como base principal: 5% daria R$ 122.750 mil, valor influenciado por impairment (R$ 3,39 bi) e pela baixa de transmissao (operacao descontinuada) - base volatil e nao representativa do tamanho da entidade.",
 "3. O ativo total (R$ 109,6 bi) a 0,5% daria R$ 548.020 mil: acima da adotada; a ROL e mais sensivel ao uso das demonstracoes por investidores e credores (covenants de divida liquida/EBITDA).",
 paste0("4. Excluindo receita de construcao (R$ ", fmt(constr), " mil), 0,5% da ROL daria R$ ", fmt(rol_ex*.005), " mil: a adotada fica ", round((global/(rol_ex*.005)-1)*100,1), "% acima; aceito porque a receita de construcao tem margem proxima de zero mas integra a ROL publicada."),
 paste0("5. Cobertura do Intangivel: a materialidade de execucao (R$ ", fmt(exec), " mil) equivale a ", round(exec / v("F06") * 100, 3), "% do saldo; dai o numero de itens do MUS (PT20)."),
 "6. Julgamento revisavel: se os usuarios principais forem credores, o LAIR/EBITDA passa a ser mais relevante; registrar no PT11 e rever apos o PT10.")
writeLines(just, file.path(DIR$res, "04_materialidade_justificativa.txt"), useBytes = TRUE)
print(mat); print(cmp)

# Justificativa da conta-alvo (maior materialidade do ativo): contas do ativo consolidado
ac <- data.frame(conta = c("Intangível","Ativo financeiro da concessão","Contas a receber de clientes (circ. + não circ.)","Imobilizado","Caixa e equivalentes","Almoxarifado"),
  saldo_2025_mil = c(31729991, 19135756, 9491337 + 824227, 6540907, 2659827, 291436), pagina_pdf = c("10 (Nota 14)","10 (Nota 12)","10 (Nota 6)","10 (Nota 13)","10 (Nota 4)","10"))
ac$pct_ativo_total <- round(100 * ac$saldo_2025_mil / ativo, 1)
ac$vezes_materialidade_global <- round(ac$saldo_2025_mil / global)
ac$escolhida <- ifelse(ac$conta == "Intangível", "SIM - maior saldo individual do ativo (28,9%)", "")
write.csv(ac, file.path(DIR$res, "00_justificativa_conta_alvo.csv"), row.names = FALSE, fileEncoding = "UTF-8")
