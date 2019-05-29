:- consult(counter).
:- consult(eightPuzzle).
:- consult(queues).

/*
Limitations:
- after running the program, prolog needs to be closed and reopened for it to work again
- takes a long time on large problem sizes i.e when the goal state is far from the initial state.  It does solve it though
- statistics hasn't been implemented.  It's just been hard-coded in so that breadthFirstSearch will run when given 3 parameters
*/

breadthFirstSearch(InitialState, Solution, Statistics) :- 
	make_queue(StateQueue),											% make queue Frontier
	join_queue(InitialState, StateQueue, Frontier),					% add to Frontier
	assert(closed(root, InitialState)),
	bfs(Frontier, Result),
	queue_to_list(Result, Solution),
	Statistics = (0,0,0,1),
	
	retractall(closed(_)),
	retractall(join_queue(_)),
	retractall(serve_queue(_)),
	retractall(jump_queue(_)),
	retractall(bfs(_)),
	retractall(addNeighbours(_)),
	retractall(succ8(_)),
	retractall(contains(_)),
	retractall(extractSolution(_)).


bfs(InitialQueue, Result) :- 
	contains([1,2,3,4,5,6,7,8,0], InitialQueue), 					 % base case
	make_queue(SolutionQueue),
	extractSolution([1,2,3,4,5,6,7,8,0], SolutionQueue, PathQueue),
	Result = PathQueue.
bfs(InitialQueue, Result) :- 
	serve_queue(InitialQueue, FrontElement, RemovedQueue), 			% dequeue
	succ8(FrontElement, Neighbours),								% get neighbours
	addNeighbours(Neighbours, FrontElement, RemovedQueue, NewQueue),
	bfs(NewQueue, Result).
	
	 
	
addNeighbours([], Parent, OldQueue, NewQueue) :- NewQueue = OldQueue.		% if Neighbours queue is empty
addNeighbours([(_, State) | _], Parent, OldQueue, NewQueue) :-		% if first element is goal state
	goal8(State),
	join_queue(State, OldQueue, JoinedQueue),
	assert(closed(Parent, State)),
	NewQueue = JoinedQueue.
addNeighbours([(_, State) | Tail], Parent, OldQueue, NewQueue) :-		% if first element isn't in any queue 
	not(closed(_, State)),
	not(contains(State, OldQueue)),
	assert(closed(Parent, State)),
	join_queue(State, OldQueue, JoinedQueue),
	addNeighbours(Tail,  Parent, JoinedQueue, NewQueue).
addNeighbours([(_, State)| Tail], Parent, OldQueue, NewQueue) :-		% if first element is already in a queue
	contains(State, OldQueue),
	addNeighbours(Tail,  Parent, OldQueue, NewQueue);
	closed(_, State),
	addNeighbours(Tail,  Parent, OldQueue, NewQueue).
	
contains(State, Queue) :- serve_queue(Queue, FrontElement, RemovedQueue), State == FrontElement.
contains(State, Queue) :- serve_queue(Queue, FrontElement, RemovedQueue), contains(State, RemovedQueue).

extractSolution(State, Queue, Solution) :- closed(root, State), jump_queue(State, Queue, PathQueue), Solution = PathQueue.
extractSolution(State, Queue, Solution) :-
	closed(Parent, State),
	jump_queue(State, Queue, PathQueue),
	extractSolution(Parent, PathQueue, Solution).		% iterates through closed() by starting at goal and going up tree until initial state(root) is found
	
	