<?php

require 'connect.php';

if($_SERVER['REQUEST_METHOD']=="POST"){

    $response = array();
    $nama = $_POST['nama'];
    $username = $_POST['username']; 
    $password = $_POST['password'];
    
    $insert = "INSERT INTO users VALUE(NULL,'$username', '$password', '$nama', NOW())";

    if(mysqli_query($con, $insert)){
    $response['value']=1;
    $response['message']="Register Succes";
    echo json_encode($response);

    }else{ 
        $response['value']=0;
        $response['message']="Register Failed";
        echo json_encode($response);
    }      
}

?>