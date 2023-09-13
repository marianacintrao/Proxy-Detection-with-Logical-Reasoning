    three_cluster(Attr1, Val1, Attr2, Val2, Attr3, Val3, Item) :-
        potential_implication(Attr1, Val1, Attr2, Val2, Attr3, Val3, _, _, _, _),
        attribute(Attr1, Item, Val1), attribute(Attr2, Item, Val2), attribute(Attr3, Item, Val3),
        not protected(Attr1), not outcome(Attr1),
        not protected(Attr2), not outcome(Attr2),
        not protected(Attr3), not outcome(Attr3),
        Attr1 != Attr2, Attr1 != Attr3, Attr2 != Attr3.
        
    three_cluster_plus_protected(Attr1, Val1, Attr2, Val2, Attr3, Val3, Attr4, Val4, Item) :-
        potential_implication(Attr1, Val1, Attr2, Val2, Attr3, Val3, Attr4, Val4, _, _),
        attribute(Attr1, Item, Val1), attribute(Attr2, Item, Val2), attribute(Attr3, Item, Val3), 
        not protected(Attr1), not outcome(Attr1),
        not protected(Attr2), not outcome(Attr2),
        not protected(Attr3), not outcome(Attr3),
        Attr1 != Attr2, Attr1 != Attr3, Attr2 != Attr3,

        attribute(Attr4, Item, Val4),
        protected(Attr4).

    count_three_cluster(Attr1, Val1, Attr2, Val2, Attr3, Val3, N) :- 
        N = #count{Item : three_cluster(Attr1, Val1, Attr2, Val2, Attr3, Val3, Item)}, N > 0,
        attribute(Attr1, _, Val1), attribute(Attr2, _, Val2), attribute(Attr3, _, Val3),
        not protected(Attr1), not outcome(Attr1),
        not protected(Attr2), not outcome(Attr2),
        not protected(Attr3), not outcome(Attr3),
        potential_implication(Attr1, Val1, Attr2, Val2, Attr3, Val3, _, _, _, _),
        Attr1 != Attr2, Attr1 != Attr3, Attr2 != Attr3.
    
    count_three_cluster_plus_protected(Attr1, Val1, Attr2, Val2, Attr3, Val3, Attr4, Val4, N) :- 
        N = #count{Item : three_cluster_plus_protected(Attr1, Val1, Attr2, Val2, Attr3, Val3, Attr4, Val4, Item)}, N > 0,
        attribute(Attr1, _, Val1), attribute(Attr2, _, Val2), attribute(Attr3, _, Val3),
        not protected(Attr1), not outcome(Attr1),
        not protected(Attr2), not outcome(Attr2),
        not protected(Attr3), not outcome(Attr3),
        potential_implication(Attr1, Val1, Attr2, Val2, Attr3, Val3, Attr4, Val4, _, _),
        Attr1 != Attr2, Attr1 != Attr3, Attr2 != Attr3,

        attribute(Attr4, _, Val4),
        protected(Attr4).

    implication(Attr1, Val1, Attr2, Val2, Attr3, Val3, Attr4, Val4, P, I) :-
        potential_implication(Attr1, Val1, Attr2, Val2, Attr3, Val3, Attr4, Val4, _, _),
        count_three_cluster(Attr1, Val1, Attr2, Val2, Attr3, Val3, N1), count_three_cluster_plus_protected(Attr1, Val1, Attr2, Val2, Attr3, Val3, Attr4, Val4, N2),
        not protected(Attr1), not outcome(Attr1),
        not protected(Attr2), not outcome(Attr2),
        not protected(Attr3), not outcome(Attr3),
        protected(Attr4),
        P = N2 * 100 / N1,
        P >= 80,
        I = N1 * 100 / C,
        count_items(C),
        I >= 5.

    count_facts(V) :-
        A = #count{Attr : attribute(Attr, _, _)},
        I = #count{Item : attribute(_, Item, _)},
        V = A * I,
        attribute(_, _, _). 

    count_items(I) :-
        I = #count{Item : attribute(_, Item, _)},
        attribute(_, _, _). 

    #show implication/10.
    #show protected/1.
