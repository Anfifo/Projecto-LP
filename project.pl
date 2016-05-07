/* * * * * * * * * * * * * * * * * * * * * * * *
* André Fonseca 
* 	84698
* Bárbara Caracol
* 	84703
* LP LEIC-T 2016 
* * * * * * * * * * * * * * * * * * * * * * * */


/* * * * * * * * * * * * * * * * * * * * * * * *
* dir = c, b, e, d
* pos = posicao = (Linha, Coluna)
* lab = labirinto =  [[(dir,pos),...], [(dir,pos),...]]
* i = direcao que diz que e' a primeira posicao
* * * * * * * * * * * * * * * * * * * * * * * */


/* * * * * * * * * * * * * * * * * * * * * * * *
*
*			FUNCOES AUXILIARES
*
* * * * * * * * * * * * * * * * * * * * * * * */

% add_lists\3 
% (List1, List2, List1_e_List2_juntas)
add_lists([], L, L):-!.
add_lists(L,[],L):-!.
add_lists([H|T], L, C_list):-
	add_lists(T, L, C_list2),
	C_list = [H| C_list2].

% esta_na_lista\2
% (List, Elemento), ve se o elemento esta na lista
esta_na_lista([],_):- fail,!.
esta_na_lista([H|_], H):-!. 
esta_na_lista([H|T], Elem):-
	H \== Elem ,
	esta_na_lista(T, Elem),!.


% remove_elemento\3
% (List, Elemento, List_sem_o_elemento), remove um elemento da List
remove_elemento([], _, []):-!.

remove_elemento([Head|Tail], Element, New_list):-
	Head \== Element,
	remove_elemento(Tail, Element, New_list_Tail),
	New_list = [Head| New_list_Tail], !.

remove_elemento([Head | Tail], Element, New_list):-
	Head == Element,
	remove_elemento(Tail, Element, New_list_Tail),
	New_list = New_list_Tail, !.


% get_elemento_in_list\3
% (List, Position, Elemento in Position), finds the element in list's position
encontra_elemento_em_lista([Head|_], 1, Head):-!.
encontra_elemento_em_lista([_|Tail], Pos, Element):-
	Pos > 1,
	Pos1 is Pos -1,
	encontra_elemento_em_lista(Tail, Pos1, Element), !.


% encontra_paredes\3
% (Lista, Posicao, paredes_na_posicao), encontra as 
% paredes/elementos numa posicao de uma matriz
encontra_paredes(List,(L,C), Element):-
	encontra_elemento_em_lista(List, L, New_list),
	encontra_elemento_em_lista(New_list, C, Element),!.


% cria_mov\3
% (direccao, posicao, Movimento_no_sentido_da_direccao)
% cria um movimento a partir da posicao e da direccao
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


% todos_movs_poss\3
% (Lista_Direccoes, Posicao, Movimentos_Possiveis)
% cria uma lista com todos os movimentos possiveis sobre as direccoes da lista
todos_movs_poss([], _,[]):-!.
todos_movs_poss(Dir_List, Pos, Poss_Movs):-
	[Head|Tail] = Dir_List,
	cria_mov(Head, Pos, Mov),
	todos_movs_poss(Tail, Pos, Prev_Poss_Movs),
	Poss_Movs = [Mov|Prev_Poss_Movs],!.


% filtra_listas\3
% (Lista, Filtro, Lista_sem_elementos_no_Filtro)
filtra_listas([],_,[]):-!.

filtra_listas([Head|Tail], Filter, Filtered):- 
	\+esta_na_lista(Filter, Head),
	filtra_listas(Tail, Filter, Filtered2),
	Filtered = [Head|Filtered2], !.

filtra_listas([Head|Tail], Filter, Filtered):- 
	esta_na_lista(Filter, Head),
	filtra_listas(Tail, Filter, Filtered), !.


