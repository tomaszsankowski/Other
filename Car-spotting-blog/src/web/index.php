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
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
  <script>
  $( function() {
    $( "#accordion" ).accordion({
      heightStyle: "content"
    });
  } );
  </script>
    
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
    <nav>
      <a class="button">Menu</a>
        <div class="visible">
        <div class="drop">
          <a class="active" href="index.php">Strona Główna</a>
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
        <h1 class="heading">Trochę o mojej pasji- carspottingu:</h1>
        <br>
        <h2>Czym jest carspotting?</h2>
        <p>Carspotting to zajęcie polegające na fotografofaniu i filmowaniu drogich, nietypowych, bądź oryginalnych samochodów zazwyczaj w przestrzeni miejskiej. Swoje znaleziska osoby uprawiające carspotting, tzw. carspotterzy, wrzucają na swoje media społecznościowe lub umieszczają na specjalnych stronach zrzeszających osoby o podobnych zainteresowaniach</p>
        <br>
        <h2>Skąd pomysł na carspotting?</h2>
        <p>Od małego lubiłem patrzeć na sportowe samochody. Lubiałem dźwięk pisku opon i zapach benzyny. W wieku 16 lat zaczęłem jeździć z kumplami na zloty samochodowe. Już wtedy nieświadomie robiąc zdjęcia i udostępniając je na moim prywatnym koncie na Instagramie zaczełem uprawiać to hobby. Szybko założyłem osobne konto, na którym chwaiłem się zdjęciami oraz filmami przeróżncyh samochodów, które niechący spotykałem na ulicy, bądź zlotach. Z biegem czasu poznałem takie miejsca w Trójmieście, gdzie stężenie luksusowych samochodów jest wzmożone, np. pod luksusowym hotelem Sheraton czy na ulicy Szafarnia, gdzie znajduje się wiele prestiżowych restauracji oraz hoteli. Myślę, że moment, w którym oficjalnie stałem się carspotterem, to kiedy zaczęłem wychodzić w wolnym czasie z domu (w tym samemu) tylko po to aby pojechać porobić zdjęcia jakiś nowych aut, których przedtem nie udało mi sięsfotografować. Wtedy to zaczęłem spędzać długie godziny poszukując coraz bardziej interesujących projektów samochodów, tylko po to, aby pochwalić się tym gronu moich "fanów" obserwujących mnie na instagramie.</p>
        <br><br>
        <h1 class="heading">Moje najlepsze znaleziska:</h1>
        <div id="accordion">
          <h3 class="samochody" id="CHIRON">Bugatti Chiron</h3>
            <div class="auto">
            <p>
                <img src="img/znal1.jpg" alt="chiron">
                Jedno z najdroższych seryjnie produkowanych hipersamochodów przez wiele lat nosił miano najszybszego samochodu z fabryki na świecie. Ważący 1996kg potwór to 2 drzwiowe coupe z 7 biegową skrzynią DCT. Napęd ma na 4 koła, a 8 litrowy silnik W16 o mocy 1479 koni mechanicznych pozwala mu osiągać zawrotną prędkość ponad 440km/h, a do setki Chiron rozpędzi się w czasie 2,5s. Zdecydowanie jedno z najpiękniejszych i najlepiej brzmiących aut jakie kiedykolwiek spotkałem.
            </p>
          </div>
          <h3 class="samochody" id="MUSTANG">Ford Mustang GT</h3>
          <div class="auto">
            <p>
            <img src="img/znal2.jpg" alt="n1sasha">
            Mustangi wśród fanów motoryzacji wywołują mieszane uczucia. Przez wielu modele te mieszane są z błotem. Wynika to ze stosunkowo małej mocy w porównaniu do brzmienia i tego, że mustangi to poprostu stosunkowo tanie samochody. Jednak brzmienie ich silników to miód dla moich uszu. Samochód na zdjęciu to samochód znanego na arenie carspottingowej youtubera- sashy. Pod maską znajdziemy wolnossące V8 o pojemności 5 litrów i mocy 450KM. 529Nm momentu obrotowego pozwala mu na rozpędzenie się do setki w skromne 4.9s. Niestety z powodu braku uturbienia maksymalna prędkość tego mustanga to niewiele ponad 250km/h, jednak sam samochów zdecydowanie nadrabia pięknym wyglądem oraz wspaniałymi doznaniami słuchowymi.
            </p>
          </div>
          <h3 class="samochody" id="SUPRA">Toyota Supra MK3</h3>
          <div class="auto">
            <p>
            <img src="img/znal3.jpg" alt="superka">
            Supry to samochody które uwielbia każdy miłośnik motoryzacji. Piękny wygląd oraz brzmienie powodują, że na drugi plan schodzi niestety zazwyczaj mała pojemność i moc silnika. Ten przedstawiony na zdjęciu to 3 litrowy uturbiony silnik benzynowy, który posiada 235KM oraz 344Nm maksymalnego momentu obrotowego. Posiada on 5 biegową manulaną skrzynię biegów, więć bardzo zaskakujące będzie to, że ten z pozoru niewinny samochodzik jest w stanie osiągnąć przędkość 245km/h, a 6.3s potrzebne do rozpędzenia się do 100km/h pozwolą nam na zostawienie w tyle nie jednego pozera w swoim Civicu,
            </p>
          </div>
        </div>
        <h1 class="heading">Porównanie parametrów samochodów w tabeli:</h1>
        <table class="tabelka" id="tabela">
        <tr>
            <th>Samochód</th>
            <th>Moc</th>
            <th class="hidden">Pojemność silnika</th>
            <th>Czas do 100</th>
            <th>Prędkość maksymalna</th>
        </tr>
        <tr>
            <td><a class="ajdi" href="#CHIRON">Bugatti Chiron</a></td>
            <td>1479KM</td>
            <td class="hidden">8.0l</td>
            <td>2.5s</td>
            <td>440km/h</td>
        </tr>
        <tr>
            <td><a class="ajdi" href="#MUSTANG">Ford Mustang GT</a></td>
            <td>450KM</td>
            <td class="hidden">5.0l</td>
            <td>4.9s</td>
            <td>250km/h</td>
        </tr>
        <tr>
            <td><a class="a.jdi" href="#SUPRA">Toyota Supra MK3</a></td>
            <td>235KM</td>
            <td class="hidden">3.0l</td>
            <td>6.3s</td>
            <td>245km/h</td>
        </tr>
        </table>
        <div class="javascriptworks">
        <h3 style="text-align: center">Dodaj parametry swojego auta!</h3>
        <form>
        <label><input maxlength="20" type="text" id="car" name="car">Nazwa samochodu</label><br>
        <label><input maxlength="20" type="text" id="power" name="power">Moc silnika (KM)</label><br>
        <label><input maxlength="6" type="text" id="V" name="poj">Pojemność silnika (l)</label><br>
        <label><input maxlength="6" type="text" id="V100" name="do100">ile do 100km/h?</label><br>
        <label><input maxlength="6" type="text" id="maxV" name="maxV">Prędkość maksymalna (km/h)</label><br>
        <input type="reset" id="mleko" value="Nowe auto">
        </form>
        <button id="addCar">Dodaj</button>
        </div>
    </div>
    <footer>
        <h3><i>Tomasz Sankowski 193363 2022-10-21</i></h3>
    </footer>
    <script src="script.js"></script>
    <script src="scriptable.js"></script>
</body>
</html>