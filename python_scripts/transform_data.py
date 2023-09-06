import pandas as pd
import sys
import random

def format_value(value):
    if type(value) != str:
        return '"' + str(round(value, 2)) + '"'
    else:
        return  '"' + value.replace('"', "'") + '"'
    

def write_clingo_data(data, clingodataname, protected_attributes, outcome_attribute):
    
    attributes = list(data.columns)
    f = open(clingodataname, "w")
        
    for index, row in data.iterrows():
        item_name = "i" + str(index)

        for attr in attributes:
            rows_string = "attribute(" + format_value(attr) + ", " + item_name + ", " + format_value(row[attr]) + ").\n"
            f.write(rows_string)
        f.write("\n")

    protected_string = "\n".join(["protected(" + '"' + attr + '"' + ")." for attr in protected_attributes])
    f.write(protected_string)
    f.write("\n\n")

    outcome_string = "outcome(" + format_value(outcome_attribute) + ")."
    f.write(outcome_string)
    f.write("\n")

    f.close()


def csv_to_clingo(sourcedatafolder, dataset, outdatafolder, protected_attributes, outcome_attribute):

    datafilename = dataset + ".csv"
    clingodataname = outdatafolder + "data-" + dataset + ".lp"

    data = pd.read_csv(sourcedatafolder + datafilename)

    write_clingo_data(data, clingodataname, protected_attributes, outcome_attribute)
        
   

def undersample_csv_to_clingo(sourcedatafolder, dataset, outdatafolder, protected_attributes, outcome_attribute, n_records=500):

    datafilename = dataset + ".csv"
    clingodataname = outdatafolder + "recs-" + str(n_records) + "-data-" + dataset + ".lp"

    data = pd.read_csv(sourcedatafolder + datafilename)
    #n_records = min(data.shape[0], n_records)
    data = data.sample(n=n_records)

    write_clingo_data(data, clingodataname, protected_attributes, outcome_attribute)

