
#Lê argumento da linha de comando com o dataset a ser tratado
argumentos <- commandArgs(trailingOnly = TRUE)

if(length(argumentos) == 0) {
  stop("Uso: atuarial_modelos.R [dataset em .csv] \n Para mais informações de uso desse script, acesse o LEIAME.txt")
}

#Carrega o arquivo
message(cat("Lendo e analisando os dados do dataset", argumentos[1]))
message("Isso pode durar alguns minutos, aguarde.")
arq_casco_comp <- read.csv(argumentos[1])

#Cria a variável com o código FIPE dos modelos
listamodelos <-  as.factor(arq_casco_comp$COD_MODELO)

#Faz os cálculos temporários para chegar ao prêmio de risco por modelo
output_somacarteira <- data.frame(tapply(arq_casco_comp$COD_MODELO, INDEX = listamodelos, FUN = "length"))
output_somafreq1 <- data.frame(tapply(arq_casco_comp$FREQ_SIN1+1, INDEX = listamodelos, FUN = "sum"))
output_somafreq2 <- data.frame(tapply(arq_casco_comp$FREQ_SIN2+1, INDEX = listamodelos, FUN = "sum"))
output_somafreq3 <- data.frame(tapply(arq_casco_comp$FREQ_SIN3+1, INDEX = listamodelos, FUN = "sum"))
output_somafreq4 <- data.frame(tapply(arq_casco_comp$FREQ_SIN4+1, INDEX = listamodelos, FUN = "sum"))
output_somafreq9 <- data.frame(tapply(arq_casco_comp$FREQ_SIN9+1, INDEX = listamodelos, FUN = "sum"))
output_somaindeniz1 <- data.frame(tapply(arq_casco_comp$INDENIZ1, INDEX = listamodelos, FUN = "sum"))
output_somaindeniz2 <- data.frame(tapply(arq_casco_comp$INDENIZ2, INDEX = listamodelos, FUN = "sum"))
output_somaindeniz3 <- data.frame(tapply(arq_casco_comp$INDENIZ3, INDEX = listamodelos, FUN = "sum"))
output_somaindeniz4 <- data.frame(tapply(arq_casco_comp$INDENIZ4, INDEX = listamodelos, FUN = "sum"))
output_somaindeniz9 <- data.frame(tapply(arq_casco_comp$INDENIZ9, INDEX = listamodelos, FUN = "sum"))

#Roubo e Furto
freq1_carteira_modelo <- data.frame(sapply(output_somafreq1, output_somacarteira, FUN = "/"))
indeniz1_media_modelo <- data.frame(sapply(output_somaindeniz1, output_somafreq1, FUN = "/"))
premio_risco1 <- data.frame(sapply(indeniz1_media_modelo, freq1_carteira_modelo, FUN = "*"))
rownames(premio_risco1) <- levels(listamodelos)
colnames(premio_risco1) <- c("Prêmio")

#Colisão Parcial
freq2_carteira_modelo <- data.frame(sapply(output_somafreq2, output_somacarteira, FUN = "/"))
indeniz2_media_modelo <- data.frame(sapply(output_somaindeniz2, output_somafreq2, FUN = "/"))
premio_risco2 <- data.frame(sapply(indeniz2_media_modelo, freq2_carteira_modelo, FUN = "*"))
rownames(premio_risco2) <- levels(listamodelos)
colnames(premio_risco2) <- c("Prêmio")

#Colisão Perda Total
freq3_carteira_modelo <- data.frame(sapply(output_somafreq3, output_somacarteira, FUN = "/"))
indeniz3_media_modelo <- data.frame(sapply(output_somaindeniz3, output_somafreq3, FUN = "/"))
premio_risco3 <- data.frame(sapply(indeniz3_media_modelo, freq3_carteira_modelo, FUN = "*"))
rownames(premio_risco3) <- levels(listamodelos)
colnames(premio_risco3) <- c("Prêmio")

#Incêndio
freq4_carteira_modelo <- data.frame(sapply(output_somafreq4, output_somacarteira, FUN = "/"))
indeniz4_media_modelo <- data.frame(sapply(output_somaindeniz4, output_somafreq4, FUN = "/"))
premio_risco4 <- data.frame(sapply(indeniz4_media_modelo, freq4_carteira_modelo, FUN = "*"))
rownames(premio_risco4) <- levels(listamodelos)
colnames(premio_risco4) <- c("Prêmio")

#Assistência 24H
freq9_carteira_modelo <- data.frame(sapply(output_somafreq9, output_somacarteira, FUN = "/"))
indeniz9_media_modelo <- data.frame(sapply(output_somaindeniz9, output_somafreq9, FUN = "/"))
premio_risco9 <- data.frame(sapply(indeniz9_media_modelo, freq9_carteira_modelo, FUN = "*"))
rownames(premio_risco9) <- levels(listamodelos)
colnames(premio_risco9) <- c("Prêmio")

#Sinistralidade
premiosganhos_modelo <- data.frame(tapply(arq_casco_comp$PREMIO1, INDEX = arq_casco_comp$COD_MODELO, FUN = "sum"))
colnames(premiosganhos_modelo) <- c("Valor")

#Soma as diversas matrizes de indenizações do dataset
soma_indeniz_modelo <- data.frame(sapply(output_somaindeniz1, output_somaindeniz2, FUN = "+"))
soma_indeniz_modelo2 <- data.frame(sapply(soma_indeniz_modelo, output_somaindeniz3, FUN = "+"))
soma_indeniz_modelo3 <- data.frame(sapply(soma_indeniz_modelo2, output_somaindeniz4, FUN = "+"))
soma_indeniz_modelo_final <- data.frame(sapply(soma_indeniz_modelo3, output_somaindeniz9, FUN = "+"))

rownames(soma_indeniz_modelo_final) <- levels(listamodelos)

sinistralidade_modelo <- round(data.frame(sapply(soma_indeniz_modelo_final, premiosganhos_modelo, FUN = "/")), digits = 2)
rownames(sinistralidade_modelo) <- levels(listamodelos)
colnames(sinistralidade_modelo) <- c("Valor")

#Importância Segurada Média
ismedia_modelo <- data.frame(tapply(arq_casco_comp$IS_MEDIA, INDEX = listamodelos, FUN = "mean"))
rownames(ismedia_modelo) <- levels(listamodelos)
colnames(ismedia_modelo) <- c("Valor")

#Exposição Média
exposicaomedia_modelo <- data.frame(tapply(arq_casco_comp$EXPOSICAO1, INDEX = listamodelos, FUN = "mean"))
rownames(exposicaomedia_modelo) <- levels(listamodelos)
colnames(exposicaomedia_modelo) <- c("Valor")

#Compila os resultados
tbl_estatisticas_modelo <- round(data.frame(c(sinistralidade_modelo), c(ismedia_modelo), c(exposicaomedia_modelo)), digits = 2)
rownames(tbl_estatisticas_modelo) <- levels(listamodelos)
colnames(tbl_estatisticas_modelo) <- c("Sinistralidade", "IS Média", "Exposição Média")
write.csv(tbl_estatisticas_modelo, "estatisticas_modelos.csv")
message("Estatísticas dos modelos compiladas em 'estatisticas_modelos.csv'")

#Prossegue para o script de cálculo de prêmio bruto
message("Iniciando o script de cálculo de prêmio bruto")
Sys.sleep(5)

source('calculos_modelos.R')