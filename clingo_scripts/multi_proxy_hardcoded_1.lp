    one_cluster(Attr1, Val1, Item) :-
        attribute(Attr1, Item, Val1),
        not protected(Attr1), not outcome(Attr1).

    one_cluster_plus_protected(Attr1, Val1, Attr2, Val2, Item) :-
        attribute(Attr1, Item, Val1), attribute(Attr2, Item, Val2),
        not protected(Attr1), not outcome(Attr1),
        protected(Attr2).
        
    count_one_cluster(Attr1, Val1, N) :-
        N = #count{Item : one_cluster(Attr1, Val1, Item)},
        attribute(Attr1, _, Val1),
        not protected(Attr1), not outcome(Attr1).

    count_one_cluster_plus_protected(Attr1, Val1, Attr2, Val2, N) :- 
        N = #count{Item : one_cluster_plus_protected(Attr1, Val1, Attr2, Val2, Item)},
        not protected(Attr1), not outcome(Attr1),
        protected(Attr2),
        attribute(Attr1, _, Val1), attribute(Attr2, _, Val2).

    implication(Attr1, Val1, Attr2, Val2, P, I) :-
        count_one_cluster(Attr1, Val1, N1), count_one_cluster_plus_protected(Attr1, Val1, Attr2, Val2, N2),
        not protected(Attr1), not outcome(Attr1),
        protected(Attr2),
        P = N2 * 100 / N1,
        P >= 80,
        I = N1 * 100 / C,
        I >= 5,
        count_items(C).

    count_facts(V) :-
        A = #count{Attr : attribute(Attr, _, _)},
        I = #count{Item : attribute(_, Item, _)},
        V = A * I,
        attribute(_, _, _). 

    count_items(I) :-
        I = #count{Item : attribute(_, Item, _)},
        attribute(_, _, _). 


    #show implication/6.
    #show protected/1.
    #show count_facts/1.
    #show count_items/1.
