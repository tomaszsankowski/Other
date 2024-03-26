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
      <a href="addnewposts">Kontakt</a>
      <a class="active" href="autor.php">O mnie</a>
        </div>
    </nav>
    
    <div class="content">   
        <div class="anime">
            <div class="animation">
            </div>
        </div>
        <h1 class="headingauthor">O autorze:</h1>
        <section class="mcchicken">
            <img src="img/profile.jpg" alt="prifle-picture" id="one">
            <p class="tomasz"><strong>Tomasz Sankowski</strong></p><p><br>
            Na co dzień jestem studentem Politechniki Gdańskiej. Od 2022 roku studiuję tam informatykę. Przedtem skończyem V Liceum Ogólnokształcące w Gdańsku. Podczas wakacji przed rozpoczęciem studiów pełnoetatowo pracowałem w MacDonaldzie, teraz przychodzę tam tylko w weekendy. Kiedyś chciałbym być programistą, jednak moim hobby jest motoryzacja. Uwielbiam jeżdzić samochodzem, samodzielnie robić w nim drobne naprawy oraz oczywiście fotografować bardziej oryginalne czy rzadko spotykane sztuki. Moim wymarzonym autem jest Toyota Supra MK3. Mam nadzieje, że będzie mnie kiedyś na nią stać, i role się zamienią- wtedy to inni carspotterzy będą robić zdjęcia mi. Poza tym zawsze będę miał zamiłowanie do Skody. To właśnie modelem tej firmy - Fabią robiłem swoje pierwsze tysiące kilometrów.</p>
            <h3>Możesz odnaleźć mnie na tych oto social mediach:</h3>
            <div class="links">
            <a href="https://www.facebook.com/"><img src="img/facebook.png" alt="facebook-logo"></a>
            <a href="https://www.instagram.com/"><img src="img/instagram.png" alt="instagram-logo"></a>
            </div>
        </section>
            
    </div>
    <footer><h3><i>Tomasz Sankowski 193363 2022-10-21</i></h3></footer>
</body>
</html>
<!--<-->