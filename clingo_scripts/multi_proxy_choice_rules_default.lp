    1 { proxy(Attr, Val) : attribute(Attr, _, Val), not protected(Attr), not outcome(Attr) } 3.

    :- proxy(Attr, Val1), proxy(Attr, Val2), Val1 != Val2.
    :- not proxy(_, _).
    
    item_not_in_cluster(Item) :- proxy(Attr, Val), not attribute(Attr, Item, Val), attribute(_, Item, _).
    item_in_cluster(Item) :- not item_not_in_cluster(Item), attribute(_, Item, _).

    count_cluster_occurrences(N) :-
        N = #count
            { Item : item_in_cluster(Item) }. 

    count_association(Protected, Val, N) :- 
        N = #count
            { Item : item_in_cluster(Item), attribute(Protected, Item, Val)},
        attribute(Protected, _, Val), protected(Protected).

    count_items(I) :-
        I = #count{Item : attribute(_, Item, _)},
        attribute(_, _, _). 


    implication(Protected, Val, P, I) :-
        count_cluster_occurrences(N1), count_association(Protected, Val, N2),
        protected(Protected),
        P = N2 * 100 / N1,
        P >= 80,
        I = N1 * 100 / C,
        count_items(C),
        I >= 5.
        
    count_attributes_in_cluster(C) :-
        C = #count{Attr : proxy(Attr, _)}.

    :- count_cluster_occurrences(N), count_items(N).
    :- not implication(_, _, _, _).

    #show proxy/2.
    #show implication/4.
    #show count_attributes_in_cluster/1.

