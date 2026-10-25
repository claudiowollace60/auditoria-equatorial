# Auditoria 1 — Equatorial Energia Distribuição S.A.

**Instituição:** Universidade de Brasília (UnB)  

**Disciplina:** Auditoria 1  

**Aluno:** Cláudio Wollace Santos Da Hora

**Matrícula:** 242010937

**Área de estudo:** ativo financeiro da concessão e obrigações especiais relacionadas

**Natureza:** trabalho acadêmico, sem emissão de opinião de auditoria sobre a companhia.

Projeto acadêmico desenvolvido na disciplina **Auditoria 1**, da Universidade de Brasília (UnB), com foco no ativo financeiro da concessão e nas obrigações especiais relacionadas da Equatorial Energia Distribuição S.A., referentes ao exercício de 2025.

O repositório reúne análise documental pública, procedimentos analíticos em R, avaliação de riscos, materialidade, documentação de papéis de trabalho e matriz de cobertura das Normas Brasileiras de Contabilidade aplicáveis à auditoria independente.

**Exercício de referência:** 2025  
**Ambiente de desenvolvimento:** RStudio / R  
**Status:** projeto acadêmico em fase de revisão e validação final.

## Aviso importante

A base analítica utilizada é **inteiramente sintética** e não representa registros contábeis internos da Equatorial Energia Distribuição S.A. Foi desenvolvida para fins didáticos, permitindo testar scripts de auditoria e conciliar os saldos agregados com os valores públicos de referência.

Os resultados dos testes sobre essa base demonstram o funcionamento da metodologia implementada, mas não constituem constatações sobre os registros reais da companhia nem fundamentam uma opinião de auditoria.

## Referência contábil

O estudo utiliza como referência os valores divulgados na Nota Explicativa 11 das demonstrações contábeis de 2025, conforme a identificação registrada no controle de fontes do projeto.

Valores em R$ mil:

| Descrição | Valor |
|---|---:|
| Ativo financeiro da concessão — bruto | 21.062.007,0 |
| Obrigações especiais | (5.862.808,0) |
| Ativo financeiro da concessão — líquido | 15.199.199,0 |

**Fonte documental:** página impressa 44, correspondente à página 46 do PDF consultado. A URL, a data de acesso e as informações de referência estão registradas em `fontes/controle_fontes.csv`.

## Objetivos do projeto

- Aplicar conceitos de planejamento e documentação de auditoria independente.
- Relacionar riscos de distorção relevante às afirmações contábeis pertinentes.
- Desenvolver testes analíticos sobre uma população de dados sintéticos.
- Verificar integridade, unicidade, conciliação de saldos e diferenças de recálculo.
- Documentar exceções simuladas e avaliar sua identificação pelos testes.
- Elaborar papéis de trabalho, matriz de riscos, parâmetros ilustrativos de materialidade e matriz de cobertura normativa.

## Estrutura do repositório

| Diretório | Conteúdo |
|---|---|
| `R/` | Scripts de geração da base, testes iniciais, avaliação de exceções, papéis de trabalho, materialidade, riscos e cobertura normativa |
| `dados/` | Base sintética comprimida, dicionário de variáveis e controle dos erros inseridos |
| `resultados/` | Resultados dos testes, amostra ilustrativa, exceções, papéis de trabalho e matrizes analíticas |
| `fontes/` | Controle das fontes públicas e das referências normativas |
| `normas/` | Documentação de apoio e referências normativas |
| `dossie/` | Relatório técnico, programas de auditoria e documentação do trabalho |

## Procedimentos analíticos implementados

Os scripts em R contemplam:

- Geração de uma população sintética de **500.000 registros**.
- Verificação da integridade da população e da unicidade dos identificadores.
- Conciliação dos saldos agregados com os valores públicos de referência utilizados no exercício.
- Recálculo de valores e identificação de diferenças.
- Identificação de registros sem identificador de documento de suporte e de datas fora do período analisado.
- Comparação entre erros inseridos deliberadamente na simulação e exceções detectadas.
- Geração de resultados para documentação e análise das limitações dos testes.

## Resultados da simulação

Os resultados abaixo referem-se exclusivamente à base sintética:

| Indicador | Resultado |
|---|---:|
| Registros analíticos | 500.000 |
| Identificadores únicos | 500.000 |
| Diferenças de recálculo inseridas deliberadamente | 250 |
| Erros inseridos identificados pelos testes | 250 |
| Erros inseridos não identificados | 0 |
| Registros sem identificador de documento de suporte | 5.459 |
| Registros com datas fora do período de 2025 | 75 |

### Conciliação dos saldos sintéticos

| Indicador | Valor em R$ mil |
|---|---:|
| Saldo registrado agregado | 15.199.199,0 |
| Saldo recalculado agregado | 15.216.626,8 |
| Diferença: registrado menos recalculado | (17.427,8) |

A diferença agregada decorre das alterações introduzidas deliberadamente na base sintética. Os 250 erros de recálculo foram identificados pelos testes implementados. Esse resultado demonstra a detecção dos erros conhecidos inseridos na simulação, não a eficácia de uma auditoria sobre dados reais.

## Documentação principal

- `dossie/relatorio_principal.md` — relatório técnico em formato editável.
- `dossie/relatorio_principal.pdf` — versão em PDF do relatório.
- `dossie/programas_auditoria.csv` — programas de auditoria previstos para as áreas consideradas.
- `resultados/08_matriz_cobertura_NBC_TA.csv` — matriz de cobertura normativa, com referências de versão registradas.
- `resultados/07_PT500_PT530.csv` — papel de trabalho relacionado aos testes analíticos e à amostragem.
- `resultados/14_conciliacao_e_excecoes_separadas.csv` — conciliação e classificação das exceções.
- `fontes/controle_fontes.csv` — registro das fontes públicas consultadas.
- `fontes/controle_normas.csv` — controle de referências normativas, versões registradas e observações.

## Como executar

1. Abra o projeto no RStudio.
2. Confirme que o diretório de trabalho é a pasta raiz do projeto.
3. Execute os scripts da pasta `R/` em ordem numérica, observando as dependências entre eles.
4. Consulte os arquivos gerados na pasta `resultados/`.

**Atenção:** os scripts podem sobrescrever resultados produzidos anteriormente. Recomenda-se manter uma cópia dos resultados que já tenham sido revisados antes de executar novamente os procedimentos.

## Limitações do estudo

O trabalho não envolveu acesso à razão contábil real da companhia, sistemas internos, contratos integrais ou documentos comprobatórios internos. Não foram realizadas entrevistas, inspeções físicas, confirmações externas ou observações de controles da entidade.

Os procedimentos dependentes de evidências reais permanecem planejados ou não executados. Os parâmetros de materialidade são ilustrativos e acadêmicos. A aplicabilidade e a vigência das versões normativas devem ser confirmadas nas fontes oficiais antes da entrega definitiva.

