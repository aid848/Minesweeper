/*
**	Facilitates 2D map matrix representations including:
**		- Tile types
**		- Tile states
**		- getters
**		- setters
**		- map generators
**
**		* Uses 1-based indexing
*/



% Small test matrix
% -1 == bomb, [1,8] == adjacency tiles, 0 == empty, no adjacent mines
smallMap( [ [2, -1, 1],
			[-1, 2, 1],
			[1,  1, 0] ]).

% Tile states:
tileState(100, covered).
tileState(101, flagged).
tileState(110, revealed).
tileState(111, exploded).

% Tile types:
%	-1 ==  mine
%	[0,8] == distance tile
tileType(-1, mine).
tileType(0, d0).
tileType(1, d1).
tileType(2, d2).
tileType(3, d3).
tileType(4, d4).
tileType(5, d5).
tileType(6, d6).
tileType(7, d7).
tileType(8, d8).

% isMine is true if tile == -1, representing a mine
isMine(Tile) :- Tile is -1.




% onClickFlag sets Tile at Col, Row in StateMap to flagged.  Solves for: NewStateMap =
onClickFlag(Col, Row, StateMap, NewStateMap)  :- 
	setTile(StateMap, Col, Row, Tile, NewStateMap),
	tileState(Tile, flagged).

% getTile is true if Tile is at Col, Row in Map - returns: Tile = 
% General getter 
getTile(Col, Row, Map, Tile) :-
	nth1(Row, Map, RowList),
	nth1(Col, RowList, Tile).

% setTile(Map, Col, Row, Val, NewMap) is true if NewMap is Map with Tile at (Col, Row) == Val
% General setter
setTile([R|Rows] , Col , 1 , Val , [NR|Rows])  :- 
	!,
	replace_column(R,Col,Val,NR).                                       
setTile([NR|Rows], Col, Row, Val, [NR|NRows]) :- 
	Row > 1,                                 
	Row1 is Row - 1,                             
	setTile(Rows, Col, Row1, Val, NRows).                                       

     

% ======================== Tile Map (Matrix) Generation ======================
%

generateZeroMap(0, _, []) :- !.
generateZeroMap(ColN, RowN, [R|T]) :-
	ColN > 0,
	Col is ColN - 1,
	setRow(RowN, R, 0),
	generateZeroMap(Col, RowN, T).

% Generates a ColN x RowN initial mine map wih random distribution - 1's are mines, 0's other tiles
generateMineMap(0, _, []) :- !.
generateMineMap(ColN, RowN, [R|T]) :-
	ColN > 0,
	Col1 is ColN - 1,
	setRowRandom(RowN, R, -1, 1),
	generateMineMap(Col1, RowN, T).

% Generates a ColN x RowN initial Tile State map - all tiles are covered (100)
generateStartStateMap(0, _, []) :- !.
generateStartStateMap(ColN, RowN, [R|T]) :-
	ColN > 0,
	Col1 is ColN - 1,
	tileState(Val, covered),
	setRow(RowN, R, Val),
	generateStartStateMap(Col1, RowN, T).

% generateStartMap(MM, X, Y, NX, NY, M, Output) constructs a full starting tile map
% given:
% 		MM:  		NX x NY matrix of mine positions and empty tiles
%		X and Y: 	Indices used to traverse the matrices - initial call set X<-NX and Y<-NY
%		NX and NY: 	Map dimensions
%		M: 			NX x NY matrix of 0's (on initial call), needed to iteratively construct output
%		Output:		NX a NY matrix representing the starting map

% Example use:
% 		generateMineMap(16,16,MineMap), generateZeroMap(16,16,M), generateStartMap(MineMap, 16,16,16,16, M, Output).
%
% ... lots of cases to cover:

generateStartMap([], 1, 1, _, _, [], []) :- !.

% reaches top left corner ( base case)
generateStartMap(MineMap, 1, 1, _, _, Builder, Output) :-
	getTile(1, 1, MineMap, -1),
	setTile(Builder, 1, 1, -1, Output),
	!.

generateStartMap(MineMap, 1, 1, _, _, Builder, Output) :-
	XN is 2,
	YN is 2,
	getTile(1, YN, MineMap, Bottom),
	getTile(XN, 1, MineMap, Right),
	getTile(XN, YN, MineMap, BottomRight),
	Sum is -1*(Bottom + Right + BottomRight),
	setTile(Builder, 1, 1, Sum, Output),
	!.

