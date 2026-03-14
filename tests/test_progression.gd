extends GutTest

# Simulates game progression to verify balance
# Player should reach first house upgrade in ~10 minutes of play


func test_early_game_affordable():
	# Player starts with 0 coins, tapping gives 1 coin
	# Catnip costs 10 - should take ~10 taps
	var tap_value := Economy.get_tap_value(1.0, 0, 1.0)
	assert_eq(tap_value, 1.0)
	var catnip_cost := Economy.get_item_cost(10.0, 1.15, 0)
	assert_eq(catnip_cost, 10.0)
	# 10 taps to buy first catnip - reasonable


func test_catnip_generates_income():
	# After buying catnip, CPS goes up
	var foods := [{"id": "catnip", "base_production": 0.5}]
	var food_counts := {"catnip": 1}
	var cps := Economy.get_total_cps(foods, [], food_counts, {}, 1.0)
	assert_eq(cps, 0.5, "One catnip should give 0.5 CPS")


func test_simulated_10_minute_progression():
	# Simulate 10 minutes of optimal play
	var coins := 0.0
	var total_earned := 0.0
	var cps := 0.1  # base CPS
	var food_counts: Dictionary = {}
	var foods := [
		{"id": "catnip", "base_cost": 10.0, "base_production": 0.5, "cost_multiplier": 1.15},
		{"id": "tuna_can", "base_cost": 50.0, "base_production": 2.0, "cost_multiplier": 1.15},
	]
	var toys := [
		{"id": "ball_of_yarn", "base_cost": 25.0, "base_production": 1.0, "cost_multiplier": 1.15},
	]
	var toy_counts: Dictionary = {}

	# Simulate 600 seconds (10 min) in 1-second ticks
	for _t in range(600):
		coins += cps
		total_earned += cps
		# Tap once per second
		var total_owned := 0
		for c in food_counts.values():
			total_owned += c
		for c in toy_counts.values():
			total_owned += c
		coins += Economy.get_tap_value(1.0, total_owned, 1.0)
		total_earned += Economy.get_tap_value(1.0, total_owned, 1.0)

		# Auto-buy cheapest affordable item
		var bought := true
		while bought:
			bought = false
			var best_item: Dictionary = {}
			var best_cost := INF
			var best_cat := ""
			var best_counts: Dictionary = {}
			for item in foods:
				var count: int = food_counts.get(item.id, 0)
				var cost := Economy.get_item_cost(item.base_cost, item.cost_multiplier, count)
				if cost < best_cost and coins >= cost:
					best_cost = cost
					best_item = item
					best_cat = "food"
					best_counts = food_counts
			for item in toys:
				var count: int = toy_counts.get(item.id, 0)
				var cost := Economy.get_item_cost(item.base_cost, item.cost_multiplier, count)
				if cost < best_cost and coins >= cost:
					best_cost = cost
					best_item = item
					best_cat = "toy"
					best_counts = toy_counts
			if not best_item.is_empty() and coins >= best_cost:
				coins -= best_cost
				best_counts[best_item.id] = best_counts.get(best_item.id, 0) + 1
				cps = Economy.get_total_cps(foods, toys, food_counts, toy_counts, 1.0) + 0.1
				bought = true

	# After 10 min player should have earned enough for first house unlock (5K)
	assert_true(total_earned >= 5000.0,
		"Should earn 5K+ in 10min, got: " + str(total_earned))


func test_house_multiplier_accelerates():
	# After upgrading to 2x house, earning rate should double
	var foods := [{"id": "catnip", "base_production": 0.5}]
	var food_counts := {"catnip": 10}
	var cps1 := Economy.get_total_cps(foods, [], food_counts, {}, 1.0)
	var cps2 := Economy.get_total_cps(foods, [], food_counts, {}, 2.0)
	assert_eq(cps2, cps1 * 2.0, "2x house should double CPS")


func test_cost_scaling_prevents_runaway():
	# Verify costs grow fast enough to prevent instant progression
	var cost0 := Economy.get_item_cost(10.0, 1.15, 0)
	var cost20 := Economy.get_item_cost(10.0, 1.15, 20)
	var cost50 := Economy.get_item_cost(10.0, 1.15, 50)
	assert_true(cost20 > cost0 * 10, "Cost at 20 should be 10x+ base")
	assert_true(cost50 > cost0 * 100, "Cost at 50 should be 100x+ base")
