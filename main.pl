:- use_module(library(pce)).
:- use_module(library(time)).
:- include('eventHandlers.pl').
:- include('guiUtil.pl').

:- dynamic flagged/2, revealed/2, exploded/2.

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
    generateStartStateMap(MX,MY,STATEMAP),
    % placeholder for map of mines
    startMap(MX, MY, MINESMAP),
    send(@w,string,0),
    countdown(0,@c,@w),
    placeMap(P,MINESMAP,STATEMAP).


% restart the program
restart([P,M]) :- 
    free(P),
    free(M),
    retractall(flagged(_,_)),
    retractall(revealed(_,_)),
    retractall(exploded(_,_)),
    run.

