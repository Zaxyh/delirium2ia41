:-module(plusCourtChemin, [solve/5]).
:-use_module('outilsCarte').

								
/*
	passageX(+A, -B, +Size, +L)
*/

/*
 en haut
*/
% si ya rien en haut
passageH(A, B, Size, L) :- numCaseHaut(A, Size, B),
						   getElement(L, B, El),
						   ( El < 3 ; El = 17 ).
						   
/*						  
en bas
*/
passageB(A, B, Size, L) :- numCaseBas(A, Size, B),
						   getElement(L, B, El), 
						   ( El < 3 ; El = 17 ).

/*						  
a gauche
*/
passageG(A, B, Size, L) :- numCaseGauche(A, Size, B),
						   getElement(L, B, El),
						   ( El < 3 ; El = 17 ).

% rocher méthode express
passageG(A, B, Size, L) :- numCaseGauche(A, Size, B),
						   getElement(L, B, El),
						   ( El = 3 ).
						   
/*
a droite
*/
passageD(A, B, Size, L) :- numCaseDroite(A, Size, B),
						   getElement(L, B, El),
						   ( El < 3 ; El = 17 ).



						   
s(A, B, 0, L, Size) :- passageD(A, B, Size, L).
s(A, B, 0, L, Size) :- passageH(A, B, Size, L).
s(A, B, 0, L, Size) :- passageG(A, B, Size, L).
s(A, B, 0, L, Size) :- passageB(A, B, Size, L).


h(A, Distance, B, Size) :-
		Xa is A mod Size,
		Ya is A // Size,
		Xb is B mod Size,
		Yb is B // Size,
		Distance is ( (Xb-Xa)*(Xb-Xa) + (Yb-Ya)*(Yb-Ya) ).


trouverPositionElement2([T|R], Code, Indice, I) :- T=Code, I is Indice, !.
trouverPositionElement2([_|R], Code, Indice, I) :- Indice2 is Indice + 1, trouverPositionElement2(R, Code, Indice2, I), !.



solve(Start, SolPath, L, Size, Finish) :-
	astar([[[Start], 0]], SolPath, L, Size, Finish).

astar([BestPath|Paths], Path, L, Size, Finish) :-
	BestPath = [Path, Cost],
	Path = [LastNode|_],
	LastNode=Finish, !.

astar([BestPath|Paths], SolPath, L, Size, Finish) :-
	BestPath = [Path, Cost],
	Path = [LastNode|_],
	extend(Path, Cost, Paths, NewPaths, L, Size, Finish),
	astar(NewPaths, SolPath, L, Size, Finish).

% extend best path by successors of last node

extend(Path, Cost, Paths, NewPaths, L, Size, Finish) :-
	Path = [LastNode|_],
	findall(S, ( s(LastNode, S, _, L, Size) , not(member(S, Path))) , Succs), %successor(A, B, 0, L, Size)
	/* @bigz : j'ai ajouté le not(member(S, Path)) mais je ne sais pas si c'est une bonne idée ... */
	%write('Je suis en :\n'), write(LastNode), write('\n et les solutions : \n'), write(S),
	not(Succs = []),
	extend_path(Succs, Path, Cost, Paths, NewPaths, L, Size, Finish).

% extend path by each node in Succs and insert into Paths in order of costs

extend_path([], _, _, Paths, Paths, L, Size, Finish).		% no more paths

extend_path([S|Succs], Path, Cost, Paths, Paths2, L, Size, Finish) :-
	Path = [LastNode|_],
	s(LastNode, S, C, L, Size),%successor(A, B, 0, L, Size)
	NewCost is Cost + C,			% g(S) = NewCost
	h(S, H, Finish, Size),				% h(S) = estimate S->goal %% value(A, D, B, L, Size)
	NewEst is NewCost + H,			% f(S) = estimate of node's value
	insert([S|Path], NewCost, NewEst, Paths, Paths1, L, Size, Finish),
	extend_path(Succs, Path, Cost, Paths1, Paths2, L, Size, Finish).

% insert path in order in the list of paths

insert(Path, Cost, Estimate, [], [[Path, Cost]], L, Size, Finish).

insert(Path, Cost, Estimate, Paths, [[Path, Cost]|Paths], L, Size, Finish) :-
	Paths = [Path1|_],
	Path1 = [[Last1|_], Cost1],
	h(Last1, H, Finish, Size),
	Estimate1 is Cost1 + H,
	Estimate1 > Estimate.			% new path is better

insert(Path, Cost, Estimate, [Path1|Paths], [Path1|Paths1], L, Size, Finish) :-
	insert(Path, Cost, Estimate, Paths, Paths1, L, Size, Finish).
