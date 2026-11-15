# 09_papeis_trabalho.R - 27 papéis de trabalho em estrutura uniforme + matriz de cobertura (NBC TA) + pendências
source("R/00_config.R")
rd <- function(f) read.csv(file.path(DIR$res, f), stringsAsFactors = FALSE)
mat <- rd("02_materialidade_adotada.csv"); MG <- mat$valor_mil[1]; ME <- mat$valor_mil[2]; TRV <- mat$valor_mil[3]; ESP <- mat$valor_mil[4]
rs  <- rd("08_inserido_vs_detectado_resumo.csv"); g <- function(m) rs$valor[rs$medida == m]
tp <- rd("07_inserido_vs_detectado_por_tipo.csv")
cn  <- rd("10_conciliacao_base_x_nota14.csv"); DIF <- cn$diferenca_mil[cn$linha_nota14 == "TOTAL"]
ex  <- rd("11_explicacao_diferenca_base.csv"); RESID <- ex$valor_mil[3]
mo  <- rd("16_mus_avaliacao_stringer_original.csv"); mp <- rd("16_mus_avaliacao_stringer_pos_correcao.csv")
po  <- rd("14_mus_parametros_original.csv"); pp <- rd("14_mus_parametros_pos_correcao.csv")
val <- function(d, m, col = "superavaliacao") as.numeric(d[[col]][d$medida == m])
pv <- function(d, p) as.numeric(d$valor[d$parametro == p])
um  <- rd("19_sensibilidade_um_fator.csv"); vu <- rd("20_sensibilidade_vida_util.csv"); an <- rd("21_analitico_amortizacao.csv")
bm  <- rd("01_materialidade_benchmarks.csv")
N <- function(x, d = 0) fmt(x, d)
RES <- "Registrado no PT; resultados em resultados/"
PREP <- paste0("Matrícula ", MATRICULA)
mk <- function(cod, titulo, norma, objetivo, conta, afirm, riscos, pop, proc, evid, result, exc, concl, limit, nat)
  data.frame(codigo = cod, titulo = titulo, norma_itens = norma, objetivo = objetivo, conta_processo_divulgacao = conta,
             afirmacoes = afirm, riscos = riscos, populacao_fontes_criterios = pop, procedimentos = proc, evidencias_referencias = evid,
             resultados = result, excecoes = exc, conclusao = concl, limitacoes = limit, natureza = nat,
             preparador = PREP, data_elaboracao = DATA_ELAB, revisao = "PENDENTE - revisor: ______ data: ____/____/______")
REAL <- "Realizado com evidência pública"; PLAN <- "Planejado por falta de acesso"; SIM <- "Simulado para fins didáticos"
CT <- "Intangível (Nota 14) - R$ 31.729.991 mil (BP, PDF p.10)"
P <- list()
P[[1]] <- mk("PT 200","Objetivos gerais, ética, independência e ceticismo","NBC TA 200 (R1): itens 11-24, A1-A75; NBC TA 200 itens 13-15",
 "Documentar ética, independência, ceticismo, julgamento profissional, risco de auditoria e condições para obter segurança razoável.",
 "Demonstrações contábeis consolidadas; conta-alvo: Intangível.","Todas (existência, integridade, valorização, apresentação).",
 "Perímetro errado (controlada em vez da holding); dados sintéticos tomados como reais; ausência de independência e de ceticismo documentados.",
 "DFP 2025 da Equatorial S.A. (S01); orientações do P2 (S02); Código de Ética (CFC).",
 "1) Ética e independência: declaração didática do preparador (sem vínculo com a companhia, sem contato com empresa ou auditor, conforme instruções); ameaças avaliadas (autointeresse: nenhuma; familiaridade: nenhuma). 2) Ceticismo e julgamento: totais recalculados e reconciliados (não apenas lidos); inconsistências da DFP registradas (R$ 1.741 mil; R$ 156.591 mil). 3) Risco de auditoria = risco de distorção relevante x risco de detecção: risco de distorção alto em estimativas (PT 315); risco de detecção reduzido com MUS e analíticos (PT 530, PT 520). 4) Segurança razoável: exigiria controles e acesso interno; neste trabalho é alvo didático, sem opinião (PT EC). 5) Identificação da entidade: Equatorial S.A. (ticker EQTL3; Nota 1); antiga Equatorial Energia S.A.",
 "fontes/fatos_dfp_2025.csv (F01-F34); fontes/controle_fontes.csv; PT 230; PT EC.",
 "Entidade confirmada; escopo = consolidado; Intangível R$ 31.729.991 mil.","Diferença de R$ 156.591 mil no impairment (Nota 16) e de R$ 1.741 mil entre Notas 14 e 14.1 (PT 500).",
 "Ceticismo documentado; condições para segurança razoável não satisfeitas em termos reais (sem acesso interno).","Dados de registros individuais são sintéticos; só os totais por linha são públicos.",REAL)
P[[2]] <- mk("PT 210","Termos do trabalho de auditoria","NBC TA 210 (R1): itens 6-12, A1-A25",
 "Avaliar as precondições da auditoria e preparar carta de contratação didática (objetivo, alcance, responsabilidades, estrutura de relatório).",
 "Carta de contratação (minutas/carta_contratacao.md); estrutura de relatório financeiro aplicável.","Apresentação e divulgação.",
 "Escopo mal definido; expectativas divergentes; precondições não atendidas (estrutura inadequada, administração sem responsabilidade reconhecida).",
 "DFP 2025: Nota 2 (base de preparação, CPC/IFRS), aprovação pelo Conselho em 25/03/2026 (PDF p.22); minuta didática.",
 "1) Precondições avaliadas com a DFP pública: (a) estrutura de relatório = CPC/IFRS (aceitável); (b) administração reconhece responsabilidade pela elaboração e aprovação das DFs (25/03/2026); (c) acesso a informações: limitado ao público, o que NÃO atenderia a precondição em um trabalho real. 2) Carta de contratação didática preparada com objetivo, alcance (consolidado 2025, conta-alvo Intangível), responsabilidades e estrutura do relatório. 3) Conclusão: precondições atendidas apenas para fins didáticos.",
 "minutas/carta_contratacao.md; DFP p.22.","Carta preparada; precondição de acesso não atendida em termos reais.","Nenhuma carta foi enviada ou assinada.",
 "Carta didática pronta; contratação real exigiria acesso a informações internas (pendência P-02).","Carta fictícia; não há contratante real.",SIM)
