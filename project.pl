/*
* Poss = possivel
*
* rep das solucoes :
* dir = c, b, e, d
* pos = posicao = (Linha, Coluna)
* lab = labirinto =  [(dir,pos),...]
* i = direcao que diz que é a primeira posicao
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
concatenate([], L, L):-!.
concatenate(L,[],L):-!.
concatenate([H|T], L, C_list):-
	concatenate(T, L, C_list2),
	C_list = [H| C_list2].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
esta_na_lista([],_):- fail,!.
esta_na_lista([H|_], H):-!. 
esta_na_lista([H|T], Elem):-
	H \== Elem ,
	esta_na_lista(T, Elem),!.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% finds possible directions in a certain position

%adds and auxiliar tupple to check current position in Labirynth
encontra_paredes(Lab, Pos, Dir):- encontra_paredes(Lab, Pos, Dir, (1,0)).

% searchs for right line
encontra_paredes([_ | Tail], (L,C), Dir, (L_target, C_target)):-
	L_target < L,
	L_target2 is L_target +1,
	encontra_paredes(Tail, (L,C), Dir, (L_target2, C_target)), !.

% when correct line is found, opens the list to begin searching the collumn
encontra_paredes([Head|_], (L,C), Dir, (L_target, C_target)):-
	L_target =:= L,
	C_target == 0,
	C_target2 = 1,
	encontra_paredes(Head, (L,C), Dir, (L_target, C_target2)),!.

% searchs for the right collumn
encontra_paredes([_ | Tail], (L,C), Dir, (L_target, C_target)):-
	L_target =:= L,
	C_target > 0,
	C_target < C,
	C_target2 is C_target +1,
	encontra_paredes(Tail, (L,C), Dir, (L_target, C_target2)),!.

% when right position is found, returns the list with possible directions
encontra_paredes([Head| _] ,Pos, Head, Pos):-!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% takes as arguemnts direction and Current Position, gives to
% Mov the result of moving in a direction from current position
cria_mov('c', (L,C), Mov):-
	New_L is L - 1,
	Mov = ('c', New_L, C), !.

cria_mov('b', (L,C), Mov):-
	New_L is L + 1,
	Mov = ('b', New_L, C), !.

cria_mov('e', (L,C), Mov):-
	New_C is C-1,
	Mov = ('e', L, New_C), !.

cria_mov('d', (L,C), Mov):-
	New_C is C+1,
	Mov = ('d', L, New_C), !.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% receives all directions and generates a list
% with all the possible movements
todos_movs_poss([], _,[]):-!.

todos_movs_poss(Dir_List, Pos, Poss_Movs):-
	[Head|Tail] = Dir_List,
	cria_mov(Head, Pos, Mov),
	todos_movs_poss(Tail, Pos, Prev_Poss_Movs),
	Poss_Movs = [Mov|Prev_Poss_Movs],!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% receives 2 lists and returns a filtered list
% of the elements in first and not in second
filter_lists([],_,[]):-!.

filter_lists([Head|Tail], Filter, Filtered):- 
	\+esta_na_lista(Filter, Head),
	filter_lists(Tail, Filter, Filtered2),
	Filtered = [Head|Filtered2], !.

filter_lists([Head|Tail], Filter, Filtered):- 
	esta_na_lista(Filter, Head),
	filter_lists(Tail, Filter, Filtered), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filtra os movimentos repetidos
filtra_movimentos_aux((_,L,C), [(_,L,C)|_], []):-!.
filtra_movimentos_aux(Mov_Poss, [_|T], Poss):-
	filtra_movimentos_aux(Mov_Poss, T, Poss),!.
filtra_movimentos_aux(Mov_Poss, [],[Mov_Poss]):-!.

filtra_movimentos([],_,[]):-!.
filtra_movimentos([Head|Tail], Movs, Poss):-
	filtra_movimentos_aux(Head, Movs, Poss3),
	filtra_movimentos(Tail, Movs, Poss2),
	concatenate(Poss3,Poss2,Poss),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recebe um labirinto, posicao atual e movs ja feitos
% e determina os movimentos possiveis que nao foram ja feitos

movs_possiveis(Lab, Pos_atual, Movs, Poss):-
	encontra_paredes(Lab, Pos_atual, Paredes),
	filter_lists([c,b,e,d],Paredes, Direccoes),
	todos_movs_poss(Direccoes, Pos_atual, Movs_Poss),
	filtra_movimentos(Movs_Poss, Movs, Poss).



distancia((_,L1,C1), (_,L2,C2), Dist):-
	Dist is abs(L1-L2) + abs(C1-C2).









/* testes:
Lab1=
[[[d,e,c],[e,b,c],[b,c],[c],[d,c],[d,e,c]],
[[e,b],[b,c],[b,c],[],[b],[d,b]],
[[e,c],[b,c],[b,c],[b],[b,c],[d,b,c]],
[[d,e],[e,c],[c],[c],[c],[d,c]],
[[e,b],[d,b],[e,b],[b],[b],[d,b]]],
movs_possiveis(Lab1, (2,5), [(i, 1, 6), (b, 2, 6), (e, 2, 5)], Poss).
*/