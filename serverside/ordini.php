<?php

    header('Content-Type: application/json');
    
    ini_set('display_errors', 1);
    $con = new mysqli('*************', '*************', '*************', '*************');
    //$con = new mysqli('127.0.0.1', 'root', '', 'merende2');
    $stringa_query = "SELECT ordini.nome, ordini.cognome, ordini.qta,  ordini.IDU, ordini.dchiusura, prodotti.des 
                        FROM ordini, prodotti 
                        WHERE DATE(data) = CURRENT_DATE() AND ordini.id = prodotti.id
                        ORDER by ordini.dchiusura";
    $ris = $con->query($stringa_query); //query sul db
    while($row = $ris->fetch_assoc()) {
        $myArray[] = $row;
    }
    echo json_encode($myArray);
?>
