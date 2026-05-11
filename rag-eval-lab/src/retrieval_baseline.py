import csv
def retrieve(q):
 rows=list(csv.DictReader(open("data/sample/docs.csv")));
 return max(rows,key=lambda r:sum(w in r["text"].lower() for w in q.lower().split()))
