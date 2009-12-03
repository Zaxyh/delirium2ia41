:- module(eviterMonstre, [eviterMonstre/4]).

/**
* Retourne une liste type L, mettant des rochers type 9 lorsque les 
* cases n'existes pas
* @Profil : caseNonAccessible(L, Pos, Size, -Vue)
**/

% Case 1 et 2 et 3 4 et 5 6 7 8
caseNonAccessible(L, Pos, Size, Num, ElementRetourne) :- 
	(Num = 1 ; Num = 2 ; Num = 3 ; Num = 4 ; Num = 5 ; Num = 6 ; Num = 7 ; Num = 8),
	CaseMur is Pos-Size,
	getElement(L, CaseMur, E),
	E = 9,!.

% Case 2 5 6 9 10 13 14 17
caseNonAccessible(L, Pos, Size, Num, ElementRetourne) :- 
	(Num = 2 ; Num = 5 ; Num = 6 ; Num = 9 ; Num = 10 ; Num = 13 ; Num = 14 ; Num = 17),
	CaseMur is Pos - 1,
	getElement(L, CaseMur, E),
	E = 9,!.
	
% Case 4 7 8 11 12 15 16 19
caseNonAccessible(L, Pos, Size, Num, ElementRetourne) :- 
	(Num = 4 ; Num = 7 ; Num = 8 ; Num = 11 ; Num = 12 ; Num = 15 ; Num = 16 ; Num = 19),
	CaseMur is Pos+1,
	getElement(L, CaseMur, E),
	E = 9,!.
	
% Case 13 14 15 16 17 18 19 20
caseNonAccessible(L, Pos, Size, Num, ElementRetourne) :- 
	(Num = 13 ; Num = 14 ; Num = 15 ; Num = 16 ; Num = 17 ; Num = 18 ; Num = 19 ; Num = 20),
	CaseMur is Pos+Size,
	getElement(L, CaseMur, E),
	E = 9,!.

% Case 1 2 3 4
caseNonAccessible(L, Pos, Size, Num, ElementRetourne) :- 
	(Num = 1 ; Num = 2 ; Num = 3 ; Num = 4),
	CaseMur is Pos-2*Size,
	getElement(L, CaseMur, E),
	E = 9,!.
	
% Case 5 9 10 13
caseNonAccessible(L, Pos, Size, Num, ElementRetourne) :- 
	(Num = 5 ; Num = 9 ; Num = 10 ; Num = 13),
	CaseMur is Pos-2,
	getElement(L, CaseMur, E),
	E = 9,!.
	
% Case 8 11 12 16
caseNonAccessible(L, Pos, Size, Num, ElementRetourne) :- 
	(Num = 8 ; Num = 11 ; Num = 12 ; Num = 16),
	CaseMur is Pos+2,
	getElement(L, CaseMur, E),
	E = 9,!.
	
% Case 17 18 19 20
caseNonAccessible(L, Pos, Size, Num, ElementRetourne) :- 
	(Num = 17 ; Num = 18 ; Num = 19; Num = 20),
	CaseMur is Pos+Size*2,
	getElement(L, CaseMur, E),
	E = 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 1,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos - Size * 3,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 1,
	Case is 9,!.

getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 2,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos - Size * 2 - 1,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 2,
	Case is 9,!.	

getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 3,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos - Size * 2,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 3,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 4,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos - Size * 2 + 1,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 4,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 5,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos - Size - 2,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 5,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 6,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos - Size - 1,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 6,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 7,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos - Size + 1,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 7,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 8,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos - Size + 2,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 8,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 9,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos - 3,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 9,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 10,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos - 2,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 10,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 11,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos + 2,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 11,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 12,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos + 3,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 12,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 13,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos + Size - 2,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 13,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 14,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos + Size - 1,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 14,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 15,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos + Size + 1,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 15,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 16,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos + Size + 2,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 16,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 17,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos + Size * 2 - 1,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 17,
	Case is 9,!.

getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 18,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos + Size * 2,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 18,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 19,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos + Size * 2 + 1,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 19,
	Case is 9,!.
	
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 20,
	not(caseNonAccessible(L, Pos, Size, Num, Element)),
	Indice is Pos + Size * 3,
	getElement(L, Indice, C), Case is C,!.
getElementCaseNum(L, Pos, Size, Num, Case) :- 
	Num = 20,
	Case is 9,!.
	
