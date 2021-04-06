:- use_module(library(pce)).
:- include('map.pl').

dims(X,Y) :- X is 500, Y is 500.
mapSize(X,Y) :- X is 16, Y is 16.
imgs(X,Y) :- X is 16, Y is 16.
padding(T,B,L,R) :- T is 0, B is 50, L is 0, R is 50.
% run the program with this
run :- cleanup,init.

% Any named XPCE objects must be freed here, don't use named objects except for debug
cleanup :- free(@bm).

% game setup
init :- 
    new(MAINFRAME,frame('Minesweeper')),
    new(P, picture),
    send(MAINFRAME,append,P),
    dims(A,B),
    send(P,size,size(A,B)),
    send(P,open),
    mapSize(MX,MY),
    generateStartingState(MX,MY,MAP),
    placeMap(P).


% loads image into parent view
loadimg(PARENT,IMG,PICTURE,X,Y) :- send(PARENT, display, new(IMG,bitmap(PICTURE)), point(X,Y)), send(IMG,size,size(32,32)).

% message(target, callback, arg1,args2,...)
addPrologCallBack(TARGET, CLICK, FUNCTION, ARGS) :- send(TARGET, recogniser,click_gesture(CLICK, '', single, message(@prolog,FUNCTION,prolog(ARGS)))).

% gets both position coords from an xpce object
getTilePos(Tile,X,Y) :- get(Tile,x,X),get(Tile,y,Y), print(X).

% removed an xpce bitmap and draws a new one in the same place as the old one based on the path to an acceptable image
swapIcon([OLD,NEW,P]) :- getTilePos(OLD,X,Y),free(OLD), send(P,display,new(I,bitmap(NEW)), point(X,Y)).

placeMap(P) :- placeMapHelper(P,1,1).
placeMapHelper(P,X,Y) :- mapSize(_,MY),Y=<MY, Y1 is Y+1,placeMapHelperRow(P,X,Y),print(Y),placeMapHelper(P,X,Y1).

% TODO change the callback to the interaction handler AND add right click handler
placeMapHelperRow(P,X,Y) :- mapSize(MAXX,_),X<MAXX,X1 is X + 1,mapToGrid(X,Y,A,B),loadimg(P,I,'./icons/unmarked.xpm',A,B),addPrologCallBack(I,left,swapIcon,[I,'16x16/print.xpm',P]), placeMapHelperRow(P,X1,Y). %getTile(X,Y,MAP,T)
placeMapHelperRow(P,X,Y) :- mapSize(MAXX,_),X=:=MAXX,mapToGrid(X,Y,A,B),loadimg(P,I,'./icons/unmarked.xpm',A,B),addPrologCallBack(I,left,swapIcon,[I,'16x16/print.xpm',P]).

% Map the internal coords to screen space (xpm images are 16x16)
mapToGrid(X1,Y1,X2,Y2) :- imgs(H,W),padding(T,B,L,R),X2 is X1 * W + L, Y2 is Y1 * H + T.