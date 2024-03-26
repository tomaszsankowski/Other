% this prolog program solves a simple game
% in which we have a 1 dimensional board of length n
% where pawns of both you and you enemy move and kill each other in a
% way specified by rules executed with predicates generateP1 and generateP2


mySame(X,X).

% ZASADA 7

generateP1(A,N) :- generateP11(A, M), generateP12(M, N).

generateP11([], []).

generateP11([H|T], [H|P]) :- generateP11(T, P), \+ mySame(T, P).

generateP11([X,Y|T], [XP,YP|T]) :- XP is X + 1, YP is Y - 1, X =< 1, Y > 0, Y =<2.

generateP12([], []).

generateP12([H|T], [H|P]) :- generateP12(T, P), \+ mySame(T, P).

generateP12([X,Y,Z|T], [XP,Y,ZP|T]) :- XP is X - 1, ZP is Z + 1, X > 0, X =< 2, Y = 0, Z =< 1.

generateP2(A, N) :- generateP22122(A, N); generateP23(A, N).

generateP22122(A,N) :- generateP21(A, M), generateP22(M, N).

generateP21([], []).

generateP21([H|T], [H|P]) :- generateP21(T, P), \+ mySame(T, P).

generateP21([X,Y|T], [XP,YP|T]) :- XP is X + 1, YP is Y - 1, X = 0, Y = 1.

generateP22([], []).

generateP22([H|T], [H|P]) :- generateP22(T, P), \+ mySame(T, P).

generateP22([X,Y,Z|T], [XP,Y,ZP|T]) :- XP is X - 1, ZP is Z + 1, X > 0, X =< 1, Z = 0.

generateP23([],[]).

generateP23([H|T],[H|P]) :- generateP23(T,P), \+ mySame(T,P).

generateP23([X,Y|T], [XP,YP|T]) :- XP is X - 1, YP is Y + 1, X = 1, Y = 0.

writeWinningMoves([]).

writeWinningMoves([H|T]) :- write(H), writeWinningMoves(T).

% GAME

moveP1(A,WinningMoves) :- generateP1(A, M), append(WinningMoves, [M], NewWinningMoves), \+ moveP2(M,NewWinningMoves), writeWinningMoves(NewWinningMoves), nl. % is player 1 winning for this state A

moveP2(A,WinningMoves) :- generateP2(A, M), append(WinningMoves, [M], NewWinningMoves), \+ moveP1(M,NewWinningMoves), writeWinningMoves(NewWinningMoves), nl. % is player 2 winning for this state A

play(A) :- moveP1(A,[A]).