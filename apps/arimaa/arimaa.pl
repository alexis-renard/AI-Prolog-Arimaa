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
 get_moves(Moves, [silver, []], [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

%%%%%% SNIPPETS DU PROF %%%%%%
% get_moves(Move, Gamestate, Board) :- coup_possible([Move|Y], Board).
% coup_possible(X, Board) :- ..., X = Res.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% INITIALISATION %%%%%%
board([[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stronger(cat,rabbit).
stronger(dog,cat).
stronger(horse,dog).
stronger(camel,horse).
stronger(elephant,camel).


is_stronger(X,X).
is_stronger(X,Y) :-stronger(X,Y).
is_stronger(X,Z):- stronger(X,Y),      
                    stronger(Y,Z).







%%%%%% RECUPERER LES ENNEMIS %%%%%%
% type : get_enemies(Board,Resultat)

get_enemies([],[]).
get_enemies([[X,Y,A,gold]|B],[[X,Y,A,gold]|En]):-
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
get_allies([[X,Y,A,silver]|B],[[X,Y,A,silver]|En]):-
                        get_allies(B,En).
get_allies([_|B],En):-
                        get_allies(B,En).

testAllies(Res):-
    board(B),
    get_allies(B,Res).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% RECUPERER LES VOISINS %%%%%%
% type : get_adjacent_case(Board,Resultat)
% beware : le (0,0) est en haut à gauche
%%%%% 1) On récupère les voisins directs d'une certaine case et ce qu'il y a dessus %%%%%%%%

get_north([X,Y],[Xn,Y]):-   X>0,
                            Xn is X-1.
get_north([X,Y],[]).
get_infos_north([X,Y],B,Res):-  get_north([X,Y],Cn),
                                get_infos(Cn,B,Res).
get_infos_north([],B,[]).


get_east([X,Y],[X,Ye]):-   Y<7,
                            Ye is Y+1.
get_east([X,Y],[]).
get_infos_east([X,Y],B,Res):-   get_east([X,Y],Ce),
                                get_infos(Ce,B,Res).
get_infos_east([],B,[]).



get_south([X,Y],[Xs,Y]):-   X<7,
                            Xs is X+1.
get_south([X,Y],[]).
get_infos_south([X,Y],B,Res):-  get_south([X,Y],Cs),
                                get_infos(Cs,B,Res).
get_infos_south([],B,[]).


get_west([X,Y],[X,Yw]):-   Y>0,
                            Yw is Y-1.
get_west([X,Y],[]).
get_infos_west([X,Y],B,Res):-  get_west([X,Y],Cw),
                                get_infos(Cw,B,Res).
get_infos_west([],B,[]).


%%%%% 2) On utilise les fonctions précédentes pour récupérer tous les voisins d'une case   %%%%%%%%%%%

get_adjacent_case(C,B,[Cn,Ce,Cs,Cw]) :- get_infos_north(C,B,Cn),
                                        get_infos_east(C,B,Ce),
                                        get_infos_south(C,B,Cs),
                                        get_infos_west(C,B,Cw).
                                        
                                        

%%%%% 3) On épure cette liste grâce à notre fonction reduce (qui enlevera les listes vides)

reduce([],[]).
reduce([[]|Q],R) :- reduce(Q,R).
reduce([T|Q],[T|R]) :- reduce(Q,R).


%%%%%%%%%%%%%%%%% TestAdjacentCases  %%%%%%%%%%%%%%%%%%   Renvoie la liste épurée des voisins.
testAdjacentCases(C,B,Res) :- get_adjacent_case(C,B,L),
                              reduce(L,Res).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% ENVIRONNEMENT SATURE %%%%%%

%%%%%%env_sature(C,B):-   testAdjacentCases(C,B,Cadj),    %%recupere les coordonnées des cases adjacente







%Cadj pour Cadjacent

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%% RECUPERER INFOS A PARTIR DES COORDONNEES %%%%%%%

% get_infos([],[X,Y,_,_],[]).


get_infos_onboard([[X,Y,A,T]|B],[X,Y,_,_],[X,Y,A,T]):-!.
get_infos_onboard([_|B],[X,Y,_,_],Res):-get_infos_onboard(B,[X,Y,_,_], Res).


get_infos([],B,[]).
get_infos([X,Y],B,Res):-member([X,Y,_,_],B),
                        get_infos_onboard(B,[X,Y,_,_],Res).
get_infos([X,Y],B,[]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%% CASE VIDE %%%%%%%%%%%%%%

vide([X,Y,_,_]):-   board(B),
                    \+member([X,Y,_,_],B).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% MOVE DE TEST %%%%%%
% get_moves([[[1,0],[2,0]],[[1,0],[2,2]],[[0,1],[0,0]],[[0,0],[0,1]]], Gamestate, Board).
% get_moves([[[1,0],[5,1]],[[0,0],[1,0]],[[0,1],[0,0]],[[0,0],[0,1]]], Gamestate, Board).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

usefulTest(C, Res):- board(B),
                    testAdjacentCases(C,B,Res).
                    
