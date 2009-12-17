:- module(outilsCarte, [
              caseExist/2, 
                          getElement/3,
						  dernierElement/2,
                          caseAccessible/2,
                          caseDanger/2,
                          numCaseHaut/3,
                          numCaseBas/3,
                          numCaseGauche/3,
                          numCaseDroite/3,
                          replaceElement/4,
                          replaceAll/4,
						  retourneElementFromTo/4,
						  getLignes/3
                        ]
).

/**
* Dernier élement d'une liste
**/
dernierElement(L, E) :- reverse(L, [E|_]).

/** 
* Permet de vérifier si une case est existante
* @profil : caseExist(+L, +Indice)
**/
caseExist([_|_], 0).
caseExist([_|R], Indice) :- 
	Indice > 0, 
	I2 is Indice - 1, 
	caseExist(R, I2).

/** 
* Permet de récupérer la valeur de l'élément d'indice Indice dans la liste L
* @profil : getElement(+L, +Indice, ?Element)

getElement([], _, _) :- fail.
getElement([T|_], 0, Element) :- Element is T. 
getElement([T|R], Indice, Element) :- Indice > 0, I2 = Indice - 1, getElement(R, I2, Element).
**/
getElement(L, Indice, Element) :- length(L, Long), Indice > Long, Element = 9,!.
getElement(_, Indice, Element) :- Indice < 0, Element = 9,!.
getElement(L, Indice, Element) :- nth0(Indice, L, E), Element is E.

/**
* Permet de savoir si une case est accecible (case vide ou herbe)
* @profil : caseAccessible(+L, +Indice)
**/
caseAccessible(L, Indice) :- getElement(L, Indice, Element), Element =< 1, !.
caseAccessibleOuDiamant(L, Indice) :- getElement(L, Indice, Element), Element =< 2, !.

/**
* Permet de savoir si une case est un danger
* @profil : caseDanger(+L, +Indice)
**/
caseDanger(L, Indice) :- getElement(L, Indice, Element), Element = 11, !.
caseDanger(L, Indice) :- getElement(L, Indice, Element), Element = 12, !.


/**
* Permet de connaitre le numéro de la case du dessus
* @profil : numCaseHaut(+N, +Size, -Ret)
**/
numCaseHaut(N, Size, Ret) :- 
        Ret is N - Size.

/**
* Permet de connaitre le numéro de la case du dessus
* @profil : numCaseBas(+N, +Size, -Ret)
**/                                                      
numCaseBas(N, Size, Ret) :- 
        Ret is N + Size.
                                                         
/**
* Permet de connaitre le numéro de la case de gauche
* @profil : numCaseGauche(+N, +Size, -Ret)
**/
numCaseGauche(N, Size, Ret) :-
        Col is N mod Size,
        Col \= 0,
        Ret is N - 1.

/**
* Permet de connaitre le numéro de la case de droite
* @profil : numCaseDroite(+N, +Size, -Ret)
**/                                                             
numCaseDroite(N, Size, Ret) :-
        Col is ( N mod Size ) + 1,
        Col \= Size,
        Ret is N + 1.


/**
* Remplace la case d'incide Indice (commence à 0) dans L par la valeur Valeur
* retourne la nouvelle liste dans NewL
**/
replaceElement([_|R], 1, Valeur, [Valeur|R]).
replaceElement([T|R], Indice, Valeur, [T|R2]) :-
                  I2 is Indice - 1,
                  replaceElement(R, I2, Valeur, R2),!.
        
/**
* Remplace dans L tous les élements d'indice compris dans la liste I exemple : [indice0, indice5, ...]
* par la valeur V, ne remplace pas la case contenant le joueur
* Puis renvoi la liste modifié sous L2
* @profil : replaceAll(+L, +I, -L2, +V)
**/  
replaceAll(L, I, L2, V) :-
             sublist( <(-1), I, I2),
              sort(I2, I3),
              replaceAll2(L, I3, L2, V),!.
replaceAll2(L, [], L, _):-!.
replaceAll2([], _, [], _):-!.
replaceAll2([_|R], [0|RI], [V|R2], V) :-
                  maplist(plus(-1), RI, I2),
                  replaceAll2(R, I2, R2, V),!.
replaceAll2([T|R], I, [T|R2], V) :-
              maplist(plus(-1), I, I2),
              replaceAll2(R, I2, R2, V).
			  

/**
* Retourne les élements d'une liste de l'indice D à l'indice A
* Indice commencant à 1
* retourne la liste des élements dans L2
* @profil : retourneElementFromTo(L, D, A, L2)
**/
retourneElementFromTo(L, D, A, L2) :-
        D < 0, retourneElementFromTo(L, 1, A, L2),!.
retourneElementFromTo(L, D, A, L2) :-
        A < 0, retourneElementFromTo(L, D, 1, L2),!.
retourneElementFromTo(L, D, D, L2) :-
        nth1(D, L, E),
        L2 = [E],!.
retourneElementFromTo(L, D, A, L2) :-
        retourneElementFromTo2(L, D, A, L2),!.

retourneElementFromTo2([T|_], 0, 0, [T]) :- !.
retourneElementFromTo2([T|R], 0, A, [T|R2]) :-
                             A2 is A - 1,
                             retourneElementFromTo2(R, 0, A2, R2),!.
retourneElementFromTo2([_|R], D, A, L2) :-
                   D2 is D-1,
                   A2 is A-1,
                   retourneElementFromTo2(R, D2, A2, L2),!.

/**
Retourne L Sous forme de liste de lignes
**/				   
nPremiersTermes(_, 0, []) :- !.
nPremiersTermes([T|R], N, [T|R2]) :- N2 is N-1, nPremiersTermes(R, N2, R2).
supprimerNPremiers(L, 0, L) :- !.
supprimerNPremiers([_|R], N, R2) :- N2 is N-1, supprimerNPremiers(R, N2, R2).

getLignes([], _, []) :- !.
getLignes(L, Size, [T|R2]) :-
             nPremiersTermes(L, Size, T),
             supprimerNPremiers(L, Size, L2),
             getLignes(L2, Size, R2).