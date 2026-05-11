import csv
from retrieval_baseline import retrieve
q=list(csv.DictReader(open("data/sample/questions.csv")))[0]
d=retrieve(q["question"]);print({"coverage": int(q["expected"] in d["text"].lower())})
