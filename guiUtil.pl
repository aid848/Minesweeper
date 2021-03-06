:- use_module(library(pce)).
:- use_module(library(time)).

% Game config, sizes and other constants here.
imgs(X,Y) :- X is 16, Y is 16.
% difficulty related items
padding(T,B,L,R) :- easy,T is 50, B is 0, L is 100, R is 0.
padding(T,B,L,R) :- medium,T is 50, B is 0, L is 75, R is 0.
padding(T,B,L,R) :- hard,T is 50, B is 0, L is 50, R is 0.
dims(X,Y) :- easy,X is 400, Y is 400.
dims(X,Y) :- medium,X is 400, Y is 400.
dims(X,Y) :- hard,X is 400, Y is 400.
mapSize(X,Y) :- easy,X is 12, Y is 12.
mapSize(X,Y) :- medium,X is 16, Y is 16.
mapSize(X,Y) :- hard,X is 18, Y is 18.
mines(N) :- easy,N is 10.
mines(N) :- medium,N is 40.
mines(N) :- hard,N is 60.

% Any named XPCE objects must be freed here, don't use named objects except for debug
cleanup :- free(@c),free(@r),free(@s), free(@w),free(@m), free(@minescount), retractall(flagged(_,_)), retractall(revealed(_,_)), retractall(exploded(_,_)).

% sets up game window frame
mineFrame(MAINFRAME) :- new(MAINFRAME,frame('Minesweeper')).

% establishes the main field area shell
minePlayingField(P,MAINFRAME) :- 
    new(P, picture),
    send(MAINFRAME,append,P),
    dims(A,B),
    send(P,size,size(A,B)).

% inits gui elements of the top bar and sets their properties such as fonts
mineControls(P,MA) :- 
    send(P, display,new(@c, text(0)), point(270, 0)),
    send(@c,font,font(helvetica, bold, 30)),
    send(@c,colour,red),
    mines(M),
    send(P, display,new(@s, text(M)), point(75, 0)),
    send(@s,font,font(helvetica, bold, 30)),
    send(@s,colour,red),
    send(P,display,new(@w,text(1)), point(190,0)),
    send(P,display,new(@minescount,text(M)), point(190,0)),
    send(P,display, new(@r,bitmap('./icons/smileybase.xpm')), point(190,0)),
    addPrologCallBack(@r,left,restart,[P,MA]).

% gets both position coords from an xpce object
getTilePos(Tile,X,Y) :- get(Tile,x,X),get(Tile,y,Y).

% removed an xpce bitmap and draws a new one in the same place as the old one based on the path to an acceptable image
swapIcon([OLD,NEW,MINESMAP,STATEMAP,P]) :- 
    getTilePos(OLD,X,Y),
    free(OLD),
    send(P,display,
    new(I,bitmap(NEW)), point(X,Y)),
    addPrologCallBack(I,left,handleLeftClick,[I,MINESMAP,STATEMAP,P]),
    addPrologCallBack(I,right,handleRightClick,[I,MINESMAP,STATEMAP,P]).

swapSmiley(OLD,NEW,P,I) :-
    getTilePos(OLD,X,Y),
    free(OLD),
    send(P,display,
    new(I,bitmap(NEW)), point(X,Y)),
    addPrologCallBack(I,left,restart,[P,@m]).

% loads image into parent view
loadimg(PARENT,IMG,PICTURE,X,Y) :-
    send(PARENT, display,
    new(IMG,bitmap(PICTURE)),
    point(X,Y)),
    send(IMG,size,size(32,32)).

% Adds a prolog callback by sending it through an xpce message(target, callback, arg1,args2,...)
addPrologCallBack(TARGET, CLICK, FUNCTION, ARGS) :-
    send(TARGET, recogniser,click_gesture(CLICK, '', single, message(@prolog,FUNCTION,prolog(ARGS)))).

% Call to setup playable map, uses one indexed coords like the map representation
placeMap(P,MINESMAP,STATEMAP) :- placeMapHelper(P,MINESMAP,STATEMAP,1,1).
placeMapHelper(P,MINESMAP,STATEMAP,X,Y) :-
    mapSize(_,MY),Y=<MY, Y1 is Y+1,placeMapHelperRow(P,MINESMAP,STATEMAP,X,Y),
    placeMapHelper(P,MINESMAP,STATEMAP,X,Y1).

