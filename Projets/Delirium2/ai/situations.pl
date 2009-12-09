:- module(situations, [situations/4]).

/**
* Repertories les différentes situations
* que le mineur peut rencontrer, et essaye, si une situation est trouvée de 
* la résoudre.
* (cf : Fichier Situations.
**/

situations(L, Pos, Size, Direction) :- 
	situation1(L, Pos, Size, Direction),!.
situations(L, Pos, Size, Direction) :- 
	situation1_2(L, Pos, Size, Direction),!.

/*
*********************************************************************************
Situation 1
Verifie si il y a un monstre en Mineur - Size * 2 et un diamant en Mineur - Size
*********************************************************************************
*/
situation1(L, Pos, Size, Direction) :- 
	
	Diamant is Pos - Size,
	getElement(L, Diamant, EDiamant),
	EDiamant = 2,
	
	Monstre is Pos - Size * 2,
	getElement(L, Monstre, EMonstre),
	EMonstre = 11,
		
	trouverDirectionSituation1(L, Pos, Size, Direction),!.
	
trouverDirectionSituation1(L, Pos, Size, Direction) :- 
	Droite1 is Pos + 1,
	Droite2 is Pos + 2,
	Gauche1 is Pos - 1,
	Gauche2 is Pos - 2,
	ecrireFile('On est en train de chercher le chemin', 'SituationsLog.txt'),
	trouverDirectionSituation1E2(L, Droite1, Droite2, Gauche1, Gauche2, Direction),!.
trouverDirectionSituation1E2(L, D1, D2, G1, G2, Direction) :- 
	ecrireFile('1', 'SituationsLog.txt'),
	caseAccessible(L, D1),
	ecrireFile('2', 'SituationsLog.txt'),
	caseAccessible(L, D2),
	ecrireFile('3', 'SituationsLog.txt'),
	Direction = 1,!.
trouverDirectionSituation1E2(L, D1, D2, G1, G2, Direction) :- 
	ecrireFile('4', 'SituationsLog.txt'),
	caseAccessible(L, G1),
	ecrireFile('5', 'SituationsLog.txt'),
	caseAccessible(L, G2),
	ecrireFile('6', 'SituationsLog.txt'),
	Direction = 0,!.
	
/**
Situation 1, permet de déplacement de deux cases permettant de faire tomber le diamant
**/
situation1_2(L, Pos, Size, Direction) :- 
	
	Diamant is Pos - Size + 1,
	getElement(L, Diamant, EDiamant),
	EDiamant = 2,
	
	Monstre is Pos - Size * 2 + 1,
	getElement(L, Monstre, EMonstre),
	EMonstre = 11,
	
	Vide is Pos + 1,
	getElement(L, Vide, EVide),
	EVide = 0,
	
	Direction = 0,!.
situation1_2(L, Pos, Size, Direction) :- 
	
	Diamant is Pos - Size - 1,
	getElement(L, Diamant, EDiamant),
	EDiamant = 2,
	
	Monstre is Pos - Size * 2 - 1,
	getElement(L, Monstre, EMonstre),
	EMonstre = 11,
	
	Vide is Pos - 1,
	getElement(L, Vide, EVide),
	EVide = 0,
	
	Direction = 1,!.