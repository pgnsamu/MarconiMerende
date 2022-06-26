<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        .disclaimer{
            display: none;
        }
    </style>
    <title>Ordini</title>
</head>
<body>
  <h1> Ordini </h1>
    <?php
        ini_set('display_errors', 1);
        $con = new mysqli('localhost', 'id19124812_samuele', 'dSUNy1*&aMo[u^W*', 'id19124812_merende');
        $stringa_query = "SELECT ordini.nome, ordini.cognome, ordini.qta, prodotti.des FROM ordini, prodotti WHERE DATE(data) = CURRENT_DATE() AND ordini.id = prodotti.id";
        $ris = $con->query($stringa_query); //query sul db
        if ($ris->num_rows > 0) {
            echo "<table border='1'>";
            echo "<tr><th>nome</th><th>cognome</th><th>quantità</th><th>prodotto ordinato</th></tr>";
            foreach ($ris as $riga) {
                echo "<tr><td>" . $riga['nome'] . "</td><td>" . $riga['cognome'] . "</td><td>" . $riga['qta'] . "</td><td>" . $riga['des'] . "</td></tr>";
            }
            echo "</table>";
        }
    ?>
</body>
</html>