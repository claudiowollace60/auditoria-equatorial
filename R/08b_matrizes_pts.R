# 08b_matrizes_pts.R - matrizes exigidas pelo roteiro (PT 265, 315, 330, 402/505, 450, 500, 501, 550, 600) e controles
source("R/00_config.R")
rd <- function(f) read.csv(file.path(DIR$res, f), stringsAsFactors = FALSE)
w  <- function(d, f) write.csv(d, file.path(DIR$res, f), row.names = FALSE, fileEncoding = "UTF-8")
mat <- rd("02_materialidade_adotada.csv"); MG <- mat$valor_mil[1]; ME <- mat$valor_mil[2]; TRV <- mat$valor_mil[3]
SIN <- "Executado em dados sintéticos"; PUB <- "Executado com evidência pública"; PLN <- "Planejado - sem acesso"

# ---- PT 315: matriz de riscos por conta e afirmação ----
mr <- data.frame(id = sprintf("R%02d", 1:13),
 conta = c("Intangível","Intangível","Intangível","Intangível","Receita - energia não faturada","Receita de construção","Contas a receber (PECLD)","Provisão para riscos judiciais","Ativo financeiro da concessão","Imposto de renda diferido","Partes relacionadas","Operação descontinuada (Transmissão)","Dívida e covenants"),
 saldo_mil = c(31729991,31729991,31729991,31729991,1546475,10706360,10315564,4749734,19135756,2068852,913670,NA,54471763),
 afirmacao = c("Valorização (impairment/mais-valia Echo)","Valorização (amortização e vida útil)","Existência / ocorrência","Classificação","Corte e valorização","Ocorrência","Valorização","Integridade","Valorização (VNR)","Valorização","Apresentação e divulgação","Apresentação","Apresentação e obrigações"),
 risco = c("Premissas de WACC, crescimento e horizonte enviesadas; perda de R$ 2.359.265 mil na mais-valia","Taxas médias não refletem vida útil; despesa fora da expectativa (PT19)","Ativos baixados ou não existentes mantidos no cadastro","Registro em linha/classe errada da Nota 14","Estimativa de consumo não faturado (KAM)","Margem próxima de zero (ICPC 01) mascarando receita fictícia","Perda esperada de 29,4% do bruto subestimada","Reversões de R$ 1.749.649 mil e adições de R$ 1.020.094 mil indicam julgamento relevante","Atualização do VNR e premissas regulatórias","Realização de prejuízo fiscal (R$ 1.743.217 mil) e diferenças temporárias","Transações e saldos não divulgados","Reapresentação de 2024 incompleta","Descumprimento de covenant e classificação circulante"),
 risco_inerente = c("Alto","Alto","Médio","Médio","Alto","Médio","Alto","Alto","Alto","Médio","Médio","Médio","Médio"),
 significativo = c("Sim","Sim","Não","Não","Sim (KAM)","Não","Não","Sim","Não","Não","Não","Não","Não"),
 controles_ti = "Não avaliados - sem acesso aos sistemas (planejado: cadastro patrimonial, faturamento, razão)",
 resposta = c("PT 540; PT 330","PT 520; PT 540","PT 530; PT 500","PT 500 (E9)","PT 501; PT 520","PT 520","PT 520; PT 540","PT 501","PT 540 (planejado)","PT 540 (planejado)","PT 550","PT 510; PT 600","PT 570"))
w(mr, "23_matriz_riscos.csv")

