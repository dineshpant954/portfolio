import csv

if __name__=="__main__":
    rows=list(csv.DictReader(open("data/sample/projects.csv")))
    red=sum(1 for r in rows if r["status"]=="red")
    print({"total_projects":len(rows),"red_projects":red})
