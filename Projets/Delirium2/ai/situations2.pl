:- module(situations2, [situations2/4]).
:-use_module('outilsCarte').


situations2(L, Pos, Size, Objectif) :- 
		( member(12, L) ; member(11, L) ),
		!,
		findall(
			Case,
			(
					nth0(Case, L, 0),
					
					numCaseDroite(Case, Size, CDroite),
					nth0(CDroite, L, 1),
					
					numCaseHaut(CDroite, Size, CHautDroite),
					nth0(CHautDroite, L, 3),
					
					numCaseBas(Case, Size, CBas),
					nth0(CBas, L, 3),
					
					numCaseBas(CDroite, Size, CBasDroite),
					nth0(CBasDroite, L, 0)
					
			),
			ListeCase
		),
		not( ListeCase = [] ),
		ecrire('Situation 2'),
		ecrire(L), ecrire(Size),
		ListeCase = [O|_],
		ecrire(O),
		prendreDecision(O, Size, Objectif), ecrire(Objectif).

		
prendreDecision(CaseDepart, Size, CBas) :-
		numCaseBas(CaseDepart, Size, CBas),
		numCaseDroite(CBas, Size, CBasDroite),
		nth0(CBasDroite, L, 11),
		!.
		
prendreDecision(CaseDepart, Size, CBas) :-
		numCaseBas(CaseDepart, Size, CBas),
		numCaseDroite(CBas, Size, CBasDroite),
		nth0(CBasDroite, L, 12),
		!.
		
prendreDecision(CaseDepart, Size, CBasDroite) :-
		numCaseBas(CaseDepart, Size, CBas),
		numCaseDroite(CBas, Size, CBasDroite).
		
		