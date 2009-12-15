:-module(plusCourtChemin, [solve/5]).
:-use_module('outilsCarte').
:-use_module('rochers').


/*
        passageX(+A, -B, +Size, +L)
*/

/*
 en haut
*/
% si ya rien en haut
passageH(A, B, Size, L, 1000) :- 
		rocherMeTombeDessus(L, Size, A),
		!,
		%ecrire(A), ecrire(L), ecrire(Size),
		numCaseHaut(A, Size, B),
        getElement(L, B, El),
	    ( El =< 3 ; El = 17 ).


passageH(A, B, Size, L, 1) :- 
		numCaseHaut(A, Size, B),
        getElement(L, B, El),
	    ( El < 3 ; El = 17 ).

/*
en bas
*/
passageB(A, B, Size, L, 1) :- 
		numCaseBas(A, Size, B),
		getElement(L, B, El),
		( El < 3 ; El = 17 ).

/*
a gauche
*/
passageG(A, B, Size, L, 1) :- 
		numCaseGauche(A, Size, B),
	    getElement(L, B, El),
	    ( El < 3 ; El = 17 ).


passageG(A, B, Size, L, 500) :- 
	pousserRocherGauche(5, A, L, Size),
	numCaseGauche(A, Size, B).

/*
a droite
*/
passageD(A, B, Size, L, 1) :- 
		numCaseDroite(A, Size, B),
	    getElement(L, B, El),
	    ( El < 3 ; El = 17 ).


passageD(A, B, Size, L, 500) :-
		pousserRocherDroite(5, A, L, Size),
		numCaseDroite(A, Size, B).

	
	
	
s(A, B, Poids, L, Size) :- 
		passageD(A, B, Size, L, Poids).
		
s(A, B, Poids, L, Size) :- 
		passageH(A, B, Size, L, Poids).
		
s(A, B, Poids, L, Size) :- 
		passageG(A, B, Size, L, Poids).
		
s(A, B, Poids, L, Size) :- 
		passageB(A, B, Size, L, Poids).


h(A, Distance, B, Size) :-
		Xa is A mod Size,
		Ya is A // Size,
		Xb is B mod Size,
		Yb is B // Size,
		Distance is ( (Xb-Xa)*(Xb-Xa) + (Yb-Ya)*(Yb-Ya) ).


solve(Start, Solution, L, Size, Finish) :-
        nb_setval(openList, [[0, [Start]]]),
        nb_setval(closedList, []),
        astar(Solution, L, Size, Finish).
        %astar([[[Start], 0]], SolPath, L, Size, Finish).

 % plus de noeuds dans open list, pas de solutions !
 astar([], _, _, _) :-
      nb_getval(openList, []),
      !.

% noeud courant = finish -> solution trouvée
astar(Solution, _, _, Finish) :-
      nb_getval(openList, [[_, Solution]|_]),
      Solution = [Finish|_],
      !.

% recherhe de tous les fils de la meilleur sol
astar(Solution, L, Size, Finish) :-
      nb_getval(openList, [[Cout, MeilleurChemin]|AutresCheminsOuverts]),
      nb_getval(closedList, ClosedList),
      % meilleur chemin en tete de liste
      MeilleurChemin = [DernierNoeud|_],
      % mettre à jour l'open liste = faire sauter la tete
      nb_setval(openList, AutresCheminsOuverts),
      %write(AutresCheminsOuverts),
      % ajouter le noeud courant a la liste close
      append(ClosedList, [DernierNoeud], ListeFerme),
      nb_setval(closedList, ListeFerme),
      % trouver tous les enfants
      findall(
           Couple,
           (
                s(DernierNoeud, S, P, L, Size) ,
                not(member(S, ListeFerme)),
				Couple = [S, P] % noeud et poids
           ),
           Succs
      ),
      %write(Succs),
      % les ajouter a l'open list
      ajouterChemin(MeilleurChemin, Cout, Succs, Size, Finish),
      % on continue a tracer les chemins
      astar(Solution, L, Size, Finish).


ajouterChemin(_, _, [], _, _) :- !. % plus rien à ajouter

ajouterChemin(MeilleurChemin, Cout, [Couple|NoeudsRestants], Size, Finish) :-
	  % récup noeud et poids
	  Couple = [S|CoutDeplacement],
      % calcul du nouveau cout
      h(S, Distance, Finish, Size),
	  %ecrire(CoutDeplacement),
      NouveauCout is Cout + Distance + CoutDeplacement,
      %write(S), write('  '), write(NouveauCout), write('\n'),
      % ajout a la liste ouverte
      append([S], MeilleurChemin, NouveauChemin),
      %write(NouveauChemin), write('\n'),
      ajouterListeOuverte(NouveauChemin, NouveauCout),
      % on ajoute les autres noeuds possibles
      ajouterChemin(MeilleurChemin, Cout, NoeudsRestants, Size, Finish).


ajouterListeOuverte(NouveauChemin, NouveauCout) :-
      nb_getval(openList, OpenList),
      %write('liste ouverte actuelle : '), write(OpenList), write('\n'),
      %write('Nouveau chemin et cout : '), write(NouveauChemin), write('   '), write(NouveauCout), write('\n'),
      append(OpenList, [[NouveauCout, NouveauChemin]], NouvelleListeOuverte),
      sort(NouvelleListeOuverte, NouvelleListeOuverteTriee),
      %write('Liste apres ajout : '), write(NouvelleListeOuverteTriee), write('\n'),
      nb_setval(openList, NouvelleListeOuverteTriee).




