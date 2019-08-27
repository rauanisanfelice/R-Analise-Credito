# Files > More > Set As Working Diretory

# IMPORTA O ARQUIVO
base_credit = read.csv('credit-data.csv')

# REMOVE A COLUNA CLIENTID
base_credit$clientid = NULL

# TRAZ UM RESUMO GERAL DA BASE
summary(base_credit)


##################################################################
# SELECIONA TODAS AS IDADES NEGATIVAS, SOMENTE COM RESTRIÇÕES DE LINHA
base_credit[base_credit$age < 0, ]

# Seleciona todas as idades negativas, somente com restrição de linha e coluna 1 e 2
base_credit[base_credit$age < 0, 1:2]

# TRAS TUDO QUE É NEGATIVO E REMOVE OS NA (N/A)
base_credit[base_credit$age < 0 & !is.na(base_credit$age), ]


##################################################################
# CRIA UM BACKUP
base_credit_01 = base_credit

# DELETA A COLUNA IDADE
base_credit_01$age = NULL


##################################################################
# CRIA BACKUP
base_credit_02 = base_credit

# INCLUI SOMENTE OS REGISTROS POSITIVOS NA VARIAVEL
base_credit_02 = base_credit_02[base_credit_02$age > 0, ]


##################################################################
# CRIA BACKUP
base_credit_03 = base_credit

# PEGA AS INCONSISTENCIAS E MULTIPLICA POR -1
base_credit_03[base_credit_03$age < 0 & !is.na(base_credit_03$age), ] = base_credit_03[base_credit_03$age < 0 & !is.na(base_credit_03$age), ] * -1

# NÃO POSSUI MAIS IDADES NEGATIVAS
base_credit_03[base_credit_03$age < 0 & !is.na(base_credit_03$age), ]


##################################################################
# CRIA BACKUP
base_credit_04 = base_credit

# FAZ SELECT PARA DESCOBRIR AS LINHAS
base_credit_04[base_credit_04$age < 0 & !is.na(base_credit_04$age), ]

# ALTERA OS VALORES PARA POSITIVO AS IDADES QUE ERA NEGATIVAS
base_credit_04[16,2] = 28 
base_credit_04[22,2] = 52
base_credit_04[27,2] = 36

##################################################################
# CRIA BACKUP
base_credit_05 = base_credit

# CALCULA A MÉDIA
mean(base_credit_05$age)

# MEDIA SEM N/A
mean(base_credit_05$age, na.rm = TRUE)

# CALCULA A MÉDIA DAS IDADES SEM NEGATIO E N/A
MEDIA = mean(base_credit_05$age[base_credit_05$age > 0], na.rm = TRUE)

# SE A IDADE FOR NEGATIVA SUBSTIRUI PELA MEDIA CALCULADA
base_credit_05$age = ifelse(base_credit_05$age < 0, MEDIA, base_credit_04$age)


##################################################################
# TRATA ERROS N/A

# CRIA BACKUP
base_credit_06 = base_credit_03

# VERIFICA SE POSSUI IDADES N/A
base_credit_06[is.na(base_credit_06$age), ]

# INCLUI A MEDIA PARA TODAS AS IDADES N/A
base_credit_06$age = ifelse(is.na(base_credit_06$age), MEDIA, base_credit_06$age)


##################################################################
# REALIZA O ESCALONAMENTO DOS DADOS

# CRIA BACKUP
base_credit_07 = base_credit_06

# ESCALONA SOMENTE A COLUNA 1 ATÉ 3
base_credit_07[ ,1:3] = scale(base_credit_07[ , 1:3])

# VERIFICA O RESUMO APOS O ESCALONAMENTO
summary(base_credit_07)


##################################################################
# ESCALONA SOMENTE A COLUNA 1 ATÉ 3
base_credit_07$default = factor(base_credit_07$default, levels = c(0,1))


##################################################################
# INSTALA O PACOTE QUE FAZ A DIVISÃO DA BASE
install.packages('caTools')
install.packages('e1071')
install.packages('caret')

# CARREGA O PACOTE
library(caTools)
library(e1071)
library(caret)

##################################################################
# SETA UMA SEMENTE
set.seed(1)

# DIVIDE SUA BASE EM 60 %
divisao = sample.split(base_credit_07$default, SplitRatio = 0.60)

# PRINT DIVISÃO
divisao

# SEPARA A BASE TREINO EM UM SUB CONJUNTO(SUBSET) EM TUDO QUE FOI MARCADO COM TRUE NA DIVISAO
base_treino = subset(base_credit_07, divisao == TRUE)

# SEPARA A BASE TESTE EM UM SUB CONJUNTO(SUBSET) EM TUDO QUE FOI MARCADO COM FALSE NA DIVISAO
base_teste = subset(base_credit_07, divisao == FALSE)


##################################################################
# CHAMA A FUNÇÃO SVM  E PASSA OS PARAMENTROS
classif_svm = svm(formula=default~., data = base_treino, type='C-classification', kernel='radial', cost=0.5)
print(classif_svm)

# PASSA  A BASE DE TESTE MESNO A ULTIMA COLUNA
prev_svm = predict(classif_svm, newdata = base_teste[-4])
print(prev_svm)

# CRIA A MATRIZ CONFUSAO
matriz_confusao_svm = table(base_teste[ ,4], prev_svm)
print(matriz_confusao_svm)

# PRINT O TOTAL DE ERROS E ACERTOS
confusionMatrix(matriz_confusao_svm)

# CAPTURA ACURACIA E PRINT
result_cm = confusionMatrix(matriz_confusao_svm)
result_cm = result_cm$overall
acuracia_cm = result_cm['Accuracy']
print(acuracia_cm)