getListeCasesDangers(L, Pos, Size, Liste) :- 
	getElementCaseNum(L, Pos, Size, 1, H1),
	getElementCaseNum(L, Pos, Size, 2, H2),
	getElementCaseNum(L, Pos, Size, 3, H3),
	getElementCaseNum(L, Pos, Size, 4, H4),
	getElementCaseNum(L, Pos, Size, 5, H5),
	getElementCaseNum(L, Pos, Size, 6, H6),
	getElementCaseNum(L, Pos, Size, 7, H7),
	getElementCaseNum(L, Pos, Size, 8, H8),
	getElementCaseNum(L, Pos, Size, 9, H9),
	getElementCaseNum(L, Pos, Size, 10, H10),
	getElementCaseNum(L, Pos, Size, 11, H11),
	getElementCaseNum(L, Pos, Size, 12, H12),
	getElementCaseNum(L, Pos, Size, 13, H13),
	getElementCaseNum(L, Pos, Size, 14, H14),
	getElementCaseNum(L, Pos, Size, 15, H15),
	getElementCaseNum(L, Pos, Size, 16, H16),
	getElementCaseNum(L, Pos, Size, 17, H17),
	getElementCaseNum(L, Pos, Size, 18, H18),
	getElementCaseNum(L, Pos, Size, 19, H19),
	getElementCaseNum(L, Pos, Size, 20, H20),
	Liste = [H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12, H13, H14, H15, H16, H17, H18, H19, H20],
	
	/*ecrire2('Debut phase ma position'), ecrire2(Pos),
	ecrire2('---'),
	ecrire2(H1),
	ecrire2(H2),
	ecrire2(H3),
	ecrire2(H4),
	ecrire2(H5),
	ecrire2(H6),
	ecrire2(H7),
	ecrire2(H8),
	ecrire2(H9),
	ecrire2(H10),
	ecrire2(H11),
	ecrire2(H12),
	ecrire2('Fin phase 2'),*/
!.
	
/**
* Vérifie si un danger est présent autour du mineur
* Un danger est défini par un monstre présent à 2 cases autour du mineur au plus.
* soit 20 possibilité d'attaque par monstre
* @profil : dangerAutour(+L, +Pos, +Size, -Direction) SlW2 9
**/

monstreAutour(L, Pos, Size, Direction) :-
	
	ecrireL(L),
	
	ecrire2('-------------------- on a trouve 0'),
	
	% On définie les cases possible pour la présence de monstre autour du mineur
	getListeCasesDangers(L, Pos, Size, ListeCaseARisque),
	
	ecrire2('-------------------- on a trouve 1'),
	
	% On Définit les Indices autour du mineur à une distance de 1
	% Soit les cases possible pour se déplacer
	D1 is Pos - Size,
	D2 is Pos - 1,
	D3 is Pos + 1,
	D4 is Pos + Size,
	
	% On vérifie si les HX contiennet des monstres
	verifierMonstre(
		L,
		ListeCaseARisque,
		[D1, D2, D3, D4],
		DirectionAPrendre,
		1
	),
	
	ecrire2('-------------------- on a trouve 22222222222222222222222222222222'),
	
	Direction is DirectionAPrendre
	
.

/*
  Rappel directions
  0 : gauche
  1 : droite
  2 : haut
  3 : bas
*/
typeEchappement(Num, Type) :- Num = 1,
	Type is 1.
typeEchappement(Num, Type) :- Num = 2,
	Type is 2.
typeEchappement(Num, Type) :- Num = 3,
	Type is 3.
typeEchappement(Num, Type) :- Num = 4,
	Type is 4.
typeEchappement(Num, Type) :- Num = 5,
	Type is 5.
typeEchappement(Num, Type) :- Num = 6,
	Type is 6.
typeEchappement(Num, Type) :- Num = 7,
	Type is 7.
typeEchappement(Num, Type) :- Num = 8,
	Type is 8.
typeEchappement(Num, Type) :- Num = 9,
	Type is 9.
typeEchappement(Num, Type) :- Num = 10,
	Type is 10.
typeEchappement(Num, Type) :- Num = 11,
	Type is 11.
typeEchappement(Num, Type) :- Num = 12,
	Type is 12.
typeEchappement(Num, Type) :- Num = 13,
	Type is 13.
typeEchappement(Num, Type) :- Num = 14,
	Type is 14.
typeEchappement(Num, Type) :- Num = 15,
	Type is 15.
typeEchappement(Num, Type) :- Num = 16,
	Type is 16.
typeEchappement(Num, Type) :- Num = 17,
	Type is 17.
