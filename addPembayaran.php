<?php

require 'connect.php';

if($_SERVER['REQUEST_METHOD']=="POST"){

    $response = array();
    $pembayaran = $_POST['pembayaran'];
    $keterangan = $_POST['keterangan']; 
    $idUsers = $_POST['idUsers'];
    
    $insert = "INSERT INTO hutang VALUE(NULL,'$pembayaran', '$keterangan', NOW(), '$idUsers')";

    if(mysqli_query($con, $insert)){
    $response['value']=1;
    $response['message']="Pembayaran Succes";
    echo json_encode($response);

    }else{ 
        $response['value']=0;
        $response['message']="Penbayaran Failed";
        echo json_encode($response);
    }      
}

?>