:- include('map.pl').

/*
**	Backend logical event handlers:
**		- Left clicks
**		- Right clicks
**		- Game over
**		- Restart
*/

% changes the icon of the left clicked tile depending on what the tile was
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is 0, !, uncoverArea(P, MINESMAP,STATEMAP,X1,Y1,_).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is -1, setTile(STATEMAP,X1,Y1,111,NEWSTATEMAP), assertz(exploded(X1,Y1)), !, swapIcon([OLD,'./icons/hit.xpm',MINESMAP,NEWSTATEMAP,P]),swapSimiley(@r,'./icons/smiley-lose.xpm',P,_), stopCounter, uncoverMap(P,MINESMAP).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is 1, setTile(STATEMAP,X1,Y1,110,NEWSTATEMAP), assertz(revealed(X1,Y1)), !, swapIcon([OLD,'./icons/mine1.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is 2, setTile(STATEMAP,X1,Y1,110,NEWSTATEMAP), assertz(revealed(X1,Y1)), !, swapIcon([OLD,'./icons/mine2.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is 3, setTile(STATEMAP,X1,Y1,110,NEWSTATEMAP), assertz(revealed(X1,Y1)), !, swapIcon([OLD,'./icons/mine3.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is 4, setTile(STATEMAP,X1,Y1,110,NEWSTATEMAP), assertz(revealed(X1,Y1)), !, swapIcon([OLD,'./icons/mine4.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is 5, setTile(STATEMAP,X1,Y1,110,NEWSTATEMAP), assertz(revealed(X1,Y1)), !, swapIcon([OLD,'./icons/mine5.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is 6, setTile(STATEMAP,X1,Y1,110,NEWSTATEMAP), assertz(revealed(X1,Y1)), !, swapIcon([OLD,'./icons/mine6.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is 7, setTile(STATEMAP,X1,Y1,110,NEWSTATEMAP), assertz(revealed(X1,Y1)), !, swapIcon([OLD,'./icons/mine7.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is 8, setTile(STATEMAP,X1,Y1,110,NEWSTATEMAP), assertz(revealed(X1,Y1)), !, swapIcon([OLD,'./icons/mine8.xpm',MINESMAP,NEWSTATEMAP,P]).

% flips the icon of the right clicked tile to flag or blank
handleRightClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is -1, setTile(STATEMAP,X1,Y1,101,NEWSTATEMAP), get(@minescount,value,MCO), atom_number(MCO,MC), MC1 is MC - 1, MC1=0, send(@minescount,string,MC1), assertz(flagged(X1,Y1)), !, swapIcon([OLD,'./icons/flag.xpm',MINESMAP,NEWSTATEMAP,P]), flag,swapSimiley(@r,'./icons/smiley-win.xpm',P,_), stopCounter, uncoverMap(P, MINESMAP).
handleRightClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val is -1, setTile(STATEMAP,X1,Y1,101,NEWSTATEMAP), get(@minescount,value,MCO), atom_number(MCO,MC), MC1 is MC - 1, MC1>0, send(@minescount,string,MC1), assertz(flagged(X1,Y1)), !, swapIcon([OLD,'./icons/flag.xpm',MINESMAP,NEWSTATEMAP,P]), flag.
handleRightClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 100, getTile(X1,Y1,MINESMAP,Val), Val \= -1, setTile(STATEMAP,X1,Y1,101,NEWSTATEMAP), assertz(flagged(X1,Y1)), !, swapIcon([OLD,'./icons/flag.xpm',MINESMAP,NEWSTATEMAP,P]), flag.
handleRightClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 101, getTile(X1,Y1,MINESMAP,Val), Val is -1, setTile(STATEMAP,X1,Y1,100,NEWSTATEMAP), get(@minescount,value,MCO), atom_number(MCO,MC), MC1 is MC + 1, send(@minescount,string,MC1), retract(flagged(X1,Y1)), !, swapIcon([OLD,'./icons/unmarked.xpm',MINESMAP,NEWSTATEMAP,P]), unflag.
handleRightClick([OLD,MINESMAP,STATEMAP,P]) :- get(@w, value, A), atom_number(A, 0), getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), \+revealed(X1,Y1), getTile(X1,Y1,STATEMAP,State), State is 101, getTile(X1,Y1,MINESMAP,Val), Val \= -1, setTile(STATEMAP,X1,Y1,100,NEWSTATEMAP), retract(flagged(X1,Y1)), !, swapIcon([OLD,'./icons/unmarked.xpm',MINESMAP,NEWSTATEMAP,P]), unflag.

% recursively uncovers a large area of zeros
uncoverArea(P, MINESMAP,STATEMAP,X,Y,NEWSTATEMAP) :-
    mapSize(MAXX,MAXY),
    X>0,
    X=<MAXX,
    Y>0,
    Y=<MAXY,
    L is X-1,
    R is X+1,
    U is Y-1,
    D is Y+1,
    getTile(X,Y,STATEMAP,State),
    State is 100,
    getTile(X,Y,MINESMAP,Val),
    Val is 0,
    \+revealed(X,Y),
    \+flagged(X,Y),
    !, 
    setTile(STATEMAP,X,Y,110,NEWSTATEMAP1),
    assertz(revealed(X,Y)),
    mapToGrid(X,Y,A,B), 
    loadimg(P,_,'./icons/down.xpm',A,B),
    uncoverArea(P, MINESMAP,NEWSTATEMAP1,L,U,NEWSTATEMAP2),
    uncoverArea(P, MINESMAP,NEWSTATEMAP2,X,U,NEWSTATEMAP3),
    uncoverArea(P, MINESMAP,NEWSTATEMAP3,R,U,NEWSTATEMAP4),
    uncoverArea(P, MINESMAP,NEWSTATEMAP4,L,Y,NEWSTATEMAP5),
    uncoverArea(P, MINESMAP,NEWSTATEMAP5,R,Y,NEWSTATEMAP6),
    uncoverArea(P, MINESMAP,NEWSTATEMAP6,L,D,NEWSTATEMAP7),
    uncoverArea(P, MINESMAP,NEWSTATEMAP7,X,D,NEWSTATEMAP8),
    uncoverArea(P, MINESMAP,NEWSTATEMAP8,R,D,NEWSTATEMAP).

uncoverArea(P, MINESMAP,STATEMAP,X,Y,NEWSTATEMAP) :-
    mapSize(MAXX,MAXY),
    X>0,
    X=<MAXX,
    Y>0,
    Y=<MAXY,
    getTile(X,Y,STATEMAP,State),
    State is 100,
    getTile(X,Y,MINESMAP,Val),
    Val is 1,
    \+revealed(X,Y),
    \+flagged(X,Y),
    !, 
    setTile(STATEMAP,X,Y,110,NEWSTATEMAP),
    assertz(revealed(X,Y)),
    mapToGrid(X,Y,A,B), 
    loadimg(P,_,'./icons/mine1.xpm',A,B).

uncoverArea(P, MINESMAP,STATEMAP,X,Y,NEWSTATEMAP) :-
    mapSize(MAXX,MAXY),
    X>0,
    X=<MAXX,
    Y>0,
    Y=<MAXY,
    getTile(X,Y,STATEMAP,State),
    State is 100,
    getTile(X,Y,MINESMAP,Val),
    Val is 2,
    \+revealed(X,Y),
    \+flagged(X,Y),
    !, 
    setTile(STATEMAP,X,Y,110,NEWSTATEMAP),
    assertz(revealed(X,Y)),
    mapToGrid(X,Y,A,B), 
    loadimg(P,_,'./icons/mine2.xpm',A,B).

uncoverArea(P, MINESMAP,STATEMAP,X,Y,NEWSTATEMAP) :-
    mapSize(MAXX,MAXY),
    X>0,
    X=<MAXX,
    Y>0,
    Y=<MAXY,
    getTile(X,Y,STATEMAP,State),
    State is 100,
    getTile(X,Y,MINESMAP,Val),
    Val is 3,
    \+revealed(X,Y),
    \+flagged(X,Y),
    !, 
    setTile(STATEMAP,X,Y,110,NEWSTATEMAP),
    assertz(revealed(X,Y)),
    mapToGrid(X,Y,A,B), 
    loadimg(P,_,'./icons/mine3.xpm',A,B).

uncoverArea(P, MINESMAP,STATEMAP,X,Y,NEWSTATEMAP) :-
    mapSize(MAXX,MAXY),
    X>0,
    X=<MAXX,
    Y>0,
    Y=<MAXY,
    getTile(X,Y,STATEMAP,State),
    State is 100,
    getTile(X,Y,MINESMAP,Val),
    Val is 4,
    \+revealed(X,Y),
    \+flagged(X,Y),
    !, 
    setTile(STATEMAP,X,Y,110,NEWSTATEMAP),
    assertz(revealed(X,Y)),
    mapToGrid(X,Y,A,B), 
    loadimg(P,_,'./icons/mine4.xpm',A,B).

uncoverArea(P, MINESMAP,STATEMAP,X,Y,NEWSTATEMAP) :-
    mapSize(MAXX,MAXY),
    X>0,
    X=<MAXX,
    Y>0,
    Y=<MAXY,
    getTile(X,Y,STATEMAP,State),
    State is 100,
    getTile(X,Y,MINESMAP,Val),
    Val is 5,
    \+revealed(X,Y),
    \+flagged(X,Y),
    !, 
    setTile(STATEMAP,X,Y,110,NEWSTATEMAP),
    assertz(revealed(X,Y)),
    mapToGrid(X,Y,A,B), 
    loadimg(P,_,'./icons/mine5.xpm',A,B).

uncoverArea(P, MINESMAP,STATEMAP,X,Y,NEWSTATEMAP) :-
    mapSize(MAXX,MAXY),
    X>0,
    X=<MAXX,
    Y>0,
    Y=<MAXY,
    getTile(X,Y,STATEMAP,State),
    State is 100,
    getTile(X,Y,MINESMAP,Val),
    Val is 6,
    \+revealed(X,Y),
    \+flagged(X,Y),
    !, 
    setTile(STATEMAP,X,Y,110,NEWSTATEMAP),
    assertz(revealed(X,Y)),
    mapToGrid(X,Y,A,B), 
    loadimg(P,_,'./icons/mine6.xpm',A,B).

uncoverArea(P, MINESMAP,STATEMAP,X,Y,NEWSTATEMAP) :-
    mapSize(MAXX,MAXY),
    X>0,
    X=<MAXX,
    Y>0,
    Y=<MAXY,
    getTile(X,Y,STATEMAP,State),
    State is 100,
    getTile(X,Y,MINESMAP,Val),
    Val is 7,
    \+revealed(X,Y),
    \+flagged(X,Y),
    !, 
    setTile(STATEMAP,X,Y,110,NEWSTATEMAP),
    assertz(revealed(X,Y)),
    mapToGrid(X,Y,A,B), 
    loadimg(P,_,'./icons/mine7.xpm',A,B).

uncoverArea(P, MINESMAP,STATEMAP,X,Y,NEWSTATEMAP) :-
    mapSize(MAXX,MAXY),
    X>0,
    X=<MAXX,
    Y>0,
    Y=<MAXY,
    getTile(X,Y,STATEMAP,State),
    State is 100,
    getTile(X,Y,MINESMAP,Val),
    Val is 8,
    \+revealed(X,Y),
    \+flagged(X,Y),
    !, 
    setTile(STATEMAP,X,Y,110,NEWSTATEMAP),
    assertz(revealed(X,Y)),
    mapToGrid(X,Y,A,B), 
    loadimg(P,_,'./icons/mine8.xpm',A,B).

uncoverArea(_,_,_,_,_,_).