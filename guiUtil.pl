:- use_module(library(pce)).
:- use_module(library(time)).

% Game config
dims(X,Y) :- X is 400, Y is 400.
mapSize(X,Y) :- X is 16, Y is 16.
imgs(X,Y) :- X is 16, Y is 16.
padding(T,B,L,R) :- T is 50, B is 0, L is 75, R is 0.
mines(N) :- N is 100.

% Any named XPCE objects must be freed here, don't use named objects except for debug
cleanup :- free(@c),free(@r),free(@s), free(@w).


mineFrame(MAINFRAME) :- new(MAINFRAME,frame('Minesweeper')).

minePlayingField(P,MAINFRAME) :- 
    new(P, picture),
    send(MAINFRAME,append,P),
    dims(A,B),
    send(P,size,size(A,B)).

mineControls(P,MA,ID) :- 
    send(P, display,new(@c, text(0)), point(270, 0)),
    send(@c,font,font(helvetica, bold, 30)),
    send(@c,colour,red),
    mines(M),
    send(P, display,new(@s, text(M)), point(75, 0)),
    send(@s,font,font(helvetica, bold, 30)),
    send(@s,colour,red),
    send(P,display,new(@w,text(1)), point(190,0)),
    send(P,display, new(@r,bitmap('./icons/smileybase.xpm')), point(190,0)),
    addPrologCallBack(@r,left,restart,[P,MA]).

% gets both position coords from an xpce object
getTilePos(Tile,X,Y) :- get(Tile,x,X),get(Tile,y,Y).

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

% Map the internal coords to screen space (xpm images are 16x16)
mapToGrid(X1,Y1,X2,Y2) :- imgs(H,W),padding(T,B,L,R),X2 is (X1 - 1) * W + L, Y2 is (Y1 - 1) * H + T.

% Map the screen space (X2,Y2) to internal coords (X1,Y1)
gridToMap(X1,Y1,X2,Y2) :- imgs(H,W),padding(T,B,L,R),X1 is (X2 - L) / W + 1, Y1 is (Y2 - T) / H + 1.

% countdown timer working
countdown(X,P,W) :-
    get(W,value,A),
    atom_number(A,0),
    X1 is X + 1,
    get(P,value,B),
    atom_number(B,X),
    send(P,string,X1), 
    alarm(1, countdown(X1,P,W),_,[remove(true)]).

% Increments the number of flags based on the operator
flagcounter(X,+,R) :- R is X + 1.
flagcounter(X,-,R) :- R is X - 1.
flagcounter(X,=,R) :- R is X.

minecounter(X,+,R) :- R is X + 1.
minecounter(X,-,R) :- R is X - 1.
minecounter(X,=,R) :- R is X.

% manually change mines left counter
incMine(_) :- get(@s,value,A),atom_number(A,X),mines(N),X < N,X1 is X + 1,send(@s,string,X1).
decMine(_) :- get(@s,value,A),atom_number(A,X),X>0,X1 is X - 1,send(@s,string,X1).
calcMine(X) :- minecounter(A,=,_),flagcounter(B,=,_),X is A - B,send(@s,string,X).

startCounter(N,P) :- in_pce_thread(countdown(N,P)).

% counter(N) :- send(@c,string,5),N1 is N+1,counter(N1) .

% timer(ID) :- alarm(1,countdown(0,@c,ID),ID).

% countdown(X,P,Id) :- 
%     get(@c,value,A),
%     atom_number(A,X),
%     X1 is X + 1,
%     send(@c,string,X1),
%     alarm(1,countdown(0,@c,ID),_).

% countdown timer, blocks so needs to be run on a separate thread :(
% countdown(X,P) :- send(P,string,X), sleep(1), X1 is X + 1, countdown(X1,P).

% countdown timer 
