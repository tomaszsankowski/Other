var nazwa = document.getElementById("car");
var moc = document.getElementById("power");
var poj = document.getElementById("V");
var dostu = document.getElementById("V100");
var maxV = document.getElementById("maxV");
const submitCar = document.getElementById("addCar");

submitCar.addEventListener("click", addingCars);

function addingCars()
{
    let newMonster = document.createElement('tr');document.getElementById("tabela").appendChild(newMonster);
    
    let newNazwa = document.createElement('td');
    newNazwa.textContent = nazwa.value;
    newMonster.appendChild(newNazwa);
    
    let newMoc = document.createElement('td');
    newMoc.textContent = moc.value + "KM";
    newMonster.appendChild(newMoc);
    
    let newPoj = document.createElement('td');
    newPoj.textContent = poj.value + "l";
    newMonster.appendChild(newPoj);
    
    let newDostu = document.createElement('td');
    newDostu.textContent = dostu.value + "s";
    newMonster.appendChild(newDostu);
    
    let newMaxv = document.createElement('td');
    newMaxv.className = "hidden";
    newMaxv.textContent = maxV.value + "km/h";
    newMonster.appendChild(newMaxv);
}