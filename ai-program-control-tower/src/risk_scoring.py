import csv

def score(row):
    risk=0
    risk += 30 if int(row["milestone_due_days"]) < 0 else 10 if int(row["milestone_due_days"]) < 3 else 0
    risk += min(int(row["dependency_count"])*5,30)
    risk += min(int(row["blocked_tasks"])*8,40)
    return min(risk,100)

if __name__=="__main__":
    for r in csv.DictReader(open("data/sample/projects.csv")):
        print(r["project"], score(r))
