<?php

require 'connect.php';

if($_SERVER['REQUEST_METHOD']=="POST"){

    $response = array();
    $pemasukkan = $_POST['pemasukkan'];
    $keterangan = $_POST['keterangan']; 
    $idUsers = $_POST['idUsers'];
    
    $insert = "INSERT INTO menu VALUE(NULL, '', '$pemasukkan', NOW(), '$keterangan', '$idUsers')";

    if(mysqli_query($con, $insert)){
    $response['value']=1;
    $response['message']="Add Data Succes";
    echo json_encode($response);

    }else{ 
        $response['value']=0;
        $response['message']="Add Data Failed";
        echo json_encode($response);
    }      
}

?>