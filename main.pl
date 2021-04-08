:- use_module(library(pce)).
:- use_module(library(time)).
:- include('eventHandlers.pl').
:- include('guiUtil.pl').

run1 :- time(run).

% run the program with this
run :- cleanup,init.

% game setup
init :- 
    mineFrame(MAINFRAME),
    minePlayingField(P,MAINFRAME),
    mineControls(P,MAINFRAME,ID),
    send(P,open),
    mines(B),
    minecounter(B,=,Q),
    flagcounter(0,=,R),
    mapSize(MX,MY),
    % map of tileStates
    generateStartingState(MX,MY,STATEMAP),
    % placeholder for map of mines
    exampleMap(MINESMAP),
    placeMap(P,MINESMAP,STATEMAP),
    countdown(0,@c).
    % countdown(0,@c,e).


% works but looks bad, TODO maybe keep frame and redo sub elements
restart([P,M]) :- 
    free(P),
    free(M),
    run.

% timer(ID) :- alarm(1,countdown(0,@c,ID),ID).

% countdown(X,P,Id) :- 
%     get(@c,value,A),
%     atom_number(A,X),
%     X1 is X + 1,
%     send(@c,string,X1),
%     alarm(1,countdown(0,@c,ID),_).