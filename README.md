# TheoremRisk

TheoremRisk - Seguro Auto - Versão 1.0

Esse é um projeto independente constituído de um conjunto de scripts na linguagem R para calcular prêmios de Seguro Auto ao consumidor final e estatísticas com base nos datasets disponibilizados pelo sistema Autoseg da SUSEP - Superintendência de Seguros Privados.

O sistema Autoseg disponibiliza dados e informações sobre as apólices de Seguro Auto vigentes de todo o mercado brasileiro a cada semestre sob a forma de datasets em .csv. Acesse em https://www2.susep.gov.br/menuestatistica/autoseg/principal.aspx

Para usar esses scripts, baixe datasets por meio do link acima. 

Os scripts desse projeto foram escritos para lerem e analisarem o dataset 'arq_casco_comp.csv', que contém dados de exposição, prêmios, sinistros e importância segurada para a cobertura de Casco, elencados pelos critérios Categoria Tarifária/Região/Modelo/Ano/Sexo/Faixa Etária. Outros datasets do conjunto não funcionarão por enquanto, mas quando possível irei implementar código novo para analisá-los.


## Método de precificação

O método atuarial utilizado nesse projeto é o clássico método de prêmio de risco, onde por meio do histórico de frequência de sinistros da carteira se calcula o prêmio mínimo a se cobrar para repor o montante gasto em indenização de perdas, e a partir desse prêmio base são adicionadas variáveis contábeis, tributárias e comerciais até chegar ao prêmio final ofertado ao consumidor. 

Para usar os scripts desse projeto, é necessário que o seu sistema operacional (Linux, Windows ou Mac) possua o interpretador da linguagem R instalado para uso em linha de comando. Para melhor comodidade e estudo desse script, use uma IDE específica para a linguagem R, como o RStudio.


## O que é cada arquivo?

`parametros.csv`: parâmetros que os scripts `calculos_geral.R` e `calculos_modelos.R` utilizarão para o cálculo dos prêmios ao consumidor final. Manter os nomes dos parâmetros inalterados, apenas modifique os valores da segunda coluna de acordo com a sua preferência antes de executar `atuarial_geral.R` ou `atuarial_modelos.R`.

`margem_seguranca`: margem de segurança para evitar prejuízos por desvios bruscos ou altas repentinas de sinistralidade. Valor em %
`carregamento`: carregamento, compreendendo despesas administrativas, comissionamento do corretor, margem de lucro e impostos indiretos. Valor em % 
`iof`: Imposto sobre Operações Financeiras vigente para os seguros de acordo com a legislação tributária. Valor em %

`atuarial_geral.R`: calcula os prêmios de risco para cada uma das coberturas (Roubo e Furto, Colisão Perda Parcial, Colisão Perda Total, Incêndio e Assistência 24H), armazena-os em tabelas na memória, e compila estatísticas do dataset para o arquivo `estatisticas_geral.csv`.

`calculos_geral.R`: é chamado automaticamente após a execução de `atuarial_geral.R`. Calcula os prêmios ao consumidor final para cada cobertura levando em consideração os prêmios de risco obtidos e os parâmetros existentes em `parametros.csv`, e compila-os num arquivo que receberá o nome `resultados_geral.csv`.

`atuarial_modelos.R`: faz o mesmo que o script `atuarial_geral.R`, porém os cálculos são feitos para cada modelo de veículo existente no dataset enviado. Estatísticas atuariais em `estatisticas_modelo.csv`.

`calculos_modelos.R`: faz o mesmo que o script `calculos_geral.R`, porém os cálculos são feitos para cada modelo de veículo existente no dataset enviado. Resultados em `resultados_modelo.csv`.

Nos arquivos de resultados, o identificador do modelo é o código do veículo na tabela FIPE. 

Determinados modelos, por serem raros dentro das carteiras de seguro auto, podem apresentar indisponibilidade de resultados em certas coberturas devido à frequência de sinistros ser igual a 0. Para evitar esse problema, o código executa um processo de suavização de Laplace durante o cálculo dos prêmios de risco, artificialmente somando +1 em todos os campos de frequência de sinistros.


## Uso/Sintaxe

`[interpretador R] [atuarial_geral.R ou atuarial_modelos.R] [caminho do dataset arq_casco_comp no seu computador]`

Exemplo: `Rscript atuarial_modelos.R arq_casco_comp2019.csv`

## Aviso Importante

A depender do tamanho do dataset enviado, cuja quantidade de registros pode estar na casa dos milhões, a conclusão do processamento e compilação dos resultados pode demorar de forma significativa, consumindo toda a memória RAM disponível. 

Se você acha que sua máquina possui limitações de memória e capacidade de processamento, feche todos os programas abertos antes de executar o script ou o faça em uma máquina com boa especificação (recomenda-se ao menos 16GB de memória RAM e CPUs de penúltima geração).
