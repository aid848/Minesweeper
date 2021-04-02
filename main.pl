:- use_module(library(pce)).

% run the program with this
run :- cleanup,init.

% Any named XPCE objects must be freed here, don't use named objects except for debug
cleanup :- free(@bm).

% game setup
init :- new(P, picture('demo')),
    send(P,open),
    loadimg(P,T1,'32x32/books.xpm',25,25),
    loadimg(P,T2,'16x16/print.xpm',50,50),
    % funloop(30,30,P),
    addPrologCallBack(T1,left,swapIcon,[T1,'16x16/print.xpm',P]),
    addPrologCallBack(T2,left,swapIcon,[T2,'32x32/books.xpm',P]).


% loads image into parent view
loadimg(PARENT,IMG,PICTURE,X,Y) :- send(PARENT, display, new(IMG,bitmap(PICTURE)), point(X,Y)).

% message(target, callback, arg1,args2,...)
addPrologCallBack(TARGET, CLICK, FUNCTION, ARGS) :- send(TARGET, recogniser,click_gesture(CLICK, '', single, message(@prolog,FUNCTION,prolog(ARGS)))).

% gets both position coords from an xpce object
getTilePos(Tile,X,Y) :- get(Tile,x,X),get(Tile,y,Y), print(X).

% removed an xpce bitmap and draws a new one in the same place as the old one based on the path to an acceptable image
swapIcon([OLD,NEW,P]) :- getTilePos(OLD,X,Y),free(OLD), send(P,display,new(I,bitmap(NEW)), point(X,Y)), addToMap(I,X,Y).

% funloop(_,0,0).
% funloop(X,Y,P) :- loadimg(P,_,'32x32/books.xpm',X,Y), funloop(X - 5,Y - 5,P), X1 is X-5,Y1 is Y-5.

% TODO add tile reference to map rep *TODO
% addToMap(Tile,X,Y).

% TODO map the internal coords to screen space
% mapToGrid(X1,Y1,X2,Y2).