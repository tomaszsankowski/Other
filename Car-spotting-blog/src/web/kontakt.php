<?php session_start(); ?>
<!DOCTYPE html>
<html class="no-js" lang="pl">
<head>
<title>Moje Hobby</title>
    
<script>
    document.documentElement.className = 
       document.documentElement.className.replace("no-js","");
</script>
    
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="style.css">
<link rel="shortcut icon" href="favicon.png">
</head>
<body>
    <div class="loginin" id="logini">
        <?php
        if(isset($_SESSION['login']))
        {
        ?>
        <?= "Hej, ".$_SESSION['login'] ?>
        <form action="/logout" method="POST">
            <button class="logout-button" type="submit">Wyloguj się</button>
        </form>
        <?php
        }
        else
        {
        ?>
        Zaloguj się:
        <form action="/login" method="POST">
            <input type="text" name="login" placeholder="Login . . ." required>
            <input type="password" name="password" placeholder="Hasło . . ." required>
            <input type="submit" id="go" value="Zaloguj się">
            <input type="reset" id="cleaned" value="Anuluj">
        </form>
        <br>
        Nie masz jeszcze konta? 
        <a href="registerscreen">Zarejestruj się</a>
        <?php
        }
        ?>
    </div>
    <header >
            <h1 class="sizer"><strong><i>CAR SPOTTING</i></strong></h1>
        <button aria-label="bluemode">
            <span class="gruby">Tryb koloru</span>
            <span class="icon"></span>
        </button>
    </header>
    <script src="script.js"></script>
    <nav>
      <a class="button">Menu</a>
        <div class="visible">
        <div class="drop">
          <a href="index.php">Strona Główna</a>
          <ul>
            <li><a href="#CHIRON">Bugatti</a></li>
            <li><a href="#MUSTANG">Ford</a></li>
            <li><a href="#SUPRA">Toyota</a></li>
          </ul>
      </div>
      <a href="posts">Galeria zdjęć</a>
      <a class="active" href="addnewposts">Kontakt</a>
      <a href="autor.php">O mnie</a>
        </div>
      
    </nav>
    <div class="content">
        <h1 class="heading">Wyślij nam swoje znaleziska</h1>
        <form action="/post" method="POST" enctype="multipart/form-data">
        <input type="text" name="title" placeholder="Tytuł:" required>
        <input type="text" name="author" placeholder="Autor:" required>
        <input type="text" name="watermark" placeholder="Tekst znaku wodnego:" required>
        <input type="file" name="file" required>
        <input type="submit" value="Udostępnij obraz">
        <input type="reset" value="Wyczyść">
        </form>
    </div>
    <footer><h3><i>Tomasz Sankowski 193363 2022-10-21</i></h3></footer>
</body>
</html>