:- module(bot,
      [  get_moves/3
      ]).

% declare the dynamic fact
:- dynamic moves/1.
%predicat to add a new move to the list of moves
add_move(NewMove) :-
    moves(M),
    retract(moves(M)),
    asserta(moves([NewMove|M])).


%%%%%% MOVE DE TEST %%%%%%
choose_move(Board,[T|Q],Moves,1):-
    add_move(T).
choose_move(Board,[T|PossibleMoves],Moves,N):-
    add_move(T),
    N2 is N-1,
    choose_move(Board,PossibleMoves,N2).

get_moves(Move, Gamestate, Board):-
    get_all_moves(Board,PossibleMoves),
    choose_move(Board,PossibleMoves,4),
    moves(Move).

% get_moves([[[1,0],[5,1]],[[0,0],[1,0]],[[0,1],[0,0]],[[0,0],[0,1]]], Gamestate, Board).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
