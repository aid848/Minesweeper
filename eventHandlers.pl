:- include('map.pl').

/*
**	Backend logical event handlers:
**		- Left clicks
**		- Right clicks
**		- Game over
**		- Restart
*/

% removed an xpce bitmap and draws a new one in the same place as the old one based on the path to an acceptable image
swapIcon([OLD,NEW,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y),free(OLD), send(P,display,new(I,bitmap(NEW)), point(X,Y)),b_setVal(mark,"E"), addPrologCallBack(I,left,handleLeftClick,[I,MINESMAP,STATEMAP,P]), addPrologCallBack(I,right,handleRightClick,[I,MINESMAP,STATEMAP,P]).

% changes the icon of the left clicked tile depending on what the tile was
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,MINESMAP,Val), Val is 0, !, swapIcon([OLD,'./icons/down.xpm',MINESMAP,STATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,MINESMAP,Val), Val is -1, !, swapIcon([OLD,'./icons/hit.xpm',MINESMAP,STATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,MINESMAP,Val), Val is 1, !, swapIcon([OLD,'./icons/mine1.xpm',MINESMAP,STATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,MINESMAP,Val), Val is 2, !, swapIcon([OLD,'./icons/mine2.xpm',MINESMAP,STATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,MINESMAP,Val), Val is 3, !, swapIcon([OLD,'./icons/mine3.xpm',MINESMAP,STATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,MINESMAP,Val), Val is 4, !, swapIcon([OLD,'./icons/mine4.xpm',MINESMAP,STATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,MINESMAP,Val), Val is 5, !, swapIcon([OLD,'./icons/mine5.xpm',MINESMAP,STATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,MINESMAP,Val), Val is 6, !, swapIcon([OLD,'./icons/mine6.xpm',MINESMAP,STATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,MINESMAP,Val), Val is 7, !, swapIcon([OLD,'./icons/mine7.xpm',MINESMAP,STATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,MINESMAP,Val), Val is 8, !, swapIcon([OLD,'./icons/mine8.xpm',MINESMAP,STATEMAP,P]).

% flips the icon of the right clicked tile to flag or blank
handleRightClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,STATEMAP,Val), Val is 0, !, swapIcon([OLD,'./icons/flag.xpm',MINESMAP,STATEMAP,P]).
handleRightClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,X2,X,Y), getTile(X1,X2,STATEMAP,Val), Val is 1, !, swapIcon([OLD,'./icons/unmarked.xpm',MINESMAP,STATEMAP,P]).