P[[3]] <- mk("PT 220","Gestão da qualidade da auditoria","NBC TA 220 (R3): itens 13-40",
 "Planejar direção, supervisão, revisão, consultas e recursos, documentando conflitos e riscos à qualidade.",
 "Gestão da qualidade do trabalho (individual, didático).","Não se vincula a afirmação de saldo; vincula-se à confiabilidade do trabalho.",
 "Risco de falta de revisão independente, de base simulada tomada como real e de dependência de fontes públicas.",
 "Orientações do P2; política de qualidade de firma (inexistente neste trabalho).",
 "Planejado: (1) Direção: preparador único (matrícula informada) com roteiro do P2; (2) Supervisão: orientação do professor; (3) Revisão: campo de revisão em cada PT, sem simular revisor; (4) Consultas: normas do CFC e leitura da DFP; (5) Recursos: R, pandoc, planilhas; (6) Conflitos e riscos à qualidade registrados: ausência de revisor, uso de dados sintéticos, acesso apenas público, prazo. Executado: criação do campo de revisão (PENDENTE) nos 27 PTs.",
 "resultados/pts_27.csv (campo 'revisao'); PT 230.","Campo de revisão presente em 27/27 PTs; todos pendentes.","Nenhuma revisão realizada; nenhuma assinatura simulada.",
 "Qualidade depende de revisão futura por terceiro.","Trabalho individual; sem revisor de qualidade.",PLAN)
P[[4]] <- mk("PT 230","Documentação de auditoria","NBC TA 230 (R1): itens 8-16, A1-A24",
 "Criar índice, convenção de códigos, referências cruzadas, controle de versões e rotina de montagem e guarda do arquivo.",
 "Dossiê completo (scripts, dados, PTs).","Todas.","PTs sem referência cruzada; resultados não reproduzíveis; perda de versões.",
 "Repositório; scripts R/00-13; docs/indice_pts.md; docs/convencao_codigos.md.",
 "1) Índice dos PTs gerado automaticamente (docs/indice_pts.md). 2) Convenção: PT EC e PT <nº da NBC TA>; arquivos em papeis_trabalho/PT_<código>.md; referências cruzadas no formato PT nnn / resultados/nn_*. 3) Controle de versões em resultados/32_controle_versoes.csv e Git. 4) Montagem: executar R/run_all.R e R/12_verificacao.R (lista OK/FALTA). 5) Guarda: prazo de retenção tratado como parâmetro didático (5 anos), a definir pela firma/regulador em trabalho real.",
 "docs/indice_pts.md; docs/convencao_codigos.md; resultados/verificacao.csv; README.md.","Verificação sem FALTA.","Nenhuma, se a verificação retornar 100% OK.",
 "Documentação suficiente para reperformance.","Dados brutos da DFP não redistribuídos (apenas os fatos extraídos e a referência de página).",REAL)
P[[5]] <- mk("PT 240","Responsabilidades do auditor quanto a fraude","NBC TA 240: itens 12-32, A1-A44 (versão do exercício 2025 - ver matriz)",
 "Avaliar fatores de risco de fraude, incluindo reconhecimento de receita e burla de controles pela administração; planejar testes de lançamentos e respostas.",
 "Receita (R$ 52.073.804 mil; KAM de receita não faturada R$ 1.546.475 mil); estimativas; lançamentos manuais; base do Intangível.","Ocorrência, corte, existência, valorização.",
 "Presunção de fraude em receita; burla de controles; viés em estimativas (impairment, provisões); capitalização indevida.",
 "DFP; base sintética de 525.150 registros.",
 "1) Fatores de risco (incentivos/pressão: covenants dívida líquida/EBITDA <= 4,5, metas de resultado; oportunidade: estimativas complexas; racionalização: não observável). 2) Receita: presunção de risco mantida para receita não faturada e receita de construção. 3) Burla de controles: planejados testes de lançamentos manuais (critérios: fim de período, valores redondos, usuário incomum, contas incomuns) - planejados por falta de acesso ao razão; executados na base sintética testes de duplicidade (T1), valores atípicos (T7), sinal e data (T4, T6). 4) Resposta: elementos de imprevisibilidade (amostra MUS com partida aleatória). 5) Resultado nos testes sintéticos: erros inseridos 1.430; detectados 930; falsos positivos 4. E8 e E9 não detectáveis por testes aritméticos.",
 "R/04_testes_base.R; resultados/05-09; PT 330.","Duplicidades e outliers identificados; ver resultados/07.","E8/E9 não detectados (500 registros).",
 "Risco de fraude não eliminado: testes aritméticos são insuficientes para estimativas; testes de lançamentos reais pendentes.","Base sintética; sem acesso a lançamentos reais.",SIM)
P[[6]] <- mk("PT 250","Leis e regulamentos","NBC TA 250: itens 12-24, A1-A22",
 "Mapear obrigações relevantes e riscos de descumprimento; definir procedimentos e comunicações diante de indícios.",
 "Concessões de distribuição, geração e saneamento; contratos de dívida; Lei das S.A.; normas CVM/B3.","Apresentação e divulgação; existência e obrigações.",
 "Descumprimento de contratos de concessão (ANEEL), covenants, regras de companhia aberta (Novo Mercado) ou ambientais com efeito em provisões e impairment.",
 "Notas 1, 14, 16, 18.6, 23 (DFP); regulamentos ANEEL (acesso externo pendente).",
 "1) Mapa de obrigações: (a) contratos de concessão e regulação ANEEL (Nota 1, prazos até 2030-2057); (b) Lei das S.A. e CVM (DFP e ITR); (c) Novo Mercado B3 desde 2008 (Nota 1); (d) covenants financeiros (Nota 18.6); (e) legislação ambiental, regulatória e fiscal (provisões da Nota 23: regulatórias R$ 118.357 mil; ambientais R$ 40.480 mil). 2) Executado: leitura dos covenants (limite dívida líquida/EBITDA <= 4,5; apurados entre 1,8 e 2,8; PDF p.77) e das provisões regulatórias/ambientais. 3) Planejado: contratos de concessão, correspondência com ANEEL e atas. 4) Diante de indício: documentar, discutir com a administração e comunicar à governança (PT 260); considerar comunicação a autoridades conforme NBC TA 250 itens 22-28.",
 "PDF p.76-77, 89; PT 570; PT 260.","Covenants dentro do limite; provisões regulatórias aumentaram de R$ 41.851 mil para R$ 118.357 mil.","Contratos de concessão não obtidos.",
 "Sem indício de descumprimento em evidência pública; conformidade plena depende de acesso (P-06).","Sem acesso a contratos e correspondência regulatória.",REAL)
