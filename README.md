# Auditoria 1 — Equatorial Energia Distribuição S.A.

**Matrícula:** 242010937
**Exercício de referência:** 2025
**Ambiente:** RStudio / R
**Status:** projeto em desenvolvimento; revisão e documentação final pendentes.

## Importante

A base analítica é inteiramente sintética e não representa registros internos reais da Equatorial. Ela foi construída para fins didáticos e para conciliar matematicamente o saldo registrado ao saldo público de referência.

O saldo líquido de referência é R$ 15.199.199 mil, conforme a Nota Explicativa 11 das demonstrações contábeis de 2025, página impressa 44 e página 46 do PDF. A URL e a data de acesso estão registradas em fontes/controle_fontes.csv e devem ser verificadas antes da entrega.

## Estrutura do projeto

- `R/`: scripts de geração, testes, avaliação de exceções, papel de trabalho, matriz normativa, materialidade e documentação de exceções.
- `dados/`: base sintética comprimida, dicionário de variáveis e controle dos erros inseridos.
- `resultados/`: testes, amostra ilustrativa, papel de trabalho, matriz de cobertura, materialidade, riscos e avaliação de exceções.
- `fontes/`: controle das fontes públicas.
- `normas/`: README e controle das normas a consultar.
- `dossie/`: índice, relatório preliminar e programas de auditoria.

## Execução

Execute os scripts da pasta R em ordem numérica, a partir da pasta raiz do projeto. Os scripts podem sobrescrever arquivos de resultados gerados anteriormente.

## Resultados validados

- Base com 500.000 registros e 500.000 identificadores únicos.
- Todos os registros identificados como sintéticos.
- Saldo registrado líquido: R$ 15.199.199 mil.
- Saldo recalculado líquido: R$ 15.216.626,8 mil.
- 250 registros com diferenças deliberadamente inseridas.
- Diferença agregada entre os valores recalculados e registrados: R$ 17.427,8 mil.
- Os 250 erros de recálculo inseridos foram detectados nos testes sobre a base sintética.

## Limitações

Os testes executados não foram realizados sobre o razão contábil real da companhia. Não houve acesso a sistemas internos, documentos originais, entrevistas, inspeções físicas ou confirmações externas. As exceções simuladas não são achados reais de auditoria.

## Pendências antes da entrega

- Conferir a fonte pública e a URL oficial.
- Confirmar as versões vigentes e a aplicabilidade das normas de auditoria.
- Completar os papéis de trabalho e justificar as decisões de materialidade e amostragem.
- Revisar os programas de auditoria e a conclusão integrada.
- Gerar e conferir o dossiê final em PDF.
- Criar o repositório GitHub e testar o acesso aos arquivos.
