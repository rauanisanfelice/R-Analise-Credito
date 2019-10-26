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
        <link rel="stylesheet" type="text/css" href="./src/style/styles.css" />
        <link rel="icon" type="imagem/png" href="./src/img/favicon.png" />
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
    </head>

    <body>
      <?php
        $host = 'analise-postgre';
        $db = 'postgres';
        $port = '5432';
        $user = 'postgre';
        $pass = 'docker123';

        $con_string = "host=$host port=$port dbname=$db user=$user password=$pass";
        $con = pg_connect($con_string);
        
        $q1 = $_POST['q1'];
        $q2 = $_POST['q2'];
        $q3 = $_POST['q3'];

        $query = "INSERT INTO analise (renda, idade, emprestimo, resultado) VALUES ($q1, $q2, $q3, null);";
        pg_query($con, $query);
        
        // TODO incluir validação de SO
        $retorno = getOS();
        if ($retorno = 'Windows')
            exec('Rscript Analise_Credito_SVM.R', $results);
        else
            exec('Rscript Analise_Credito_SVM.R', $results);
        
            print_r($results);
        
        // TODO ajustar formar de chamar
        // TODO simplificar caminho
        // TODO GET CURRENT FOLDER
        // $content = file_get_contents('./R/resultado.txt');
        
        //$acuraciaPos = strpos($content, 'Accuracy');
        //$resultadoPos = strpos($content, '$resultado');

        //$acuracia = substr($content, $acuraciaPos + 8, 11);
        //$resultado = substr($content, $resultadoPos + 22, 1);
        
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
        

        $user_agent = $_SERVER['HTTP_USER_AGENT'];

        function getOS() { 
            global $user_agent;
            $os_platform  = "Unknown OS Platform";
            $os_array     = array(
                                '/windows nt 10/i'      =>  'Windows',
                                '/windows nt 6.3/i'     =>  'Windows',
                                '/windows nt 6.2/i'     =>  'Windows',
                                '/windows nt 6.1/i'     =>  'Windows',
                                '/windows nt 6.0/i'     =>  'Windows',
                                '/windows nt 5.2/i'     =>  'Windows',
                                '/windows nt 5.1/i'     =>  'Windows',
                                '/windows xp/i'         =>  'Windows',
                                '/windows nt 5.0/i'     =>  'Windows',
                                '/windows me/i'         =>  'Windows',
                                '/win98/i'              =>  'Windows',
                                '/win95/i'              =>  'Windows',
                                '/win16/i'              =>  'Windows',
                                '/macintosh|mac os x/i' =>  'Mac OS',
                                '/mac_powerpc/i'        =>  'Mac OS',
                                '/linux/i'              =>  'Linux',
                                '/ubuntu/i'             =>  'Linux',
                            );

            foreach ($os_array as $regex => $value)
                if (preg_match($regex, $user_agent))
                    $os_platform = $value;

            return $os_platform;
        }

        ?>
        <div id="menu-superior">
            <button type="button" class="btn btn-outline-dark" onclick="location.href='index.html';">Voltar</button>
        </div>
    </body>
</html>