import csv

if __name__=="__main__":
    for r in csv.DictReader(open("data/sample/projects.csv")):
        if int(r["blocked_tasks"]) > 0:
            print("RISK,{project},Blocked tasks={blocked}".format(project=r["project"], blocked=r["blocked_tasks"]))
