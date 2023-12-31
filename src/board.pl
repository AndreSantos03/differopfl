:-use_module(library(lists)).


/**                   
 * i = 0   A           o---o---o---o---o
 *                    / \ / \ / \ / \ / \ 
 * i = 1   B         o---o---o---o---o---o
 *                  / \ / \ / \ / \ / \ / \ 
 * i = 2   C       o---o---o---o---o---o---o
 *                / \ / \ / \ / \ / \ / \ / \
 * i = 3   D     o---o---o---o---o---o---o---o
 *              / \ / \ / \ / \ / \ / \ / \ / \
 * i = 4   E   o---o---o---o---o---o---o---o---o
 *              \ / \ / \ / \ / \ / \ / \ / \ / \
 * i = 5   F     o---o---o---o---o---o---o---o   \
 *                \ / \ / \ / \ / \ / \ / \ / \   \
 * i = 6   G       o---o---o---o---o---o---o   \   \
 *                  \ / \ / \ / \ / \ / \ / \   \   \ 
 * i = 7   H         o---o---o---o---o---o   \   \   \
 *                    \ / \ / \ / \ / \ / \   \   \   \
 * i = 8   I          o---o---o---o---o    \   \   \   \
 *                      \   \   \   \   \   \   \   \   \
 *                       1   2   3   4   5   6   7   8   9
 * 
 *                      j=0 j=1 j=2 j=3 j=4 j=5 j=6 j=7 j=8
 * 
 * 
 
 * 
 *  
**/

%0 stands for empty space
%1 stands for white piece
%2 stands for black piece
%3 stands for unused space, mostly for spacing

% Define the initial state of the game board with pieces and empty spaces.
initialstate([ % Board
    [3,3,3,3,0,0,0,0,0],
    [3,3,3,0,2,2,2,2,0],
    [3,3,0,2,0,2,0,2,0],
    [3,0,2,2,2,2,2,2,0],
    [0,0,0,0,0,0,0,0,0],
    [0,1,1,1,1,1,1,0,3],
    [0,1,0,1,0,1,0,3,3],
    [0,1,1,1,1,0,3,3,3],
    [0,0,0,0,0,3,3,3,3]
]).

% Define a intermediate state of the game board with pieces and empty spaces.
intermediatestate([ % Board
    [3,3,3,3,0,0,0,0,0],
    [3,3,3,0,2,2,2,0,0],
    [3,3,2,1,0,1,0,0,0],
    [3,0,2,0,1,2,2,0,0],
    [0,0,1,2,2,0,0,2,0],
    [0,1,1,2,1,1,1,0,3],
    [0,0,1,1,2,1,0,3,3],
    [0,1,2,0,0,0,3,3,3],
    [0,0,0,0,0,3,3,3,3]
]).

finalstate([ % Board
    [3,3,3,3,0,0,1,0,0],
    [3,3,3,0,2,2,2,0,0],
    [3,3,2,0,0,1,0,0,0],
    [3,0,2,0,1,2,2,0,0],
    [0,0,1,2,2,0,0,2,0],
    [0,1,1,2,1,1,1,0,3],
    [0,0,1,1,2,1,0,3,3],
    [0,1,2,0,0,0,3,3,3],
    [0,0,0,0,0,3,3,3,3]
]).

% Define the value matrix for black pieces.
blackvalue([ % Board
[0,0,0,0,1,1,1,1,1],
[0,0,0,2,2,2,2,2,2],
[0,0,3,3,3,3,3,3,3],
[0,4,4,4,4,4,4,4,4],
[5,5,5,5,5,5,5,5,5],
[6,6,6,6,6,6,6,6,0],
[7,7,7,7,7,7,7,0,0],
[8,8,8,8,8,8,0,0,0],
[9,9,9,9,9,0,0,0,0]
]).

% Define the value matrix for white pieces.
whitevalue([ % Board
[0,0,0,0,9,9,9,9,9],
[0,0,0,8,8,8,8,8,8],
[0,0,7,7,7,7,7,7,7],
[0,6,6,6,6,6,6,6,6],
[5,5,5,5,5,5,5,5,5],
[4,4,4,4,4,4,4,4,0],
[3,3,3,3,3,3,3,0,0],
[2,2,2,2,2,2,0,0,0],
[1,1,1,1,1,0,0,0,0]
]).

% Custom predicate to read a line and parse coordinates in "I-J" format
read_coordinates(I-J) :-
    write('I = '),
    read(I), % Read the first number into I
    write('J = '),
    read(J),
    !. % Read the second number into J

