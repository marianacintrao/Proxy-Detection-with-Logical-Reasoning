import clingo

def get_proxy_clusters_choice_rules(datafile, min_implication_probability=80, min_incidence_probability=5, min_cluster_size=1, max_cluster_size=3):

    data = open(datafile, "r").read()
    script = get_script(min_implication_probability, min_incidence_probability, min_cluster_size, max_cluster_size)
    ctl = clingo.Control(["-W", "none", "0"])
    ctl.add(data)
    ctl.add(script)
    ctl.ground()

    for cluster_size in range(min_cluster_size, max_cluster_size + 1):

        sym_count_attrs = clingo.Function("count_attributes_in_cluster", [clingo.Number(cluster_size)])    
        program_name = "cluster"+ str(cluster_size)
        
        ctl.ground([(program_name, [])])

        with ctl.solve(yield_=True, async_=True, assumptions=[
                (sym_count_attrs, True)
            ]) as handle:

            while_True = True
            while while_True:
                handle.resume()
                _ = handle.wait()
                model = handle.model()
                if model is None:
                    print(handle.get())
                    while_True = False
                else:
                    print(model)


def get_script(min_implication_probability, min_incidence_probability, min_cluster_size, max_cluster_size):
    return """
    """ + str(min_cluster_size) + """ { proxy(Attr, Val) : attribute(Attr, _, Val), not protected(Attr), not outcome(Attr) } """ + str(max_cluster_size) + """.

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
        P >= """ + str(min_implication_probability) + """,
        I = N1 * 100 / C,
        count_items(C),
        I >= """ + str(min_incidence_probability) + """.
        
    count_attributes_in_cluster(C) :-
        C = #count{Attr : proxy(Attr, _)}.

    :- count_cluster_occurrences(N), count_items(N).
    :- not implication(_, _, _, _).

    #show proxy/2.
    #show implication/4.
    #show count_attributes_in_cluster/1.

"""

