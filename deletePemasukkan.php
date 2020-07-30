<?php

require 'connect.php';

if($_SERVER['REQUEST_METHOD']=="POST"){

    $response = array();
    $idData = $_POST['idData'];
    
    $insert = "DELETE FROM menu WHERE id='$idData'";

    if(mysqli_query($con, $insert)){
    $response['value']=1;
    $response['message']="Delete Data Succes";
    echo json_encode($response);

    }else{ 
        $response['value']=0;
        $response['message']="Delete Data Failed";
        echo json_encode($response);
    }      
}

?>