P[[7]] <- mk("PT 260","Comunicação com os responsáveis pela governança","NBC TA 260 (R2): itens 14-17, A12-A24",
 "Preparar comunicação sobre alcance, época, riscos significativos, independência e principais dificuldades.",
 "Governança corporativa (Conselho e comitê).","Apresentação e divulgação.",
 "Achados relevantes não comunicados tempestivamente.","Minuta didática (minutas/comunicacao_governanca.md); PT 315, 450, 265.",
 "Simulado: minuta contendo (1) alcance e época (planejamento e conclusão); (2) riscos significativos (impairment, receita não faturada, provisões judiciais); (3) declaração didática de independência; (4) principais dificuldades (acesso apenas público, dados sintéticos); (5) deficiências significativas (PT 265).",
 "minutas/comunicacao_governanca.md.","Minuta com 5 itens obrigatórios.","Não enviada.","Pendente de envio e retorno (simulados).","Sem interlocutor real; comunicação fictícia.",SIM)
P[[8]] <- mk("PT 265","Comunicação de deficiências de controle interno","NBC TA 265: itens 7-10, A5-A12",
 "Preparar matriz com condição, critério, causa, efeito e recomendação, distinguindo hipóteses de constatações.",
 "Controles de cadastro, amortização e divulgação do Intangível.","Integridade, valorização, classificação.",
 "Deficiência significativa não comunicada; hipótese tratada como fato.",
 "resultados/26_matriz_deficiencias.csv; resultados/25_mapa_distorcoes.csv.",
 "13 itens classificados: 7 constatações em testes na base sintética (D01-D07), 2 constatações em evidência pública (D10, D11) e 4 hipóteses (D08, D09, D12, D13). Significância avaliada em função da materialidade de execução e da natureza.",
 "resultados/26; PT 450; PT 260.","Deficiências significativas: D01 (valores atípicos), D03, D10 (impairment) e D12 (a investigar).","Hipóteses não sustentadas por evidência: D08, D09, D12, D13.",
 "Matriz pronta; hipóteses dependem de informação interna.","Constatações D01-D07 refletem erros inseridos em dados sintéticos.",SIM)
P[[9]] <- mk("PT 300","Planejamento da auditoria","NBC TA 300 (R1): itens 7-12, A2-A15",
 "Elaborar estratégia global, plano, cronograma e programas por ciclo; justificar prioridades e alterações.",
 "Demonstrações consolidadas; Intangível; ciclos de receitas, disponibilidades, estoques, imobilizado/intangível, passivos e estimativas.","Todas.",
 "Dedicar esforço a contas imateriais; ignorar a operação descontinuada (transmissão).",
 "DFP 2025 (BP p.10; DRE p.11; Notas 14, 16, 27; relatório p.3-4).",
 "1) Estratégia global: auditoria de grupo, conta-alvo Intangível (28,9% do ativo), ênfase em estimativas. 2) Entendimento: ROL R$ 52.073.804 mil; ativo R$ 109.603.944 mil; venda do Grupo Transmissão (31/10/2025, Nota 35); impairment R$ 3.391.261 mil. 3) Plano: PT 315 (riscos), PT 320 (materialidade), PT 330 (respostas). 4) Cronograma didático: planejamento (semana 1), execução (semanas 2-3), conclusão (semana 4); entrega em 25/10/2026. 5) Programas por ciclo em programas_auditoria/01-06. 6) Prioridades justificadas pelo risco significativo (PT 315) e alterações previstas: se o MUS ficar acima do erro tolerável, ampliar amostra (ver sensibilidade do tamanho, resultados/17).",
 "fontes/fatos_dfp_2025.csv; PT 315; PT 320; programas_auditoria/.","Estratégia e plano definidos.","Nenhuma.","Plano baseado em dados públicos e coerente com o risco.","Sem orçamento de horas e equipe reais.",REAL)
P[[10]] <- mk("PT 315","Identificação e avaliação dos riscos de distorção relevante","NBC TA 315 (R2): itens 19-34, A60-A118",
 "Compreender a entidade, seu ambiente, estrutura contábil, TI e controles; elaborar matriz de riscos por conta e afirmação; identificar riscos significativos.",
 "Intangível; impairment; receita; provisões; ativo financeiro; dívida.","Existência, integridade, valorização, classificação, apresentação.",
 "Impairment (WACC 8,00% Echo); vida útil; provisões judiciais (reversões de R$ 1.749.649 mil); receita não faturada; operação descontinuada.",
 "DFP 2025: Notas 1, 2, 6, 14, 16, 23, 27, 35, 38; relatório do auditor (KAMs).",
 "1) Entidade e ambiente: holding de participações em distribuição, geração e saneamento (Nota 1); setor regulado pela ANEEL. 2) Estrutura contábil: CPC/IFRS (Nota 2); ICPC 01/IFRIC 12 para concessões. 3) TI: sistemas de cadastro, faturamento e razão não observáveis (planejado). 4) Controles: não testados (planejado). 5) Matriz de riscos por conta e afirmação com 13 riscos; significativos: impairment, vida útil/amortização, receita não faturada (KAM) e provisões judiciais. 6) Inconsistências da DFP: R$ 1.741 mil (Notas 14/14.1), R$ 156.591 mil (impairment) e Direito de exploração com líquido negativo (R$ 165.415 mil).",
 "resultados/23_matriz_riscos.csv; resultados/12_conciliacao_dfp_notas.csv; PT 330; PT 540.","4 riscos significativos; 13 riscos mapeados.",
 "Diferença de R$ 156.591 mil no impairment (acima do trivial, abaixo da global).","Risco de distorção relevante alto para estimativas.","Entendimento de TI e controles planejado, não executado; fluxos de caixa projetados não divulgados.",REAL)
