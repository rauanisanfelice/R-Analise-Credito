![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/rauanisanfelice/R-Analise-Credito.svg)
![GitHub top language](https://img.shields.io/github/languages/top/rauanisanfelice/R-Analise-Credito.svg)
![GitHub pull requests](https://img.shields.io/github/issues-pr/rauanisanfelice/R-Analise-Credito.svg)
![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/rauanisanfelice/R-Analise-Credito.svg)
![GitHub contributors](https://img.shields.io/github/contributors/rauanisanfelice/R-Analise-Credito.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/rauanisanfelice/R-Analise-Credito.svg)

![GitHub stars](https://img.shields.io/github/stars/rauanisanfelice/R-Analise-Credito.svg?style=social)
![GitHub followers](https://img.shields.io/github/followers/rauanisanfelice.svg?style=social)
![GitHub forks](https://img.shields.io/github/forks/rauanisanfelice/R-Analise-Credito.svg?style=social)


# Análise de Crédito;

Análise de Crédito utilizando a linguagem R e a biblioteca SVM o sistema esta com uma Acurácia de 97.18%.

## Sistemas Utilizados:
* Apache;
* Docker Compose;
* R;
* R Studio;
* PgAdmin;
* Postgre;

## Instruções;

Você deve atribuir no R Studio esta pasta como "Working Diretory" atual.

FIles > More > Set As Working Diretory

Para subir o Bando execute o comando a baixo: 
```console
docker-compose up -d
```

### Configurando container PGADMIN;

Acesse o link:

[Banco PgAdmin](http://localhost:8080)

Realize o login:
>User: admin  
>Pass: admin

Clique em: Create > Server

Conecte no Banco com os seguintes parametros:  

Name: #nome desejado#  
>Host: analise-postgre
>Port: 5432  
>Db  : postgre  
>User: postgres  
>Pass: docker123

Para criar as tabelas e importar os dados execute a Query:
> ..\R-Analise-Credito\database\create-table.sql

Estrutura da tabale:  

|Renda|Idade|Emprestimo|Result|
|:-----:|:-----:|:------:|:------:|
|Integer|Integer|Integer|Integer|

## Links;

- [Sistema](http://localhost/R-Analise-Credito/app/result.php)  
- [Banco PgAdmin](http://localhost:8080)