% filtra_movimentos_aux\3
% (Movimento, Lista_de_Movimentos_a_filtrar, Lista_com_Movimento_filtrado)
% Se o movimento nao se encontrar na lista de movimentos,
% pomos na Lista_com_movimentos_filtrado
filtra_movimentos_aux((_,L,C), [(_,L,C)|_], []):-!.
filtra_movimentos_aux(Mov_Poss, [_|T], Poss):-
	filtra_movimentos_aux(Mov_Poss, T, Poss),!.
filtra_movimentos_aux(Mov_Poss, [],[Mov_Poss]):-!.

%filtra_movimentos\3
% (L_Movimentos_Possiveis, L_Movimentos_feitos, L_dos_possiveis_sem_os_feitos)
filtra_movimentos([],_,[]):-!.
filtra_movimentos([Head|Tail], Movs, Poss):-
	filtra_movimentos_aux(Head, Movs, Poss3),
	filtra_movimentos(Tail, Movs, Poss2),
	add_lists(Poss3,Poss2,Poss),!.


% coordenada_mov\2
% (Movimento, Posicao_do_movimento)
coordenada_mov((_,L,C), (L,C)).









/* * * * * * * * * * * * * * * * * * * * * * * *
*
*	 		FUNCOES PRINCIPAIS
*
* * * * * * * * * * * * * * * * * * * * * * * */

% movs_possiveis\4
% (Labirinto, Posicao_atual, Movimentos_Feitos, Movimentos_Possiveis)
% Na posicao atual do labirinto, ve os Movimentos possiveis, que sao
% os movimentos permitidos pelas paredes e que ainda nao foram feitos.
movs_possiveis(Lab, Pos_atual, Movs, Poss):-
	encontra_paredes(Lab, Pos_atual, Paredes),
	filtra_listas([c,b,e,d],Paredes, Direccoes),
	todos_movs_poss(Direccoes, Pos_atual, Movs_Poss),
	filtra_movimentos(Movs_Poss, Movs, Poss).




% distancia\3
% (Posicao1, Posicao2, Distancia_entre_posicao1_e_a_posicao2)
distancia((L1,C1), (L2,C2), Dist):-
	Dist is abs(L1-L2) + abs(C1-C2).




% encontra_mov_minimo\4
% (Lista_Movimentos, Posicao_Inicial, Posica_Final, Minimo)
% encontra o Movimento mais proximo da distancia Final,
% em caso de empate, encontra o mais distante da posicao inicial,
% em caso de empate de novo, o que seguir a ordem em que aparece na lista
encontra_mov_minimo([Head|[]],_,_, Head):-!.

encontra_mov_minimo([Head|Tail], Ini, Fin, Head):-
	encontra_mov_minimo(Tail, Ini, Fin, Min),
	coordenada_mov(Head, Coord),
	coordenada_mov(Min, MinCoord),
	distancia(Coord, Fin, Dist),
	distancia(MinCoord, Fin, Min_Dist),
	Dist < Min_Dist,!.

encontra_mov_minimo([Head|Tail], Ini, Fin, Head):-
	encontra_mov_minimo(Tail, Ini, Fin, Min),
	coordenada_mov(Head, Coord),
	coordenada_mov(Min, MinCoord),
	distancia(Coord, Fin, Dist),
	distancia(MinCoord, Fin, Min_Dist),
	Dist == Min_Dist,
	distancia(Coord, Ini, Dist_Ini),
	distancia(MinCoord, Ini, Min_Dist_Ini),
	Dist_Ini >= Min_Dist_Ini,!.

encontra_mov_minimo([Head|Tail], Ini, Fin, Min):-
	encontra_mov_minimo(Tail, Ini, Fin, Min),
	coordenada_mov(Head, Coord),
	coordenada_mov(Min, MinCoord),
	distancia(Coord, Fin, Dist),
	distancia(MinCoord, Fin, Min_Dist),
	Dist >= Min_Dist,!.


