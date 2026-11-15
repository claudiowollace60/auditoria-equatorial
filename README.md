# Auditoria 1 - P2: Equatorial S.A. (holding, consolidado) - Exercício 2025

Matrícula **242010937** · Conta-alvo: **Intangível (R$ 31.729.991 mil)** · Entidade: **Equatorial S.A.** (antes Equatorial Energia S.A.; EQTL3) · 

> Este projeto **substitui** o anterior. O anterior usava valores de uma controlada e materialidade de 1% de R$ 15.199.199 mil; aqui tudo parte das **demonstrações consolidadas da holding** (DFP 2025, PDF fornecido).

## Como reproduzir (do zero, ~30 s)
```r
# no R, com a raiz do projeto como diretório de trabalho (R >= 4.1)
source("R/run_all.R")        # roda 01..11, gera o PDF (se houver Chrome) e roda a verificação
```
Opcional: `python3 R/13_gerar_xlsx.py` (planilha editável; requer `openpyxl`). Semente única: `242010937` (R/00_config.R).
`R/12_verificacao.R` imprime a lista **OK/FALTA** (29 requisitos) e grava `resultados/verificacao.csv`.

## Estrutura
| Pasta | Conteúdo |
|---|---|
| `R/` | Scripts numerados 00-13 (config, fatos, base, materialidade, testes, conciliações, MUS, sensibilidade, analíticos, PTs, programas/minutas, dossiê, verificação, xlsx) |
| `fontes/` | `fatos_dfp_2025.csv` (34 fatos com página do PDF), `controle_fontes.csv` |
| `dados/` | **Base SINTÉTICA** (coluna `origem_dado`) (525.150 reg.), gabarito limpo, **log de erros inseridos**, dicionário, premissas |
| `resultados/` | Todas as saídas (CSV), `pts_27.csv`, matriz NBC TA, pendências, verificação, xlsx editável |
| `papeis_trabalho/` | **PT EC e PT 200 a PT 600** (27 PTs do roteiro do P2; um `.md` por PT, estrutura uniforme) |
| `programas_auditoria/` | Receitas, disponibilidades, estoques, imobilizado/intangível, passivos, estimativas |
| `minutas/` | Carta de contratação (PT 210), comunicação com a governança (PT 260), modelos de circularização (PT 505), carta de representação (PT 580), carta de recomendações e estrutura didática de relatório (sem opinião) |
| `docs/` | Índice dos PTs, convenção de códigos (PT 230) e **conclusão integrada** |
| `dossie/` | `dossie_P2.pdf/.html/.md` com referências cruzadas e figuras |

## O que atende a cada feedback do professor
| Feedback | Onde |
|---|---|
| Entidade/perímetro (holding) | Dossiê §1-2; PT01; `fontes/fatos_dfp_2025.csv` |
| C2 - 27 PTs com profundidade uniforme, minutas, revisão | `resultados/pts_27.csv`; `papeis_trabalho/`; `minutas/`; campo de revisão em todos |
| C3 - materialidade justificada para as DFs como um todo | `resultados/01-04_materialidade*`; PT11 (6 benchmarks comparados) |
| C5 - MUS, sensibilidade executada, avaliação da amostra | `resultados/14-17` (MUS pré e pós-correção, Stringer), `18-20` (sensibilidade), PT20/PT21 |
| C6 - organização e reprodutibilidade | `run_all.R`, semente fixa, verificação OK/FALTA |

## Natureza dos PTs (classificação oficial)
14 *Realizado com evidência pública* · 11 *Simulado para fins didáticos* · 2 *Planejado por falta de acesso* (PT 220 e PT 402; nos demais PTs as partes que dependem de acesso interno estão detalhadas como planejadas dentro do próprio PT).

## Resultados-chave
- Base limpa fecha com a Nota 14 (R$ 31.729.991 mil). Com 1.430 erros inseridos, a diferença é R$ 855.050 mil; os testes explicam R$ 854.668 mil (recall 65%, precisão 99,6%); **E8/E9 (500 registros) escapam por desenho** e aparecem como limitação.
- Materialidade: global R$ 260.000 mil (0,5% da ROL), execução R$ 195.000 mil, trivial R$ 13.000 mil.
- MUS: pré-correção LS R$ 1.724.180 mil > ME (não conclui); pós-correção LS R$ 194.723 mil ≤ ME (margem estreita).
- Inconsistências **da própria DFP**: 1.741 entre Notas 14 e 14.1 (efeito líquido nulo); componentes do impairment R$ 3.547.852 mil x total declarado R$ 3.391.261 mil (R$ 156.591 mil); amortização de Distribuição - Em serviço R$ 720.175 mil acima da expectativa (pendência P-19-1).

## Limitações e pendências (ver `resultados/pendencias.csv`)
- A abertura em registros individuais, as datas e a alocação por distribuidora são **simuladas**; só os totais por linha da Nota 14 são públicos.
- Sensibilidade do impairment usa premissas **hipotéticas** (horizonte 20 anos, g = 3,5%); fluxos reais não são divulgados.
- **Conferir a versão vigente de cada NBC TA no portal do CFC** e registrar a data de acesso (P-00).
- Campos de revisão estão PENDENTES em todos os PTs; revisor deve preencher.

## Conformidade com as instruções do P2
- **Roteiro.** Fiz os 27 papéis de trabalho pedidos: PT EC e NBC TA 200, 210, 220, 230, 240, 250, 260, 265, 300, 315, 320, 330, 402, 450, 500, 501, 505, 510, 520, 530, 540, 550, 560, 570, 580 e 600. A NBC TA 700 não está no roteiro, então só montei um modelo didático de relatório, sem opinião.

- **Versões das normas.** Consultei a lista de normas no site do CFC em 11/11/2026 e anotei a versão de cada uma na coluna `versao_norma` da matriz de cobertura. A NBC TA 240 (R2) e a 570 (R1) saíram no DOU em 25/09/2026, mas só valem para períodos que começam em ou depois de 01/01/2027 (notícia do CFC de 28/09/2026: https://cfc.org.br/noticias/cfc-atualiza-normas-de-auditoria-sobre-fraudes-e-continuidade-operacional/). Como o exercício analisado é 2025, usei a NBC TA 240 (R1) e a versão da 570 anterior à R1. Não achei o número da resolução dessas versões antigas na lista do CFC, então ainda preciso conferir isso.
- **Fontes** (`fontes/controle_fontes.csv`). O PDF da DFP 2025 foi baixado por mim no site de RI da Equatorial em 11/11/2026, e registrei o link direto do arquivo e a página de origem. Os portais da CVM e da B3 estão marcados como "não acessado", porque não os usei.
- **Identificação da companhia.** Equatorial S.A. (antes Equatorial Energia S.A.), ticker EQTL3, conforme a Nota 1 da DFP. Não consegui confirmar a data exata da mudança de nome.
- **Base sintética.** O arquivo tem cerca de 11 MB compactado, então cabe no limite de 100 MB do GitHub.


