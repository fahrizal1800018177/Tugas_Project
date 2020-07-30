<?php

require 'connect.php';

$response = array();

$sqli = mysqli_query($con, "SELECT c.*, d.nama FROM hutang c LEFT JOIN users d ON c.idUsers = d.id");

while($c = mysqli_fetch_array($sqli)){

    $d['id'] = $c['id'];
    $d['pembayaran'] = $c['pembayaran'];
    $d['keterangan'] = $c['keterangan'];
    $d['waktu'] = $c['waktu'];
    $d['idUsers'] = $c['idUsers'];
    $d['nama'] = $c['nama'];

    array_push($response, $d);
}

echo json_encode($response);

?>
