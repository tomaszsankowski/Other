% first program (sortuj predicate)is implementation
% of counting sort in Prolog language

% the second program (czy_graficzny predicate) checks
% if the given list is graphical

% the last program (czy_spojny predicate)
% checks if given graph is connected


    %sprawdz([1,0,1])
    %sprawdz([1,1,1])
    %sprawdz([1,1,1,1])
    %sprawdz([1,2,2,1,2])
    %sprawdz([3,3,3,0,3])

    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zadanie 0 | Funkcja wejściowa %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sprawdz(Lista) :- 
    sortuj(Lista, L),
    write('Posortowane: '), write(L), nl,
    czy_graficzny(L, Odp2),
    write('Czy graficzny: '), write(Odp2), nl,
    czy_spojny(L, Odp3),
    write('Czy spojny: '), write(Odp3), nl, nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zadanie 1 | Counting sort %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]) :- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

zlicz([], _, Counts, Counts).
zlicz([X|Xs], Max, CurrentCounts, Result) :-
    nth0(X, CurrentCounts, Count),
    NewCount is Count + 1,
    replace(CurrentCounts, X, NewCount, NewCounts),
    zlicz(Xs, Max, NewCounts, Result).


lista_zer(_, 0, []).
lista_zer(X, N, [X|L]) :- N > 0, N1 is N - 1, lista_zer(X, N1, L).

utworz_wynik([], _, Acc, Acc).
utworz_wynik([Count|RestCounts], CurrentNumber, Acc, SortedList) :-
    Count > 0,
    NewCount is Count - 1,
    utworz_wynik([NewCount|RestCounts], CurrentNumber, [CurrentNumber|Acc], SortedList).
utworz_wynik([0|RestCounts], CurrentNumber, Acc, SortedList) :-
    NextNumber is CurrentNumber + 1,
    utworz_wynik(RestCounts, NextNumber, Acc, SortedList).


sortuj([], _).

sortuj(Lista, SortedList) :-
    max_list(Lista, Max),
    Len is Max + 1,
    lista_zer(0, Len, Zeros),
    zlicz(Lista, Max, Zeros, SortedCounts),
    utworz_wynik(SortedCounts, 0, [], SortedList).
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zadanie 2 | Czy lista tworzy ciąg graficzny? %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

czy_graficzny(Lista, Odp) :-
    (jest_graficzny(Lista) -> Odp = true ; Odp = false).


jest_graficzny([]).
jest_graficzny([0|T]) :- jest_graficzny(T).
jest_graficzny([H|T]) :-
    H > 0,
    length(T, Len),
    H =< Len,
    odejmij(T, H, 1, NewT),
    sortuj(NewT, DescendingNewT),
    jest_graficzny(DescendingNewT).


odejmij([], _, _, []).
odejmij([H|T], N, X, [NewH|NewT]) :-
    N > 0,
    NewN is N - 1,
    NewH is H - X,
    NewH >= 0,
    odejmij(T, NewN, X, NewT).
odejmij([H|T], N, _, [H|NewT]) :-
    N =< 0,
    odejmij(T, N, 0, NewT).
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zadanie 3 | Czy graf jest spójny?                                             %
% A degree sequence di,i=1..n is potentially connected if and only if d(i) >= 1 %
% and                                                                           %
% if sum(d(i)) i=1..n >= 2(n-1)                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

czy_spojny(L) :-
    jest_zero(L),
    suma(L,S),
    len(L,D),
    S >= 2 * (D-1).
czy_spojny(L, Odp) :-
    czy_spojny(L), Odp = true ; Odp = false.
    

jest_zero([H]) :- H =\= 0.
jest_zero([H|T]) :-
    H =\= 0,
    jest_zero(T).
    
suma([],0).
suma([H|T], S) :- 
    suma(T, P), 
    S is H + P.
    
len([], 0).
len([H|T], N) :- 
    len(T, NP), 
    N is NP + 1.