% Get the coordinates from the user for the base piece they want to move.
get_base_coordinates(Color, I-J, Board) :-
    repeat,
    write('Enter the coordinates (I-J) from where you want to move your piece: '),
    read_coordinates(I-J),
    (is_valid_position(I-J) ->  % Check if the position is valid
        get_value(I-J, Color, Board)
    ;   write('Invalid position. Please try again.'), nl,
        fail  % Fail to repeat the loop
    ).

% Get the coordinates from the user for the target position to move their piece.
get_target_coordinates(I-J, Board) :-
    repeat,
    write('Enter the coordinates (I-J) to where you want to move your piece: '),
    read_coordinates(I-J),
    (is_valid_position(I-J), is_empty(I-J, Board) ->  % Check if the position is valid and empty
        true
    ;   write('Invalid target position. Please try again.'), nl,
        fail  % Fail to repeat the loop
    ).

% Allow the user to choose a move and verify its validity.
move_choice(Color, I-J, I1-J1, Board) :-
    repeat,
    get_base_coordinates(Color, I-J, Board),
    get_target_coordinates(I1-J1, Board),
    (valid_move(Color, I-J, I1-J1, Board) ->  % Check if it's a valid move
        true
    ;   write('Invalid move. Please try again.'), nl,
        fail  % Fail to repeat the loop
    ).


% Allow the user to choose a move and verify its validity.
move(Board, Color,FinalBoard) :-
    move_choice(Color, I-J, I1-J1,Board),
    (valid_move(Color, I-J, I1-J1,Board) ->
        move_board(Board, Color, I-J, I1-J1, FinalBoard)
    ;   write('The move you inputted was not valid!'), nl
    ).


% Update the game board after a piece is moved.
move_board(Board, Color, I-J, I1-J1, FinalBoard) :-
    update_board(Board, I, J, 0, TempBoard),
    update_board(TempBoard, I1, J1, Color, FinalBoard).

% Check if a given position on the board is empty.
is_empty(I-J, Board) :-
    get_value(I-J, Value, Board),
    Value is 0.

% Get the value at a specific position on the board.
get_value(I-J, Value, Board) :-
    nth0(I, Board, Row), % Get the row at position I
    nth0(J, Row, Value). % Get the value at position J

% Get a specific row from the board.
get_row(I, Row, Board) :-
    nth0(I, Board, Row).

% Update the game board with a new value at a specified position.
update_board(Board, I, J, NewValue, NewBoard) :-
    update_cell(Board, I, J, NewValue, UpdatedBoard),
    NewBoard = UpdatedBoard.

% Update a specific cell within a row.
update_cell([Row | Rest], 0, J, NewValue, [UpdatedRow | Rest]) :-
    update_row(Row, J, NewValue, UpdatedRow).

% Recursively update the cells in a row.
update_cell([Row | Rest], I, J, NewValue, [Row | UpdatedRest]) :-
    I > 0,
    I1 is I - 1,
    update_cell(Rest, I1, J, NewValue, UpdatedRest).

% Update a specific cell within a row.
update_row([_ | Rest], 0, NewValue, [NewValue | Rest]).

% Recursively update the cells in a row.
update_row([Value | Rest], J, NewValue, [Value | UpdatedRest]) :-
    J > 0,
    J1 is J - 1,
    update_row(Rest, J1, NewValue, UpdatedRest).

% Check if there are available moves for a specific player.
has_available_moves(Board, Color, AvailableMoves) :-
    get_available_moves(Board, Color, AvailableMoves),
    AvailableMoves \= [].

% Determine if a player has reached their goal (winning condition).
reach_goal(1, Board) :-
    % Check the first row (top edge)
    nth0(0, Board, FirstRow),
    member(1, FirstRow).

reach_goal(2, Board) :-
    nth0(8, Board, LastRow),
    member(2, LastRow).

% Determine if the game is over and print the winner.
game_over(Board, Color) :-
    (reach_goal(Color, Board);
    Color = 1,
    \+ has_available_moves(Board, 2, _);
    Color = 2,
    \+ has_available_moves(Board, 1, _)),
    write('Player '), write(Color), write(' is the winner.\n').

% Get the value of a white piece at a specific position.
getWhiteValue(I-J, Value) :-
    whitevalue(Board),
    nth0(I, Board, Row),
    nth0(J, Row, Value).

% Get the value of a black piece at a specific position.
getBlackValue(I-J, Value) :-
    blackvalue(Board),
    nth0(I, Board, Row),
    nth0(J, Row, Value).

% Custom predicate to switch the turn between players
switch_color(1, 2).
switch_color(2, 1).

