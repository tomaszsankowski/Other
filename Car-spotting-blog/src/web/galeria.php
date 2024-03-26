<?php session_start(); ?>
<?php
if(isset($_GET["page"]))
        {
            $page = $_GET["page"];
        }
        else
        {
            $page = 1;
        }
?>
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
      <a class="active" href="posts">Galeria zdjęć</a>
      <a href="addnewposts">Kontakt</a>
      <a href="autor.php">O mnie</a>
        </div>
      
    </nav>
    <div class="content">
        <h1 class="heading">Galeria zdjęć:</h1>
        <?php foreach ($posts as $post): ?>
        <div class="galeria">
            <a href="images/watermark/water<?= $post->imageFullName ?>">
                <img src="images/miniatures/mini<?= $post->imageFullName ?>" alt="image">
            </a>
            <div class="desc">
                <h4><?= $post->title ?></h4>
                <p><?= $post->author ?></p>
            </div>
        </div>
        <?php endforeach; ?>
       
        <div class="minimenu">
        <?php
        for($i=1;$i<=$pages;$i++)
        { 
        if($i==$page)
        {
        ?>
            <a class="activated" href="posts?page=<?= "$i" ?>"><?= "Strona "."$i" ?></a>
        <?php
        }
        else
        {
        ?>
            <a href="posts?page=<?= "$i" ?>"><?= "Strona "."$i" ?></a>
        <?php 
        }
        } 
        ?>
        </div>
    </div>
    <footer><h3><i>Tomasz Sankowski 193363 2022-10-21</i></h3></footer>
</body>
</html>