:- use_module(library(pce)).
:- use_module(library(time)).
:- include('eventHandlers.pl').
:- include('guiUtil.pl').

% run the program with this
run :- cleanup,init.

% game setup and init
init :- 
    mineFrame(MAINFRAME),
    minePlayingField(P,MAINFRAME),
    mineControls(P,MAINFRAME),
    send(P,open),
    mapSize(MX,MY),
    % map of tileStates
    generateStartingState(MX,MY,STATEMAP),
    % placeholder for map of mines
    exampleMap(MINESMAP),
    send(@w,string,0),
    countdown(0,@c,@w),
    placeMap(P,MINESMAP,STATEMAP).


% restart the program
restart([P,M]) :- 
    free(P),
    free(M),
    run.