% ordena_poss\4
% ordena_poss(Mov_Possiveis, Mov_Possiveis_Ordenados, Pos_inicial, Pos_final)
% ordeda os movimentos em relacao a sua distancia a posicao final, em caso 
% de empate ordena em relacao a distancia inicial
ordena_poss([], [], _, _):-!.
ordena_poss(Poss, Poss_ord, Pos_ini, Pos_fin):-
	encontra_mov_minimo(Poss, Pos_ini, Pos_fin, Min),
	remove_elemento(Poss, Min, Poss2),
	ordena_poss(Poss2, Poss_ord2, Pos_ini, Pos_fin),
	Poss_ord = [Min|Poss_ord2],!.



	
% encontra_caminho\5
% (Labirinto, Pos_atual, Pos_Final, Movs_Para_fim, Movs_Feitos_ate_agora)
% encontra os movimentos necessarios para se chegar da Pos_Atual_a_final
% seguindo a ordem dos movimentos c > b > e > d
encontra_caminho(_, Pos_fin, Pos_fin, [], _):-!.

encontra_caminho(Lab, Pos_atual, Pos_fin, Movs, Movs_feitos):-
	movs_possiveis(Lab, Pos_atual, Movs_feitos, [Prox_mov|_]),
	coordenada_mov(Prox_mov, Nova_pos),
	encontra_caminho(Lab, Nova_pos, Pos_fin, Movs_Futuros, [Prox_mov|Movs_feitos]),
	Movs = [Prox_mov|Movs_Futuros],!.

encontra_caminho(Lab, Pos_atual, Pos_fin, Movs, Movs_feitos):-
	movs_possiveis(Lab, Pos_atual, Movs_feitos, [Prox_mov|_]),
	encontra_caminho(Lab, Pos_atual, Pos_fin, Movs, [Prox_mov|Movs_feitos]),!.

% resolve1\4 
% (Labirinto, Posicao_inicial, Posicao_final, Movimentos_ate_a_pos_final)
% encontra a lista de todos os movimentos feitos desde a posicao inicial a final,
% seguindo a prioridade de movimentos c > b > e > d
resolve1(Lab, (L,C), Pos_fin, Movs):-
		encontra_caminho(Lab, (L,C), Pos_fin, Movs2, [(i,L,C)]),
		Movs = [(i,L,C)|Movs2].




% encontra_caminho2\6
% (Labirinto,Pos_inicial, Pos_atual, Pos_Final, Movs_Para_fim, Movs_Feitos_ate_agora)
% encontra os movimentos necessarios para se chegar da Pos_Atual_a_final
% seguindo a ordem do movimento que resulte na posicao mais proxima da final.
encontra_caminho2( _, _, Pos_fin, Pos_fin, [], _):-!.

encontra_caminho2(Lab, Pos_ini, Pos_atual, Pos_fin, Movs, Movs_feitos):-
	movs_possiveis(Lab, Pos_atual, Movs_feitos, Poss_Desord),
	ordena_poss(Poss_Desord, [Prox_mov|_], Pos_ini, Pos_fin),
	coordenada_mov(Prox_mov, Nova_pos),
	encontra_caminho2(Lab, Pos_ini, Nova_pos, Pos_fin, Movs_Futuros, [Prox_mov|Movs_feitos]),
	Movs = [Prox_mov|Movs_Futuros],!.

encontra_caminho2(Lab,Pos_ini, Pos_atual, Pos_fin, Movs, Movs_feitos):-
	movs_possiveis(Lab, Pos_atual, Movs_feitos, Poss_Desord),
	ordena_poss(Poss_Desord, [Prox_mov|_], Pos_ini, Pos_fin),
	encontra_caminho2(Lab , Pos_ini, Pos_atual, Pos_fin, Movs, [Prox_mov|Movs_feitos]),!.


% resolve2\4
% (Labirinto,Pos_inicial, Pos_Final, Movs_Para_fim)
% encontra os movimentos necessarios para se chegar da Pos_Atual_a_final
% seguindo a ordem do movimento que resulte na posicao mais proxima da final.
resolve2(Lab, (L,C), Pos_fin, Movs):-
		encontra_caminho2(Lab, (L,C), (L,C), Pos_fin, Movs2, [(i,L,C)]),
		Movs = [(i,L,C)|Movs2].

