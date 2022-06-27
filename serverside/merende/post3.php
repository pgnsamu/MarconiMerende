<?php

    require "vendor/autoload.php";
    use \Firebase\JWT\JWT;
    use \Firebase\JWT\Key;

	//including the database connection file
	$con = new mysqli('localhost', 'id19124812_samuele', 'dSUNy1*&aMo[u^W*', 'id19124812_merende');
	
    ini_set('display_errors', 0); 
	if($_SERVER['REQUEST_METHOD'] == "POST"){
        $headers = getallheaders();
        
        if(isset($headers['authorization'])){
            $jwt = $headers['authorization'];
            $key = ""; //secret key
            if($jwt) { 
                try {
                    $decoded = JWT::decode($jwt, new Key($key, "HS256")); 
                        
                    //Receive the RAW post data.
                    $content = trim(file_get_contents("php://input"));

                    //Attempt to decode the incoming RAW post data from JSON.
                    $array = json_decode($content, true);
                    //echo $array[0]["uname"]; // Access Array data
                        
                    $year=date("Y");
                    $month=date("m");
                    $day=date("d");
                    $serialsim= $array[0]["serialsim"]; //00
                    $classe= $array[0]["classe"]; //
                    $nome= $array[0]["nome"];
                    $cognome= $array[0]["cognome"];
                    $cod_organizzazione= $array[0]["cod_organizzazione"];
                    $flagordine = 0;
                    $string = strtolower("$nome.$cognome@marconicloud.it");

                    


                    //controllare se l'ordine per la data attuale e la classe � chiuso
                    $resultdata = mysqli_query($con, "SELECT classe 
                                                    FROM ordini 
                                                    WHERE year(data)=$year AND month(data)=$month AND day(data)=$day 
                                                    AND classe='$classe' AND dchiusura is not NULL"
                                                ); 
                    
                    while($resdata = mysqli_fetch_array($resultdata)) { 
                        if (strcasecmp($classe, $resdata["classe"])==0){
                            $flag=1;//la classe � chiusa
                            break;
                        }else{
                            $flag=0;
                            break;
                        }
                    }
                    
                    //parte inserita per permettere al bar di inibire tutti gli ordinativi
                    $resultdatalock = mysqli_query($con, "SELECT status 
                                                            FROM blocco"); 
                    
                    while($resdatalock = mysqli_fetch_array($resultdatalock)) { 
                        
                        if ($resdatalock["status"]==1){
                            $flag=1;//il bar � chiuso
                            break;
                        }else{
                            $flag=0;
                            break;
                        }
                    }
                        
                    //$flag=0;//istruzione inserita per far inserire l'ordine anche se classe chiusa	
                    if ($flag==1){
                        $json = array("status" => 0, "msg" => "Bar chiuso non possibile inserire ordini");
                        echo json_encode($json);
                    }else{
                            
                        //controllare se esiste un ordine per quell'utente	
                        $resultdataordine = mysqli_query($con, "SELECT classe FROM ordini WHERE year(data)=$year AND month(data)=$month AND day(data)=$day AND nome='$nome' AND cognome='$cognome' AND classe='$classe'"); // using mysqli_query instead
                        


                        while($resdataordine = mysqli_fetch_array($resultdataordine)) { 
                            if (strcasecmp($classe, $resdataordine["classe"])==0){
                                $flagordine=1;//ordine presente
                                break;
                            }else{
                                $flagordine=0;
                                break;
                            }
                        }								
                        $flagordine=0;//istruzione inserita per far inserire l'ordine anche se ordine gi� presente
                        if ($flagordine==1){
                            $json = array("status" => 0, "msg" => "Ordinazione presente");
                            echo json_encode($json);
                        }else{
                            
                            //cancello eventuali altri ordini sull'utente e la data attuale
                            //$result1 = mysqli_query($con, "DELETE from ordini WHERE year(data)=$year AND month(data)=$month AND day(data)=$day AND nome='$nome' AND cognome='$cognome' AND classe='$classe'"); // using mysqli_query instead
                            
                            

                            $count = count($array);
                            for ($i = 0; $i < $count; $i++) {
                                $id= $array[$i]["id"];
                                $qta= $array[$i]["qta"];
                                $serialsim= $array[$i]["serialsim"];
                                $classe= $array[$i]["classe"];
                                $nome= $array[$i]["nome"];
                                $cognome= $array[$i]["cognome"];
                                $cod_organizzazione= $array[$i]["cod_organizzazione"];
                                
                                //insert data to database
                                $result = mysqli_query($con, "INSERT INTO ordini(classe, data, id, qta, serialsim, nome, cognome, cod_organizzazione) VALUES('$classe',NOW(),'$id','$qta','$serialsim','$nome','$cognome',$cod_organizzazione)");
                                //mysqli_commit($con);
                                //$resulttest = mysqli_query($con, "INSERT INTO log(data, des) VALUES(NOW(),'$classe,$id,$qta,$serialsim,$nome,$cognome,$cod_organizzazione')");
                            }
                            
                            $json = array("status" => 1, "msg" => "Ordine inserito!. $count prodotti");
                            echo json_encode($json);
                        }
                    }
                } catch (Exception $e) { 
                    http_response_code(401); 
                    $json = array("status" => 2, "msg" => $e->getMessage());
                    echo json_encode($json);
                } 
            } 
        }
	}
	//per cancellare un ordine
	if($_SERVER['REQUEST_METHOD'] == "GET"){
		
		//getting id from url
		$nome = $_GET['nome'];
		$cognome = $_GET['cognome'];
		$classe = $_GET['classe'];

		$year=date("Y");
		$month=date("m");
		$day=date("d");

		
		//controllare se l'ordine per la data attuale e la classe � chiuso
		$resultdata = mysqli_query($con, "SELECT classe FROM ordini WHERE year(data)=$year AND month(data)=$month AND day(data)=$day AND classe='$classe' AND dchiusura is not NULL"); 
		
			while($resdata = mysqli_fetch_array($resultdata)) { 
			
			if (strcasecmp($classe, $resdata["classe"])==0){
				$flag=1;//la classe � chiusa
				break;
			}else{
				$flag=0;
				break;
			}
		}
		$flag=0;//istruzione inserita per far cancellare l'ordine anche se classe chiusa (faccio cancella solo gli ordini senza dchiusura)	
		if ($flag==1){
			$json = array("status" => 0, "msg" => "Ordinazione chiusa :-(");
			echo json_encode($json);
		}else{

		//cancello eventuali altri ordini sull'utente e la data attuale
		$result1 = mysqli_query($con, "DELETE from ordini WHERE year(data)=$year AND month(data)=$month AND day(data)=$day AND nome='$nome' AND cognome='$cognome' AND classe='$classe' AND dchiusura is NULL"); // using mysqli_query instead
			
			$json = array("status" => 1, "msg" => "Ordine Cancellato!");
			echo json_encode($json);
		}
		
	}

?>
