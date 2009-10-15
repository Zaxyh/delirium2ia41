/*


  Définition de l'IA du mineur

  Les prédicats setViewPerimeter/2 et move/6 sont consultés dans le jeu.


*/


/*
  setViewPerimeter( -SX,-SY )

  Périmètre de vue du mineur.
  Si SX=0 ou SY=0, le mineur a une connaissance globale du sous-terrain.
  Si SX>0 et SY>0, le mineur perçoit l'ensemble des (2*SX+1)*(2*SY+1) cases autour de lui.
*/

setViewPerimeter( 0,0 ).


/*
  move( +L,+X,+Y,+Pos,+Size,+CanGotoExit,-Dx,-Dy )

  * L représente la liste des items perçus par le mineur
  * (X,Y) représente la position absolue du mineur dans la zone
  * Pos représente la position du mineur dans la liste L
  * Size représente le nombre d'items dans une ligne stockée dans la liste L.
    Soit P la position du mineur dans la liste. Alors :
    * P-1 indique la case à sa gauche,
    * P+1 indique la case à sa droite,
    * P-Size indique la case en haut,
    * P+Size indique la case en bas
  * CanGotoExit indique si le mineur peut atteindre la sortie ou non
  * (Dx,Dy) représente le mouvement que le mineur doit effectuer sur la base de ce qu'il a perçu
*/

% Mouvement aléatoire avec le prédicat move/8

%move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy ) :- D is random( 5 ), dir( D, Dx, Dy ).


move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy ) :- CanGotoExit = 1,
																trouverOuAller(X, Y, L, Size, Direction, CanGotoExit),
																dir( Direction, Dx, Dy ), 
																!.
			
move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy) :- member( 2, L ),
																trouverOuAller(X, Y, L, Size, Direction, CanGotoExit), 
																dir( Direction, Dx, Dy ), 
																!.



%SiAlorsSinon(Condition, Alors, _) :- Condition, !, Alors.
%SiAlorsSinon(_,_,Sinon) :- Sinon.

/* 
	trouve la position du diamant le plus proche, enfin en ligne par ligne bof bof
	L : la liste des cases
	Code : code de l'élément à trouver , par exemple 2 pour les diamants
	Indice : indice en cours d'inspection (envoyer 0 lors de l'appel)
	I : Contiendra l'indice de la case contenant le diamant : valeur de retour
*/
trouverPositionElement([T|R], Code, Indice, I) :- T=Code, I is Indice, !.
trouverPositionElement([_|R], Code, Indice, I) :- Indice2 is Indice + 1, trouverPositionElement(R, Code, Indice2, I), !.


/* 
	plus court chemin pour atteindre une destination Xd, Yd a partir des coordonnées du joueur Xp, Yp
	Pas de gestion des obstacles
  0 : gauche
  1 : droite
  2 : haut
  3 : bas
*/
pccDestination(Xp, _, Xd, _, D) :- Xp > Xd, !, D is 0.
pccDestination(Xp, _, Xd, _, D) :- Xp < Xd, !, D is 1.
pccDestination(_, Yp, _, Yd, D) :- Yp > Yd, !, D is 2.
pccDestination(_, Yp, _, Yd, D) :- Yp < Yd, !, D is 3.
pccDestination(_, _, _, _, D) :-  D is 4.

/*
	renvoie la direction la plus courte pour atteindre le diamant
*/
trouverPpcDiamant(Xplayer, Yplayer , L, Size, D) :- 	trouverPositionElement(L, 2, 0, I),
														Ydiamant is (I // Size), 
														Xdiamant is (I mod Size),
														ecrire(I),
														ecrire(Size),
														ecrire(L),
														ecrire('xdiam'), ecrire(Xdiamant),
														ecrire('ydiam'), ecrire(Ydiamant),
														ecrire('xplayer'), ecrire(Xplayer),
														ecrire('yplayer'), ecrire(Yplayer),
														ecrire('   '),
														pccDestination(Xplayer, Yplayer, Xdiamant, Ydiamant, D2),
														D is D2.
/*
	renvoie la direction la plus courte pour atteindre la sortie
*/
trouverPpcSortie(Xplayer, Yplayer , L, Size, D) :- 		trouverPositionElement(L, 17, 0, I),
														Ysortie is (I // Size), 
														Xsortie is (I mod Size) ,
														ecrire(I),
														ecrire(L),
														ecrire('xsortie'), ecrire(Xsortie),
														ecrire('ysortie'), ecrire(Ysortie),
														ecrire('xplayer'), ecrire(Xplayer),
														ecrire('yplayer'), ecrire(Yplayer),
														ecrire('   '),
														pccDestination(Xplayer, Yplayer, Xsortie, Ysortie, D2),
														D is D2.
/* 
	trouve ou aller s il reste des diamants 
	Xplayer, Yplayer : position du joueur
	L : Map du jeux
	Size : longeur d'une ligne du jeux
	Direction : direction à prendre
	CanGotoExit : peux aller a la sortie
*/
trouverOuAller(Xplayer, Yplayer , L, Size, Direction, CanGotoExit) :- 	CanGotoExit = 0,
																		!, 
																		trouverPpcDiamant(Xplayer, Yplayer , L, Size, D),
																		Direction is D.
% aller a la sortie				
trouverOuAller(Xplayer, Yplayer , L, Size, Direction, CanGotoExit) :-	CanGotoExit = 1,
																		member( 17, L ),
																		!,
																		ecrire('je cherche la sortie'),
																		trouverPpcSortie(Xplayer, Yplayer , L, Size, D),
																		Direction is D.					


/*
  move( +L,+X,+Y,+Pos,+Size,+CanGotoExit,-Dx,-Dy,+VPx,+VPy,-NewVPx,-NewVPy )

  * L représente la liste des items perçus par le mineur
  * (X,Y) représente la position absolue du mineur dans la zone
  * Pos représente la position du mineur dans la liste L
  * Size représente le nombre d'items dans une ligne stockée dans la liste L.
    Soit P la position du mineur dans la liste. Alors :
    * P-1 indique la case à sa gauche,
    * P+1 indique la case à sa droite,
    * P-Size indique la case en haut,
    * P+Size indique la case en bas
  * CanGotoExit indique si le mineur peut atteindre la sortie ou non
  * (Dx,Dy) représente le mouvement que le mineur doit effectuer sur la base de ce qu'il a perçu
  * VPx et VPy représente le périmètre de vue actuel utilisé pour générer L
  * NewVPx et NewVPy représente le nouveau périmètre de vue du mineur
*/

% Mouvement aléatoire avec le prédicat move/12
%  avec augmentation du périmètre de vue si aucun diamant n'est en vue
			


%move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _ ) :- ecrire(L), member( 2, L ), D is random( 5 ), dir( D, Dx, Dy ), !.
%move( L, X, Y, Pos, Size, CanGotoExit, _, _, Vx, Vy, Vx1, Vy1 ) :- Vx1 is Vx+1, Vy1 is Vy+1.


ecrire( T ) :- open( 'trace.txt', append, L ), write( L, T ), nl( L ), close( L ).


/*
  Définition des quatre directions
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
  Affichage des coordonnées du mineur et d'un texte adéquat s'il a ramassé tous les diamants nécessaires
*/

display( X,Y,0 ) :- write( X ), write( ',' ), write( Y ), nl.
display( X,Y,1 ) :- write( X ), write( ',' ), write( Y ), write( ' - Tous les diamants necessaires ont ete recoltes !' ), nl.
