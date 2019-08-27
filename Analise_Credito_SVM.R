# "FIles > More > Set As Working DIretory" 

# Importa o arquivo 
base_credit = read.csv('credit-data.csv')

# remove a coluna clientid
base_credit$clientid = NULL

# traz um resumo geral da base
summary(base_credit)

##################################################################
# seleciona todas as idades negativas, somente com restricao de linha
base_credit[base_credit$age < 0, ]

# seleciona todas as idades negativas, somente com restricao de linha e coluna 1 e 2
base_credit[base_credit$age < 0, 1:2]

# TRAS TUDO QUE E NEGATIVO E REMOVE OS NA (N/A)
base_credit[base_credit$age < 0 & !is.na(base_credit$age), ]

##################################################################
# CRIA UM BACKUP
base_credit_edit = base_credit

# DELETA A COLUNA IDADE
base_credit_edit$age = NULL

# INCLUI SOMENTE OS REGISTROS POSITIVOS NA VARIAVEL
base_credit_edit = base_credit_edit[base_credit_02$age > 0, ]


##################################################################
# PEGA AS INCONSISTENCIAS E MULTIPLICA POR -1
base_credit_edit[base_credit_edit$age < 0 & !is.na(base_credit_edit$age), ] = base_credit_edit[base_credit_edit$age < 0 & !is.na(base_credit_edit$age), ] * -1

# VERIFICA SE POSSUI MAIS IDADES NEGATIVAS
base_credit_edit[base_credit_edit$age < 0 & !is.na(base_credit_edit$age), ]

##################################################################
# TRATA ERROS N/A
# VERIFICA SE POSSUI IDADES N/A
base_credit_edit[is.na(base_credit_edit$age), ]

# INCLUI A MEDIA PARA TODAS AS IDADES NA
base_credit_edit$age = ifelse(is.na(base_credit_edit$age), MEDIA, base_credit_edit$age)

##################################################################
# REALIZA O ESCALONAMENTO DOS DADOS
base_credit_edit[ ,1:3] = scale(base_credit_edit[ , 1:3])

# VERIFICA O RESUMO APOS O ESCALONAMENTO
summary(base_credit_edit)

##################################################################
# ENCODE - TRANSFORMA A VARIAVEIS CATEGORICAS EM NUMERICAS DISCRETAS
base_credit_edit$default = factor(base_credit_edit$default, levels = c(0,1))


##################################################################
# INSTALA O PACOTE
install.packages('caTools')

# CARREGA O PACOTE
library(caTools)

# SETA UMA SEMENTE
set.seed(1)

# DIVIDE SUA BASE EM 60 %
divisao = sample.split(base_credit_edit$default, SplitRatio = 0.60)

# PRINT DIVISAO
divisao

# SEPARA A BASE TREINO EM UM SUB CONJUNTO(SUBSET) EM TUDO QUE FOI MARCADO COM TRUE NA DIVISAO
base_treino = subset(base_credit_edit, divisao == TRUE)

# SEPARA A BASE TESTE EM UM SUB CONJUNTO(SUBSET) EM TUDO QUE FOI MARCADO COM FALSE NA DIVISAO
base_teste = subset(base_credit_edit, divisao == FALSE)

# CHAMA A FUNCAO SVM E PASSA OS PARAMENTROS
classif_svm = svm(formula=default~., data = base_treino, type='C-classification', kernel='radial', cost=0.5)
print(classif_svm)

# PASSA  A BASE DE TESTE MESNO A ULTIMA COLUNA
prev_svm = predict(classif_svm, newdata = base_teste[-4])
print(prev_svm)

# CRIA A MATRIZ CONFUSAO
matriz_confusao_svm = table(base_teste[ ,4], prev_svm)
print(matriz_confusao_svm)

## PACOTE PARA CALCULAR TOTAL ACERTOS E ERROS
library(caret)

## CALCULA O TOTAL DE ERROS E ACERTOS
confusionMatrix(matriz_confusao_svm)
