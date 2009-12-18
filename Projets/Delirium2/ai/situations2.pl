:-module(situations2, [situations2/4]).
:-use_module('outilsCarte').


presenceMonstre(L, I, P) :- 
		P > 0,
		I2 is I + P,
		( nth0(I2, L, 11) ; nth0(I2, L, 12) ),
		!.

presenceMonstre(L, I, P) :-
		P > 0,
		P2 is P - 1,
		presenceMonstre(L, I, P2).
		
		
		
/*
			Phase 1 : le monstre se ballade tranquille
*/
situations2(L, _, Size, Objectif) :- 

		%ecrire('---'), ecrire(L), ecrire(Size),
		
		findall(
			Case,
			(
					(
						nth0(Case, L, 1) ;
						nth0(Case, L, 0) ;
						nth0(Case, L, 10)
					),
					
					numCaseDroite(Case, Size, CDroite),
					nth0(CDroite, L, 1),
					
					numCaseHaut(CDroite, Size, CHautDroite),
					nth0(CHautDroite, L, 3),
					
					numCaseBas(Case, Size, CBas),
					nth0(CBas, L, 3),
					
					numCaseBas(CDroite, Size, CBasDroite),
					(
						nth0(CBasDroite, L, 0)  ;
						nth0(CBasDroite, L, 11) ;
						nth0(CBasDroite, L, 12)
					),
					
					% monstre sur la même ligne a 1..7
					(
						presenceMonstre(L, CBas, 7) ;
						presenceMonstre(L, Case, 7) 
					)
					
			),
			ListeCase
		),
		not( ListeCase = [] ),
		!,
		ListeCase = [O|_],
		prendreDecision(O, L, Size, Objectif).

/*
			Phase 2 : le piège est tendus
			cas gauche
*/		

situations2(L, Pos, Size, Objectif) :- 

		findall(
			Case,
			(
					(
						nth0(Case, L, 1) ;
						nth0(Case, L, 0) ;
						nth0(Case, L, 10)
					),
					
					numCaseDroite(Case, Size, CDroite),
					(
						nth0(CDroite, L, 10) ;
						nth0(CDroite, L, 0)
					),
					
					numCaseHaut(CDroite, Size, CHautDroite),
					nth0(CHautDroite, L, 3),
					
					numCaseBas(Case, Size, CBas),
					nth0(CBas, L, 3),

					% monstre sur la même ligne a 2..3
					Indice is CBas + 3,
					Indice2 is CBas + 2,
					( nth0(Indice, L, 11) ; nth0(Indice, L, 12) ;  nth0(Indice2, L, 11) ; nth0(Indice2, L, 12) )
					
			),
			ListeCase
		),
		not( ListeCase = [] ),
		Objectif is Pos - 1,
		nth0(Objectif, L, 0),
		!.

		
/*
			Phase 2 : le piège est tendus
			cas haut
*/		

situations2(L, Pos, Size, Objectif) :- 
		
		findall(
			Case,
			(
					(
						nth0(Case, L, 1) ;
						nth0(Case, L, 0) ;
						nth0(Case, L, 10)
					),
					
					numCaseDroite(Case, Size, CDroite),
					(
						nth0(CDroite, L, 10) ;
						nth0(CDroite, L, 0)
					),
					
					numCaseHaut(CDroite, Size, CHautDroite),
					nth0(CHautDroite, L, 3),
					
					numCaseBas(Case, Size, CBas),
					nth0(CBas, L, 3),

					% monstre sur la même ligne a 2..3
					Indice is CBas + 3,
					Indice2 is CBas + 2,
					( nth0(Indice, L, 11) ; nth0(Indice, L, 12) ;  nth0(Indice2, L, 11) ; nth0(Indice2, L, 12) )
					
			),
			ListeCase
		),
		not( ListeCase = [] ),
		Objectif is Pos - Size,
		( nth0(Objectif, L, 0) ; nth0(Objectif, L, 0) ),
		!.

		
		
/*
Attendre sous le rocher
*/		

situations2(L, Pos, Size, Objectif) :- 
		
		findall(
			Case,
			(
					(
						nth0(Case, L, 1) ;
						nth0(Case, L, 0) ;
						nth0(Case, L, 10)
					),
					
					numCaseDroite(Case, Size, CDroite),
					(
						nth0(CDroite, L, 10) ;
						nth0(CDroite, L, 0)
					),
					
					numCaseHaut(CDroite, Size, CHautDroite),
					nth0(CHautDroite, L, 3),
					
					numCaseBas(Case, Size, CBas),
					nth0(CBas, L, 3),

					% monstre sur la même ligne a 1..7
					(
						presenceMonstre(L, CBas, 7) ;
						presenceMonstre(L, Case, 7) 
					)
					
			),
			ListeCase
		),
		not( ListeCase = [] ),
		Objectif is Pos.	
		
/*
Prise de décision pour la phase 1
*/		

% se placer sur la case Objectif
prendreDecision(Objectif, L, _, Objectif) :-
		( nth0(Objectif, L, 0) ; nth0(Objectif, L, 1) ),
		!.


% patienter avant que le monstre soit en position : aller retour G/D
prendreDecision(Objectif, L, Size, Objectif) :-
		numCaseBas(Objectif, Size, CBas),
		CBas2 is CBas + 4,
		not(nth0(CBas2, L, 11)),
		not(nth0(CBas2, L, 12)),
		!.		

	
% Monstre en position : on se met sous le cailloux
prendreDecision(Objectif, _, _, Goal) :-
		Goal is Objectif + 1,
		!.

		
		
		
		
		
		