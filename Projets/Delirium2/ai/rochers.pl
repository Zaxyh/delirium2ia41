:- module(rochers, [
                          pousserRocherDroite/4,
                          pousserRocherGauche/4,
						  rocherMeTombeDessus/3
                        ]
).
:-use_module('outilsCarte').


/**
Pousser les rochers
Methode complète.
jusqu'a "Profondeur" rochers
**/	

/*
	A gauche
*/

% profondeur max atteinte, a-t-on un vide ?
pousserRocherGauche(0, C, L, Size) :-
		numCaseGauche(C, Size, G),
		getElement(L, G, 0),
		!.
% un vide derriere les rochers
pousserRocherGauche(Profondeur, C, L, Size) :-
		numCaseGauche(C, Size, G),
		getElement(L, G, 0),
		!.			
% un rocher, regarder encore derrière !		
pousserRocherGauche(Profondeur, C, L, Size) :-
		numCaseGauche(C, Size, G),
		getElement(L, G, 3),
		Profondeur2 is Profondeur - 1,
		pousserRocherGauche(Profondeur2, G, L, Size).

		
/*
	A droite
*/
		
pousserRocherDroite(0, C, L, Size) :-
		numCaseDroite(C, Size, D),
		getElement(L, D, 0),
		!.

pousserRocherDroite(Profondeur, C, L, Size) :-
		numCaseDroite(C, Size, D),
		getElement(L, D, 0),
		!.		
		
pousserRocherDroite(Profondeur, C, L, Size) :-
		numCaseDroite(C, Size, D),
		getElement(L, D, 3),
		Profondeur2 is Profondeur - 1,
		pousserRocherDroite(Profondeur2, D, L, Size).
	

/*
	En haut
*/
		
	
rocherMeTombeDessus(L, Size, N1) :-
	numCaseHaut(N1, Size, N2),
	numCaseHaut(N2, Size, N3),
	numCaseHaut(N3, Size, N4),
	getElement(L, N2, El1),
	getElement(L, N3, El2),
	getElement(L, N4, El3),
	(El1 = 3 ; El2 = 3 ; El3 = 3 ; El1 = 2 , El2 = 2 ; El3 = 2).
	
	