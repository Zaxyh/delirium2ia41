:- module(eviterMonstre, [eviterMonstre/4]).

/**
* Vérifie si un danger est présent autour du mineur
* Un danger est défini par un monstre présent à 2 cases autour du mineur au plus.
* soit 20 possibilité d'attaque par monstre
* @profil : dangerAutour(+L, +Pos, +Size, -Direction)
**/
monstreAutour(L, Pos, Size, Direction) :-
	
	% On définit les indices autour du mineur
	SautLine is 2 * Size,
	H1 is Pos - SautLine - 1,
	H2 is Pos - SautLine,
	H3 is Pos - SautLine + 1,
	H4 is Pos - Size - 2,
	H5 is Pos - Size - 1,
	H6 is Pos - Size,
	H7 is Pos - Size + 1,
	H8 is Pos - Size + 2,
	H9 is Pos - 2,
	H10 is Pos - 1,
	H11 is Pos + 1,
	H12 is Pos + 2,
	H13 is Pos + Size - 2,
	H14 is Pos + Size - 1,
	H15 is Pos + Size,
	H16 is Pos + Size + 1,
	H17 is Pos + Size + 2,
	H18 is Pos + SautLine - 1,
	H19 is Pos + SautLine,
	H20 is Pos + SautLine + 1,
	
	% On Définit les Indices autour du mineur à une distance de 1
	% Soit les cases possible pour se déplacer
	D1 is Pos - Size,
	D2 is Pos - 1,
	D3 is Pos + 1,
	D4 is Pos + Size,
	
	% On vérifie si les HX contiennet des monstres
	verifierMonstre(
		L,
		[H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12, H13, H14, H15, H16, H17, H18, H19, H20],
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
	Type is 1.
typeEchappement(Num, Type) :- Num = 3,
	Type is 1.
typeEchappement(Num, Type) :- Num = 5,
	Type is 5.
typeEchappement(Num, Type) :- Num = 6,
	Type is 1.
typeEchappement(Num, Type) :- Num = 7,
	Type is 6.
	
typeEchappement(Num, Type) :- Num = 14,
	Type is 7.
typeEchappement(Num, Type) :- Num = 15,
	Type is 2.
typeEchappement(Num, Type) :- Num = 16,
	Type is 8.
typeEchappement(Num, Type) :- Num = 18,
	Type is 2.
typeEchappement(Num, Type) :- Num = 19,
	Type is 2.
typeEchappement(Num, Type) :- Num = 20,
	Type is 2.
	
typeEchappement(Num, Type) :- Num = 4,
	Type is 4.
typeEchappement(Num, Type) :- Num = 9,
	Type is 4.
typeEchappement(Num, Type) :- Num = 10,
	Type is 4.
typeEchappement(Num, Type) :- Num = 13,
	Type is 4.
	
typeEchappement(Num, Type) :- Num = 8,
	Type is 3.
typeEchappement(Num, Type) :- Num = 11,
	Type is 3.
typeEchappement(Num, Type) :- Num = 12,
	Type is 3.
typeEchappement(Num, Type) :- Num = 17,
	Type is 3.
	
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
	nth0(DirectionChoisie, [3, 0, 1], DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 2,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [2, 0, 1], DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 3,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [0, 2, 3], DirectionFinale),
	Direction is DirectionFinale,!.

trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 4,
	random(0,2, DirectionChoisie),
	nth0(DirectionChoisie, [1, 2, 3], DirectionFinale),
	Direction is DirectionFinale,!.
	
% Direction supplémentaire / Angles spéciaux
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 5,
	random(0,1, DirectionChoisie),
	nth0(DirectionChoisie, [1, 3], DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 6,
	random(0,1, DirectionChoisie),
	nth0(DirectionChoisie, [0, 3], DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 7,
	random(0,1, DirectionChoisie),
	nth0(DirectionChoisie, [1, 2], DirectionFinale),
	Direction is DirectionFinale,!.
	
trouverEchappement(L, [T|R], LD, Direction, NumH) :- 
	typeEchappement(NumH, Type),
	Type = 8,
	random(0,1, DirectionChoisie),
	nth0(DirectionChoisie, [0, 2], DirectionFinale),
	Direction is DirectionFinale,!.
	
/**  
* Eviter un monstre
* @profil : eviterMonstre(+L, +Pos, +Size, -Direction)
**/
eviterMonstre(L, Pos, Size, Direction) :- 
	monstreAutour(L, Pos, Size, DirectionSurvie), 
	Direction is DirectionSurvie.