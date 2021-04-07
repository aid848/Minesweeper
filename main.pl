:- use_module(library(pce)).
:- include('eventHandlers.pl').
:- include('guiUtil.pl').

% run the program with this
run :- cleanup,init.

% game setup
init :- 
    mineFrame(MAINFRAME),
    minePlayingField(P,MAINFRAME),
    mineControls(P),
    send(P,open),
    minecounter(0,=,R),
    mapSize(MX,MY),
    % map of tileStates
    generateStartingState(MX,MY,STATEMAP),
    % placeholder for map of mines
    exampleMap(MINESMAP),
    placeMap(P,MINESMAP,STATEMAP),
    startCounter(0).


% works but looks bad, TODO maybe keep frame and redo sub elements
restart([P]) :- free(P), run.



