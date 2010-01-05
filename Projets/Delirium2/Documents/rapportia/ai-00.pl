:-use_module('outilsCarte').
:-use_module('plusCourtChemin').
:-use_module('eviterMonstre').
:-use_module('situations').
:-use_module('situations2').

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
trouverPositionElement([T|_], Code, Indice, I) :- T=Code, I is Indice, !.
trouverPositionElement([_|R], Code, Indice, I) :- Indice2 is Indice + 1, trouverPositionElement(R, Code, Indice2, I), !.


/* 
        plus court chemin pour atteindre une destination Xd, Yd a partir des coordonnées du joueur Xp, Yp
        Pas de gestion des obstacles
*/
pccDestination(Start, Finish, L, Size, D) :-
                solve(Start, Soln, L, Size, Finish),
                not(Soln = []),
                reverse(Soln, Oo),
                nth0(1, Oo, ToGo),
                quelleSuivante(Start, ToGo, D, Size).

/*
  quelle est la direction pour la case suivante ? : C : courant, N : next, D : direction
  0 : gauche
  1 : droite
  2 : haut
  3 : bas
  
  quelleSuivante(+Current, +Next, -Direction, +Size)
*/
quelleSuivante(C, N, 1, _) :- 
	C2 is C + 1, 
	N = C2, 
	!.
quelleSuivante(C, N, 0, _) :- 
    C2 is C - 1, 
	N = C2, 
	!.
quelleSuivante(C, N, 3, Size) :- 
    C2 is C + Size,
	N = C2,
	!.
quelleSuivante(C, N, 2, Size) :- 
    C2 is C - Size, 
	N = C2, 
	!.
%quelleSuivante(_, _, D, _) :- ecrire('ALEATOIRE !'), D is random(5). 
quelleSuivante(_, _, 4, _) :- 
	ecrire('Bloque !').

/*
trouverPlusProcheDiamant(+positionJoueur, +Map, +Size, -Destination)
*/

trouverPlusProcheDiamant(PosPlayer, Ldepart, Size, D) :- 
		%ecrire(Size),

	  suppressionDiamantsInnaccessible(Ldepart, PosPlayer, Size, L),

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
	  tenterDeplacement(PosPlayer, S, L, Size, D), 
	  !.
      %S = [ [_|[Indice]] | _ ].

% un monstre nous bloque le passage	  
trouverPlusProcheDiamant(PosPlayer, L, Size, D) :-
		nth0(Indice, L, 12), 
		distance(PosPlayer, Indice, Size, Dist),
		trouverCompromis(PosPlayer, Indice, Dist, Size, L, D).

/*
distance euclidienne entre deux points A et B
distance(+A, +B, +Size, -Distance) 
*/
distance(A, B, Size, Distance) :-
		Xa is A mod Size,
		Ya is A // Size,
		Xb is B mod Size,
		Yb is B // Size,
		Distance is ( (Xb-Xa)*(Xb-Xa) + (Yb-Ya)*(Yb-Ya) ).

/* 
compromis pour fuir un monstre, on cherche à s'en éloigner a tout prit sachant qu'on a pas de passage vers le diamant : 
	trouverCompromis(+PosPlayer, +PositionMonstre, +DistanceMonstre, +Size, +L, -DirectionAPrendre)
*/
% en bas
trouverCompromis(P, PM, DM, Size, L, 3) :- 
		numCaseBas(P, Size, B),
		nth0(B, L, El),
		(El = 0 ; El = 1 ),
		distance(B, PM, Size, DistanceMonstre),
		DistanceMonstre >= DM,
		!.
% a gauche
trouverCompromis(P, PM, DM, Size, L, 0) :- 
		numCaseGauche(P, Size, B),
		nth0(B, L, El),
		(El = 0 ; El = 1 ),
		distance(B, PM, Size, DistanceMonstre),
		DistanceMonstre >= DM,
		!.
% a droite
trouverCompromis(P, PM, DM, Size, L, 1) :- 
		numCaseDroite(P, Size, B),
		nth0(B, L, El),
		(El = 0 ; El = 1 ),
		distance(B, PM, Size, DistanceMonstre),
		DistanceMonstre >= DM,
		!.
% en haut
trouverCompromis(P, PM, DM, Size, L, 2) :- 
		numCaseHaut(P, Size, B),
		nth0(B, L, El),
		(El = 0 ; El = 1 ),
		distance(B, PM, Size, DistanceMonstre),
		DistanceMonstre >= DM,
		!.	
	




tenterDeplacement(_, [], _, _, _) :- !, fail.
	 
tenterDeplacement(From, [[_|[To]]|_], L, Size, D) :-
	pccDestination(From, To, L, Size, D),
	!.
	
tenterDeplacement(From, [_|Others], L, Size, D) :-	  
	tenterDeplacement(From, Others, L, Size, D).
	
/*
        renvoie la direction à prendre pour atteindre le diamant
*/
trouverPpcDiamant(L, Pos, Size, D) :-     
		trouverPlusProcheDiamant(Pos, L, Size, D).

/*
        renvoie la direction à prendre pour atteindre le diamant
*/
trouverPpcSortie(L, Pos, Size, D) :- 
		nth0(I, L, 17),
		pccDestination(Pos, I, L, Size ,D).
        


/* 
        trouve ou aller s il reste des diamants 
        Xplayer, Yplayer : position du joueur
        L : Map du jeux
        Size : longeur d'une ligne du jeux
        Direction : direction à prendre
        CanGotoExit : peux aller a la sortie
*/
trouverOuAller(L, Pos, Size, Direction, CanGotoExit) :-   
		CanGotoExit = 0,
		trouverPpcDiamant(L, Pos, Size, Direction),!.

