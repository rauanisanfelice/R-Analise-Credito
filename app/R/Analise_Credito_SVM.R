
# Files > More > Set As Working Diretory
# IMPORTA O ARQUIVO
# base_credit = read.csv('credit-data.csv')

svm_analise_cred <- function(){
    
    # INSTALA O PACOTE QUE FAZ A DIVIS�O DA BASE
    #install.packages('caTools')
    #install.packages('e1071')
    #install.packages('caret')
    #install.packages('RPostgreSQL')
    #install.packages('ggplot2')
    
    # CARREGA O PACOTE
    library(ggplot2)
    library(caTools)
    library(e1071)
    library(caret)
    library(RPostgreSQL)
    
    # CRIA CONEXAO AO BANCO
    pgdrv <- dbDriver(drvName = "PostgreSQL")
    db <-DBI::dbConnect(pgdrv,
                        dbname="postgres",
                        host="localhost",
                        port=5432,
                        user="postgre",
                        password="docker123")
    base_credit = dbGetQuery(db,"SELECT * FROM analise")
    
    # REMOVE A COLUNA CLIENTID
    base_credit$id = NULL
    
    
    ##################################################################
    # REMOVE IDADES NEGATIVAS
    base_credit= base_credit[base_credit$idade > 0, ]
    
    # REMOVE IDADES N/A
    base_credit = base_credit[!is.na(base_credit$idade), ]
    
    # Substitui idade por faixa etaria
    base_credit$renda = cut(base_credit$renda, breaks = c(20000,30000,40000,50000,60000,70000), labels = c("20k - 30k", "30k - 40k", "40k - 50k", "50k - 60k", "60k - 70k"), right = TRUE)
    base_credit$idade = cut(base_credit$idade, breaks = c(0,10,20,30,40,50,60,70,80,90,100), labels = c("0 - 10", "10 - 20", "20 - 30", "30 - 40", "40 - 50", "50 - 60", "60 - 70", "70 - 80", "80 - 90", "90 - 100"), right = TRUE)
    base_credit$emprestimo = cut(base_credit$emprestimo, breaks = c(0,20000,40000,60000,80000,100000,120000,140000,160000), labels = c("0 - 20k", "20k - 40k", "40k - 60k", "60k - 80k", "80k - 1m", "1,0m - 1,2m", "1,2m - 1,4m", "1,4m - 1,6m"), right = TRUE)
    
    ##################################################################
    # CRIA BACKUP
    base_credit_01 = base_credit
    
    # REALIZA O ESCALONAMENTO DOS DADOS
    base_credit_01$resultado = factor(base_credit_01$resultado, levels = c(0,1))
    
    base_credit_02 = base_credit_01
    
    
    ##################################################################
    # SETA UMA SEMENTE
    set.seed(1)
    
    # DIVIDE BASE COM RESULTADOS E BASE SEM RESULTADOS
    base_processed_sem <- subset(base_credit_02, !is.na(base_credit_02$resultado))
    base_processed_com <- subset(base_credit_02, is.na(base_credit_02$resultado))
    
    
    ##################################################################
    # REDUZIR A BASE
    # DIVIDE A BASE EM 50% QUE TEM RESULTADOS
    divisao_00 = sample.split(base_processed_sem[base_processed_sem$resultado == 0 ,], SplitRatio = 0.4)
    
    # SEPARA A BASE TREINO EM UM SUB CONJUNTO(SUBSET) EM TUDO QUE FOI MARCADO COM TRUE NA DIVISAO
    base_metade_sem = rbind(subset(base_processed_sem[base_processed_sem$resultado == 0 ,], divisao_00 == TRUE), base_processed_sem[base_processed_sem$resultado == 1,])
    
    
    
    ##################################################################
    # DIVIDE A BASE EM 60% QUE TEM RESULTADOS
    divisao = sample.split(base_metade_sem$resultado, SplitRatio = 0.6)
    
    # SEPARA A BASE TREINO EM UM SUB CONJUNTO(SUBSET) EM TUDO QUE FOI MARCADO COM TRUE NA DIVISAO
    base_treino = subset(base_metade_sem, divisao == TRUE)
    
    # SEPARA A BASE TESTE EM UM SUB CONJUNTO(SUBSET) EM TUDO QUE FOI MARCADO COM FALSE NA DIVISAO
    base_teste = subset(base_metade_sem, divisao == FALSE)
    
    
    ##################################################################
    # CLASSIFICA OS REGISTROS QUE JA POSSUEM RESULTADO
    # CHAMA A FUNCAO SVM  E PASSA OS PARAMENTROS
    classif_svm = svm(formula=resultado~., data=base_treino, type='C-classification', kernel='radial', cost=0.5)
    #print(classif_svm)
    
    # PASSA  A BASE DE TESTE MESNO A ULTIMA COLUNA
    prev_svm = predict(classif_svm, newdata = base_teste[-4])
    #print(prev_svm)
    
    # CRIA A MATRIZ CONFUSAO
    matriz_confusao_svm = table(base_teste[ ,4], prev_svm)
    #print(matriz_confusao_svm)
    
    # PRINT O TOTAL DE ERROS E ACERTOS
    #confusionMatrix(matriz_confusao_svm)
    
    # CAPTURA ACURACIA E PRINT
    result_cm = confusionMatrix(matriz_confusao_svm)
    result_cm = result_cm$overall
    acuracia_cm = round(result_cm['Accuracy'] * 100, digits = 2)
    
    
    ##################################################################
    # CLASSIFICA O NOVO REGISTRO QUE NAO POSSUE RESULTADO
    prev_svm_result = predict(classif_svm, newdata = base_processed_com[-4])
    
    retorno <- list("acuracia" = acuracia_cm, "resultado" = prev_svm_result)
    
    return(retorno)
}

svm_analise_cred()
