/*
**	Facilitates 2D map matrix representations including:
**		- Tile types
**		- Tile states
**		- getters
**		- setters
**
**		* Uses 1-based indexing
*/



% Small test matrix
% -1 == bomb, [1,8] == adjacency tiles, 0 == empty, no adjacent mines
smallMap( [ [2, -1, 1],
			[-1, 2, 1],
			[1,  1, 0] ]).

% Tile states:
% 	0 == Covered
%   1 == Flagged
%	2 == Revealed
%	3 == Exploded
tileState(0, covered).
tileState(1, flagged).
tileState(2, revealed).
tileState(3, exploded).

% isMine is true if tile == -1, representing a mine
isMine(Tile) :- Tile is -1.

% onClickFlag sets Tile at Col, Row in StateMap to flagged.  Solves for: NewStateMap =
onClickFlag(Col, Row, StateMap, NewStateMap)  :- 
	setTile(StateMap, Col, Row, Tile, NewStateMap),
	tileState(Tile, flagged).

% setTile(Map, Col, Row, Val, NewMap) is true if NewMap is Map with Tile at (Col, Row) == Val
 % General setter
 setTile([R|Rows] , Col , 1 , Val , [NR|Rows])  :- 
	!,
	replace_column(R,Col,Val,NR).                                       
	setTile([NR|Rows], Col, Row, Val, [NR|NRows]) :- 
	Row > 1,                                 
	Row1 is Row - 1,                             
	setTile(Rows, Col, Row1, Val, NRows).                                       
  
  % Helper for setTile
  replace_column([_|NRs], 1, Val, [Val|NRs]) :- !.
  replace_column([R|NRs], Col, Val, [R|Rows]) :- 
	Col > 1,                                    
	Col1 is Col - 1,                                
	replace_column(NRs, Col1, Val, Rows). 


% getTile is true if Tile is at Col, Row in Map - returns: Tile = 
% General getter 
getTile(Col, Row, Map, Tile) :-
	nth1(Row, Map, RowList),
	nth1(Col, RowList, Tile).


% Generates a ColN x RowN initial Tile State map - all tiles are covered (0)
% Num = N, used for 
generateStartingState(0, _, []) :- !.
generateStartingState(ColN, RowN, [R|T]) :-
	ColN > 0,
	Col1 is ColN - 1,
	setRow(RowN, R),
	generateStartingState(Col1, RowN, T).

% Fills a row with N 0's
setRow(0, []) :- !.
setRow(N, Row) :-
	N > 0,
	N1 is N - 1,
	tileState(V, covered),
	Row = [V|T],
	setRow(N1, T).


test(0, []) :- !.
test(N, List) :-
	N > 0,
	N1 is N -1,
	List = [0|T],
	test(N1, T).

     