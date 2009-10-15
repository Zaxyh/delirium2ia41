/*
  D�finition de l'IA du mineur
  Les pr�dicats setViewPerimeter/2 et move/6 sont consult�s dans le jeu.
*/


/*
  setViewPerimeter( -SX,-SY )
  P�rim�tre de vue du mineur.
  Si SX=0 ou SY=0, le mineur a une connaissance globale du sous-terrain.
  Si SX>0 et SY>0, le mineur per�oit l'ensemble des (2*SX+1)*(2*SY+1) cases autour de lui.
*/
setViewPerimeter( 3,3 ).


/* 
	trouve la position du diamant le plus proche � partir du coin haut-gauche, enfin en ligne par ligne bof bof
	L : la liste des cases
	Code : code de l'�l�ment � trouver , par exemple 2 pour les diamants
	Indice : indice en cours d'inspection (envoyer 0 lors de l'appel)
	I : Contiendra l'indice de la case contenant le diamant : valeur de retour
*/
trouverPositionElement([T|R], Code, Indice, I) :- T=Code, I is Indice, !.
trouverPositionElement([_|R], Code, Indice, I) :- Indice2 is Indice + 1, trouverPositionElement(R, Code, Indice2, I), !.


/* 
	plus court chemin pour atteindre une destination Xd, Yd a partir des coordonn�es du joueur Xp, Yp
	Pas de gestion des obstacles
*/
pccDestination(Start, Finish, L, Size, D) :- Size2 is Size - 2,
											%ecrire('Les donn�es du probl�me : '),
											%ecrire(Start), ecrire(Finish), ecrire(L), ecrire(Size2),
											%ecrire('hum... le bon chemin est :'),
											%dijkstra(Start, Finish, R, Len, L, Size2),
											%ecrire(R),
											dijkstra(Start, Finish, [T,N|_], Len, L, Size2), % tete : ou je suis, N : next case
											quelleSuivante(T, N, D2, Size),
											%ecrire('Je suis en :'),
											%ecrire(T),
											%ecrire('Je veux aller en :'),
											%ecrire(N),
											%ecrire('Donc je prend la direction :'),
											%ecrire(D2),
											%ecrire(' '),
											D is D2.

/*
	quelle est la direction pour la case suivante ? : C : courant, N : next, D : direction
  0 : gauche
  1 : droite
  2 : haut
  3 : bas
*/
quelleSuivante(C, N, D, _) 		:- C2 is C + 1, N = C2, !, D is 1.
quelleSuivante(C, N, D, _) 		:- C2 is C - 1, N = C2, !, D is 0.
quelleSuivante(C, N, D, Size) 	:- C2 is C + Size, N = C2, !, D is 3.
quelleSuivante(C, N, D, Size) 	:- C2 is C - Size, N = C2, !, D is 2.
%quelleSuivante(_, _, D, _) 		:- ecrire('ALEATOIRE !'), D is random(5). 
quelleSuivante(_, _, D, _) 		:- ecrire('Bloque !'), D is 4.
 
/*
	renvoie la direction � prendre pour atteindre le diamant
*/
trouverPpcDiamant(L, Size, D) :- 	trouverPositionElement(L, 2, 0, I),   %  I = position diamant
									trouverPositionElement(L, 10, 0, I2), %  I2 = position joueur
									pccDestination(I2, I, L, Size ,D).
/*
	renvoie la direction � prendre pour atteindre le diamant
*/
trouverPpcSortie(L, Size, D) :- trouverPositionElement(L, 17, 0, I),  %  I = position sortie
								trouverPositionElement(L, 10, 0, I2), %  I2 = position joueur
								pccDestination(I2, I, L, Size ,D).
								
/* 
	trouve ou aller s il reste des diamants 
	Xplayer, Yplayer : position du joueur
	L : Map du jeux
	Size : longeur d'une ligne du jeux
	Direction : direction � prendre
	CanGotoExit : peux aller a la sortie
*/
trouverOuAller(Xplayer, Yplayer , L, Size, Direction, CanGotoExit) :- 	CanGotoExit = 0,
																		!, 
																		trouverPpcDiamant(L, Size, Direction).

% aller a la sortie				
trouverOuAller(Xplayer, Yplayer , L, Size, Direction, CanGotoExit) :-	CanGotoExit = 1,
																		member( 17, L ),
																		!,
																		%ecrire('je cherche la sortie'),
																		trouverPpcSortie(L, Size, Direction).	


/*
  move( +L,+X,+Y,+Pos,+Size,+CanGotoExit,-Dx,-Dy,+VPx,+VPy,-NewVPx,-NewVPy )

  * L repr�sente la liste des items per�us par le mineur
  * (X,Y) repr�sente la position absolue du mineur dans la zone
  * Pos repr�sente la position du mineur dans la liste L
  * Size repr�sente le nombre d'items dans une ligne stock�e dans la liste L.
    Soit P la position du mineur dans la liste. Alors :
    * P-1 indique la case � sa gauche,
    * P+1 indique la case � sa droite,
    * P-Size indique la case en haut,
    * P+Size indique la case en bas
  * CanGotoExit indique si le mineur peut atteindre la sortie ou non
  * (Dx,Dy) repr�sente le mouvement que le mineur doit effectuer sur la base de ce qu'il a per�u
  * VPx et VPy repr�sente le p�rim�tre de vue actuel utilis� pour g�n�rer L
  * NewVPx et NewVPy repr�sente le nouveau p�rim�tre de vue du mineur
*/