% Places a map tile row recursively
placeMapHelperRow(P,MINESMAP,STATEMAP,X,Y) :-
    mapSize(MAXX,_),X<MAXX,X1 is X + 1,
    mapToGrid(X,Y,A,B),loadimg(P,I,'./icons/unmarked.xpm',A,B),
    addPrologCallBack(I,left,handleLeftClick,
    [I,MINESMAP,STATEMAP,P]),
    addPrologCallBack(I,right,handleRightClick,[I,MINESMAP,STATEMAP,P]),
    placeMapHelperRow(P,MINESMAP,STATEMAP,X1,Y). 

placeMapHelperRow(P,MINESMAP,STATEMAP,X,Y) :-
    mapSize(MAXX,_),X=:=MAXX,mapToGrid(X,Y,A,B),
    loadimg(P,I,'./icons/unmarked.xpm',A,B),
    addPrologCallBack(I,left,handleLeftClick,[I,MINESMAP,STATEMAP,P]),
    addPrologCallBack(I,right,handleRightClick,[I,MINESMAP,STATEMAP,P]).

% Uncovers the covered mines
uncoverMap(P,MINESMAP) :- uncoverMapHelper(P,MINESMAP,1,1).

% Iterates through the columns of the map
uncoverMapHelper(P,MINESMAP,X,Y) :-
    mapSize(_,MAXY),
    Y=<MAXY,
    Y1 is Y+1,
    uncoverMapHelperRow(P,MINESMAP,X,Y),
    uncoverMapHelper(P,MINESMAP,X,Y1).

% Uncovers a tile row recursively
uncoverMapHelperRow(P,MINESMAP,X,Y) :-
    mapSize(MAXX,_),
    X<MAXX,
    X1 is X+1,
    uncoverTile(P,MINESMAP,X,Y),
    uncoverMapHelperRow(P,MINESMAP,X1,Y).

uncoverMapHelperRow(P,MINESMAP,X,Y) :-
    mapSize(MAXX,_),
    X=:=MAXX,
    uncoverTile(P,MINESMAP,X,Y).

% Uncovers a specific tile
uncoverTile(P,MINESMAP,X,Y) :- exploded(X,Y), getTile(X,Y,MINESMAP,Val), Val is -1, mapToGrid(X,Y,A,B), !, loadimg(P,_,'./icons/hit.xpm',A,B).
uncoverTile(P,MINESMAP,X,Y) :- flagged(X,Y), getTile(X,Y,MINESMAP,Val), Val is -1, mapToGrid(X,Y,A,B), !, loadimg(P,_,'./icons/flag.xpm',A,B).
uncoverTile(P,MINESMAP,X,Y) :- flagged(X,Y), getTile(X,Y,MINESMAP,Val), Val \= -1, mapToGrid(X,Y,A,B), !, loadimg(P,_,'./icons/notmine.xpm',A,B).
uncoverTile(P,MINESMAP,X,Y) :- getTile(X,Y,MINESMAP,Val), Val is -1, mapToGrid(X,Y,A,B), !, loadimg(P,_,'./icons/mine.xpm',A,B).
uncoverTile(_,_,X,Y) :- revealed(X,Y), !.
uncoverTile(P,_,X,Y) :- mapToGrid(X,Y,A,B), loadimg(P,_,'icons/unmarked.xpm',A,B).

% Map the internal coords to screen space (xpm images are 16x16)
mapToGrid(X1,Y1,X2,Y2) :- imgs(H,W),padding(T,_,L,_),X2 is (X1 - 1) * W + L, Y2 is (Y1 - 1) * H + T.

% Map the screen space (X2,Y2) to internal coords (X1,Y1)
gridToMap(X1,Y1,X2,Y2) :- imgs(H,W),padding(T,_,L,_),X1 is (X2 - L) / W + 1, Y1 is (Y2 - T) / H + 1.

% countdown timer gui updater
countdown(X,P,W) :-
    get(W,value,A),
    atom_number(A,0),
    X1 is X + 1,
    get(P,value,B),
    atom_number(B,X),
    send(P,string,X1), 
    alarm(1, countdown(X1,P,W),_,[remove(true)]).

% called if gameover, stops counter
stopCounter :- 
    send(@w,string,1).

% doesn't work, don't use
restartCounter :- 
    send(@w,string,0),alarm(1, countdown(0,@c,@w),_,[remove(true)]).

% call to change mines left counter
unflag :- get(@s,value,A),atom_number(A,X),X1 is X + 1,send(@s,string,X1).
flag :- get(@s,value,A),atom_number(A,X),X1 is X - 1,send(@s,string,X1).

% checks if all flags used, use to check for game completion
allFlags :- get(@s,value,A),atom_number(A,X), X =:= 0.