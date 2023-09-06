import re
import sys
from multi_proxy_hardcoded import call_clingo


def process_potential_implications(clingo_output):

    lines = clingo_output.splitlines()
    for i in range(1, len(lines)):
        line = lines[i]
        implications = re.split("implication", line)[1:]
        for imp in implications:
            imp = re.split("count_facts", imp)[0]
            print("potential_implication" + imp + ".")
            

def check_implication(processed_clingo_output, datafile):

    data = open(datafile, "r").read()

    # 1 attribute proxy clusters
    print("cluster size = 1")
    script = open("clingo_scripts/multi_proxy_hardcoded_check_1.lp", "r").read()
    script = script + processed_clingo_output
    try:
        call_clingo(data, script)
    except:
        print("No candidate proxies") 
    print("\n")

    # 2 attribute proxy clusters
    print("cluster size = 2")
    script = open("clingo_scripts/multi_proxy_hardcoded_check_2.lp", "r").read()
    script = script + processed_clingo_output
    try:
        call_clingo(data, script)
    except:
        print("No candidate proxies") 
    print("\n")

    # 3 attribute proxy clusters
    print("cluster size = 3")
    script = open("clingo_scripts/multi_proxy_hardcoded_check_3.lp", "r").read()
    script = script + processed_clingo_output
    try:
        call_clingo(data, script)
    except:
        print("No candidate proxies") 
    print("\n")



if __name__ == "__main__":

    potential_proxies_file = sys.argv[1]
    potential_proxies = open(potential_proxies_file, "r").read()

    datafile = sys.argv[2]

    check_implication(potential_proxies, datafile)


