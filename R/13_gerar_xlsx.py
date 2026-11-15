# 13_gerar_xlsx.py - planilha editavel com os principais resultados (requer openpyxl). Rodar da raiz: python3 R/13_gerar_xlsx.py
import csv, os
from openpyxl import Workbook
from openpyxl.styles import Font, Alignment, PatternFill
from openpyxl.utils import get_column_letter
R = "resultados"
def rd(f, base=R):
    with open(os.path.join(base, f), encoding="utf-8") as fh: return list(csv.reader(fh))
def num(x):
    try: return float(x) if x not in ("", "NA") else None
    except: return x
wb = Workbook(); wb.remove(wb.active)
HDR = PatternFill("solid", fgColor="DCE6F1")
def sheet(name, rows, wrap=False, widths=None):
    ws = wb.create_sheet(name[:31])
    for i, r in enumerate(rows):
        ws.append([num(c) if i else c for c in r])
    for c in ws[1]: c.font = Font(bold=True); c.fill = HDR; c.alignment = Alignment(wrap_text=True, vertical="top")
    for j in range(1, ws.max_column + 1):
        w = (widths or {}).get(j, min(max(len(str(c.value or "")) for c in ws[get_column_letter(j)][:60]) + 2, 60))
        ws.column_dimensions[get_column_letter(j)].width = w
        if wrap:
            for c in ws[get_column_letter(j)][1:]: c.alignment = Alignment(wrap_text=True, vertical="top")
    ws.freeze_panes = "A2"; return ws
ws = wb.create_sheet("LEIA-ME")
for l in ["Equatorial S.A. (consolidado) - Auditoria 1 - P2 - Matrícula 242010937",
          "Planilha editável gerada de resultados/*.csv. Fonte da verdade: scripts R/ (run_all.R).",
          "Aba 'Materialidade_editavel' tem fórmulas: altere benchmark/percentual e veja global, execução e J do MUS.",
          "Natureza dos PTs: Realizado com evidência pública | Planejado por falta de acesso | Simulado para fins didáticos."]:
    ws.append([l])
ws.column_dimensions["A"].width = 120
# Materialidade editavel com formulas
wm = wb.create_sheet("Materialidade_editavel")
wm.append(["Benchmark", "Valor (R$ mil)", "% adotado", "Materialidade (R$ mil)"])
bm = rd("01_materialidade_benchmarks.csv")[1:]
for i, r in enumerate(bm, start=2):
    wm.append([r[0], num(r[1]), num(r[2]), f"=B{i}*C{i}"])
n = len(bm) + 3
wm.append([]); wm.append(["Benchmark escolhido (1=ROL)", 1]); wm.append(["Materialidade global (arredondada, R$ mil)", "=ROUND(INDEX(D2:D7,B%d),-3)" % n])
wm.append(["Execução (75%)", f"=ROUND(B{n+1}*0.75,-3)"]); wm.append(["Trivial (5%)", f"=ROUND(B{n+1}*0.05,-3)"])
wm.append(["Fator de confiança (95%)", 3.0]); wm.append(["Intervalo MUS J = ME/FC", f"=B{n+2}/B{n+4}"])
wm.column_dimensions["A"].width = 52
for c in "BCD": wm.column_dimensions[c].width = 22
for c in wm[1]: c.font = Font(bold=True); c.fill = HDR
sheet("PTs_27", rd("pts_27.csv"), wrap=True, widths={j: 40 for j in range(1, 19)})
sheet("Matriz_NBC_TA", rd("matriz_cobertura_nbc_ta.csv"), wrap=True)
for nm, f in [("Benchmarks","01_materialidade_benchmarks.csv"),("Mat_adotada","02_materialidade_adotada.csv"),("Inserido_vs_detectado","07_inserido_vs_detectado_por_tipo.csv"),
              ("Conciliacao_base_N14","10_conciliacao_base_x_nota14.csv"),("Conciliacao_DFP","12_conciliacao_dfp_notas.csv"),("MUS_param","14_mus_parametros_original.csv"),
              ("MUS_aval_pre","16_mus_avaliacao_stringer_original.csv"),("MUS_aval_pos","16_mus_avaliacao_stringer_pos_correcao.csv"),("MUS_sens_n","17_mus_sensibilidade_n.csv"),
              ("Sens_WACC_g","18_sensibilidade_wacc_g.csv"),("Sens_1fator","19_sensibilidade_um_fator.csv"),("Sens_vida_util","20_sensibilidade_vida_util.csv"),
              ("Conta_alvo","00_justificativa_conta_alvo.csv"),("Matriz_riscos","23_matriz_riscos.csv"),("Respostas_riscos","24_matriz_respostas_riscos.csv"),("Mapa_distorcoes","25_mapa_distorcoes.csv"),("Deficiencias","26_matriz_deficiencias.csv"),("Avaliacao_evidencias","27_avaliacao_evidencias.csv"),("PT501_litigios","28_pt501_litigios.csv"),("PT550_partes_rel","29_pt550_partes_relacionadas.csv"),("PT600_componentes","30_pt600_componentes.csv"),("PT505_circularizacao","31_pt505_controle_circularizacao.csv"),("Analitico_amort","21_analitico_amortizacao.csv"),("Analitico_indices","22_analitico_indices.csv"),("Pendencias","pendencias.csv")]:
    sheet(nm, rd(f), wrap=True)
sheet("Fatos_DFP", rd("fatos_dfp_2025.csv", "fontes"), wrap=True)
sheet("Fontes", rd("controle_fontes.csv", "fontes"), wrap=True)
wb.save("resultados/Equatorial_P2_resultados_editavel.xlsx"); print("xlsx ok")
