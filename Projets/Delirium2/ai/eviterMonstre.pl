:- module(eviterMonstre, [eviterMonstre/4]).

/**
* Vérifie si un danger est présent autour du mineur
* Un danger est défini par un monstre présent à 2 cases autour du mineur au plus.
* soit 20 possibilité d'attaque par monstre
* @profil : dangerAutour(+L, +Pos, +Size, -Direction) SlW2 9
**/
getVue2Cases(L, Pos, Size, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12) :- 
	caseProb is Pos - Size,
	getElement(L, CaseProb, E),
	E = 9,
	H1 is 9, H2 is 9, H3 is 9,
	H4 is 9, H7 is 9,
	getVue2Cases(L, Pos, Size, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12),!.
	
getVue2Cases(L, Pos, _, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12) :- 
	caseProb is Pos - 1,
	getElement(L, CaseProb, E),
	E = 9,
	H1 is 9, H10 is 9,
	H4 is 9, H5 is 9, H6 is 9,
	getVue2Cases(L, Pos, Size, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12),!.
	
getVue2Cases(L, Pos, _, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12) :- 
	caseProb is Pos + 1,
	getElement(L, CaseProb, E),
	E = 9,
	H3 is 9, H7 is 9,
	H8 is 9, H9 is 9, H12 is 9,
	getVue2Cases(L, Pos, Size, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12),!.

getVue2Cases(L, Pos, Size, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12) :- 
	caseProb is Pos + Size,
	getElement(L, CaseProb, E),
	E = 9,
	H10 is 9, H11 is 9,
	H12 is 9, H6 is 9, H9 is 9,
	getVue2Cases(L, Pos, Size, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12),!.
	
getVue2Cases(L, Pos, Size, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12).
	
monstreAutour(L, Pos, Size, Direction) :-
	
	ecrire2('Monstre autour commence'),
	
	% On définit les indices autour du mineur
	H1 is Pos - Size * 2 - 1,
	H2 is Pos - Size * 2,
	H3 is Pos - Size * 2 + 1,
	H4 is Pos - Size - 2,
	H5 is Pos - 2,
	H6 is Pos + Size - 2,
	H7 is Pos - Size + 2,
	H8 is Pos + 2,
	H9 is Pos + Size + 2,
	H10 is Pos + Size * 2 - 1,
	H11 is Pos + Size * 2,
	H12 is Pos + Size * 2 + 1,
	getVue2Cases(L, Pos, Size, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12),
	
	ecrire2('Par exemple h1 = '),
	ecrire2(H1),
	
	% On Définit les Indices autour du mineur à une distance de 1
	% Soit les cases possible pour se déplacer
	D1 is Pos - Size,
	D2 is Pos - 1,
	D3 is Pos + 1,
	D4 is Pos + Size,
	
	% On vérifie si les HX contiennet des monstres
	verifierMonstre(
		L,
		[H1,H2,H3,H4,H5,H6,H7,H8,H9,H10,H11,H12],
		[D1, D2, D3, D4],
		DirectionAPrendre,
		1
	),
	
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
	
verifierMonstre(_, [], _, _, _) :- fail,!.

verifierMonstre(L, [T|R], [D,_,_,_], Direction, NumH) :- 
	caseDanger(L, T),trouverEchappement(L, [T|R], LD, DirectionChoisie, NumH),
	Direction is DirectionChoisie,
	Direction = 2,
	caseAccessible(L, D)
,!.

verifierMonstre(L, [T|R], [_,D,_,_], Direction, NumH) :- 
	caseDanger(L, T),trouverEchappement(L, [T|R], LD, DirectionChoisie, NumH),
	Direction is DirectionChoisie,
	Direction = 0,
	caseAccessible(L, D)
,!.

verifierMonstre(L, [T|R], [_,_,D,_], Direction, NumH) :- 
	caseDanger(L, T),trouverEchappement(L, [T|R], LD, DirectionChoisie, NumH),
	Direction is DirectionChoisie,
	Direction = 1,
	caseAccessible(L, D)
,!.

verifierMonstre(L, [T|R], [_,_,_,D], Direction, NumH) :- 
	caseDanger(L, T),trouverEchappement(L, [T|R], LD, DirectionChoisie, NumH),
	Direction is DirectionChoisie,
	Direction = 3,
	caseAccessible(L, D)
,!.

verifierMonstre(L, [T|R], LD, Direction, NumH) :- 
	NumH2 is NumH + 1,
	verifierMonstre(L, R, LD, Direction, NumH2),!.

% Si danger
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 1,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [1, 3], DirectionFinale),
	ecrire2('Situation 1 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 2,
	random(0,3, DirectionChoisie),
	nth0(DirectionChoisie, [3, 0, 1], DirectionFinale),
	ecrire2('Situation 2 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 3,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [0, 3], DirectionFinale),
	ecrire2('Situation 3 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.

trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 4,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [1,3], DirectionFinale),
	ecrire2('Situation 4 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
% Direction supplémentaire / Angles spéciaux
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 5,
	random(0,3, DirectionChoisie),
	nth0(DirectionChoisie, [1,2,3], DirectionFinale),
	ecrire2('Situation 5 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 6,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [1, 2], DirectionFinale),
	ecrire2('Situation 6 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.

trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 7,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [0, 3], DirectionFinale),
	ecrire2('Situation 7 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 8,
	random(0,3, DirectionChoisie),
	nth0(DirectionChoisie, [0, 2, 3], DirectionFinale),
	ecrire2('Situation 8 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.

trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 9,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [0, 2], DirectionFinale),
	ecrire2('Situation 9 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 10,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [2, 1], DirectionFinale),
	ecrire2('Situation 10 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 11,
	random(0,3, DirectionChoisie),
	nth0(DirectionChoisie, [0, 1, 2], DirectionFinale),
	ecrire2('Situation 11 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 12,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [0, 2], DirectionFinale),
	ecrire2('Situation 12 je vais en '), ecrire2(DirectionFinale),
	Direction is DirectionFinale,!.
	
/**  
* Eviter un monstre
* @profil : eviterMonstre(+L, +Pos, +Size, -Direction)
**/
eviterMonstre(L, Pos, Size, Direction) :- 
	monstreAutour(L, Pos, Size, DirectionSurvie), 
	Direction is DirectionSurvie.