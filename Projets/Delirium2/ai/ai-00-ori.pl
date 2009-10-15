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
  move( +L,+X,+Y,+Pos,+Size,+CanGotoExit,-Dx,-Dy )

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
*/

% Mouvement al�atoire avec le pr�dicat move/8

%move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy ) :- D is random( 5 ), dir( D, Dx, Dy ).



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

move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _ ) :- ecrire(L),member( 2, L ), D is random( 5 ), dir( D, Dx, Dy ), !.
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
