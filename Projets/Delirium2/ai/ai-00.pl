:-use_module('outilsCarte').
:-use_module('plusCourtChemin').
:-use_module('eviterMonstre').

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
											dijkstra(Start, Finish, [T,N|_], Len, L, Size2), % tete : ou je suis, N : next case
											quelleSuivante(T, N, D2, Size),
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

move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _ ) :- eviterMonstre(L, Pos, Size, Direction),
																dir( Direction, Dx, Dy ), 
																ecrire('Il y a eu danger'),
																!.

move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _ ) :- CanGotoExit = 1,
																trouverOuAller(X, Y, L, Size, Direction, CanGotoExit),
																dir( Direction, Dx, Dy ), ecrire('ok on va a la sortie'),
																!.
			
move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _) :-  member( 2, L ), 
																trouverOuAller(X, Y, L, Size, Direction, CanGotoExit), 
																dir( Direction, Dx, Dy ), ecrire('ok on prendl e diamant'), 
																!.

move( L, X, Y, Pos, Size, CanGotoExit, _, _, Vx, Vy, Vx1, Vy1 ) :- Vx1 is Vx+1, Vy1 is Vy+1.


ecrire( T ) :- open( 'trace.txt', append, L ), write( L, T ), nl( L ), close( L ).

ecrire2( T ) :- open( 'dangerMonstre.txt', append, L ), write( L, T ), nl( L ), close( L ).

ecrire3( T ) :- open( 'L.txt', append, L ), write( L, T ), nl( L ), close( L ).

ecrireL([]) :- ecrire3('------------------------------------------------').
ecrireL([T|R]) :- 
	ecrire3(T), ecrireL(R).

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

