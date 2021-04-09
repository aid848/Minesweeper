:- include('map.pl').

/*
**	Backend logical event handlers:
**		- Left clicks
**		- Right clicks
**		- Game over
**		- Restart
*/

% changes the icon of the left clicked tile depending on what the tile was
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 0, getTile(X1,Y1,MINESMAP,Val), Val is 0, setTile(STATEMAP,X1,Y1,2,NEWSTATEMAP), !, swapIcon([OLD,'./icons/down.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 0, getTile(X1,Y1,MINESMAP,Val), Val is -1, setTile(STATEMAP,X1,Y1,3,NEWSTATEMAP), !, swapIcon([OLD,'./icons/hit.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 0, getTile(X1,Y1,MINESMAP,Val), Val is 1, setTile(STATEMAP,X1,Y1,2,NEWSTATEMAP), !, swapIcon([OLD,'./icons/mine1.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 0, getTile(X1,Y1,MINESMAP,Val), Val is 2, setTile(STATEMAP,X1,Y1,2,NEWSTATEMAP), !, swapIcon([OLD,'./icons/mine2.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 0, getTile(X1,Y1,MINESMAP,Val), Val is 3, setTile(STATEMAP,X1,Y1,2,NEWSTATEMAP), !, swapIcon([OLD,'./icons/mine3.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 0, getTile(X1,Y1,MINESMAP,Val), Val is 4, setTile(STATEMAP,X1,Y1,2,NEWSTATEMAP), !, swapIcon([OLD,'./icons/mine4.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 0, getTile(X1,Y1,MINESMAP,Val), Val is 5, setTile(STATEMAP,X1,Y1,2,NEWSTATEMAP), !, swapIcon([OLD,'./icons/mine5.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 0, getTile(X1,Y1,MINESMAP,Val), Val is 6, setTile(STATEMAP,X1,Y1,2,NEWSTATEMAP), !, swapIcon([OLD,'./icons/mine6.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 0, getTile(X1,Y1,MINESMAP,Val), Val is 7, setTile(STATEMAP,X1,Y1,2,NEWSTATEMAP), !, swapIcon([OLD,'./icons/mine7.xpm',MINESMAP,NEWSTATEMAP,P]).
handleLeftClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 0, getTile(X1,Y1,MINESMAP,Val), Val is 8, setTile(STATEMAP,X1,Y1,2,NEWSTATEMAP), !, swapIcon([OLD,'./icons/mine8.xpm',MINESMAP,NEWSTATEMAP,P]).

% flips the icon of the right clicked tile to flag or blank
handleRightClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 0, setTile(STATEMAP,X1,Y1,1,NEWSTATEMAP), !, swapIcon([OLD,'./icons/flag.xpm',MINESMAP,NEWSTATEMAP,P]).
handleRightClick([OLD,MINESMAP,STATEMAP,P]) :- getTilePos(OLD,X,Y), gridToMap(X1,Y1,X,Y), getTile(X1,Y1,STATEMAP,State), State is 1, setTile(STATEMAP,X1,Y1,0,NEWSTATEMAP), !, swapIcon([OLD,'./icons/unmarked.xpm',MINESMAP,NEWSTATEMAP,P]).