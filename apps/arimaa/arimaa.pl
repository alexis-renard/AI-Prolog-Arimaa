:- module(bot,
      [  get_moves/3
      ]).

%%pour afficher toute la réponse et non uniquement le début
%%set_prolog_flag(answer_write_options,[max_depth(0)]).

% % declare the dynamic fact
% :- dynamic moves/1.
%
% % predicat to add a new move to the list of moves
% add_move(NewMove) :- moves(M), retract(moves(M)), asserta(moves([NewMove|M])).
%
% % init moves with an empty list, add a new move to this list, return the new moves with the added move
% test(M) :- asserta(moves([])), add_move([[1,0],[2,0]]), moves(M).


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
%The little one
% board([[0,0,rabbit,silver],[1,1,horse,silver]]).
board([[0,0,rabbit,silver],[1,1,horse,silver],[0,2,horse,silver],[2,3,horse,silver]]).


%The original one
 %board([[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

%The custom one
%board([[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,horse,gold],[7,1,rabbit,silver],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

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

%%% NORTH
get_north([X,Y],[Xn,Y]):-   X>0,
                            Xn is X-1.
get_north([_,_],[]).

get_infos_north([X,Y],B,Res):-  get_north([X,Y],Cn),
                                get_infos(Cn,B,Res).
get_infos_north([],_,[]).

%%% EAST
get_east([X,Y],[X,Ye]):-   Y<7,
                            Ye is Y+1.
get_east([_,_],[]).
get_infos_east([X,Y],B,Res):-   get_east([X,Y],Ce),
                                get_infos(Ce,B,Res).
get_infos_east([],_,[]).


%%% SOUTH
get_south([X,Y],[Xs,Y]):-   X<7,
                            Xs is X+1.
get_south([_,_],[]).
get_infos_south([X,Y],B,Res):-  get_south([X,Y],Cs),
                                get_infos(Cs,B,Res).
get_infos_south([],_,[]).

%%% WEST
get_west([X,Y],[X,Yw]):-   Y>0,
                            Yw is Y-1.
get_west([_,_],[]).
get_infos_west([X,Y],B,Res):-  get_west([X,Y],Cw),
                                get_infos(Cw,B,Res).
get_infos_west([],_,[]).


%%%%% 2) On utilise les fonctions précédentes pour récupérer tous les voisins d'une case   %%%%%%%%%%%

get_adjacent_case(C,B,[Cn,Ce,Cs,Cw]) :- get_infos_north(C,B,Cn),
                                        get_infos_east(C,B,Ce),
                                        get_infos_south(C,B,Cs),
                                        get_infos_west(C,B,Cw).



%%%%% 3) On épure cette liste grâce à notre fonction reduce (qui enlevera les listes vides)

reduce([],[]).
reduce([[]|Q],R) :- reduce(Q,R).
reduce([T|Q],[T|R]) :- reduce(Q,R).


%%%%%%%%%%%%%%%%% get_adjacent_case_reduced  %%%%%%%%%%%%%%%%%%   Renvoie la liste épurée des voisins.
get_adjacent_case_reduced(C,B,Res) :-   get_adjacent_case(C,B,L),
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


get_infos_onboard([[X,Y,A,T]|_],[X,Y,_,_],[X,Y,A,T]):-!.
get_infos_onboard([_|B],[X,Y,_,_],Res):-get_infos_onboard(B,[X,Y,_,_], Res).


get_infos([],_,[]).
get_infos([X,Y],B,Res):-member([X,Y,_,_],B),
                        get_infos_onboard(B,[X,Y,_,_],Res).
get_infos([_,_],_,[]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% CASE VIDE %%%%%%%%%%%%%%

vide([X,Y,_,_]):-   board(B),
                    \+member([X,Y,_,_],B).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% MOUVEMENT D'UNE PIECE - DIRECTION %%%%%%%%%%%%%%


%% NORTH
possible_move_per_piece_north([X,Y,_,_],_,[]):- border_north([X,Y]).   %%Cas bordures
possible_move_per_piece_north([X,Y,_,_],B,[]):- get_north([X,Y],Cn),       %%Cas trou sans alliée (renvoie True si la case au nord est un trou et qu'il n'y a pas d'alliée autour)
                                                hole(Cn),
                                                \+ at_least_one_ally(Cn,B).
possible_move_per_piece_north([X,Y,_,_],B,[]):- get_infos_north([X,Y],B,[_,_,_,Tn]),  %%Cas piece alliée au nord
                                                silver = Tn.
possible_move_per_piece_north([X,Y,A,_],B,[]):- get_infos_north([X,Y],B,[_,_,An,Tn]), % Cas où on a une case vide, ou un ennemi
                                                gold = Tn,
                                                \+is_stronger(A,An).

possible_move_per_piece_north([X,Y,_,_],_,Cn):- get_north([X,Y],Cn).

% EAST
possible_move_per_piece_east([X,Y,_,_],_,[]):- border_east([X,Y]).   %%Cas bordures
possible_move_per_piece_east([X,Y,_,_],B,[]):- get_east([X,Y],Ce),       %%Cas trou sans alliée (renvoie True si la case au nord est un trou et qu'il n'y a pas d'alliée autour)
                                                hole(Ce),
                                                \+ at_least_one_ally(Ce,B).
possible_move_per_piece_east([X,Y,_,_],B,[]):- get_infos_east([X,Y],B,[_,_,_,Te]),  %%Cas piece alliée au nord
                                                silver = Te.
possible_move_per_piece_east([X,Y,A,_],B,[]):- get_infos_east([X,Y],B,[_,_,Ae,Te]),% Cas où on a une case vide, ou un ennemi
                                                gold = Te,
                                                \+is_stronger(A,Ae).

possible_move_per_piece_east([X,Y,_,_],_,Ce):- get_east([X,Y],Ce).

% SOUTH
possible_move_per_piece_south([X,Y,_,_],_,[]):- border_south([X,Y]).   %%Cas bordures
possible_move_per_piece_south([X,Y,_,_],B,[]):- get_south([X,Y],Cs),       %%Cas trou sans alliée (renvoie True si la case au nord est un trou et qu'il n'y a pas d'alliée autour)
                                                hole(Cs),
                                                \+ at_least_one_ally(Cs,B).
possible_move_per_piece_south([X,Y,_,_],B,[]):- get_infos_south([X,Y],B,[_,_,_,Ts]),  %%Cas piece alliée au nord
                                                silver = Ts.
possible_move_per_piece_south([X,Y,A,_],B,[]):- get_infos_south([X,Y],B,[_,_,As,Ts]),% Cas où on a une case vide, ou un ennemi
                                                gold = Ts,
                                                \+is_stronger(A,As).

possible_move_per_piece_south([X,Y,_,_],_,Cs):- get_south([X,Y],Cs).

% WEST
possible_move_per_piece_west([X,Y,_,_],_,[]):- border_west([X,Y]).   %%Cas bordures
possible_move_per_piece_west([X,Y,_,_],B,[]):- get_west([X,Y],Cw),       %%Cas trou sans alliée (renvoie True si la case au nord est un trou et qu'il n'y a pas d'alliée autour)
                                                hole(Cw),
                                                \+ at_least_one_ally(Cw,B).
possible_move_per_piece_west([X,Y,_,_],B,[]):- get_infos_west([X,Y],B,[_,_,_,Tw]),  %%Cas piece alliée au nord
                                                silver = Tw.
possible_move_per_piece_west([X,Y,A,_],B,[]):- get_infos_west([X,Y],B,[_,_,Aw,Tw]),% Cas où on a une case vide, ou un ennemi
                                                gold = Tw,
                                                \+is_stronger(A,Aw).

possible_move_per_piece_west([X,Y,_,_],_,Cw):- get_west([X,Y],Cw).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% STUCKED - DIRECTION %%%%%%%%%%%%%%
stucked_by_north([X,Y,A,_],B):- get_infos_north([X,Y],B,[_,_,An,Tn]),
                                gold = Tn,
                                \+is_stronger(A,An).
stucked_by_east([X,Y,A,_],B):- get_infos_east([X,Y],B,[_,_,Ae,Te]),
                                gold = Te,
                                \+is_stronger(A,Ae).
stucked_by_south([X,Y,A,_],B):- get_infos_south([X,Y],B,[_,_,As,Ts]),
                                gold = Ts,
                                \+is_stronger(A,As).
stucked_by_west([X,Y,A,_],B):- get_infos_west([X,Y],B,[_,_,Aw,Tw]),
                                gold = Tw,
                                \+is_stronger(A,Aw).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% STUCKED - DIRECTION %%%%%%%%%%%%%%
at_least_one_ally([X,Y],B):-    get_adjacent_case([X,Y],B,Res),
                                member([_,_,_,silver],Res).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%% STUCKED  %%%%%%%%%%%%%%
% PIECE BLOQUEE PAR ENNEMI PLUS FORT
stucked([X,Y,A,T],B):-  \+at_least_one_ally([X,Y],B),
                        stucked_by_north([X,Y,A,T],B).
stucked([X,Y,A,T],B):-  \+at_least_one_ally([X,Y],B),
                        stucked_by_east([X,Y,A,T],B).

stucked([X,Y,A,T],B):-  \+at_least_one_ally([X,Y],B),
                        stucked_by_south([X,Y,A,T],B).
stucked([X,Y,A,T],B):-  \+at_least_one_ally([X,Y],B),
                       stucked_by_west([X,Y,A,T],B).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% MOUVEMENT D'UNE PIECE %%%%%%%%%%%%%%
possible_move_per_piece([X,Y,A,T],B,[]):-   stucked([X,Y,A,T],B).        %Done

possible_move_per_piece([X,Y,A,T],B,[Cn,Ce,Cs,Cw]):-
    possible_move_per_piece_north([X,Y,A,T],B,Cn),
    possible_move_per_piece_east([X,Y,A,T],B,Ce),
    possible_move_per_piece_south([X,Y,A,T],B,Cs),
    possible_move_per_piece_west([X,Y,A,T],B,Cw).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% TOUS LES MOUVEMENTS POSSIBLES PAR L'IA %%%%%%%%%%%%%%

get_all_moves_helper([],_,[]).
get_all_moves_helper([T|Q],B,[T2|Res]):-
    possible_move_per_piece(T,B,T2),
    get_all_moves_helper(Q,B,Res).

get_all_moves(B,Res):-
    get_allies(B,ListAllies),
    get_all_moves_helper(ListAllies,B,Res).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

usefulTest(Res):-   board(B),
                    get_all_moves(B,Res).

%%%%%% MOVE DE TEST %%%%%%
move_example([[[1,0],[5,1]],[[0,0],[1,0]],[[0,1],[0,0]],[[0,0],[0,1]]]).

get_moves(Move, Gamestate, Board):-
    board(Board),
    get_all_moves(Board,PossibleMoves),
    % print(PossibleMoves).
    move_example(Move).
    % choose_move(Board,PossibleMoves,Move).

% get_moves([[[1,0],[5,1]],[[0,0],[1,0]],[[0,1],[0,0]],[[0,0],[0,1]]], Gamestate, Board).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