P[[11]] <- mk("PT 320","Materialidade no planejamento e na execução","NBC TA 320: itens 10-11, 12-13, A3-A14",
 "Determinar materialidade para as demonstrações contábeis como um todo, de execução, trivial e específica; comparar benchmarks.","Demonstrações consolidadas (não apenas o Intangível).","Todas.",
 "Risco de benchmark inadequado (LAIR deprimido por impairment) e de erro tolerável incompatível com o saldo.",
 "DFP: ROL (p.11), LAIR (p.11), ativo (p.10), PL (p.10); resultados/01-03.",
 sprintf("Calcular 6 benchmarks (ROL, ROL sem construção, LAIR, LAIR médio, Ativo, PL) com faixas usuais; escolher 0,5%% da ROL = R$ %s mil, arredondada para R$ %s mil. Execução 75%% = R$ %s mil; trivial 5%% = R$ %s mil; específica 50%% = R$ %s mil para partes relacionadas, covenants e divulgação de impairment. Comparar com as alternativas (LAIR 5%% = R$ 122.750 mil; Ativo 0,5%% = R$ 548.020 mil).", N(52073804*.005), N(MG), N(ME), N(TRV), N(ESP)),
 "resultados/01_materialidade_benchmarks.csv; 02; 03; 04_materialidade_justificativa.txt.",
 sprintf("Materialidade global R$ %s mil (0,5%% ROL); execução R$ %s mil; trivial R$ %s mil.", N(MG), N(ME), N(TRV)),
 sprintf("O Intangível equivale a %s vezes a materialidade global; cobertura no PT 530.", N(round(31729991 / MG))),"Materialidade definida para o consolidado e aplicada à conta-alvo no PT 530.","Julgamento sobre usuários principais; revisável com a administração e credores.",REAL)
P[[12]] <- mk("PT 330","Respostas do auditor aos riscos avaliados","NBC TA 330 (R1): itens 5-6, 18-24, A4-A57",
 "Relacionar cada risco a testes de controles e procedimentos substantivos, definindo natureza, época e extensão e distinguindo executados de planejados.",
 "Intangível; receitas; provisões; estimativas.","Valorização, existência, classificação, integridade.",
 "Resposta insuficiente aos riscos significativos.","resultados/24_matriz_respostas_riscos.csv; PT 315.",
 "17 respostas a 13 riscos. Testes de controles: NÃO executados (sem acesso). Substantivos executados: 6 com evidência pública e 5 em dados sintéticos; 6 planejados (sem acesso). Natureza, época e extensão registradas por linha.",
 "resultados/24; programas_auditoria/01-06.","Cada risco significativo tem ao menos um teste substantivo executado.","Classificação (R04) e inspeção física (R03) apenas planejadas.",
 "Respostas adequadas em desenho; parte da execução depende de acesso interno.","Execução parcial em dados públicos e sintéticos.",SIM)
P[[13]] <- mk("PT 402","Organização prestadora de serviços","NBC TA 402: itens 9-17, A1-A20",
 "Identificar serviços terceirizados relevantes e controles complementares; planejar análise de relatórios tipo 1/tipo 2 e procedimentos alternativos.",
 "Processo de capitalização e cadastro de ativos; faturamento e arrecadação; TI.","Integridade, valorização.",
 "Terceiros executam obras, leitura de medidores, cobrança e TI; relatórios SOC podem não existir.",
 "DFP Nota 37 (compromissos de operação e manutenção, PDF p.139); contratos (não disponíveis).",
 "Planejado: (1) levantar prestadores relevantes (obras, leitura/faturamento, TI); (2) solicitar relatório tipo 2 e avaliar escopo, período e opinião; (3) mapear controles complementares do usuário; (4) se não houver relatório: procedimentos alternativos (teste de amostra de obras e faturas, inspeção de contratos). Executado: identificação dos contratos de operação e manutenção (2026 a 2046) na Nota 37.",
 "DFP p.139; PT 315.","Indício de terceirização relevante; relatórios não obtidos.","Sem relatórios SOC.","Pendente de evidência.","Sem acesso a contratos e relatórios.",PLAN)
P[[14]] <- mk("PT 450","Avaliação das distorções identificadas","NBC TA 450 (R1): itens 5-12, A1-A19",
 "Elaborar mapa de distorções identificadas ou simuladas, corrigidas e não corrigidas, e avaliar efeitos quantitativos e qualitativos.",
 "Intangível - base sintética.","Valorização, existência.","Distorções não corrigidas acima da materialidade.",
 "resultados/25_mapa_distorcoes.csv; resultados/13; MUS (PT 530).",
 sprintf("Mapa por tipo de erro (9 tipos): detectadas e corrigidas na reavaliação (E1-E7) e não corrigidas (E8 e E9). Distorções factuais detectadas: R$ %s mil líquidas (E7 R$ 808.236 mil; E2 R$ 39.971 mil; E1 R$ 11.523 mil; E6 R$ 9.178 mil; E3 R$ -14.239 mil). Residual não corrigido: R$ %s mil (E8), abaixo do trivial (R$ 13.000 mil), mas com viés unidirecional (qualitativo). MUS pré-correção: limite superior R$ %s mil (ME R$ %s mil).", N(sum(rd("13_distorcoes_detectadas_por_tipo.csv")$valor_distorcao_mil)), N(RESID,1), N(val(mo,"Limite superior total (R$ mil)")), N(ME)),
 "resultados/25; resultados/11, 13, 16.","Distorção factual agregada acima da materialidade global; exige ajuste.","E8 (viés) e E9 (classificação) não corrigidas.",
 "Solicitar correção; reavaliar após ajuste (MUS pós-correção LS = R$ 194.723 mil <= ME).","Distorções são sintéticas.",SIM)
