
#Cria variáveis e pega os parâmetros do arquivo de configuração
parametros_calculo <- read.csv('parametros.csv')
margem_seguranca <- as.numeric(parametros_calculo[1, 2]) / 100
carregamento <- as.numeric(parametros_calculo[2, 2]) / 100
iof <- as.numeric(parametros_calculo[3, 2]) / 100

#Roubo e Furto
premio_puro1 <- premio_risco1 * (1 + margem_seguranca)
premio_comercial1 <- premio_puro1 / (1 - carregamento)
premio_bruto1 <- premio_comercial1 * (1 + iof)

#Colisão Parcial
premio_puro2 <- premio_risco2 * (1 + margem_seguranca)
premio_comercial2 <- premio_puro2 / (1 - carregamento)
premio_bruto2 <- premio_comercial2 * (1 + iof)

#Colisão Perda Total
premio_puro3 <- premio_risco3 * (1 + margem_seguranca)
premio_comercial3 <- premio_puro3 / (1 - carregamento)
premio_bruto3 <- premio_comercial3 * (1 + iof)

#Incêndio
premio_puro4 <- premio_risco4 * (1 + margem_seguranca)
premio_comercial4 <- premio_puro4 / (1 - carregamento)
premio_bruto4 <- premio_comercial4 * (1 + iof)

#Assistência 24H
premio_puro9 <- premio_risco9 * (1 + margem_seguranca)
premio_comercial9 <- premio_puro9 / (1 - carregamento)
premio_bruto9 <- premio_comercial9 * (1 + iof)

#Salva os parâmetros usados para a geração das novas cotações em resultados_modelo.csv
message("-------------------------------------------")
message("Parâmetros considerados para os cálculos")
message(cat("Margem de segurança", margem_seguranca * 100, "%"))
message(cat("Carregamento", carregamento * 100, "%"))
message(cat("Valor do IOF", iof * 100, "%"))
message("-------------------------------------------")
message(cat("Cálculos gerados em", date()))

#Compila os resultados em novas tabelas
tbl_premiofinal <- round(data.frame(c(premio_bruto1), 
                                    c(premio_bruto2), 
                                    c(premio_bruto3), 
                                    c(premio_bruto4), 
                                    c(premio_bruto9)), digits = 2)

rownames(tbl_premiofinal) <- levels(listamodelos)
colnames(tbl_premiofinal) <- c("Roubo e Furto", 
                               "Colisão Parcial", 
                               "Colisão Perda Total", 
                               "Incêndio", 
                               "Assistência 24H")

#Soma todas as coberturas para criar a coluna do Seguro Compreensivo
tbl_premiofinal$Compreensivo <- tbl_premiofinal$`Roubo e Furto` + 
                                tbl_premiofinal$`Colisão Parcial` + 
                                tbl_premiofinal$`Colisão Perda Total` + 
                                tbl_premiofinal$Incêndio +
                                tbl_premiofinal$`Assistência 24H`

write.csv(tbl_premiofinal, "resultados_modelos.csv")

#Fim do script
message("Prêmios de seguro ao consumidor final calculados! Veja os resultados em 'resultados_modelos.csv'")