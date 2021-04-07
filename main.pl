:- use_module(library(pce)).
:- include('eventHandlers.pl').

% Game config
dims(X,Y) :- X is 400, Y is 400.
mapSize(X,Y) :- X is 16, Y is 16.
imgs(X,Y) :- X is 16, Y is 16.
padding(T,B,L,R) :- T is 50, B is 0, L is 75, R is 0.
mines(N) :- N is 100.
b_setVal(mark,"Hi").


% run the program with this
run :- cleanup,init.

% Any named XPCE objects must be freed here, don't use named objects except for debug
cleanup :- free(@c),free(@r),free(@s).

% game setup TODO cleanup
init :- 
    new(MAINFRAME,frame('Minesweeper')),
    new(P, picture),
    send(MAINFRAME,append,P),
    dims(A,B),
    send(P,size,size(A,B)),
    send(P, display,new(@c, text(123)), point(300, 0)),
    send(@c,font,font(helvetica, bold, 30)),
    send(@c,colour,red),
    send(P, display,new(@s, text(0)), point(100, 0)),
    send(@s,font,font(helvetica, bold, 30)),
    send(@s,colour,red),
    send(P,display, new(@r,bitmap('./icons/smileybase.xpm')), point(200,0)),
    addPrologCallBack(@r,left,restart,[P]),
    send(P,open),
    % thread_create(countdown(X).),
    minecounter(0,=,R),
    mapSize(MX,MY),
    % map of tileStates
    generateStartingState(MX,MY,STATEMAP),
    % placeholder for map of mines
    exampleMap(MINESMAP),
    % countdown(0),
    placeMap(P,MINESMAP,STATEMAP).


% loads image into parent view
loadimg(PARENT,IMG,PICTURE,X,Y) :- send(PARENT, display, new(IMG,bitmap(PICTURE)), point(X,Y)), send(IMG,size,size(32,32)).

% message(target, callback, arg1,args2,...)
addPrologCallBack(TARGET, CLICK, FUNCTION, ARGS) :- send(TARGET, recogniser,click_gesture(CLICK, '', single, message(@prolog,FUNCTION,prolog(ARGS)))).

% gets both position coords from an xpce object
getTilePos(Tile,X,Y) :- get(Tile,x,X),get(Tile,y,Y).

% call to setup playable map, uses one indexed coords like the map representation
placeMap(P,MINESMAP,STATEMAP) :- placeMapHelper(P,MINESMAP,STATEMAP,1,1).
placeMapHelper(P,MINESMAP,STATEMAP,X,Y) :- mapSize(_,MY),Y=<MY, Y1 is Y+1,placeMapHelperRow(P,MINESMAP,STATEMAP,X,Y),placeMapHelper(P,MINESMAP,STATEMAP,X,Y1).

% Places a map tile row
% TODO change the callback to the interaction handlers 
placeMapHelperRow(P,MINESMAP,STATEMAP,X,Y) :- mapSize(MAXX,_),X<MAXX,X1 is X + 1,mapToGrid(X,Y,A,B),loadimg(P,I,'./icons/unmarked.xpm',A,B),addPrologCallBack(I,left,handleLeftClick,[I,MINESMAP,P]),addPrologCallBack(I,right,handleRightClick,[I,STATEMAP,P]), placeMapHelperRow(P,MINESMAP,STATEMAP,X1,Y). 
placeMapHelperRow(P,MINESMAP,STATEMAP,X,Y) :- mapSize(MAXX,_),X=:=MAXX,mapToGrid(X,Y,A,B),loadimg(P,I,'./icons/unmarked.xpm',A,B),addPrologCallBack(I,left,handleLeftClick,[I,MINESMAP,P]),addPrologCallBack(I,right,handleRightClick,[I,STATEMAP,P]).

% Map the internal coords to screen space (xpm images are 16x16)
mapToGrid(X1,Y1,X2,Y2) :- imgs(H,W),padding(T,B,L,R),X2 is (X1 - 1) * W + L, Y2 is (Y1 - 1) * H + T.

% Map the screen space (X2,Y2) to internal coords (X1,Y1)
gridToMap(X1,Y1,X2,Y2) :- imgs(H,W),padding(T,B,L,R),X1 is (X2 - L) / W + 1, Y1 is (Y2 - T) / H + 1.

% countdown timer, blocks so needs to be run on a separate thread :(
countdown(X) :- send(@c,string,X), sleep(1),X1 is X + 1, countdown(X1).

% works but looks bad, todo maybe keep frame and redo sub elements
restart([P]) :- free(P), run.

minecounter(X,+,R) :- R is X + 1.
minecounter(X,-,R) :- R is X - 1.
minecounter(X,=,R) :- R is X.

% convert a number X into three position images for the gui
digitalClock(X,A,B,C) :- C is X rem 100, B is X rem 10, A is X rem 1.
