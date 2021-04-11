:- use_module(library(pce)).
:- use_module(library(time)).
:- include('eventHandlers.pl').
:- include('guiUtil.pl').

:- dynamic flagged/2, revealed/2, exploded/2,easy/0,medium/0,hard/0.

% run the program with this
play(easy) :- retractall(hard),retractall(medium),assert(easy), run.
play(medium) :- retractall(hard),retractall(easy),assert(medium), run.
play(hard) :- retractall(easy),retractall(medium),assert(hard), run.


run :- \+ easy ,\+ medium,\+ hard, print('Please choose a difficulty and call play').
run :- easy,\+ medium,\+ hard,cleanup,init.
run :- medium,\+ easy,\+ hard,cleanup,init.
run :- hard,\+ medium,\+ easy,cleanup,init.

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

