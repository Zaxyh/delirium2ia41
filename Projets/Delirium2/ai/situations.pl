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
situations(L, Pos, Size, Direction) :- 
        situation_rocher(L, Pos, Size, Direction),!.


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
        caseDanger(L, Monstre),

        trouverDirectionSituation1(L, Pos, Size, Direction),!.
        
trouverDirectionSituation1(L, Pos, Size, Direction) :- 
        Droite1 is Pos + 1,
        Droite2 is Pos + 2,
        Gauche1 is Pos - 1,
        Gauche2 is Pos - 2,
        trouverDirectionSituation1E2(L, Droite1, Droite2, Gauche1, Gauche2, Direction),!.
trouverDirectionSituation1E2(L, D1, D2, G1, G2, Direction) :- 
        caseAccessible(L, D1),
        caseAccessible(L, D2),
        Direction = 1,!.
trouverDirectionSituation1E2(L, D1, D2, G1, G2, Direction) :- 
        caseAccessible(L, G1),
        caseAccessible(L, G2),
        Direction = 0,!.
        
/**
Situation 1, permet de déplacement de deux cases permettant de faire tomber le diamant
**/
situation1_2(L, Pos, Size, Direction) :- 
        
        Diamant is Pos - Size + 1,
        getElement(L, Diamant, EDiamant),
        EDiamant = 2,
        
        Monstre is Pos - Size * 2 + 1,
        caseDanger(L, Monstre),
        
        Vide is Pos + 1,
        getElement(L, Vide, EVide),
        EVide = 0,
        
        Direction = 0,!.
situation1_2(L, Pos, Size, Direction) :- 
        
        Diamant is Pos - Size - 1,
        getElement(L, Diamant, EDiamant),
        EDiamant = 2,
        
        Monstre is Pos - Size * 2 - 1,
        caseDanger(L, Monstre),
        
        Vide is Pos - 1,
        getElement(L, Vide, EVide),
        EVide = 0,
        
        Direction = 1,!.
		
		
/**
* SITUATION 2 Rochers :
* Si pos - Size est accecible et Pos - 2*Size est un rocher alors :
*	- Le mineur choisit une direction dans un ordre de possibilité :
*	- A Droite, En bas, A gauche
* La possiblité de déplacement est accepté si les 2 cases dans la direction sont accecible.
**/
situation_rocher(L, Pos, Size, Direction) :- 
	
	Rocher is Pos - 2 * Size,
	CaseVide is Pos - Size,
	
	getElement(L, CaseVide, ECaseVide),
	ECaseVide = 0,
	
	getElement(L, Rocher, ERocher),
	ERocher = 3,
	
	trouverDirectionSituation_rocher(L, Pos, Size, Direction),!.

situation_rocher(L, Pos, Size, Direction) :- 
	
	Rocher is Pos - Size * 2 - 1,
	CaseVide1 is Pos - Size,
	CaseVide2 is Pos - Size * 2,
	
	getElement(L, CaseVide1, ECaseVide1),
	ECaseVide1 = 0,
	getElement(L, CaseVide2, ECaseVide2),
	ECaseVide2 = 0,
	
	getElement(L, Rocher, ERocher),
	ERocher = 3,
	
	trouverDirectionSituation_rocher(L, Pos, Size, Direction),!.	

situation_rocher(L, Pos, Size, Direction) :- 
	
	Rocher is Pos - Size * 2 + 1,
	CaseVide1 is Pos - Size,
	CaseVide2 is Pos - Size * 2,
	
	getElement(L, CaseVide1, ECaseVide1),
	ECaseVide1 = 0,
	getElement(L, CaseVide2, ECaseVide2),
	ECaseVide2 = 0,
	
	getElement(L, Rocher, ERocher),
	ERocher = 3,
	
	trouverDirectionSituation_rocher(L, Pos, Size, Direction),!.
	
trouverDirectionSituation_rocher(L, Pos, Size, Direction) :- 
        Droite1 is Pos + 1,
        Droite2 is Pos + 2,
        Gauche1 is Pos - 1,
        Gauche2 is Pos - 2,
		Bas1 is Pos + Size,
		Bas2 is Pos + 2*Size,
        trouverDirectionSituation1E2(L, Droite1, Droite2, Gauche1, Gauche2, Bas1, Bas2, Direction),!.
trouverDirectionSituation1E2(L, D1, D2, G1, G2, B1, B2, Direction) :- 
        caseAccessibleOuDiamant(L, D1),
        caseAccessibleOuDiamant(L, D2),
        Direction = 1,!.
trouverDirectionSituation1E2(L, D1, D2, G1, G2, B1, B2, Direction) :- 
        caseAccessibleOuDiamant(L, B1),
        caseAccessibleOuDiamant(L, B2),
        Direction = 3,!.
trouverDirectionSituation1E2(L, D1, D2, G1, G2, B1, B2, Direction) :- 
        caseAccessibleOuDiamant(L, G1),
        caseAccessibleOuDiamant(L, G2),
        Direction = 0,!.