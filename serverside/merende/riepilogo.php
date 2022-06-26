<?php
    $con = new mysqli('localhost', 'id19124812_samuele', 'dSUNy1*&aMo[u^W*', 'id19124812_merende');

    if($_SERVER['REQUEST_METHOD'] == "GET"){
			
		$year=date("Y");
		$month=date("m");
		$day=date("d");
		
		$classe= $_GET['classe'];

        $stringa_query = "SELECT classe, data, qta, serialsim, nome, cognome, cod_organizzazione, id, IDU FROM ordini WHERE year(data)=$year AND month(data)=$month AND day(data)=$day AND classe='$classe' AND dchiusura is NULL";
        $ris = $con->query($stringa_query); //query sul db
        
        $array = array();
        while($row =mysqli_fetch_assoc($ris)){
            $array[] = $row;
        }
        echo json_encode($array, JSON_NUMERIC_CHECK);
    }
?>