P[[15]] <- mk("PT 500","Evidência de auditoria: reconciliações e testes de detalhes","NBC TA 500: itens 6-11, A1-A25",
 "Reconciliar a base com Nota 14, Nota 14.1 e BP; testar atributos dos registros.","Intangível.","Existência, integridade, valorização, classificação.",
 "Base que não fecha com a DFP; erros aritméticos e de cut-off.","Base 525.150 registros; Nota 14 (p.63), 14.1 (p.65), BP (p.10).",
 sprintf("1) Base limpa fecha com a DFP em R$ 31.729.991 mil. 2) Base com erros diverge em R$ %s mil. 3) Oito testes (duplicidade, líquido, amort>custo, data futura, taxa, sinal, outlier, recálculo). 4) Comparação inserido x detectado: recall %s%%, precisão %s%%.", N(DIF,1), g("Recall (%)"), g("Precisao (%)")),
 "resultados/05-12; resultados/27_avaliacao_evidencias.csv; R/04; R/05.",
 sprintf("Detectados %d de %d; %d falsos positivos; diferença explicada R$ %s mil; residual R$ %s mil.", g("Detectados (VP)"), g("Erros inseridos"), g("Sinalizados que nao sao erros (FP)"), N(ex$valor_mil[2],1), N(RESID,1)),
 "E8/E9 não detectados; Notas 14 x 14.1 divergem 1.741 (custo e amortização); impairment 156.591.","Testes aritméticos reconciliam; classificação e subamortização coerente exigem evidência externa.",
 "Recall alto em E1-E7 é parcialmente circular (testes desenhados a partir dos tipos inseridos); E8/E9 mostram o limite.",SIM)
P[[16]] <- mk("PT 501","Considerações específicas sobre itens selecionados","NBC TA 501: itens 4-8, A1-A19",
 "Planejar e executar, com as fontes disponíveis, procedimentos sobre estoques, litígios e informações por segmento.",
 "Almoxarifado R$ 291.436 mil; provisões judiciais R$ 4.749.734 mil (depósitos R$ 763.970 mil); informações por UF (PDF p.138).","Existência, integridade, valorização, apresentação.",
 "Itens obsoletos; provisões judiciais subestimadas; segmento mal apresentado.",
 "DFP BP p.10; Nota 23 (p.89-90); nota de segmentos (p.138).",
 "EXECUTADO: (1) Recalculei a movimentação das provisões da Nota 23 por natureza (saldo 2024 + adições - utilização - reversão + atualização + reclassificação): diferença zero em todas as naturezas e no total (R$ 4.749.734 mil). (2) Reversões de R$ 1.749.649 mil = 33% do saldo inicial (trabalhistas 39,4%; cíveis 29,2%): estimativa sensível (PT 315, R08). (3) Processos de perda possível caíram de R$ 6.076.778 mil para R$ 3.496.979 mil (-42,5%). (4) Almoxarifado cresceu 93% (R$ 150.896 mil para R$ 291.436 mil). PLANEJADO: inventário físico, cartas de advogados, teste de probabilidade e conciliação de segmentos.",
 "resultados/28_pt501_litigios.csv; programas_auditoria/03_estoques.md.","Movimentação das provisões foot; reversões e queda de possíveis exigem inquirição.","Aumento do almoxarifado e reversões sem explicação pública.",
 "Parte executada com evidência pública; julgamentos jurídicos e inventário pendentes (P-16).","Sem acesso físico, a advogados e ao razão.",REAL)
P[[17]] <- mk("PT 505","Confirmações externas","NBC TA 505: itens 7-14, A1-A22",
 "Preparar modelos, controle de circularização, tratamento de diferenças e procedimentos alternativos, sem enviar solicitações reais.",
 "Caixa R$ 2.659.827 mil; empréstimos R$ 20.978.503 mil; debêntures R$ 33.493.260 mil; clientes poder público R$ 452.242 mil; provisões judiciais; dividendos da coligada SABESP R$ 308.748 mil.","Existência, direitos e obrigações.",
 "Saldos não confirmados por terceiros.","BP p.10; Notas 4, 6, 9, 18, 19, 23; resultados/31_pt505_controle_circularizacao.csv.",
 "Simulado: (1) seis populações definidas (bancos, credores, debenturistas, clientes, advogados, coligada); (2) modelos de solicitação em minutas/modelos_circularizacao.md; (3) controle com status NÃO ENVIADA e resposta Não; (4) regra de tratamento de diferenças (investigar acima do trivial, registrar no PT 450); (5) procedimentos alternativos por população. Nenhuma solicitação foi enviada.",
 "minutas/modelos_circularizacao.md; resultados/31.","Modelos e controle prontos; nenhuma confirmação enviada ou recebida.","Sem respostas.",
 "Pendente: procedimentos alternativos dependem de razão e extratos.","Vedado contatar terceiros.",SIM)
P[[18]] <- mk("PT 510","Saldos iniciais (auditoria inicial didática)","NBC TA 510 (R1): itens 6-9, A1-A8",
 "Tratar o caso como auditoria inicial didática: examinar saldos de abertura, políticas contábeis e efeitos de modificações na opinião do auditor anterior.",
 "Intangível 2024: R$ 32.373.681 mil; comparativos reapresentados.","Existência, valorização, apresentação.",
 "Saldo inicial diferente do fechamento anterior; mudança de política; reapresentação pela operação descontinuada.",
 "BP 2024 (p.10); Nota 14.1 (p.65); relatório do auditor (p.3-4); Nota 35.",
 "1) Saldo de abertura do Intangível na Nota 14.1 = BP 2024 (R$ 32.373.681 mil): concilia. 2) Reapresentação da transmissão (Nota 35; efeito de R$ 20.083 mil no Intangível). 3) Políticas contábeis: sem mudança de política indicada no relatório do auditor. 4) Opinião do auditor anterior: relatório do ano anterior não consultado; o relatório de 2025 não menciona modificação, apenas ênfase de reapresentação. PLANEJADO: obter relatório e papéis do auditor anterior.",
 "resultados/12_conciliacao_dfp_notas.csv.","Saldo inicial concilia sem diferença.","Relatório do ano anterior não examinado.","Saldos de abertura adequados com a evidência disponível.","Não se examinou o relatório de 2024.",REAL)
