:- use_module(library(pce)).
:- use_module(library(time)).
:- include('eventHandlers.pl').
:- include('guiUtil.pl').

:- dynamic flagged/2, revealed/2, exploded/2.

% run the program with this
run :- cleanup,init.

% game setup and init
init :- 
    mineFrame(@m),
    minePlayingField(P,@m),
    mineControls(P,@m),
    send(P,open),
    mapSize(MX,MY),
    % map of tileStates
    generateStartStateMap(MX,MY,STATEMAP),
    mines(NM),
    once(startMap(MX, MY, NM, MINESMAP)),
    send(@w,string,0),
    countdown(0,@c,@w),
    placeMap(P,MINESMAP,STATEMAP).


% restart the program
restart([P,M]) :- 
    free(P),
    free(M),
    run.

