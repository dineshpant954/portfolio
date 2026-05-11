def extract(text):
 return sorted(set(word.lower().strip(",.") for word in text.split() if len(word)>3))
