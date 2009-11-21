:-module(dijkstra, [dijkstra/6]).



/*
	quelElementEn :
		Courant : envoyer 0
		I : indice interessant (celui que l'on veux voir)
		Element : valeur de retour : code prolog de l'élément ( 2 = diamant par exemple)
		L : Liste des éléments
*/
quelElementEn(Courant, I, Element, [T|_]) :- Courant = I, !, Element is T.
quelElementEn(Courant, I, Element, [_|R]) :- Courant2 is Courant + 1, quelElementEn(Courant2, I, Element, R).



/*
	passage : renvoie vrai si un pasage est possible d'une case A à une case B dans L qui à pour longueur de ligne Size
	OU affecte à B la case possible a atteindre
*/
% en haut
passageH(A, B, Size, L) :- Ay is A // Size,
						  Ay > 0,
						  B is A - Size - 2,
						  quelElementEn(0, B, El, L),
						  ( El < 3 ; El = 17 ).

% en bas
passageB(A, B, Size, L) :- Ay is A // Size,
						  NbLigne is 25 // Size,
						  Ay =< NbLigne,
						  B is A + Size + 2,
						  quelElementEn(0, B, El, L),
						  ( El < 3 ; El = 17 ).

% a gauche
passageG(A, B, Size, L) :- Ax is A mod Size,
						  Ax > -1,
						  B is A - 1,
						  quelElementEn(0, B, El, L),
						  ( El < 3 ; El = 17 ).


% a droite
passageD(A, B, Size, L) :- Ax is A mod Size,
						  Ax < Size,
						  B is A + 1,
						  quelElementEn(0, B, El, L),
						  ( El < 3 ; El = 17 ).


						  
/*
	construirePassages : 
		Courant : indice en cour de résolution
		L : Map
		S : Taille de la carte
		
	Fait des assert du prédicat lien(A, B) qui veux dire que l'on peux passer de al case A a la case B
*/

% va faire des assert lien(A,B) si on peux passer de A à B
construirePassagesB(Courant, L, Size) :- length(L, Long),
										Courant1 is Courant + 1,
										Courant1 < Long,
										quelElementEn(0, Courant1, El, L),
										%El < 3,
										passageB(Courant1, B, Size, L),
										!,
										write(Courant1), write(' '), write(B), write('     '),
										assert(lien(Courant1, B)),
										construirePassagesB(Courant1, L, Size),
										fail.

construirePassagesB(Courant, L, Size) :- length(L, Long),
										Courant1 is Courant + 1,
										Courant1 < Long,
										construirePassagesB(Courant1, L, Size),
										fail.


construirePassagesD(Courant, L, Size) :- length(L, Long),
										Courant1 is Courant + 1,
										Courant1 < Long,
										quelElementEn(0, Courant1, El, L),
										%El < 3,
										passageD(Courant1, B, Size, L),
										!,
										write(Courant1), write(' '), write(B), write('     '),
										assert(lien(Courant1, B)),
										construirePassagesD(Courant1, L, Size),
										fail.

construirePassagesD(Courant, L, Size) :- length(L, Long),
										Courant1 is Courant + 1,
										Courant1 < Long,
										construirePassagesD(Courant1, L, Size),
										fail.


construirePassagesH(Courant, L, Size) :- length(L, Long),
										Courant1 is Courant + 1,
										Courant1 < Long,
										quelElementEn(0, Courant1, El, L),
										%El < 3,
										passageH(Courant1, B, Size, L),
										!,
										write(Courant1), write(' '), write(B), write('     '),
										assert(lien(Courant1, B)),
										construirePassagesH(Courant1, L, Size),
										fail.

construirePassagesH(Courant, L, Size) :- length(L, Long),
										Courant1 is Courant + 1,
										Courant1 < Long,
										construirePassagesH(Courant1, L, Size),
										fail.



construirePassagesG(Courant, L, Size) :- length(L, Long),
										Courant1 is Courant + 1,
										Courant1 < Long,
										quelElementEn(0, Courant1, El, L),
										%El < 3,
										passageG(Courant1, B, Size, L),
										!,
										write(Courant1), write(' '), write(B), write('     '),
										assert(lien(Courant1, B)),
										construirePassagesG(Courant1, L, Size),
										fail.

construirePassagesG(Courant, L, Size) :- length(L, Long),
										Courant1 is Courant + 1,
										Courant1 < Long,
										construirePassagesG(Courant1, L, Size),
										fail.



construirePassages(L, Size) :- not(construirePassagesB(-1, L, Size)),
				   not(construirePassagesD(-1, L, Size)),
				   not(construirePassagesG(-1, L, Size)),
				   not(construirePassagesH(-1, L, Size)),
				   fail.

				   

/*
	supprime tous les prédicats lien/2
*/
detruirePassages(_) :- abolish(lien/2).







/***********************************************************************************************
	Algo de résolution de chemin :
	prit ici : http://pcaboche.developpez.com/article/prolog/algo-graphes/?page=page_2
	et à peine modifié
*/

%
% Dijkstra
%   + Start        : Point de départ
%   + Finish       : Point de d'arrivée
%   - ShortestPath : Chemin le plus court
%   - Len          : Longueur de ce chemin
%


dijkstra(Start, Finish, ShortestPath, Len, L, Size) :-
  detruirePassages(0),
  not(construirePassages(L, Size)),
  dijk( [0-[Start]], Finish, RShort, Len, L, Size),
  reverse(RShort, ShortestPath).



% Le dernier point visité est le point d'arrivée => on s'arrête
%

dijk( [ Len-[Fin|RPath] |_], Fin, [Fin|RPath], Len, L, Size) :- !.


dijk( Visited, Fin, RShortestPath, Len, L, Size) :-
  % Recherche du meilleur candidat (prochain point à ajouter au graphe)
  %   et appel récursif au prédicat
  %

  bestCandidate(Visited, BestCandidate, L, Size),
  dijk( [BestCandidate|Visited], Fin, RShortestPath, Len, L, Size).



%
% Recherche toutes les arrêtes pour lesquelles on a:
%  - un point dans le graphe (visité)
%  - un point hors du graphe (candidat)
%
% Retourne le point qui minimise la distance par rapport à l'origine
%


bestCandidate(Paths, BestCandidate, L, Size) :-

  % à partir d'un point P1 :

  findall(
     NP            % on fait la liste de tous les points P2 tels que:
  ,
    (
      member( Len-[P1|Path], Paths),  % - le point P2 a déjà été visité
      %arc(P1,P2, Dist),                % - il existe un arc allant de P1 à P2, de distance Dist
     lien(P1, P2),
     \+isVisited(Paths, P2),         % - le point P2 n'a pas encore été visité

      NLen is Len+1,               % on calcule la distance entre l'origine et le point P2

      NP=NLen-[P2,P1|Path]            % on met chaque élément de la liste sous la forme: Distance-Chemin
                                      % pour pouvoir les trier avec le prédicat keysort/2
    )
  ,
    Candidates
  ),

  % On trie et on retient le chemin le plus court
  minimum(Candidates, BestCandidate).



%
% Sort le meilleur candidat parmi une liste de candidats
% (= celui de chemin le moins long)
%

minimum(Candidates, BestCandidate) :-
  keysort(Candidates, [BestCandidate|_]).



%
% Teste si un point P a déjà été visité
%

isVisited(Paths, P) :-
  memberchk(_-[P|_], Paths).