# ---- PT 330: respostas aos riscos (natureza, época, extensão, status) ----
resp <- data.frame(risco = c("R01","R01","R02","R02","R03","R03","R04","R05","R06","R07","R08","R08","R09","R10","R11","R12","R13"),
 teste = c("Sensibilidade WACC x g e horizonte","Teste da razoabilidade do modelo da administração","Expectativa de amortização por classe","Sensibilidade das taxas (+/-10%, +/-20%)","MUS no Intangível (itens-chave + amostra)","Inspeção física/documental dos bens da amostra","Teste de classificação por obra e concessão","Teste de corte de receita não faturada","Analítico da receita de construção","Análise do índice PECLD sobre contas a receber bruto","Recálculo da movimentação de provisões (Nota 23)","Cartas de advogados","Teste do VNR com a base regulatória","Teste de recuperabilidade do diferido","Footing e comparação de Nota 9; lista de partes relacionadas","Comparação de 2024 reapresentado e Nota 35","Leitura de covenants e CCL"),
 tipo = c("Substantivo","Substantivo","Substantivo analítico","Substantivo","Substantivo (amostragem)","Substantivo","Substantivo","Substantivo","Substantivo analítico","Substantivo","Substantivo","Substantivo","Substantivo","Substantivo","Substantivo","Substantivo","Substantivo"),
 epoca = c("Final","Final","Intermediária e final","Final","Final","Intermediária","Final","Final","Intermediária e final","Final","Final","Final","Final","Final","Final","Final","Final"),
 extensao = c("Grade 7 x 5 e 10 cenários","Modelo completo (1 UGC Echo)","5 classes + índices","4 variações","2 itens-chave + 505 itens (J = R$ 65.000 mil)","Amostra MUS","Itens com taxa 3,33%","Amostra de ciclos","Anual","Índice PECLD/bruto 2025 x 2024 (agregado; por faixa de atraso planejado)","5 classes","Todos > R$ 130.000 mil","Modelo regulatório","Base de prejuízo e diferenças","Todos os saldos da Nota 9","Intangível (saldo de abertura)","Todos os contratos citados na Nota 18.6"),
 status = c(SIN, PLN, PUB, SIN, SIN, PLN, PLN, PLN, PUB, PUB, PUB, PLN, PLN, PLN, PUB, PUB, PUB),
 pt = c("PT 540","PT 540","PT 520","PT 540","PT 530","PT 530","PT 500","PT 501","PT 520","PT 520","PT 501","PT 501","PT 540","PT 540","PT 550","PT 510","PT 570"))
resp$testes_de_controle <- "Não executados: sem acesso aos controles (planejado: teste de operação de cadastro e capitalização)"
w(resp, "24_matriz_respostas_riscos.csv")

# ---- PT 450: mapa de distorcoes ----
tp <- rd("07_inserido_vs_detectado_por_tipo.csv"); lg <- read.csv(file.path(DIR$dados, "log_erros_inseridos.csv"))
det <- aggregate(valor_distorcao_mil ~ tipo_erro, lg, function(x) round(sum(x), 1))
mp <- merge(tp[, c("tipo_erro","inseridos","detectados","nao_detectados")], det, by = "tipo_erro")
mp$status <- ifelse(mp$nao_detectados == 0, "Detectada; corrigida na reavaliação (MUS pós-correção)", "Não detectada pelos testes; NÃO corrigida")
mp$efeito_quantitativo_x_materialidade <- round(abs(mp$valor_distorcao_mil) / MG, 2)
mp$acima_trivial <- abs(mp$valor_distorcao_mil) > TRV
mp$efeito_qualitativo <- c("Indício de falha de cadastro; possível manipulação de ativos","Falha no cálculo automático","Falha de parametrização e cálculo","Cut-off: registros futuros","Taxa fora do padrão da Nota 14","Sinal invertido: possível erro de importação","Digitação/escala: efeito acima da materialidade","Subamortização intencional possível (viés)","Sem efeito no total; afeta divulgação da Nota 14")
w(mp, "25_mapa_distorcoes.csv")

