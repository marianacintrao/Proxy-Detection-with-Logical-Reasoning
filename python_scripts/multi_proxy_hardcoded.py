import clingo

def on_model(m):
    print(m)


def call_clingo(data, script):
    ctl = clingo.Control(["-W", "none"])
    #ctl = clingo.Control()
    ctl.add(data)
    ctl.add(script)
    ctl.ground()
    ctl.solve(on_model=on_model)
    print("\n")

import os

absolute_path = os.path.dirname(__file__)
relative_path = "../lib"
full_path = os.path.join(absolute_path, relative_path)

def get_proxy_clusters_hardcoded(datafile):

    data = open(datafile, "r").read()

    # 1 attribute proxy clusters
    script = open("clingo_scripts/multi_proxy_hardcoded_1.lp", "r").read()
    call_clingo(data, script)

    # 2 attributes proxy clusters
    script = open("clingo_scripts/multi_proxy_hardcoded_2.lp", "r").read()
    call_clingo(data, script)
    
    # 3 attributes proxy cluster #
    script = open("clingo_scripts/multi_proxy_hardcoded_3.lp", "r").read()
    call_clingo(data, script)
    