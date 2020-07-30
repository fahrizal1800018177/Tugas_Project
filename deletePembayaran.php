<?php

require 'connect.php';

if($_SERVER['REQUEST_METHOD']=="POST"){

    $response = array();
    $idData = $_POST['idData'];
    
    $insert = "DELETE FROM hutang WHERE id='$idData'";

    if(mysqli_query($con, $insert)){
    $response['value']=1;
    $response['message']="Delete Data Pembayaran Succes";
    echo json_encode($response);

    }else{ 
        $response['value']=0;
        $response['message']="Delete Data Pembayaran Failed";
        echo json_encode($response);
    }      
}

?>