P[[19]] <- mk("PT 520","Procedimentos analíticos","NBC TA 520: itens 5-7, A4-A21",
 "Construir expectativas, definir precisão e limites de investigação, calcular relações e variações e investigar diferenças, com cálculos reproduzíveis.",
 "Amortização do Intangível; índices financeiros.","Valorização.",
 "Amortização subestimada ou superestimada; taxas inadequadas.","Nota 14.1; Nota 14; resultados/21-22 (R/08_analiticos_520.R).",
 sprintf("Expectativa = custo médio (Nota 14.1) x taxa média (Nota 14). Precisão: taxas da Nota 14 são médias por classe (tolerância esperada de 5-10%%). Limite de investigação = materialidade de execução (R$ %s mil). Resultados: Distribuição - Em serviço (líquido de obrigações) esperado R$ %s mil x registrado R$ %s mil (diferença R$ %s mil, %s%%), acima do limite; Direito de concessão (Distribuição) diferença R$ %s mil, dentro do limite; Geração - autorização praticamente igual.", N(ME), N(an$esperado_mil[6]), N(an$registrado_mil[6]), N(an$diferenca_mil[6]), an$dif_pct[6], N(an$diferenca_mil[3])),
 "resultados/21_analitico_amortizacao.csv; 22_analitico_indices.csv.","Diferença em Em serviço não explicada com dados públicos.","Diferença acima do limite em Em serviço (taxa média por classe e baixas não divulgadas).",
 "Investigação pendente (P-19-1): obter abertura por classe, taxas e baixas.","Taxas da Nota 14 são médias; transferências no ano não ponderadas.",REAL)
P[[20]] <- mk("PT 530","Amostragem de auditoria (MUS)","NBC TA 530: itens 6-14, A1-A22",
 "Selecionar e avaliar amostra por unidade monetária do Intangível, projetando erros ao universo.","Intangível - saldos devedores da base.","Valorização, existência.",
 "Risco de amostragem; itens grandes sem teste.","Base de 525.150 registros; ME = R$ 195.000 mil (PT 320).",
 sprintf("J = ME/FC = R$ %s mil (FC 3,00; 95%%); itens-chave >= J examinados a 100%% (%d); amostra sistemática de %d itens do restante. Avaliação de Stringer. Pré-correção: %d erros na amostra, limite superior R$ %s mil > ME. Pós-correção dos itens sinalizados: n=%d, 0 erros, limite superior R$ %s mil <= ME (R$ %s mil).", N(pv(po,"Intervalo de amostragem J = ME/FC (R$ mil)")), pv(po,"Itens-chave >= J (100%)"), pv(po,"Tamanho da amostra MUS (restante)"), val(mo,"Erros na amostra (n)"), N(val(mo,"Limite superior total (R$ mil)")), pv(pp,"Tamanho da amostra MUS (restante)"), N(val(mp,"Limite superior total (R$ mil)")), N(ME)),
 "resultados/14-17; R/06_mus.R.","Pré-correção: não suporta conclusão; pós-correção: suporta (margem estreita).",
 "21.888 registros credores (R$ -1.060.862 mil) fora do MUS: cobertos por conciliação (PT 500) e analítico (PT 520).","Conclusão condicionada à correção dos erros detectados; E9 invisível ao MUS.","Valor auditado é simulado (base limpa); erro esperado zero.",SIM)
P[[21]] <- mk("PT 540","Estimativas contábeis e sensibilidade (impairment e vida útil)","NBC TA 540 (R2): itens 13-23, A1-A100",
 "Avaliar o impairment da mais-valia Echo e a razoabilidade das taxas de amortização; executar sensibilidade.","Mais-valia Echo: valor recuperável R$ 4.053.163 mil; perda R$ 2.359.265 mil; WACC 8,00%.","Valorização, apresentação.",
 "Viés da administração em WACC e crescimento; horizonte da autorização.","Nota 16 (PDF p.68-69); fluxo simulado calibrado.",
 sprintf("Fluxo FCF1 calibrado para reproduzir o valor recuperável; grade WACC (7,00%%-9,50%%) x g (2,5%%-4,5%%) e testes de um fator. WACC +0,5 p.p. aumenta o impairment em R$ %s mil (%s x materialidade); WACC +1,0 p.p. em R$ %s mil; horizonte de 15 anos em R$ %s mil. Vida útil: taxas +10%% alteram a despesa anual em R$ %s mil (%s x materialidade).", N(um$delta_mil[2]), um$delta_x_materialidade[2], N(um$delta_mil[4]), N(um$delta_mil[7]), N(vu$delta_mil[4]), vu$delta_x_materialidade[4]),
 "resultados/18-20; dossie/figuras/fig_sens_wacc_g.png.","O impairment é sensível: WACC +1 p.p. e horizonte ±5 anos excedem a materialidade global.","Fluxos reais não divulgados; premissas H=20 anos e g=3,5% são simuladas.",
 "Recomenda-se obter o modelo da administração e testar premissas de crescimento e horizonte.","Premissas de horizonte e crescimento hipotéticas.",SIM)
P[[22]] <- mk("PT 550","Partes relacionadas","NBC TA 550: itens 11-24, A1-A50",
 "Mapear vínculos, saldos e transações; avaliar completude e divulgações; planejar a identificação de operações não informadas.",
 "Nota 9 (PDF p.48); saldos R$ 913.670 mil (controladora).","Ocorrência, integridade, apresentação e divulgação.",
 "Transações não divulgadas ou fora de condições de mercado.","DFP Nota 9; atas e razão (não disponíveis).",
 "EXECUTADO: (1) mapeamento de vínculos: controladas diretas e indiretas, coligada SABESP, recuperação judicial da Equatorial Pará; (2) footing da Nota 9: R$ 14.492 + R$ 138.663 + R$ 760.515 = R$ 913.670 mil, diferença zero; (3) comparação 2025 x 2024: dividendos a receber caem de R$ 1.161.256 mil para R$ 760.515 mil. PLANEJADO: lista de partes relacionadas da administração, teste de transações (limite específico R$ 130.000 mil), consulta ao razão e a atas para operações não informadas.",
 "resultados/29_pt550_partes_relacionadas.csv; DFP p.48.","Divulgação consistente internamente.","Operações não informadas só detectáveis com acesso interno.",
 "Sem indício de erro na Nota 9; completude não concluída (P-22).","Sem lista independente de partes relacionadas.",REAL)
