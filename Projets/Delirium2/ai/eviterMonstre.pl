:- module(eviterMonstre, [eviterMonstre/3]).

getIndiceMonstre(L, Size, Indice) :- 
	nth0(Indice, L, 11),!.
	
entourerMonstres(L, Size, L2) :- 
	getIndiceMonstre(L, Size, I),
	
	% Indices à 2 cases
	H1 is I - Size * 2 - 1,
	H2 is I - Size * 2,
	H3 is I - Size * 2 + 1,
	H4 is I - Size - 2,
	H5 is I - Size + 2,
	H6 is I - 2,
	H7 is I + 2,
	H8 is I + Size - 2,
	H9 is I + Size + 2,
	H10 is I + Size * 2 - 1,
	H11 is I + Size * 2,
	H12 is I + Size *2 + 1,
	
	% Indices à 1 case
	C1 is I - Size,
	C2 is I - 1,
	C3 is I + 1,
	C4 is I + Size,
	
	verifierIndices(L, [H1,H2,H3,H4,H5,H6,H7,H8,H9,H10,H12,C1,C2,C3,C4], Indices),
	replaceAll(L, Indices, L2, 9),
	
	!.
	
verifierIndices(L, [], []).
verifierIndices(L, [T|R], [T|R2]) :- 
	caseAccessible(L, T), verifierIndices(L, R, R2),!.
verifierIndices(L, [T|R], [-1|R2]) :- 
	verifierIndices(L, R, R2), !.

/**
Prédication eviter monstre
**/	
eviterMonstre(L, Size, L2) :- 
	entourerMonstres(L, Size, L2),!.