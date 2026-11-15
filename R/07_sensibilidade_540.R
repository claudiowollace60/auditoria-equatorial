# 07_sensibilidade_540.R - NBC TA 540: sensibilidade das estimativas (impairment da mais-valia Echo e vida util do Intangivel) - PT 21
# Natureza: SIMULADO para fins didaticos (fluxos de caixa nao divulgados na DFP; calibrados para reproduzir o valor recuperavel divulgado)
source("R/00_config.R")
mat <- read.csv(file.path(DIR$res, "02_materialidade_adotada.csv")); MG <- mat$valor_mil[1]
VU0 <- 4053163; IMP0 <- 2359265; CARR <- VU0 + IMP0; W0 <- 0.08          # DFP PDF p.69: valor recuperavel, perda e WACC (Echo Participacoes)
H <- 20; G0 <- 0.035                                                    # PREMISSAS SIMULADAS: horizonte e crescimento nominal do fluxo
pv_fator <- function(w, g, H) (1 - ((1 + g) / (1 + w))^H) / (w - g)
FCF1 <- VU0 / pv_fator(W0, G0, H)                                       # fluxo do ano 1 calibrado (R$ mil)
grid <- expand.grid(wacc = seq(0.07, 0.095, by = 0.0025), g = seq(0.025, 0.045, by = 0.005))
grid$vu_mil <- round(FCF1 * mapply(pv_fator, grid$wacc, grid$g, MoreArgs = list(H = H)))
grid$impairment_mil <- pmax(0, CARR - grid$vu_mil)
grid$delta_vs_base_mil <- grid$impairment_mil - IMP0
grid$delta_vs_materialidade <- round(grid$delta_vs_base_mil / MG, 2)
write.csv(grid, file.path(DIR$res, "18_sensibilidade_wacc_g.csv"), row.names = FALSE)

# horizonte (tornado simples, um fator por vez)
um <- data.frame(cenario = c("Base (WACC 8,00%; g 3,5%; 20 anos)","WACC +0,50 p.p.","WACC -0,50 p.p.","WACC +1,00 p.p.","g -1,0 p.p.","g +1,0 p.p.","Horizonte 15 anos","Horizonte 25 anos","FCF -10%","FCF +10%"),
  vu = c(VU0,
    FCF1*pv_fator(.085,G0,H), FCF1*pv_fator(.075,G0,H), FCF1*pv_fator(.09,G0,H), FCF1*pv_fator(W0,G0-.01,H), FCF1*pv_fator(W0,G0+.01,H),
    FCF1*pv_fator(W0,G0,15), FCF1*pv_fator(W0,G0,25), .9*VU0, 1.1*VU0))
um$vu <- round(um$vu); um$impairment_mil <- pmax(0, CARR - um$vu); um$delta_mil <- um$impairment_mil - IMP0
um$delta_x_materialidade <- round(um$delta_mil / MG, 2)
um$excede_materialidade <- abs(um$delta_mil) > MG
write.csv(um, file.path(DIR$res, "19_sensibilidade_um_fator.csv"), row.names = FALSE, fileEncoding = "UTF-8")

# vida util do intangivel: efeito de +/-10% e +/-20% nas taxas sobre a despesa anual esperada (base limpa por linha)
gab <- read.csv(file.path(DIR$dados, "gabarito_base_limpa.csv.gz"))
gab$exp <- ifelse(is.na(gab$taxa_anual), 0, gab$custo_mil * gab$taxa_anual)
D0 <- sum(gab$exp[gab$linha_nota14 != "Ger - Direito de exploracao"])
vu <- data.frame(variacao_taxa = c(-.2, -.1, .1, .2)); vu$despesa_anual_mil <- round(D0 * (1 + vu$variacao_taxa))
vu$delta_mil <- round(D0 * vu$variacao_taxa); vu$delta_x_materialidade <- round(vu$delta_mil / MG, 2)
vu <- rbind(data.frame(variacao_taxa = 0, despesa_anual_mil = round(D0), delta_mil = 0, delta_x_materialidade = 0), vu)
write.csv(vu, file.path(DIR$res, "20_sensibilidade_vida_util.csv"), row.names = FALSE)

png(file.path("dossie", "figuras", "fig_sens_wacc_g.png"), 1100, 640, res = 130)
par(mar = c(4.5, 4.8, 3, 1))
cores <- c("#2b6cb0", "#2f855a", "#b7791f", "#c05621", "#9b2c2c")
gs <- sort(unique(grid$g))
plot(NA, xlim = range(grid$wacc) * 100, ylim = range(grid$impairment_mil) / 1000, xlab = "WACC (% a.a.)", ylab = "Impairment da mais-valia (R$ milhoes)",
     main = "Sensibilidade do impairment (simulada) - Echo Participacoes")
for (k in seq_along(gs)) { s <- grid[grid$g == gs[k], ]; lines(s$wacc * 100, s$impairment_mil / 1000, col = cores[k], lwd = 2, type = "b", pch = 16) }
abline(h = IMP0 / 1000, lty = 2, col = "gray40"); abline(v = 8, lty = 3, col = "gray60")
legend("topleft", legend = paste0("g = ", gs * 100, "%"), col = cores, lwd = 2, pch = 16, bty = "n")
dev.off()
cat("FCF1 calibrado:", round(FCF1), "\n"); print(um); print(vu); print(head(grid, 8))
