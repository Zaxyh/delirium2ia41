:-use_module('outilsCarte').
:-use_module('plusCourtChemin').
:-use_module('eviterMonstre').
:-use_module('situations').

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
setViewPerimeter( 3,3 ).


/* 
        trouve la position du diamant le plus proche à partir du coin haut-gauche, enfin en ligne par ligne bof bof
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
*/
pccDestination(Start, Finish, L, Size, D) :-
                solve(Start, Soln, L, Size, Finish), % tete : ou je suis, N : next case
                not(Soln = []),
                reverse(Soln, Oo),
                nth0(1, Oo, ToGo),
                quelleSuivante(Start, ToGo, D2, Size),
                D is D2.

/*
        quelle est la direction pour la case suivante ? : C : courant, N : next, D : direction
  0 : gauche
  1 : droite
  2 : haut
  3 : bas
  
  quelleSuivante(+Current, +Next, -Direction, +Size)
*/
quelleSuivante(C, N, D, _)              :- C2 is C + 1, N = C2, !, D is 1.
quelleSuivante(C, N, D, _)              :- C2 is C - 1, N = C2, !, D is 0.
quelleSuivante(C, N, D, Size)   :- C2 is C + Size, N = C2, !, D is 3.
quelleSuivante(C, N, D, Size)   :- C2 is C - Size, N = C2, !, D is 2.
%quelleSuivante(_, _, D, _)             :- ecrire('ALEATOIRE !'), D is random(5). 
quelleSuivante(_, _, D, _)              :- ecrire('Bloque !'), D is 4.

/*
trouverPlusProcheDiamant(+positionJoueur, +Map, +Size, -Position)
*/

trouverPlusProcheDiamant(PosPlayer, L, Size, Indice) :-
      XPlayer is PosPlayer mod Size,
      YPlayer is PosPlayer // Size,
      findall(
           Couple,
           (
                nth0(Indice, L, 2),
                XDiamant is Indice mod Size,
                YDiamant is Indice // Size,
                Distance is ( (XDiamant-XPlayer)*(XDiamant-XPlayer) + (YDiamant-YPlayer)*(YDiamant-YPlayer) ),
                Couple = [Distance, Indice]
           ),
           Succs
      ),
      not(Succs = []),
      sort(Succs, S),
      S = [ [_|[Indice]] | _ ].

/*
        renvoie la direction à prendre pour atteindre le diamant
*/
trouverPpcDiamant(L, Size, D) :-     
		%trouverPositionElement(L, 2, 0, I),   %  I = position diamant
		trouverPositionElement(L, 10, 0, I2), %  I2 = position joueur
		trouverPlusProcheDiamant(I2, L, Size, I),
		pccDestination(I2, I, L, Size ,D).
/*
        renvoie la direction à prendre pour atteindre le diamant
*/
trouverPpcSortie(L, Size, D) :- 
		trouverPositionElement(L, 17, 0, I),  %  I = position sortie
		trouverPositionElement(L, 10, 0, I2), %  I2 = position joueur
		pccDestination(I2, I, L, Size ,D).
        


/* 
        trouve ou aller s il reste des diamants 
        Xplayer, Yplayer : position du joueur
        L : Map du jeux
        Size : longeur d'une ligne du jeux
        Direction : direction à prendre
        CanGotoExit : peux aller a la sortie
*/
trouverOuAller(Xplayer, Yplayer , L, Size, Direction, CanGotoExit) :-   
		CanGotoExit = 0,
		!, 
		trouverPpcDiamant(L, Size, Direction).

% aller a la sortie                             
trouverOuAller(Xplayer, Yplayer , L, Size, Direction, CanGotoExit) :-   
		CanGotoExit = 1,
		member( 17, L ),
		!,
		%ecrire('je cherche la sortie'),
		trouverPpcSortie(L, Size, Direction).   


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

move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _ ) :- 
		situations(L, Pos, Size, Direction),
		dir( Direction, Dx, Dy ),!.

move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _ ) :- 
		CanGotoExit = 1,
		eviterMonstre(L, Size, L2),
		trouverOuAller(X, Y, L2, Size, Direction, CanGotoExit),
		dir( Direction, Dx, Dy ),
		ecrire('ok on va a la sortie mais on évite le monstre'),
		!.

move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _ ) :- 
		CanGotoExit = 1,
		trouverOuAller(X, Y, L, Size, Direction, CanGotoExit),
		dir( Direction, Dx, Dy ), 
		%ecrire('ok on va a la sortie'),
		!.

move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _) :-  
		member( 2, L ), 
		eviterMonstre(L, Size, L2),
		trouverOuAller(X, Y, L2, Size, Direction, CanGotoExit),
		ecrire('ok on prendl e diamant mais on évite le monstre'), 
		dir( Direction, Dx, Dy ), 
		!.                      

move( L, X, Y, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _) :- 
		member( 2, L ), 
		trouverOuAller(X, Y, L, Size, Direction, CanGotoExit), 
		%ecrire('ok on prendl e diamant'), 
		dir( Direction, Dx, Dy ), 
		!.

move( L, X, Y, Pos, Size, CanGotoExit, _, _, Vx, Vy, Vx1, Vy1 ) :- Vx1 is Vx+1, Vy1 is Vy+1.


ecrire( T ) :- open( 'trace.txt', append, L ), write( L, T ), nl( L ), close( L ).

ecrire2( T ) :- open( 'dangerMonstre.txt', append, L ), write( L, T ), nl( L ), close( L ).

ecrire3( T ) :- open( 'L.txt', append, L ), write( L, T ), nl( L ), close( L ).

ecrire4( T ) :- open( 'L2.txt', append, L ), write( L, T ), nl( L ), close( L ).

/**
Ecrit dans un fichier indiqué en paramètre
@profil : ecrireFile( +T , +NomFichier )
**/
ecrireFile( T , File ) :- open( File , append, L ), write( L, T ), nl( L ), close( L ).

ecrireL([]) :- ecrire3('------------------------------------------------').
ecrireL([T|R]) :- 
        ecrire3(T), ecrireL(R).

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

