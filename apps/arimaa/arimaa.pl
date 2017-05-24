:- module(bot,
      [  get_moves/3
      ]).

% A few comments but all is explained in README of github

% get_moves signature
% get_moves(Moves, gamestate, board).

% Exemple of variable
% gamestate: [side, [captured pieces] ] (e.g. [silver, [ [0,1,rabbit,silver],[0,2,horse,silver] ])
% board: [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]

% Call exemple:
% get_moves(Moves, [silver, []], [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

%%%%%% SNIPPETS DU PROF %%%%%%
% get_moves(Move, Gamestate, Board) :- coup_possible([Move|Y], Board).
% coup_possible(X, Board) :- ..., X = Res.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% INITIALISATION %%%%%%
board([[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[2,7,rabbit,gold],[6,0,cat,gold],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


stronger(cat,rabbit).
stronger(dog,cat).
stronger(horse,dog).
stronger(camel,horse).
stronger(elephant,camel).

stronger(X,Z):- stronger(X,Y),
                stronger(Y,Z).

%%%%%% RECUPERER LES ENNEMIS %%%%%%
% type : get_enemies(Board,Resultat)

get_enemies([],[]).
get_enemies([[X,Y,A,silver]|B],[[X,Y,A,silver]|En]):-
                        get_enemies(B,En).
get_enemies([_|B],En):-
                        get_enemies(B,En).

testEnemies(Res):-
    board(B),
    get_enemies(B,Res).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% RECUPERER LES ALLIES %%%%%%
% type : get_allies(Board,Resultat)

get_allies([],[]).
get_allies([[X,Y,A,gold]|B],[[X,Y,A,gold]|En]):-
                        get_allies(B,En).
get_allies([_|B],En):-
                        get_allies(B,En).

testAllies(Res):-
    board(B),
    get_allies(B,Res).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% RECUPERER LES VOISINS %%%%%%
% type : get_neighbours(Board,Resultat)
% beware : le (0,0) est en haut à gauche


%%%%% 1) On récupère les voisins directs d'une certaine case
get_north([X,Y],[X,Yn]):-   Y>0,
                            Yn is Y-1.
get_north([X,Y],[]).


get_south([X,Y],[X,Ys]):-   Y<7,
                            Ys is Y+1.
get_south([X,Y],[]).


get_east([X,Y],[Xe,Y]):-   X<7,
                            Xe is X+1.
get_east([X,Y],[]).


get_west([X,Y],[Xw,Y]):-   X>0,
                            Xw is X-1.
get_west([X,Y],[]).


%%%%% 2) On utilise les fonctions précédentes pour récupérer tous les voisins d'une case

get_neighbours(C,[Cn,Ce,Cs,Cw]) :-  get_north(C,Cn),
                                    get_east(C,Ce),
                                    get_south(C,Cs),
                                    get_west(C,Cw).

%%%%% 3) On épure cette liste grâce à notre fonction reduce (qui enlevera les listes vides)

reduce([],[]).
reduce([[]|Q],R) :- reduce(Q,R).
reduce([T|Q],[T|R]) :- reduce(Q,R).


%%%%% TestNeighbours
testNeighbours([X,Y],Res) :-    get_neighbours([X,Y],L),
                                reduce(L,Res).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% RECUPERER INFOS A PARTIR DES COORDONNEES %%%%%%

get_infos([[Xi,_,_,_]|B],[X,Y],Res):- get_infos(B,[X,Y],Res).
get_infos([[_,Yi,_,_]|B],[X,Y],Res):- get_infos(B,[X,Y],Res).

get_infos([[X,Y,A,T]|B],[X,Y],[X,Y,A,T]).

testInfos(C,Res):-
    board(B),
    get_infos(B,C,Res).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% MOVE DE TEST %%%%%%
get_moves([[[1,0],[2,0]],[[1,0],[2,2]],[[0,1],[0,0]],[[0,0],[0,1]]], Gamestate, Board).
% get_moves([[[1,0],[5,1]],[[0,0],[1,0]],[[0,1],[0,0]],[[0,0],[0,1]]], Gamestate, Board).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
