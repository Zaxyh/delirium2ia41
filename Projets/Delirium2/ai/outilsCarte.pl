:- module(outilsCarte, [
              caseExist/2, 
			  getElement/3,
			  caseAccessible/2,
			  caseDanger/2,
			  numCaseHaut/3,
			  numCaseBas/3,
			  numCaseGauche/3,
			  numCaseDroite/3
			]
).

/** 
* Permet de v�rifier si une case est existante
* @profil : caseExist(+L, +Indice)
**/
caseExist([_|_], 0).
caseExist([T|R], Indice) :- Indice > 0, I2 is Indice - 1, caseExist(R, I2).

/** 
* Permet de r�cup�rer la valeur de l'�l�ment d'indice Indice dans la liste L
* @profil : getElement(+L, +Indice, ?Element)

getElement([], _, _) :- fail.
getElement([T|_], 0, Element) :- Element is T. 
getElement([T|R], Indice, Element) :- Indice > 0, I2 = Indice - 1, getElement(R, I2, Element).
**/
getElement(L, Indice, Element) :- nth0(Indice, L, E), Element is E.

/**
* Permet de savoir si une case est accecible (case vide ou herbe)
* @profil : caseAccessible(+L, +Indice)
**/
caseAccessible(L, Indice) :- getElement(L, Indice, Element), Element = 1, !.
caseAccessible(L, Indice) :- getElement(L, Indice, Element), Element = 0, !.

/**
* Permet de savoir si une case est un danger
* @profil : caseDanger(+L, +Indice)
**/
caseDanger(L, Indice) :- getElement(L, Indice, Element), Element = 11, !.
caseDanger(L, Indice) :- getElement(L, Indice, Element), Element = 12, !.


/**
* Permet de connaitre le num�ro de la case du dessus
* @profil : numCaseHaut(+N, +Size, -Ret)
**/
numCaseHaut(N, Size, Ret) :- 
	Ret is N - Size.

/**
* Permet de connaitre le num�ro de la case du dessus
* @profil : numCaseBas(+N, +Size, -Ret)
**/							 
numCaseBas(N, Size, Ret) :- 
	Ret is N + Size.
							 
/**
* Permet de connaitre le num�ro de la case de gauche
* @profil : numCaseGauche(+N, +Size, -Ret)
**/
numCaseGauche(N, Size, Ret) :- 
	Ret is N - 1.

/**
* Permet de connaitre le num�ro de la case de droite
* @profil : numCaseDroite(+N, +Size, -Ret)
**/								
numCaseDroite(N, _, Ret) :-  
	Ret is N + 1.
