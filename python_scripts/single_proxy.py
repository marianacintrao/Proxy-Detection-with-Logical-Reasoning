import clingo

class Context:
    def id(x):
        return x
    def seq(x, y):
        return [x, y]
    
def on_model(m):
    print (m)

def get_single_proxies(datafile, min_implication_probability=80, min_incidence_probability=5):
    data = open(datafile, "r").read()
    script = get_script(min_implication_probability, min_incidence_probability)

    ctl = clingo.Control()
    ctl.add(data)
    ctl.add(script)
    ctl.ground(context=Context())

    ctl.solve(on_model=on_model)

def get_script(min_implication_probability, min_incidence_probability):
    return """
    get_association(Attr1, Val1, Attr2, Val2, Item) :-
        attribute(Attr1, Item, Val1), attribute(Attr2, Item, Val2),
        not protected(Attr1), not outcome(Attr1),
        protected(Attr2),
        Attr1 != Attr2.
        
    association(Attr1, Val1, Attr2, Val2) :-
        attribute(Attr1, Item, Val1), attribute(Attr2, Item, Val2),
        not protected(Attr1), not outcome(Attr1),
        protected(Attr2),
        Attr1 != Attr2.

    count_association(Attr1, Val1, Attr2, Val2, N) :- 
        N = #count{Item : get_association(Attr1, Val1, Attr2, Val2, Item)},
        not protected(Attr1), not outcome(Attr1),
        protected(Attr2),
        association(Attr1, Val1, Attr2, Val2).

    count_attribute(Attr, Val, N) :-
        N = #count{Item : attribute(Attr, Item, Val)},
        not protected(Attr), not outcome(Attr),
        attribute(Attr, _, Val). 

    implication(Attr1, Val1, Attr2, Val2, P, I) :-
        count_attribute(Attr1, Val1, N1), count_association(Attr1, Val1, Attr2, Val2, N2),
        not protected(Attr1), not outcome(Attr1),
        protected(Attr2),
        P = N2 * 100 / N1,
        P >= """ + str(min_implication_probability) + """,
        I = N1 * 100 / C,
        count_items(C),
        I >= """ + str(min_incidence_probability) + """.

    count_facts(F) :-
        A = #count{Attr : attribute(Attr, _, _)},
        C = #count{Item : attribute(_, Item, _)},
        F = A * C,
        attribute(_, _, _). 

    count_items(C) :-
        C = #count{Item : attribute(_, Item, _)},
        attribute(_, _, _). 

    #show implication/6.
    #show protected/1.
    #show outcome/1.
    #show count_facts/1.
    #show count_items/1.
"""

