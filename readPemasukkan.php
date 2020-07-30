<?php

require 'connect.php';

$response = array();

$sql = mysqli_query($con, "SELECT a.*, b.nama FROM menu a LEFT JOIN users b ON a.idUsers = b.id");

while($a = mysqli_fetch_array($sql)){

    $b['id'] = $a['id'];
    $b['saldo'] = $a['saldo'];
    $b['pemasukkan'] = $a['pemasukkan'];
    $b['waktu'] = $a['waktu'];
    $b['keterangan'] = $a['keterangan'];
    $b['idUsers'] = $a['idUsers'];
    $b['nama'] = $a['nama'];

    array_push($response, $b);
}

echo json_encode($response);

?>