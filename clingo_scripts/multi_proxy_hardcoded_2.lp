    two_cluster(Attr1, Val1, Attr2, Val2, Item) :-
        attribute(Attr1, Item, Val1), attribute(Attr2, Item, Val2),
        not protected(Attr1), not outcome(Attr1),
        not protected(Attr2), not outcome(Attr2),
        attribute_id(Attr1, O1), attribute_id(Attr2, O2), O1 < O2. 
        
    two_cluster_plus_protected(Attr1, Val1, Attr2, Val2, Attr3, Val3, Item) :-
        attribute(Attr1, Item, Val1), attribute(Attr2, Item, Val2),
        not protected(Attr1), not outcome(Attr1),
        not protected(Attr2), not outcome(Attr2),
        protected(Attr3),
        Attr1 != Attr2,

        attribute(Attr3, Item, Val3), protected(Attr3).

    count_two_cluster(Attr1, Val1, Attr2, Val2, N) :- 
        N = #count{Item : two_cluster(Attr1, Val1, Attr2, Val2, Item)},
        not protected(Attr1), not outcome(Attr1),
        not protected(Attr2), not outcome(Attr2),
        attribute(Attr1, _, Val1), attribute(Attr2, _, Val2),
        Attr1 != Attr2.
    
    count_two_cluster_plus_protected(Attr1, Val1, Attr2, Val2, Attr3, Val3, N) :- 
        N = #count{Item : two_cluster_plus_protected(Attr1, Val1, Attr2, Val2, Attr3, Val3, Item)}, N > 0,
        not protected(Attr1), not outcome(Attr1),
        not protected(Attr2), not outcome(Attr2),
        protected(Attr3),
        attribute(Attr1, _, Val1), attribute(Attr2, _, Val2), attribute(Attr3, _, Val3),
        Attr1 != Attr2.

    implication(Attr1, Val1, Attr2, Val2, Attr3, Val3, P, I) :-
        count_two_cluster(Attr1, Val1, Attr2, Val2, N1), count_two_cluster_plus_protected(Attr1, Val1, Attr2, Val2, Attr3, Val3, N2),
        not protected(Attr1), not outcome(Attr1),
        not protected(Attr2), not outcome(Attr2),
        protected(Attr3),
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

    #show implication/8.
    #show protected/1.
