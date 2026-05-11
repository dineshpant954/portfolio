from risk_scoring import score

def test_score_high_risk():
    assert score({"milestone_due_days":"-1","dependency_count":"10","blocked_tasks":"2"}) >= 70
