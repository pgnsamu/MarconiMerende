<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ordini</title>
    <style>
        .disclaimer{
            display: none;
        }
        .normal{

        }
        .finito{
            color: white;
            background-color: green;
        }
    </style>
    <script>
        let classeFetch;
        function liveUpdate(){
            //const table = document.getElementById("table");
            setInterval(function(){
                fetch("ordini.php")
                .then(response => response.json())
                .then(json => {
                    classeFetch = json;
                    var string = "<table border=1>";
                    string += "<tr><th>nome</th><th>cognome</th><th>quantità</th><th>prodotto ordinato</th></tr>";
                    classeFetch.forEach(element => {
                        var dchiusura = `${element.dchiusura}`;
                        if(dchiusura == 'null'){
                            string += `<tr class='normal' id=${element.IDU}><td>${element.nome}</td><td>${element.cognome}</td><td>${element.qta}</td><td>${element.des}</td><td><button type='submit' name='finito' value=${element.IDU} id='${element.IDU}b'>ordini preparato</button></td></tr>`;
                        }else{
                            string += `<tr class='finito' id=${element.IDU}><td>${element.nome}</td><td>${element.cognome}</td><td>${element.qta}</td><td>${element.des}</td><td><button type='submit' name='finito' value=${element.IDU} id='${element.IDU}b' disabled>ordini preparato</button></td></tr>`;
                        }
                    })
                    string += "</table>";
                    document.getElementById("container").innerHTML = string;
                })
                
            }, 100);
        }
        document.addEventListener('DOMContentLoaded', function(){
            liveUpdate();
        });
    </script>
</head>
<body>
    <h1>Ordini</h1>
    <form action="index2.php" method="post" id="container"></form>
    <?php
        if(isset($_POST["finito"])){
            //$con = new mysqli('localhost', 'id19124812_samuele', 'dSUNy1*&aMo[u^W*', 'id19124812_merende');
            $con = new mysqli('127.0.0.1', 'root', '', 'merende2');
            $stringa_query = "UPDATE `ordini` SET `dchiusura` = NOW() WHERE `ordini`.`IDU` = ". $_POST['finito'];
            $ris = $con->query($stringa_query); //query sul db
            /*
            echo "<script>
                    my_element = document.getElementById(".$_POST['finito'].");
                    my_element.setAttribute('class','finito');
                    document.getElementById('".$_POST['finito']."b').disabled = true;
                </script>";*/
        }
    ?>
</body>
</html>
