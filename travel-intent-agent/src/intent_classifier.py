def classify(q):
 q=q.lower(); return "leisure" if "beach" in q else "budget" if "budget" in q else "business"
