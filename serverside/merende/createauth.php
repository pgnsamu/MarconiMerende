<?php
    require "vendor/autoload.php";
    use \Firebase\JWT\JWT;
    use \Firebase\JWT\Key;

    $con = new mysqli('localhost', 'id19124812_samuele', 'dSUNy1*&aMo[u^W*', 'id19124812_merende');


    if($_SERVER['REQUEST_METHOD'] == "POST"){
        $content = trim(file_get_contents("php://input"));

        $array = json_decode($content, true);

        $serialsim= $array[0]["serialsim"];
        $classe= $array[0]["classe"];
        $nome= $array[0]["nome"];
        $cognome= $array[0]["cognome"];
        $cod_organizzazione= $array[0]["cod_organizzazione"];

        $string = strtolower("$nome.$cognome@marconicloud.it");
        //$string2 = "samuele.pagnotta@marconicloud.it";
        $ris= $con->query("SELECT username FROM utenti WHERE username = '$string'"); //query sul db
        $num = $ris->num_rows;
        if($num > 0){
            $secret_key = ""; //secret key
            $issuedat_claim = time(); // issued at
            $expire_claim = $issuedat_claim + 60; // expire time in seconds
            $token = array(
                "iat" => $issuedat_claim,
                "exp" => $expire_claim,
                "data" => array(
                    "firstname" => $nome,
                    "lastname" => $cognome,
                    "email" => $string
                )
            );

            http_response_code(200);

            $jwt = JWT::encode($token, $secret_key, "HS256");
            
            echo json_encode(
                array(
                    "message" => "Successful login.",
                    "jwt" => $jwt,
                    "email" => $string,
                    "expireAt" => $expire_claim
                )
            );            
        }
        else{

            http_response_code(401);
            echo json_encode(array("message" => "Login failed."));
        }
    }
?>
