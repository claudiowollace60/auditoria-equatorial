# run_all.R - executa o projeto do zero (a partir da raiz do projeto). Requer R >= 4.1 e pandoc/Chrome para o PDF.
for (s in c("01_fatos_fontes","02_gerar_base","03_materialidade","04_testes_base","05_conciliacoes","06_mus","07_sensibilidade_540",
            "08_analiticos_520","08b_matrizes_pts","09_papeis_trabalho","10_programas_minutas","11_dossie")) {
  cat("\n>>>", s, "\n"); source(file.path("R", paste0(s, ".R")), echo = FALSE)
}
# PDF do dossie (opcional): google-chrome --headless --no-pdf-header-footer --print-to-pdf=dossie/dossie_P2.pdf dossie/dossie_P2.html
if (file.exists("dossie/dossie_P2.html") && nzchar(Sys.which("google-chrome")))
  system2("google-chrome", c("--headless","--no-sandbox","--disable-gpu","--no-pdf-header-footer","--print-to-pdf=dossie/dossie_P2.pdf", paste0("file://", normalizePath("dossie/dossie_P2.html"))), stdout = FALSE, stderr = FALSE)
source("R/12_verificacao.R")