% Mouvement al�atoire avec le pr�dicat move/12
%  avec augmentation du p�rim�tre de vue si aucun diamant n'est en vue

move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _ ) :- CanGotoExit = 1,
																trouverOuAller(X, Y, L, Size, Direction, CanGotoExit),
																dir( Direction, Dx, Dy ), 
																!.
			
move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _) :- 	member( 2, L ), 
																trouverOuAller(X, Y, L, Size, Direction, CanGotoExit), 
																dir( Direction, Dx, Dy ), 
																!.

move( L, X, Y, Pos, Size, CanGotoExit, _, _, Vx, Vy, Vx1, Vy1 ) :- Vx1 is Vx+1, Vy1 is Vy+1.


ecrire( T ) :- open( 'trace.txt', append, L ), write( L, T ), nl( L ), close( L ).


/*
  D�finition des quatre directions
  0 : gauche
  1 : droite
  2 : haut
  3 : bas
*/

dir( 0,-1, 0 ).
dir( 1, 1, 0 ).
dir( 2, 0,-1 ).
dir( 3, 0, 1 ).
dir( 4, 0, 0 ).


/*
  Affichage des coordonn�es du mineur et d'un texte ad�quat s'il a ramass� tous les diamants n�cessaires
*/

display( X,Y,0 ) :- write( X ), write( ',' ), write( Y ), nl.
display( X,Y,1 ) :- write( X ), write( ',' ), write( Y ), write( ' - Tous les diamants necessaires ont ete recoltes !' ), nl.



/*
	quelElementEn :
		Courant : envoyer 0
		I : indice interessant (celui que l'on veux voir)
		Element : valeur de retour : code prolog de l'�l�ment ( 2 = diamant par exemple)
		L : Liste des �l�ments
*/
quelElementEn(Courant, I, Element, [T|_]) :- Courant = I, !, Element is T.
quelElementEn(Courant, I, Element, [_|R]) :- Courant2 is Courant + 1, quelElementEn(Courant2, I, Element, R).

/*
	passage : renvoie vrai si un pasage est possible d'une case A � une case B dans L qui � pour longueur de ligne Size
	OU affecte � B la case possible a atteindre
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
		Courant : indice en cour de r�solution
		L : Map
		S : Taille de la carte
		
	Fait des assert du pr�dicat lien(A, B) qui veux dire que l'on peux passer de al case A a la case B
*/

% va faire des assert lien(A,B) si on peux passer de A � B
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
	supprime tous les pr�dicats lien/2
*/
detruirePassages(_) :- abolish(lien/2).















/***********************************************************************************************
	Algo de r�solution de chemin :
	prit ici : http://pcaboche.developpez.com/article/prolog/algo-graphes/?page=page_2
	et � peine modifi�
*/

%
% Dijkstra
%   + Start        : Point de d�part
%   + Finish       : Point de d'arriv�e
%   - ShortestPath : Chemin le plus court
%   - Len          : Longueur de ce chemin
%


dijkstra(Start, Finish, ShortestPath, Len, L, Size) :-
  detruirePassages(0),
  not(construirePassages(L, Size)),
  dijk( [0-[Start]], Finish, RShort, Len, L, Size),
  reverse(RShort, ShortestPath).



% Le dernier point visit� est le point d'arriv�e => on s'arr�te
%

dijk( [ Len-[Fin|RPath] |_], Fin, [Fin|RPath], Len, L, Size) :- !.


dijk( Visited, Fin, RShortestPath, Len, L, Size) :-
  % Recherche du meilleur candidat (prochain point � ajouter au graphe)
  %   et appel r�cursif au pr�dicat
  %

  bestCandidate(Visited, BestCandidate, L, Size),
  dijk( [BestCandidate|Visited], Fin, RShortestPath, Len, L, Size).



%
% Recherche toutes les arr�tes pour lesquelles on a:
%  - un point dans le graphe (visit�)
%  - un point hors du graphe (candidat)
%
% Retourne le point qui minimise la distance par rapport � l'origine
%


bestCandidate(Paths, BestCandidate, L, Size) :-

  % � partir d'un point P1 :

  findall(
     NP            % on fait la liste de tous les points P2 tels que:
  ,
    (
      member( Len-[P1|Path], Paths),  % - le point P2 a d�j� �t� visit�
      %arc(P1,P2, Dist),                % - il existe un arc allant de P1 � P2, de distance Dist
     lien(P1, P2),
     \+isVisited(Paths, P2),         % - le point P2 n'a pas encore �t� visit�

      NLen is Len+1,               % on calcule la distance entre l'origine et le point P2

      NP=NLen-[P2,P1|Path]            % on met chaque �l�ment de la liste sous la forme: Distance-Chemin
                                      % pour pouvoir les trier avec le pr�dicat keysort/2
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
% Teste si un point P a d�j� �t� visit�
%

isVisited(Paths, P) :-
  memberchk(_-[P|_], Paths).

