
#Cria variáveis e pega os parâmetros do arquivo de configuração
listaprodutos <- list(rownames(tbl_premios_risco))

parametros_calculo <- read.csv('parametros.csv')
margem_seguranca <- as.numeric(parametros_calculo[1, 2]) / 100
carregamento <- as.numeric(parametros_calculo[2, 2]) / 100
iof <- as.numeric(parametros_calculo[3, 2]) / 100

message("-------------------------------------------")
message("Parâmetros considerados para os cálculos")
message(cat("Margem de segurança", margem_seguranca * 100, "%"))
message(cat("Carregamento Comercial", carregamento * 100, "%"))
message(cat("Valor do IOF", iof * 100, "%"))
message("-------------------------------------------")

#Inicia a precificação no método do prêmio de risco para cada uma das coberturas
for (produto in listaprodutos) {

premio_puro <- tbl_premios_risco[produto, ] * (1 + margem_seguranca)
premio_comercial <- premio_puro / (1 - carregamento)
premio_bruto <- premio_comercial * (1 + iof)

resultados <- list(c(premio_bruto))

}

#Compila os resultados em nova tabela
tbl_resultados <- data.frame(resultados)
rownames(tbl_resultados) <- rownames(tbl_premios_risco)
colnames(tbl_resultados) <- c("Valor")
tbl_resultados$Valor <- round(tbl_resultados$Valor, digits = 2)

write.csv(tbl_resultados, "resultados_geral.csv")

#Fim do script
message("Prêmios de seguro ao consumidor final calculados! Veja os resultados em 'resultados_geral.csv'")