# ---- PT 265: matriz de deficiencias ----
def <- data.frame(id = sprintf("D%02d", 1:13),
 condicao = c("Valores atípicos no cadastro (custo x 50)","Registros duplicados","Líquido diferente de custo+amortização+obrigações","Amortização acumulada maior que o custo","Data de incorporação posterior ao fechamento","Taxa de amortização fora da taxa da linha","Amortização com sinal positivo","Subamortização coerente com taxa 3% menor","Registros classificados em concessão errada","Total do impairment (R$ 3.391.261 mil) diferente da soma dos componentes (R$ 3.547.852 mil)","Notas 14 e 14.1 divergem em R$ 1.741 mil (custo e amortização)","Amortização de 'Em serviço' R$ 720.175 mil acima da expectativa","Controles de TI do cadastro e capitalização"),
 criterio = c("Validação de escala","Unicidade de ID","Recálculo automático","Amortização <= custo","Cut-off","Taxa por classe aprovada","Sinal contábil","Taxa por classe aprovada","Cadastro por concessão","CPC 01 (R1)/Nota 16: divulgação consistente","CPC 26 (R1): consistência entre notas","NBC TA 520: expectativa independente","NBC TA 315 (R2): entendimento de TI"),
 causa = c("Ausência de validação (hipótese)","Ausência de chave única (hipótese)","Cálculo manual (hipótese)","Trava ausente (hipótese)","Trava ausente (hipótese)","Parametrização manual (hipótese)","Erro de importação (hipótese)","Viés ou parametrização (hipótese)","Erro de cadastro (hipótese)","Desconhecida - pedir à administração","Desconhecida - pedir à administração","Desconhecida - taxas médias e baixas não divulgadas","Sem acesso"),
 efeito_mil = c(808235.5,11523,39971,-14239,0,0,9177.7,382.1,0,156591,0,720175,NA),
 recomendacao = c("Validar faixas de valor por classe","Chave única no cadastro","Cálculo automático e conciliação mensal","Trava amortização <= custo","Trava de data","Tabela de taxas com aprovação","Validar sinal na carga","Revisão de vida útil por classe","Revisão de cadastro por concessão","Reconciliar e divulgar abertura do impairment","Corrigir abertura da Nota 14","Obter abertura de taxas, baixas e transferências","Avaliar controles gerais de TI"),
 tipo = c(rep("Constatação (teste em base sintética)", 7), "Hipótese (não detectada pelos testes)", "Hipótese (não detectada pelos testes)", "Constatação (evidência pública)", "Constatação (evidência pública)", "Hipótese (depende de informação interna)", "Hipótese (sem acesso)"),
 significancia = c("Significativa","Menor","Significativa","Menor","Menor","Menor","Menor","Menor","Menor","Significativa","Menor","Significativa","A avaliar"))
w(def, "26_matriz_deficiencias.csv")

# ---- PT 500: avaliacao das evidencias ----
ev <- data.frame(fonte = c("DFP 2025 auditada (balanço, DRE, DFC)","Notas explicativas da DFP","Relatório do auditor independente (EY, 25/03/2026)","Base de dados sintética do Intangível","Cálculos próprios em R","Notícias e portais de mercado","Portal do CFC (normas)"),
 tipo = c("Documento público formal","Documento público formal","Documento público formal","Dados sintéticos","Reperformance","Informação secundária","Norma"),
 relevancia = c("Alta","Alta","Alta","Média (compatível com a Nota 14, mas fictícia)","Alta","Baixa","Alta"),
 confiabilidade = c("Alta (auditada)","Alta (auditada)","Alta","Não é evidência da companhia","Alta (reproduzível)","Baixa/média","Alta"),
 suficiencia = c("Suficiente para totais","Suficiente para totais e movimentos; insuficiente para transação a transação","Suficiente para KAM e opinião do auditor","Insuficiente para qualquer conclusão sobre a companhia","Suficiente para os testes executados","Insuficiente","Suficiente"),
 limitacao = c("Sem detalhe de transações","Taxas e premissas agregadas","Não substitui trabalho próprio","Valores individuais fictícios","Depende dos dados de entrada","Não usada como evidência de saldo","Versões a confirmar"))
w(ev, "27_avaliacao_evidencias.csv")

# ---- PT 501: litigios (Nota 23, PDF p.89-90) e movimentacao ----
li <- data.frame(natureza = c("Cíveis","Fiscais","Trabalhistas","Regulatórias","Ambientais"),
 provisao_2024 = c(2362711,179250,2680259,41851,36944), adicoes = c(410645,1477,595535,12437,0), utilizacao = c(-388642,-1685,-430823,-8086,-45),
 reversao = c(-690661,-454,-1055338,-3196,0), atualizacao = c(445516,-6738,464385,13284,3581), reclassificacao = c(0,25460,0,62067,0),
 provisao_2025_nota = c(2139569,197310,2254018,118357,40480), depositos_2025 = c(203685,218131,339950,2204,0), possivel_2025 = c(2542117,591260,363591,11,0))
