// INI UNTUK FILE PHP-nya

<?php

$data = file_get_contents('saldo.json');
$menu = json_decode($data, true);

$menu = $menu["saldo"];

?>


<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">

    <title>Project CashKu</title>
  </head>
  <body>

    <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#">Navbar</a>
    
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
        <div class="navbar-nav">
        <a class="nav-item nav-link active" href="#">Saldo<span class="sr-only">(current)</span></a>
        </div>
    </div>
    </nav>

<div class = "container">

  <div class = "row mt-3" >
    <div class = "col">
        
        <h2><a href = "#"> Pemasukkan </a></h2>
      
      </div>

    <div class = "col" >
        
        <h2><a href = "#"> Pengeluaran </a></h2>
      
      </div>          
  </div>

  <div class = "row" >

    <?php foreach($menu as $row) : ?>

    <div class = "col-md-4">
        
  <div class="card mb-3">
    <img src="img/<?= $row["gambar"]; ?> " class="card-img-top">

    <div class="card-body">
      <h5 class="card-title"><?= $row["kategori"]; ?></h5> 
      <p class="card-title">Rp. <?= $row["jumlah"]; ?> </p>
      <h5 class="card-text"><?= $row["keterangan"]; ?> </h5>
      <h5 class="card-text"><?= $row["jadwal"]; ?> </h5>

      
    </div>

  </div>
      
      </div> 

    <?php endforeach; ?>      
  </div>

</div>



    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.0.min.js" integrity="sha256-xNzN2a4ltkB44Mc/Jz3pT4iU1cmeR0FkXs4pru/JxaQ=" crossorigin="anonymous"></script>

    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
  </body>
</html>



// INI UNTUK FILE JSON-nya

{
    "saldo":[
        {
            "kategori" : "Pemasukkan",
            "jumlah" : 50000,
            "keterangan" : "Uang yang Masuk",
            "jadwal" : "Tiap Hari",
            "gambar" : "pemasukkan.png"
        },

        {
            "kategori" : "Pengeluaran",
            "jumlah" : 10000,
            "keterangan" : "Uang yang Keluar",
            "jadwal" : "Tiap Hari",
            "gambar" : "pengeluaran.png"
        }

    ]
    
}
