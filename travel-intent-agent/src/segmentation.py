def segment(tier,booked):
 return "high_value" if tier in ["gold","platinum"] and booked else "nurture"