% Is bottom right corner
generateStartMap(MineMap, NC, NR, NC, NR, Builder, Output) :-
	getTile(NC, NR, MineMap, -1),
	!,
	XP is NC - 1,
	setTile(Builder, NC, NR, -1, NewBuilder),
	generateStartMap(MineMap, XP, NR, NC, NR, NewBuilder, Output).

generateStartMap(MineMap, NC, NR, NC, NR, Builder, Output) :-
	XP is NC - 1,
	YP is NR - 1,
	getTile(NC, YP, MineMap, Top),
	getTile(XP, NR, MineMap, Left),
	getTile(XP, YP, MineMap, TopLeft),
	Sum is -1*(Top + Left + TopLeft),
	setTile(Builder, NC, NR, Sum, NewBuilder),
	generateStartMap(MineMap, XP, NR, NC, NR, NewBuilder, Output).

% is bottom row
generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol < NC,
	NRow is NR,
	NCol > 1,
	getTile(NCol, NRow, MineMap, -1),
	!,
	XP is NCol - 1,
	setTile(Builder, NCol, NRow, -1, NewBuilder),
	generateStartMap(MineMap, XP, NRow, NC, NR, NewBuilder, Output).

generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol < NC,
	NRow is NR,
	NCol > 1,
	XP is NCol - 1,
	XN is NCol + 1,
	YP is NRow - 1,
	getTile(NCol, YP, MineMap, Top),
	getTile(XP, NRow, MineMap, Left),
	getTile(XN, NRow, MineMap, Right),
	getTile(XP, YP, MineMap, TopLeft),
	getTile(XN, YP, MineMap, TopRight),
	Sum is -1*(Top + Left + Right + TopLeft + TopRight),
	setTile(Builder, NCol, NRow, Sum, NewBuilder),
	generateStartMap(MineMap, XP, NRow, NC, NR, NewBuilder, Output).

% is bottom left corner
generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol is 1,
	NRow is NR,
	getTile(NCol, NRow, MineMap, -1),
	!,
	YP is NRow - 1,
	setTile(Builder, NCol, NRow, -1, NewBuilder),
	generateStartMap(MineMap, NC, YP, NC, NR, NewBuilder, Output).

generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol is 1,
	NRow is NR,
	XN is NCol + 1,
	YP is NRow - 1,
	getTile(NCol, YP, MineMap, Top),
	getTile(XN, NRow, MineMap, Right),
	getTile(XN, YP, MineMap, TopRight),
	Sum is -1*(Top + Right + TopRight),
	setTile(Builder, NCol, NRow, Sum, NewBuilder),
	generateStartMap(MineMap, NC, YP, NC, NR, NewBuilder, Output).

% reaches rightmost column
generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol is NC,
	NRow < NR,
	NRow > 1,
	getTile(NCol, NRow, MineMap, -1),
	!,
	XP is NCol - 1,
	setTile(Builder, NCol, NRow, -1, NewBuilder),
	generateStartMap(MineMap, XP, NRow, NC, NR, NewBuilder, Output).

generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol is NC,
	NRow < NR,
	NRow > 1,
	XP is NCol - 1,
	YP is NRow - 1,
	YN is NRow + 1,
	getTile(NCol, YP, MineMap, Top),
	getTile(NCol, YN, MineMap, Bottom),
	getTile(XP, NRow, MineMap, Left),
	getTile(XP, YP, MineMap, TopLeft),
	getTile(XP, YN, MineMap, BottomLeft),
	Sum is -1*(Bottom + Top + Left + TopLeft + BottomLeft),
	setTile(Builder, NCol, NRow, Sum, NewBuilder),
	generateStartMap(MineMap, XP, NRow, NC, NR, NewBuilder, Output).

% normal
generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol < NC,
	NRow < NR,
	NCol > 1,
	NRow > 1,
	getTile(NCol, NRow, MineMap, -1),
	!,
	XP is NCol - 1,
	setTile(Builder, NCol, NRow, -1, NewBuilder),
	generateStartMap(MineMap, XP, NRow, NC, NR, NewBuilder, Output).

generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol < NC,
	NRow < NR,
	NCol > 1,
	NRow > 1,
	XP is NCol - 1,
	XN is NCol + 1,
	YP is NRow - 1,
	YN is NRow + 1,
	getTile(NCol, YP, MineMap, Top),
	getTile(NCol, YN, MineMap, Bottom),
	getTile(XP, NRow, MineMap, Left),
	getTile(XN, NRow, MineMap, Right),
	getTile(XP, YP, MineMap, TopLeft),
	getTile(XP, YN, MineMap, BottomLeft),
	getTile(XN, YP, MineMap, TopRight),
	getTile(XN, YN, MineMap, BottomRight),
	Sum is -1*(Bottom + Top + Left + Right + TopLeft + TopRight + BottomLeft + BottomRight),
	setTile(Builder, NCol, NRow, Sum, NewBuilder),
	generateStartMap(MineMap, XP, NRow, NC, NR, NewBuilder, Output).

% Reaches leftmost column
generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol is 1,
	NRow < NR,
	NRow > 1,
	getTile(NCol, NRow, MineMap, -1),
	!,
	YP is NRow - 1,
	setTile(Builder, NCol, NRow, -1, NewBuilder),
	generateStartMap(MineMap, NC, YP, NC, NR, NewBuilder, Output).

generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol is 1,
	NRow < NR,
	NRow > 1,
	XN is NCol + 1,
	YP is NRow - 1,
	YN is NRow + 1,
	getTile(NCol, YP, MineMap, Bottom),
	getTile(NCol, YN, MineMap, Top),
	getTile(XN, NRow, MineMap, Right),
	getTile(XN, YP, MineMap, TopRight),
	getTile(XN, YN, MineMap, BottomRight),
	Sum is -1*(Bottom + Top + Right + TopRight + BottomRight),
	setTile(Builder, NCol, NRow, Sum, NewBuilder),
	generateStartMap(MineMap, NC, YP, NC, NR, NewBuilder, Output).

% reaches top right corner
generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol is NC,
	NRow is 1,
	getTile(NCol, NRow, MineMap, -1),
	!,
	XP is NCol - 1,
	setTile(Builder, NCol, NRow, -1, NewBuilder),
	generateStartMap(MineMap, XP, NRow, NC, NR, NewBuilder, Output).

generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol is NC,
	NRow is 1,
	XP is NCol - 1,
	YN is NRow + 1,
	getTile(NCol, YN, MineMap, Bottom),
	getTile(XP, NRow, MineMap, Left),
	getTile(XP, YN, MineMap, BottomLeft),
	Sum is -1*(Bottom + Left + BottomLeft),
	setTile(Builder, NCol, NRow, Sum, NewBuilder),
	generateStartMap(MineMap, XP, NRow, NC, NR, NewBuilder, Output).


% reaches top row
generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol < NC,
	NCol > 1,
	NRow is 1,
	getTile(NCol, NRow, MineMap, -1),
	!,
	XP is NCol - 1,
	setTile(Builder, NCol, NRow, -1, NewBuilder),
	generateStartMap(MineMap, XP, NRow, NC, NR, NewBuilder, Output).

generateStartMap(MineMap, NCol, NRow, NC, NR, Builder, Output) :-
	NCol < NC,
	NCol > 1,
	NRow is 1,
	XP is NCol - 1,
	XN is NCol + 1,
	YN is NRow + 1,
	getTile(NCol, YN, MineMap, Bottom),
	getTile(XP, NRow, MineMap, Left),
	getTile(XN, NRow, MineMap, Right),
	getTile(XP, YN, MineMap, BottomLeft),
	getTile(XN, YN, MineMap, BottomRight),
	Sum is -1*(Bottom + Left + Right + BottomLeft + BottomRight),
	setTile(Builder, NCol, NRow, Sum, NewBuilder),
	generateStartMap(MineMap, XP, NRow, NC, NR, NewBuilder, Output).


% ====================== Helpers ======================
% Helper for setTile
replace_column([_|NRs], 1, Val, [Val|NRs]) :- !.
replace_column([R|NRs], Col, Val, [R|Rows]) :- 
	Col > 1,                                    
	Col1 is Col - 1,                                
	replace_column(NRs, Col1, Val, Rows). 

% Fills a row with Val, length N
setRow(0, [], _) :- !.
setRow(N, Row, Val) :-
	N > 0,
	N1 is N - 1,
	Row = [Val|T],
	setRow(N1, T, Val).

% Fills row with random numbers between [L, U), length N
setRowRandom(0, [], _, _) :- !.
setRowRandom(N, Row, L, U) :-
	N > 0,
	N1 is N - 1,
	random(L, U, Val),
	Row = [Val|T],
	setRowRandom(N1, T, L, U).