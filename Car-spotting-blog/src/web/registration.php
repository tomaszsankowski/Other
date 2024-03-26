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
      <a href="autor.php">O mnie</a>
        </div>
      
    </nav>
    <div class="content">
        <h1 class="heading">Zarejestruj się:</h1>
        <form action="/register" method="POST">
        <input type="text" name="login" placeholder="Login . . ." required><br>
        <input type="text" name="email" placeholder="Email . . ." required><br>
        <input type="password" name="password1" placeholder="Podaj hasło . . ." required><br>
        <input type="password" name="password2" placeholder="Powtrórz hasło . . ." required><br>
        <input type="submit" value="Zarejestruj się">
        <input type="reset" value="Wyczyść">
        </form>
    </div>
    <footer><h3><i>Tomasz Sankowski 193363 2022-10-21</i></h3></footer>
</body>
</html>