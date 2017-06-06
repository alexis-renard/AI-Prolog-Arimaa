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
%The little one
% board([[0,0,rabbit,silver],[0,1,horse,gold],[0,2,horse,silver]]).


%The original one
% board([[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

%The custom one
board([[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,horse,gold],[7,1,rabbit,silver],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% IS_STRONGER  %%%%%%
stronger(cat,rabbit).
stronger(dog,cat).
stronger(horse,dog).
stronger(camel,horse).
stronger(elephant,camel).


is_stronger(X,X).
is_stronger(X,Y):-  stronger(X,Y).
is_stronger(X,Z):-  stronger(X,Y),
                    is_stronger(Y,Z).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% IS_HOLE  %%%%%%

hole([2,5]).
hole([2,2]).
hole([5,2]).
hole([5,5]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% IS_BORDER  %%%%%%

border_north([0,_]).
border_east([_,7]).
border_south([7,_]).
border_west([_,0]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


%%%%%% RECUPERER LES INFOS D'UNE LISTE DE COORDONNEES %%%%%%
get_all_infos([],_,[]).
get_all_infos([C|Q],B,[R|Res]):-    get_infos(C,B,R),
                                    get_all_infos(Q,B,Res).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% ENVIRONNEMENT SATURE %%%%%%
% N'est pas entourée d'une composition d'alliés et de bordures (une case adjacente est donc soit libre soit ennemie)
% Renverra vrai si la pièce de coordonnées C n'est entourée QUE d'alliés, ou de bordures : vrai si aucun mouvement n'est possible
%Cadj pour Cadjacent ([[],[],[],[]])

env_vide([[],[],[],[]]).
env_sature(C,B):-   get_adjacent_case(C,B,Cadj),    %%recupere les coordonnées des cases adjacente
                    env_vide(Cadj).


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


%%%%%% MOUVEMENT D'UNE PIECE - DIRECTION %%%%%%%%%%%%%%

possible_move_per_piece_north([X,Y,A,T],B,[]):- border_north([X,Y]).

possible_move_per_piece_north([X,Y,A,T],B,[]):- get_north([X,Y],Cn),
                                                hole(Cn).

possible_move_per_piece_north([X,Y,A,T],B,[]):- get_infos_north([X,Y],B,Cn),
                                                member(silver,Cn).

% On est dans le cas où on a une case vide, ou un ennemi
possible_move_per_piece_north([X,Y,A,T],B,[]):- get_infos_north([X,Y],B,[_,_,An,Tn]),
                                                gold = Tn,
                                                stronger(An,A).

% possible_move_per_piece_north([X,Y,A,T],B,[]):- get_infos_north([X,Y],B,[Xn,Yn,An,Tn]),
%                                                 member(gold,Cn),
%                                                 stronger(Tn,T).

% possible_move_per_piece_east
% possible_move_per_piece_south
% possible_move_per_piece_west

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% STUCKED - DIRECTION %%%%%%%%%%%%%%
stucked_by_north([X,Y,A,T],B):- get_infos_north([X,Y],B,[_,_,An,Tn]),
                                gold = Tn,
                                \+is_stronger(A,An).
% stucked_by_east
% stucked_by_south
% stucked_by_west
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% STUCKED - DIRECTION %%%%%%%%%%%%%%
at_least_one_ally([X,Y],B):-    get_adjacent_case([X,Y],B,Res),
                                member([_,_,_,silver],Res).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%% STUCKED  %%%%%%%%%%%%%%
% PIECE BLOQUEE PAR ENNEMI PLUS FORT
stucked([X,Y,A,T],B):-  \+at_least_one_ally([X,Y],B),
                        stucked_by_north([X,Y,A,T],B).
% stucked([X,Y,A,T],B):-  \+at_least_one_ally([X,Y],B),
%                         stucked_by_east([X,Y],B).
% stucked([X,Y,A,T],B):-  \+at_least_one_ally([X,Y],B),
%                         stucked_by_south([X,Y],B).
% stucked([X,Y,A,T],B):-  \+at_least_one_ally([X,Y],B),
%                         stucked_by_west([X,Y],B).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% MOUVEMENT D'UNE PIECE %%%%%%%%%%%%%%
possible_move_per_piece([X,Y,A,T],B,[]):-   stucked([X,Y,A,T],B).

possible_move_per_piece([X,Y,A,T],B,[Cn,Ce,Cs,Cw]):-    possible_move_per_piece_north([X,Y,A,T],B,Cn),
                                                        possible_move_per_piece_east([X,Y,A,T],B,Ce),
                                                        possible_move_per_piece_south([X,Y,A,T],B,Cs),
                                                        possible_move_per_piece_west([X,Y,A,T],B,Cw).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%% MOVE DE TEST %%%%%%
% get_moves([[[1,0],[2,0]],[[1,0],[2,2]],[[0,1],[0,0]],[[0,0],[0,1]]], Gamestate, Board).
% get_moves([[[1,0],[5,1]],[[0,0],[1,0]],[[0,1],[0,0]],[[0,0],[0,1]]], Gamestate, Board).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

usefulTest([X,Y,A,T], Res):-    board(B),
                                stucked([X,Y,A,T],B).
