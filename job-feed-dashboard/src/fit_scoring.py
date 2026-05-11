def score_fit(k):
 t=["llm","product","metrics"];k=k.lower();return sum(1 for x in t if x in k)/len(t)