li$provisao_2025_recalculada <- rowSums(li[, c("provisao_2024","adicoes","utilizacao","reversao","atualizacao","reclassificacao")])
li$diferenca <- li$provisao_2025_recalculada - li$provisao_2025_nota
li$reversao_sobre_saldo_inicial_pct <- round(-100 * li$reversao / li$provisao_2024, 1)
tot <- li[1, ]; tot[1, ] <- NA; tot$natureza <- "Total"; for (j in 2:ncol(li)) tot[[j]] <- if (j == ncol(li)) round(-100 * sum(li$reversao) / sum(li$provisao_2024), 1) else sum(li[[j]], na.rm = TRUE)
li <- rbind(li, tot); w(li, "28_pt501_litigios.csv")

# ---- PT 550: partes relacionadas (Nota 9, PDF p.48) ----
pr <- data.frame(grupo = c("Outras contas a receber - controladas indiretas","Outras contas a receber - controlada direta (Alagoas)","Outras contas a receber - total","Recuperação judicial (Equatorial Pará)","Dividendos a receber - subtotal (inclui coligada SABESP R$ 308.748 mil)","Total saldos com partes relacionadas (controladora)"),
 saldo_2025 = c(14492,0,14492,138663,760515,913670), saldo_2024 = c(106795,2256,109051,138114,1161256,1408421), resultado_2025 = c(81693,2551,84244,3289,0,87533))
pr$footing_total <- c(NA,NA,NA,NA,NA, 14492 + 138663 + 760515); pr$diferenca_footing <- c(NA,NA,NA,NA,NA, 913670 - (14492 + 138663 + 760515))
w(pr, "29_pt550_partes_relacionadas.csv")

# ---- PT 600: componentes do grupo ----
cp <- data.frame(componente = c("Distribuição (7 concessões)","Saneamento (CSA)","Geração (Echo)"),
 intangivel_mil = c(29085816,654479,1989696), UGC_testada_impairment = c("Equatorial Goiás, CEEE-D, CEA (sem perda)","CSA (perda R$ 308.806 mil)","Echo Participações/Crescimento (perda R$ 879.781 mil) e mais-valia (R$ 2.359.265 mil)"))
cp$pct_intangivel <- round(100 * cp$intangivel_mil / 31729991, 1)
cp$significancia <- ifelse(cp$pct_intangivel > 15, "Significativo por tamanho", "Significativo por risco (impairment)")
cp$materialidade_componente_mil <- round(ME * 0.6, -3)      # 60% da materialidade de execucao (julgamento didatico)
cp$trabalho_planejado <- c("Auditoria completa do componente","Procedimentos específicos de impairment","Procedimentos específicos de impairment e mais-valia")
cp$auditor_do_componente <- "Não identificado nas fontes públicas - pendência P-26"
w(cp, "30_pt600_componentes.csv")

# ---- PT 505: controle de circularizacao (modelo; nada enviado) ----
cc <- data.frame(id = sprintf("C%02d", 1:6), destinatario = c("Bancos e emissores de aplicações","Credores de empréstimos (Nota 18)","Debenturistas/agentes fiduciários (Nota 19)","Clientes relevantes (poder público)","Advogados externos (Nota 23)","Coligada SABESP (dividendos a receber)"),
 saldo_mil = c(2659827,20978503,33493260,452242,4749734,308748), informacao_a_confirmar = c("Saldo e restrições em 31/12/2025","Saldo, taxas, garantias, covenants","Saldo, vencimentos, eventos de inadimplência","Saldo faturado e vencido","Processos e probabilidade de perda","Dividendos declarados e a receber"),
 status = "NÃO ENVIADA (vedado pelas instruções: não contatar terceiros)", resposta_recebida = "Não", tratamento_diferencas = "Reconciliar com razão; investigar acima do trivial (R$ 13.000 mil); registrar em PT 450",
 procedimento_alternativo = c("Extratos/comprovantes e conciliação bancária","Contratos, extratos e pagamentos subsequentes","Escrituras e comprovantes de pagamento","Recebimentos subsequentes e faturas","Atas e relatórios jurídicos internos","Ata da AGO da investida e recebimento subsequente"))
w(cc, "31_pt505_controle_circularizacao.csv")

cv <- data.frame(versao = c("v1.0","v2.0"), data = c("(anterior)", DATA_ELAB), descricao = c("Trabalho anterior sobre controlada - DESCARTADO (perímetro incorreto)","Reconstrução completa para a holding Equatorial S.A. (consolidado)"), responsavel = MATRICULA)
w(cv, "32_controle_versoes.csv")
cat("OK 08b\n")
