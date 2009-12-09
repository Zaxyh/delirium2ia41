:- module(eviterMonstre, [eviterMonstre/3]).

getIndiceMonstre(L, Size, Indice) :- 
	nth0(Indice, L, 11),!.
	
entourerMonstres(L, Size, L2) :- 
	getIndiceMonstre(L, Size, I),
	
	% Indices à 2 cases
	H1 is I - Size * 2,
	H2 is I - Size - 1,
	H3 is I - Size + 1,
	H4 is I - 2,
	H5 is I + 2,
	H6 is I + Size - 1,
	H7 is I + Size + 1,
	H8 is I + Size * 2,
	
	% Indices à 1 case
	C1 is I - Size,
	C2 is I - 1,
	C3 is I + 1,
	C4 is I + Size,
	
	verifierIndices(L, [H1,H2,H3,H4,H5,H6,H7,H8,C1,C2,C3,C4], Indices),
	
	verifierIndicesC1(L, Indices, Indices2, Size),
	verifierIndicesC2(L, Indices2, Indices3, Size),
	verifierIndicesC3(L, Indices3, Indices4, Size),
	verifierIndicesC4(L, Indices4, Indices5, Size),
	replaceAll(L, Indices5, L2, 9),
	
	!.
	
verifierIndices(L, [], []).
verifierIndices(L, [T|R], [T|R2]) :- 
	caseAccessible(L, T), verifierIndices(L, R, R2),!.
verifierIndices(L, [T|R], [-1|R2]) :- 
	verifierIndices(L, R, R2), !.

verifierIndicesC1(L, [H1,H2,H3,H4,H5,H6,H7,H8,C1,C2,C3,C4], R, Size) :- 
	not(caseAccessible(L, C1)),
	R = [-1,H2,H3,H4,H5,H6,H7,H8,C1,C2,C3,C4],!.
	
verifierIndicesC2(L, [H1,H2,H3,H4,H5,H6,H7,H8,C1,C2,C3,C4], R, Size) :- 
	not(caseAccessible(L, C2)),
	R = [H1,H2,H3,-1,H5,H6,H7,H8,C1,C2,C3,C4],!.
	
verifierIndicesC3(L, [H1,H2,H3,H4,H5,H6,H7,H8,C1,C2,C3,C4], R, Size) :- 
	not(caseAccessible(L, C3)),
	R = [H1,H2,H3,H4,-1,H6,H7,H8,C1,C2,C3,C4],!.
	
verifierIndicesC4(L, [H1,H2,H3,H4,H5,H6,H7,H8,C1,C2,C3,C4], R, Size) :- 
	not(caseAccessible(L, C4)),
	R = [H1,H2,H3,H4,H5,H6,H7,-1,C1,C2,C3,C4],!.
	
verifierIndicesC1(L, L2, L2, Size).
verifierIndicesC2(L, L2, L2, Size).
verifierIndicesC3(L, L2, L2, Size).
verifierIndicesC4(L, L2, L2, Size).
	
	
/**
Prédication eviter monstre
**/	
eviterMonstre(L, Size, L2) :- 
	entourerMonstres(L, Size, L2),ecrireFile(L2, 'StephLog.txt'),!.