P[[23]] <- mk("PT 560","Eventos subsequentes","NBC TA 560 (R1): itens 6-9, A1-A12",
 "Fixar a data de corte, examinar publicações posteriores ao encerramento e distinguir eventos que exigem ajuste dos que exigem divulgação.",
 "Nota 38 (PDF p.139-141); data do relatório do auditor: 25/03/2026.","Apresentação e divulgação.","Evento relevante omitido.","DFP Nota 38; relatório do auditor (p.9).",
 "1) Data de corte: 25/03/2026 (aprovação das DFs pelo Conselho e relatório do auditor). 2) Eventos listados: aumento de capital da Equatorial Distribuição (R$ 434.000 mil, 02/01/2026), dividendos privilegiados (R$ 434.000 mil), conversão de 233.174.756 ações preferenciais (05/01/2026), 11ª emissão de debêntures da Equatorial Pará (R$ 800.000 mil, 13/02/2026), aumento de capital da Pará (R$ 145 mil), dividendos adicionais de Alagoas (R$ 142 mil) e aumento de capital de Alagoas (R$ 641.780 mil). 3) Classificação: todos exigem divulgação, nenhum exige ajuste do Intangível. PLANEJADO: pesquisa de fatos relevantes e comunicados na CVM/B3 após 25/03/2026.",
 "DFP p.139-141.","Nenhum evento exige ajuste do Intangível; todos divulgados na Nota 38.","Pesquisa após a data de corte não executada.","Sem ajuste; divulgação adequada.","Pesquisa em portais CVM/B3 após o corte não realizada.",REAL)
P[[24]] <- mk("PT 570","Continuidade operacional","NBC TA 570: itens 10-16, A3-A24 (versão do exercício 2025 - ver matriz)",
 "Avaliar capacidade de continuar operando (liquidez, covenants).","Caixa, dívida, covenants (Nota 18.6).","Apresentação e divulgação.",
 "Descumprimento de covenants e liquidez de curto prazo.","BP p.10; Nota 18.6 (p.76-77).",
 "1) CCL = AC R$ 26.604.996 mil - PC R$ 17.803.899 mil = R$ 8.801.097 mil (2024: R$ 8.922.137 mil). 2) Covenant dívida líquida/EBITDA ≤ 4,5; apurado entre 1,8 e 2,8. 3) Dívida bruta/PL 1,92.",
 "resultados/22_analitico_indices.csv; DFP p.76-77.","Sem indício de incerteza relevante.","Nenhuma.","Continuidade operacional adequada com base nos dados públicos.","Sem projeção de fluxo de caixa da administração.",REAL)
P[[25]] <- mk("PT 580","Representações formais","NBC TA 580 (R1): itens 10-16, A1-A27",
 "Preparar minuta didática da carta de representações e explicar por que não substitui outras evidências.",
 "Administração.","Todas.","Falta de representações sobre estimativas de impairment.","Minuta didática (minutas/carta_representacao.md).",
 "Simulado: minuta com responsabilidade pelas DFs, integralidade de informações, estimativas, partes relacionadas e eventos subsequentes. Explicação: a carta é evidência de natureza declaratória; não substitui testes de detalhes, analíticos nem confirmações, e não reduz a necessidade de ceticismo (itens 4 e 14).",
 "minutas/carta_representacao.md.","Minuta preparada.","Não assinada.","Pendente de assinatura (simulada).","Carta fictícia para fins didáticos.",SIM)
P[[26]] <- mk("PT 600","Auditoria de grupo (componentes)","NBC TA 600 (R2): itens 17-45, A1-A60",
 "Mapear grupo, componentes e processo de consolidação; avaliar riscos, materialidade dos componentes, envolvimento de auditores de componentes e suficiência das evidências.",
 "Componentes: Distribuição, Saneamento e Geração; consolidação.","Existência, valorização, apresentação.","Componente significativo sem trabalho adequado; eliminações incorretas.",
 "DFP Notas 1.1, 14, 16, 35; resultados/30_pt600_componentes.csv.",
 "1) Mapa do grupo (Nota 1.1): holding com participações diretas e indiretas em sete distribuidoras, CSA e Echo. 2) Significância: Distribuição R$ 29.085.816 mil (91,7% do Intangível); Geração R$ 1.989.696 mil; Saneamento R$ 654.479 mil. 3) Materialidade de componente: R$ 117.000 mil (60% da execução; julgamento didático). 4) UGCs com perda: CSA e Echo; Goiás, CEEE-D e CEA sem perda. 5) Consolidação: reapresentação da transmissão (Nota 35). PLANEJADO: identificar auditores de componentes, avaliar competência e obter comunicação.",
 "resultados/30; DFP p.17, 63, 68.","Distribuição requer auditoria completa; Geração e Saneamento exigem procedimentos específicos de impairment.","Auditores de componentes não identificados.","Plano por componente definido; suficiência depende de acesso (P-26).","Sem acesso aos auditores dos componentes.",REAL)
P[[27]] <- mk("PT EC","Estrutura Conceitual para trabalhos de asseguração","Estrutura Conceitual para Trabalho de Asseguração (CFC; DOU 25/11/15)",
 "Caracterizar o trabalho, usuários, objeto, critérios, responsabilidades, evidência e nível de asseguração; diferenciar auditoria de outros trabalhos de asseguração.",
 "Trabalho didático sobre as demonstrações consolidadas da Equatorial S.A. de 2025.","Todas.","Confundir exercício didático com trabalho de asseguração real; opinião sem base.",
 "Orientações do P2; Estrutura Conceitual (CFC); DFP 2025.",
 "1) Elementos: (a) relação tripartite simulada (auditor-aluno, administração, usuários); (b) objeto: DFs consolidadas 2025; (c) critérios: CPC/IFRS; (d) evidência: documentos públicos e dados sintéticos; (e) relatório: minuta didática sem opinião. 2) Nível: segurança razoável é o objetivo da auditoria; este trabalho NÃO emite opinião. 3) Diferenciação: auditoria (segurança razoável, opinião positiva), revisão (segurança limitada, conclusão negativa) e outros trabalhos de asseguração/procedimentos previamente acordados (sem asseguração). 4) Usuários: acionistas, credores (covenants), ANEEL.",
 "docs/conclusao_integrada.md; PT 200; PT 210.","Elementos caracterizados; nível de asseguração: nenhum (trabalho didático).","Nenhuma.","Trabalho didático, sem opinião independente.","Não há contratante nem usuário real.",REAL)
