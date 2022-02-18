
#Lê argumento da linha de comando com o dataset a ser tratado
argumentos <- commandArgs(trailingOnly = TRUE)

if(length(argumentos) == 0) {
  stop("Uso: tr_auto_atuarial_geral.R [dataset em .csv] \n Para mais informações de uso desse script, acesse o LEIAME.txt")
}

#Carrega o arquivo
message("-------------------------------------------")
message("TheoremRisk - Seguro Auto - Versão 1.0")
message("-------------------------------------------")
message(cat("Lendo e analisando os dados do dataset", argumentos[1]))
message("Isso pode durar alguns minutos, aguarde.")
arq_casco_comp <- read.csv(argumentos[1])

#Total de registros do dataset
carteira <- nrow(arq_casco_comp)

#Roubo e Furto
soma_freq1 <- sum(arq_casco_comp$FREQ_SIN1+1)
soma_indeniz1 <- sum(arq_casco_comp$INDENIZ1)
premio_risco1 <- (soma_freq1/carteira) * (soma_indeniz1/soma_freq1)

#Colisão Parcial
soma_freq2 <- sum(arq_casco_comp$FREQ_SIN2+1)
soma_indeniz2 <- sum(arq_casco_comp$INDENIZ2)
premio_risco2 <- (soma_freq2/carteira) * (soma_indeniz2/soma_freq2)

#Colisão Perda Total
soma_freq3 <- sum(arq_casco_comp$FREQ_SIN3+1)
soma_indeniz3 <- sum(arq_casco_comp$INDENIZ3)
premio_risco3 <- (soma_freq3/carteira) * (soma_indeniz3/soma_freq3)

#Incêndio
soma_freq4 <- sum(arq_casco_comp$FREQ_SIN4+1)
soma_indeniz4 <- sum(arq_casco_comp$INDENIZ4)
premio_risco4 <- (soma_freq4/carteira) * (soma_indeniz4/soma_freq4)

#Assistência 24H
soma_freq9 <- sum(arq_casco_comp$FREQ_SIN9+1)
soma_indeniz9 <- sum(arq_casco_comp$INDENIZ9)
premio_risco9 <- (soma_freq9/carteira) * (soma_indeniz9/soma_freq9)

#Sinistralidade
premios_ganhos <- sum(arq_casco_comp$PREMIO1)
soma_indeniz_total <- sum(soma_indeniz1, 
                          soma_indeniz2, 
                          soma_indeniz3, 
                          soma_indeniz4, 
                          soma_indeniz9)
sinistralidade <- (soma_indeniz_total / premios_ganhos) * 100

#Importância Segurada média
is_media <- mean(arq_casco_comp$IS_MEDIA)

#Exposição média
exposicao_media <- mean(arq_casco_comp$EXPOSICAO1)

#Compila os Resultados de prêmio de risco em uma nova tabela
tbl_premios_risco <- data.frame(c(premio_risco1, 
                          premio_risco2, 
                          premio_risco3, 
                          premio_risco4, 
                          premio_risco9))
#Ajustes finais
colnames(tbl_premios_risco) <- c("Valor")
rownames(tbl_premios_risco) <- c("PR-Roubo e Furto", 
                           "PR-Colisão Parcial", 
                           "PR-Colisão Perda Total", 
                           "PR-Cobertura Incêndio" , 
                           "PR-Cobertura Assistência")

tbl_premios_risco$Valor <- round(tbl_premios_risco$Valor, digits = 2)

#Compila os demais Resultados em outra tabela
tbl_estatisticas <- data.frame(c(sinistralidade, 
                                 is_media, 
                                 exposicao_media))

colnames(tbl_estatisticas) <- c("Valor")
rownames(tbl_estatisticas) <- c("Sinistralidade em %",
                               "IS Média",
                               "Exposição Média")
tbl_estatisticas$Valor <- round(tbl_estatisticas$Valor, digits = 2)

write.csv(tbl_estatisticas, "estatisticas_geral.csv")
message("Estatísticas da carteira compiladas em estatisticas.csv")

#Prossegue para o script de cálculo de prêmio bruto
message("Iniciando o script de cálculo de prêmio bruto")
Sys.sleep(5)

source('tr_auto_calculo_geral.R')