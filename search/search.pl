% search.pl

% Entry point: produce the shortest sequence including unlocks
search(Actions) :-
    initial(Start),
    % pick up any key in the start room
    ( key(Start,C) -> Keys0 = [C] ; Keys0 = [] ),
    treasure(Goal),
    bfs([[Start, Keys0, []]], [Start-Keys0], Goal, RevMoves),
    reverse(RevMoves, Actions).

% bfs(+Queue,+Visited,+Goal,-MovesReversed)
bfs([[Room, _, Moves]|_], _, Room, Moves).
bfs([[Room, Keys, Moves]|Queue], Visited, Goal, Result) :-
    Room \= Goal,
    findall(
      [ Next, Keys2, NewMoves ],
      (
        edge(Room, Next, Lock),
        % build the new Moves list, inserting unlock(Color) if needed
        ( Lock = none ->
            Base = [ move(Room,Next) | Moves ],
            KeysTemp = Keys
        ;
          Lock = Color,
          member(Color, Keys),     % we have the key
          Base = [ move(Room,Next), unlock(Color) | Moves ],
          KeysTemp = Keys
        ),
        % collect any new key in Next
        collect_key(Next, KeysTemp, Keys2),
        NewMoves = Base
      ),
      NextStates
    ),
    append(Queue, NextStates, NewQueue),
    % add newly visited Room‑Keys combos
    findall(N-K, member([N,K,_], NextStates), NewVisited),
    append(Visited, NewVisited, Visited2),
    bfs(NewQueue, Visited2, Goal, Result).

% Undirected edges: either a plain door (none) or a locked one (Color)
edge(A, B, none)    :- door(A,B).
edge(A, B, none)    :- door(B,A).
edge(A, B, Color)   :- locked_door(A,B,Color).
edge(A, B, Color)   :- locked_door(B,A,Color).

% If a room has a key you don’t yet hold, add it
collect_key(Room, Keys, [C|Keys]) :-
    key(Room, C),
    \+ member(C, Keys).
collect_key(_, Keys, Keys).
