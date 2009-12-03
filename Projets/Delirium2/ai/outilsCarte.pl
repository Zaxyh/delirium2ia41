:- module(outilsCarte, [
              caseExist/2, 
			  getElement/3,
			  caseAccessible/2,
			  caseDanger/2
			]
).

/** 
* Permet de vérifier si une case est existante
* @profil : caseExist(+L, +Indice)
**/
caseExist([_|_], 0).
caseExist([T|R], Indice) :- Indice > 0, I2 is Indice - 1, caseExist(R, I2).

/** 
* Permet de récupérer la valeur de l'élément d'indice Indice dans la liste L
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
caseDanger(L, Value) :- Value = 11, !.
caseDanger(L, Value) :- Value = 12, !.