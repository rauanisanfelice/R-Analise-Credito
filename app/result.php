<!DOCTYPE html>
<html lang="pt">
    <script>
        window.onscroll = function() {scrollFunction()};
        function scrollFunction() {
            if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                document.getElementById("myBtn").style.display = "block";
            } else {
                document.getElementById("myBtn").style.display = "none";
            }
        }
        
        function topFunction() {
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
        }

        function mudaestado(el)
        {
            var display = document.getElementById(el).style.display;
            if (display == "none"){
                document.getElementById(el).style.display = 'block';
            } else {
                document.getElementById(el).style.display = 'none';
            }
        }
    </script>

    <head>
        <title>Virtual Democracia</title>
        <meta charset="utf-8">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <link rel="stylesheet" type="text/css" href="/rauan/R-Analise-Credito/app/src/style/styles.css" />
        <link rel="icon" type="imagem/png" href="/rauan/R-Analise-Credito/app/src/img/favicon.png" />
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
    </head>

    <body>
      <?php
        $user = 'analise';
        $pass = 'docker123';
        $host = 'localhost';
        $db = 'analise';
        $port = '5432';

        $con_string = "host=$host port=$port dbname=$db user=$user password=$pass";
        $con = pg_connect($con_string);
        
        $q1 = $_POST['q1'];
        $q2 = $_POST['q2'];
        $q3 = $_POST['q3'];
        
        // print_r($q1);
        // print_r($q2);
        // print_r($q3);

        $query = "INSERT INTO analise (renda, idade, emprestimo, resultado) VALUES ($q1, $q2, $q3, null);";
        pg_query($con, $query);
        
        exec('C:\Windows\System32\cmd.exe /c "C:\Users\rishida\Documents\Github_Rauan\rauan\R-Analise-Credito\app\R\exec_r.bat', $output);
        exec('C:\Windows\System32\cmd.exe /c "C:\Users\rishida\Documents\Github_Rauan\rauan\R-Analise-Credito\app\R\exec_r.bat', $output);

        $content = file_get_contents('./R/resultado.txt');
        
        $acuraciaPos = strpos($content, 'Accuracy');
        $resultadoPos = strpos($content, '$resultado');

        $acuracia = substr($content, $acuraciaPos + 8, 11);
        $resultado = substr($content, $resultadoPos + 22, 1);
        
        // print_r($resultado);
        $resultado_texto = $resultado == 1 ? 'Não emprestar!' : 'Libera a verba';
        $cor = $resultado == 1 ? 'rgba(255, 0, 0, 0.9)' : 'rgba(0, 255, 0, 0.9)';

        $texto_resultado = '<div class="row justify-content-center" style="margin-top:100px;"><div class="card col-6 border border-secondary" style="background-color:'.$cor.'">
            <div class="card-body">
                <h5 class="card-title">Resultado</h5>
                <p class="card-text">'.$resultado_texto.'</p>
                <p class="card-text font-weight-bold" id="percentual">'.$acuracia.'% de compatibilidade</p>
            </div>
        </div></div>';
        echo $texto_resultado;


        $query = "select id from analise order by id desc limit 1";
        $result_00 = pg_query($con, $query);
        $result_01 = pg_fetch_assoc($result_00);
        $id = $result_01['id'];

        $query = "delete from analise where id = $id";
        pg_query($con, $query);

        ?>
        <div id="menu-superior">
            <button type="button" class="btn btn-outline-dark" onclick="location.href='index.html';">Voltar</button>
        </div>
    </body>
</html>