% aller a la sortie                             
trouverOuAller(L, Pos, Size, Direction, CanGotoExit) :-   
		CanGotoExit = 1,
		trouverPpcSortie(L, Pos, Size, Direction),!.


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


/* Situation 2 */

move( L, _, _, _, Size, _, Dx, Dy, _, _, -1, _ ) :- 
		nth0(P, L, 10),
		situations2(L, P, Size, Z),
		P = Z,
		dir( 4, Dx, Dy ), !.

move( L, _, _, _, Size, _, Dx, Dy, _, _, -1, _ ) :- 
		nth0(P, L, 10),
		situations2(L, P, Size, Goal),
		pccDestination(P, Goal, L, Size, D),
		dir( D, Dx, Dy ), !.		
/* Fin situation 2 */	
		
		
/*
	Si size devient trop importante tentative
	de mouvement aléatoire
*/
move( _, _, _, _, Size, _, Dx, Dy, _, _, -1, _ ) :- 
		Size > 18,
		%D is random(4),
		dir( 1, Dx, Dy ), !.
		
		
move( L, _, _, Pos, Size, _, Dx, Dy, _, _, -1, _ ) :- 
		situations(L, Pos, Size, Direction),
		dir( Direction, Dx, Dy ), !.

move( L, _, _, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _ ) :- 
		CanGotoExit = 1,
		eviterMonstre(L, Size, L2),
		trouverOuAller(L2, Pos, Size, Direction, CanGotoExit),
		dir( Direction, Dx, Dy ),
		!.

move( L, _, _, Pos, Size, CanGotoExit, Dx, Dy, _, _, -1, _) :-  
		member( 2, L ), 
		eviterMonstre(L, Size, L2),
		trouverOuAller(L2, Pos, Size, Direction, CanGotoExit),
		dir( Direction, Dx, Dy ), 
		!.                      

move( _, _, _, _, _, _, _, _, Vx, Vy, Vx1, Vy1 ) :- Vx1 is Vx+1, Vy1 is Vy+1.


suppressionDiamantsInnaccessible(L, Pos, Size, L3) :- 
			
	findall(Indice,(nth0(Indice, L, 2)),ListeIndicesDiamants),
	not(ListeIndicesDiamants = []),
		
	supprimerDiamantsEncercles(L, Size, ListeIndicesDiamants, LI),
	replaceAll(L, LI, L2, 9),
	
	supprimerDiamantsBloques(L2, Pos, Size, L3),
	!.

suppressionDiamantsInnaccessible(L, _, _, L).

isQueMur([]) :- !.
isQueMur([T|R]) :- T =< 9 , T >= 4, isQueMur(R),!.

rechercheIndiceLigneMur([], _, _) :- fail, !.
rechercheIndiceLigneMur([T|_], CPT, CPT) :-
        isQueMur(T),!.
rechercheIndiceLigneMur([_|R], I, CPT) :-
        CPT2 is CPT+1, rechercheIndiceLigneMur(R, I, CPT2),!.
	
listeInt(Debut, Debut, [Debut]):-!.
listeInt(Debut, Fin, [Debut|R]) :- Debut2 is Debut+1, listeInt(Debut2, Fin, R),!.
	
supprimerDiamantsBloques(L, Pos, Size, LFin) :- 
	getLignes(L, Size, L2),
	rechercheIndiceLigneMur(L2, I, 0),
	I > 0, length(L2, LongL2), LongL21 is LongL2 - 1, I < LongL21,
	IDebMur is (Size * I),
	IFinMur is (IDebMur + Size),
	nettoyerLMurBloque(Pos, IDebMur, IFinMur, L, LFin),!.
	
supprimerDiamantsBloques(L, _, _, L) :- !.

nettoyerLMurBloque(Pos, ID, _, L, L2) :- 
	length(L, Long),
	Pos < ID,
	Long2 is Long-1,
	listeInt(ID, Long2, LInt),
	replaceAll(L, LInt, L3, 9),L2=L3,!.
nettoyerLMurBloque(Pos, ID, IF, L, L2) :- 
	Pos > ID,
	listeInt(0, IF, LInt),
	replaceAll(L, LInt, L3, 9),L2=L3,!.
	

% Betement on regarde si le diamant est encerclé
supprimerDiamantsEncercles(_, _, [], []):-!.
supprimerDiamantsEncercles(L, Size, [T|R], [T|R2]) :-
        C1t is T - Size, getElement(L, C1t, C1),
        C2t is T - 1, getElement(L, C2t, C2),
        C3t is T + 1, getElement(L, C3t, C3),
        C4t is T + Size,write(C4t), getElement(L, C4t, C4),
        (C1 =< 9 , C1 >= 4, C2 =< 9 , C2 >= 4, C3 =< 9 , C3 >= 4, C4 =< 9 , C4 >= 4),
        supprimerDiamantsEncercles(L, Size, R, R2),
!.
supprimerDiamantsEncercles(L, Size, [_|R], R2) :-
        supprimerDiamantsEncercles(L, Size, R, R2),!.

/** 
Ecrit dans un fichier indiqué en paramètre
@profil : ecrireFile( +T , +NomFichier )
**/
ecrireFile( T , File ) :- open( File , append, L ), write( L, T ), nl( L ), close( L ).

/** 
Ecrit dans le fichier trace.txt
**/
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