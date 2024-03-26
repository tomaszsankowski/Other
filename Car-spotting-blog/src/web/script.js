const switchButton = document.querySelector("header button");
let theme = localStorage.getItem("theme");

switchButton.addEventListener("click", changeMode);

function changeMode()
{
    if (theme === "blue") {
        document.querySelector("body").classList.remove("blue");
        document.querySelector("body").classList.add("red");
        theme = "red";
    } else {
        document.querySelector("body").classList.remove("red");
        document.querySelector("body").classList.add("blue");
        theme = "blue";
    }

    localStorage.setItem("theme", theme);
}


if (theme === "blue") {
    document.querySelector("body").classList.add("blue");
}

if (theme === "red") {
    document.querySelector("body").classList.add("red");
}
/*



const nameButton = document.getElementById("go");

nameButton.addEventListener("click", createName);

function createName()
{
    let imie = document.getElementById("tomasz");
    sessionStorage.setItem("name", imie.value);
}
const cleanButton = document.getElementById("cleaned");
cleanButton.addEventListener("click", cleanName);

function cleanName()
{
    sessionStorage.clear();
    document.getElementById("hello").innerHTML = 'Cześć, przyjacielu!';
}

if(sessionStorage.getItem("name")===null)
    {
        document.getElementById("hello").innerHTML = 'Cześć, przyjacielu!';
    }
else
    {
        document.getElementById("hello").innerHTML = 'Cześć, ' + sessionStorage.getItem("name") + '!';
    }

*/