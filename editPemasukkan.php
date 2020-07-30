<?php

require 'connect.php';

if($_SERVER['REQUEST_METHOD']=="POST"){

    $response = array();
    $pemasukkan = $_POST['pemasukkan'];
    $keterangan = $_POST['keterangan']; 
    $idData = $_POST['idData'];
    
    $insert = "UPDATE menu SET pemasukkan='$pemasukkan', waktu=NOW(), keterangan='$keterangan' WHERE id='$idData'";

    if(mysqli_query($con, $insert)){
    $response['value']=1;
    $response['message']="Edit Data Succes";
    echo json_encode($response);

    }else{ 
        $response['value']=0;
        $response['message']="Edit Data Failed";
        echo json_encode($response);
    }      
}

?>