typeEchappement(Num, Type) :- Num = 18,
	Type is 18.
typeEchappement(Num, Type) :- Num = 19,
	Type is 19.
typeEchappement(Num, Type) :- Num = 20,
	Type is 20.
	
verifierMonstre(_, [], _, _, _) :- fail,!.

verifierMonstre(L, [T|R], [D,_,_,_], Direction, NumH) :- 
	ecrire2('------------ test 1'),
	caseDanger(L, T),trouverEchappement(L, [T|R], DirectionChoisie, NumH),
	Direction is DirectionChoisie,
	Direction = 2,
	caseAccessible(L, D)
.

verifierMonstre(L, [T|R], [_,D,_,_], Direction, NumH) :- 
	ecrire2('------------ test 2'),
	caseDanger(L, T),trouverEchappement(L, [T|R], DirectionChoisie, NumH),
	Direction is DirectionChoisie,
	Direction = 0,
	caseAccessible(L, D)
.

verifierMonstre(L, [T|R], [_,_,D,_], Direction, NumH) :- 
	ecrire2('------------ test 3'),
	caseDanger(L, T),trouverEchappement(L, [T|R], DirectionChoisie, NumH),
	Direction is DirectionChoisie,
	Direction = 1,
	caseAccessible(L, D)
.

verifierMonstre(L, [T|R], [_,_,_,D], Direction, NumH) :- 
	ecrire2('------------ test 4'),
	caseDanger(L, T),trouverEchappement(L, [T|R], DirectionChoisie, NumH),
	Direction is DirectionChoisie,
	Direction = 3,
	caseAccessible(L, D)
.

verifierMonstre(L, [T|R], LD, Direction, NumH) :- 
	NumH2 is NumH + 1,
	verifierMonstre(L, R, LD, Direction, NumH2),!.

% Si danger
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 1,
	random(0,3, DirectionChoisie),
	nth0(DirectionChoisie, [0, 1, 3], DirectionFinale),
	ecrire2('Situation 1 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 2,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [3, 1], DirectionFinale),
	ecrire2('Situation 2 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 3,
	random(0,3, DirectionChoisie),
	nth0(DirectionChoisie, [1, 3, 0], DirectionFinale),
	ecrire2('Situation 3 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.

trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 4,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [0,3], DirectionFinale),
	ecrire2('Situation 4 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
% Direction supplémentaire / Angles spéciaux
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 5,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [1,3], DirectionFinale),
	ecrire2('Situation 5 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 6,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [1,3], DirectionFinale),
	ecrire2('Situation 6 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.

trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 7,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [0,3], DirectionFinale),
	ecrire2('Situation 7 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 8,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [0,3], DirectionFinale),
	ecrire2('Situation 8 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.

trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 9,
	random(0,3, DirectionChoisie),
	nth0(DirectionChoisie, [2, 3, 1], DirectionFinale),
	ecrire2('Situation 9 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 10,
	random(0,3, DirectionChoisie),
	nth0(DirectionChoisie, [2, 3, 1], DirectionFinale),
	ecrire2('Situation 10 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 11,
	random(0,3,  DirectionChoisie),
	nth0(DirectionChoisie, [2, 3, 0], DirectionFinale),
	ecrire2('Situation 11 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 12,
	random(0,3, DirectionChoisie),
	nth0(DirectionChoisie, [2, 3, 0], DirectionFinale),
	ecrire2('Situation 12 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 13,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [2,1], DirectionFinale),
	ecrire2('Situation 13 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 14,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [2,1], DirectionFinale),
	ecrire2('Situation 14 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 15,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [0,2], DirectionFinale),
	ecrire2('Situation 15 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 16,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [0,2], DirectionFinale),
	ecrire2('Situation 16 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 17,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [2, 1], DirectionFinale),
	ecrire2('Situation 17 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 18,
	random(0,3, DirectionChoisie),
	nth0(DirectionChoisie, [2, 1, 0], DirectionFinale),
	ecrire2('Situation 18 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 19,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [0,2], DirectionFinale),
	ecrire2('Situation 19 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 20,
	random(0,3, DirectionChoisie),
	nth0(DirectionChoisie, [2, 1, 0], DirectionFinale),
	ecrire2('Situation 20 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
/**  
* Eviter un monstre
* @profil : eviterMonstre(+L, +Pos, +Size, -Direction)
**/
eviterMonstre(L, Pos, Size, Direction) :- 
	monstreAutour(L, Pos, Size, DirectionSurvie), 
	Direction is DirectionSurvie.