pts <- do.call(rbind, P[c(27, 1:26)])
stopifnot(nrow(pts) == 27, !any(duplicated(pts$codigo)), all(pts$natureza %in% c(REAL, PLAN, SIM)))
chk <- sapply(pts, function(x) sum(is.na(x) | !nzchar(trimws(x)))); stopifnot(all(chk == 0))
write.csv(pts, file.path(DIR$res, "pts_27.csv"), row.names = FALSE, fileEncoding = "UTF-8")
# um markdown por PT
for (i in seq_len(nrow(pts))) {
  p <- pts[i, ]
  md <- c(paste0("# ", p$codigo, " - ", p$titulo), "",
   paste0("**Norma e itens:** ", p$norma_itens), paste0("**Natureza:** ", p$natureza), "",
   "## Objetivo", p$objetivo, "", "## Conta / processo / divulgação", p$conta_processo_divulgacao, "",
   "## Afirmações", p$afirmacoes, "", "## Riscos", p$riscos, "",
   "## População, fontes e critérios", p$populacao_fontes_criterios, "", "## Procedimentos", p$procedimentos, "",
   "## Evidências e referências cruzadas", p$evidencias_referencias, "", "## Resultados", p$resultados, "",
   "## Exceções", p$excecoes, "", "## Conclusão", p$conclusao, "", "## Limitações", p$limitacoes, "",
   "## Elaboração e revisão", paste0("Preparador: ", p$preparador, " | Data: ", p$data_elaboracao), paste0("Revisão: ", p$revisao))
  writeLines(md, file.path(DIR$pt, paste0(gsub(" ", "_", p$codigo), ".md")), useBytes = TRUE)
}
VERS <- c("PT EC"="Estrutura Conceitual para Trabalho de Asseguração (CFC, DOU 25/11/15)","PT 200"="NBC TA 200 (R1), DOU 05/09/16","PT 210"="NBC TA 210 (R1), DOU 05/09/16",
 "PT 220"="NBC TA 220 (R3), DOU 09/12/21","PT 230"="NBC TA 230 (R1), DOU 05/09/16",
 "PT 240"="NBC TA 240 (R1) aplicável ao exercício 2025. A R2 (DOU 25/09/26) só vale para períodos iniciados em ou após 01/01/2027 (CFC, notícia de 28/09/2026)",
 "PT 250"="NBC TA 250, DOU 14/02/19","PT 260"="NBC TA 260 (R2), DOU 04/07/16","PT 265"="NBC TA 265 (Res. CFC 1.210/09)","PT 300"="NBC TA 300 (R1), DOU 05/09/16",
 "PT 315"="NBC TA 315 (R2), DOU 02/09/21","PT 320"="NBC TA 320 (R1), DOU 05/09/16","PT 330"="NBC TA 330 (R1), DOU 05/09/16","PT 402"="NBC TA 402 (Res. CFC 1.215/09)",
 "PT 450"="NBC TA 450 (R1), DOU 05/09/16","PT 500"="NBC TA 500 (R1), DOU 05/09/16","PT 501"="NBC TA 501 (Res. CFC 1.218/09)","PT 505"="NBC TA 505 (Res. CFC 1.219/09)",
 "PT 510"="NBC TA 510 (R1), DOU 05/09/16","PT 520"="NBC TA 520 (Res. CFC 1.221/09)","PT 530"="NBC TA 530 (Res. CFC 1.222/09)","PT 540"="NBC TA 540 (R2), DOU 23/10/19",
 "PT 550"="NBC TA 550 (Res. CFC 1.224/09)","PT 560"="NBC TA 560 (R1), DOU 05/09/16",
 "PT 570"="NBC TA 570, versão anterior à R1, aplicável ao exercício 2025 (número da resolução a conferir). A R1 (DOU 25/09/26) só vale para períodos iniciados em ou após 01/01/2027 (CFC, notícia de 28/09/2026)",
 "PT 580"="NBC TA 580 (R1), DOU 05/09/16","PT 600"="NBC TA 600 (R2), DOU 06/12/23")
nb <- sub(" \\(R[0-9]\\)?:.*|:.*", "", pts$norma_itens); nb[pts$codigo == "PT EC"] <- "Estrutura Conceitual (asseguração)"
cob <- data.frame(pt = pts$codigo, norma = nb, titulo = pts$titulo, natureza = pts$natureza,
  status_cobertura = ifelse(pts$natureza == PLAN, "Planejado - pendente de acesso", ifelse(pts$natureza == SIM, "Executado em dados simulados", "Executado com evidência pública")),
  versao_norma = unname(VERS[pts$codigo]),
  arquivo_evidencia = paste0("papeis_trabalho/", gsub(" ", "_", pts$codigo), ".md"))
write.csv(cob, file.path(DIR$res, "matriz_cobertura_nbc_ta.csv"), row.names = FALSE, fileEncoding = "UTF-8")
print(table(pts$natureza)); cat("PTs:", nrow(pts), "\n")

dir.create("docs", showWarnings = FALSE)
idx <- c("# Índice dos papéis de trabalho", "", "Convenção: `PT EC` = Estrutura Conceitual; `PT nnn` = NBC TA nnn. Arquivos em `papeis_trabalho/PT_<código>.md`.", "",
  "| Código | Título | Natureza | Arquivo | Norma/versão |", "|---|---|---|---|---|",
  sprintf("| %s | %s | %s | [%s](../papeis_trabalho/%s.md) | %s |", pts$codigo, pts$titulo, pts$natureza, gsub(" ", "_", pts$codigo), gsub(" ", "_", pts$codigo), cob$versao_norma[match(pts$codigo, cob$pt)]))
writeLines(idx, "docs/indice_pts.md", useBytes = TRUE)
writeLines(c("# Convenção de códigos e referências cruzadas", "",
  "- **PT EC / PT 200 ... PT 600**: papéis de trabalho conforme o roteiro do P2 (27 PTs).",
  "- **Referências cruzadas**: `PT nnn` (outro papel), `resultados/nn_*.csv` (resultado reproduzível), `fontes/fatos_dfp_2025.csv` (fato F01-F34), `PDF p.xx` (página do PDF da DFP; impressa = PDF - 2).",
  "- **Pendências**: `P-nn` em `resultados/pendencias.csv`. **Riscos**: `Rnn` (PT 315). **Deficiências**: `Dnn` (PT 265).",
  "- **Natureza**: Realizado com evidência pública | Planejado por falta de acesso | Simulado para fins didáticos.",
  "- **Versões**: `resultados/32_controle_versoes.csv` e histórico do Git. **Montagem**: `source('R/run_all.R')`. **Guarda**: parâmetro didático de 5 anos."),
  "docs/convencao_codigos.md", useBytes = TRUE)
