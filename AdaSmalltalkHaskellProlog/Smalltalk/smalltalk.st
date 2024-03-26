Object subclass: #Wielokat
	instanceVariableNames: 'wierzcholki nazwa '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!

!Wielokat methodsFor: 'initialize-release'!

initialize: liczbaWierzcholkow name: nowaNazwa
	"konstruktor obiektu - wielokata"

	nazwa:=nowaNazwa.
	wierzcholki:=Array new: liczbaWierzcholkow.
	wierzcholki at: 1 put: 0@0.! !

!Wielokat methodsFor: 'accessing'!

nazwa
	"podaje nazwe wielokata"

	^nazwa!

nazwa: nowa_nazwa
	"ustawia nowa nazwe wielokata"

	nazwa:=nowa_nazwa! !

!Wielokat methodsFor: 'actions'!

drukuj
    | p |
	"wypisuje liczbe, jej pole i jej wierzcholki"
    Transcript show: 'Dana jest figura: '; show: nazwa ; cr.
    wierzcholki doWithIndex: [:item :index |
        Transcript show: 'wierzcholek ';
        show: index printString;
        show: ':';
        tab;
        show: (item x roundTo: 0.01) printString;
        show: ' @ ';
        show: (item y roundTo: 0.01) printString;
        cr.
    ].
    p:=self pole.
    Transcript show: 'Pole = '; show: (p roundTo: 0.01) printString; cr; cr.! !
    
	
"|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"

Wielokat subclass: #Kwadrat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!


!Kwadrat methodsFor: 'arithmetic'!

+ figura
	"dodaj 2 figury w sensie pola"

	| p |

	p:=self pole + figura pole.
	^(Kwadrat new) initialize: p sqrt! !

!Kwadrat methodsFor: 'actions'!

pole
	"licz pole kwadratu"

	^(wierzcholki at: 2) x squared!

skaluj: k
	"przeskaluj kwadrat"
	| new bok |
    Transcript
    show: 'Przeskaluje boki figury: ';
    show: nazwa printString;
    show: ' o współczynnik k równy ';
    show: k printString; cr; cr.
    bok := (wierzcholki at: 2) x.
    new := k * bok.
	^(Kwadrat new) initialize: new! !
	
!Kwadrat methodsFor: 'initialize-release'!

initialize: bok
	"tworz kwadrat o podanym boku"

	super initialize: 4 name: 'Kwadrat'.
	wierzcholki at: 2 put: bok@0.
	wierzcholki at: 3 put: bok@bok.
	wierzcholki at: 4 put: 0@bok.! !
	
"|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"

Wielokat subclass: #Szesciokat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!


!Szesciokat methodsFor: 'arithmetic'!

+ figura
	"dodaj 2 figury w sensie pola"

	| p a |
	p:=self pole + figura pole.
	a:=(2 * p / 3 / (3 sqrt) ) sqrt.
	^(Szesciokat new) initialize: a! !

!Szesciokat methodsFor: 'actions'!

pole
    "licz pole sześciokąta"

    | a |
    a := (wierzcholki at: 2) y.  "Długość boku sześciokąta"
    ^3 * a squared * (3 sqrt) / 2.  "Pole sześciokąta foremnego"!

skaluj: k
	"przeskaluj szesciokat"
	| new bok |
    Transcript
    show: 'Przeskaluje boki figury: ';
    show: nazwa printString;
    show: ' o współczynnik k równy ';
    show: k printString; cr; cr.
    bok := (wierzcholki at: 2) y.
    new := k * bok.
	^(Szesciokat new) initialize: new! !

!Szesciokat methodsFor: 'initialize-release'!

initialize: bok
	"tworz sześciokąt o podanym boku"

	super initialize: 6 name: 'Szesciokat'.
	wierzcholki at: 2 put: 0@bok.
	wierzcholki at: 3 put: ( bok * (3 sqrt) / 2 )@( 3 * bok / 2 ).
	wierzcholki at: 4 put: ( bok * (3 sqrt) )@bok.
	wierzcholki at: 5 put: ( bok * (3 sqrt) )@0.
	wierzcholki at: 6 put: ( bok * (3 sqrt) / 2 )@( -1 * bok / 2 ).! !
	

"|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"

k := (Kwadrat new) initialize: 2.
s := (Szesciokat new) initialize: 2.

Transcript show: 'Dane sa wielokaty:'; cr.
k drukuj.
s drukuj.

Transcript cr; show: 'k+s'; cr.
k1 := k + s.
k1 drukuj.

Transcript cr; show: 's+k'; cr.
s1 := s + k.
s1 drukuj.

k2 := k skaluj: 2.
k2 drukuj.

s2 := s skaluj: 0.5.
s2 drukuj.