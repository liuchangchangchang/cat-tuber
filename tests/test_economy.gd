extends GutTest


func test_item_cost_base():
	var cost := Economy.get_item_cost(10.0, 1.15, 0)
	assert_eq(cost, 10.0, "Base cost with 0 owned should be base_cost")


func test_item_cost_scales_exponentially():
	var cost0 := Economy.get_item_cost(10.0, 1.15, 0)
	var cost1 := Economy.get_item_cost(10.0, 1.15, 1)
	var cost5 := Economy.get_item_cost(10.0, 1.15, 5)
	var cost10 := Economy.get_item_cost(10.0, 1.15, 10)
	assert_true(cost1 > cost0, "Cost should increase with owned count")
	assert_true(cost5 > cost1, "Cost should keep increasing")
	assert_true(cost10 > cost5, "Cost should keep increasing")
	# Verify exponential: cost10 should be floor(10 * 1.15^10) = floor(40.45) = 40
	assert_eq(cost10, floor(10.0 * pow(1.15, 10)))


func test_item_production_linear():
	var prod1 := Economy.get_item_production(2.0, 1, 1.0)
	var prod5 := Economy.get_item_production(2.0, 5, 1.0)
	assert_eq(prod1, 2.0)
	assert_eq(prod5, 10.0, "Production should scale linearly")


func test_item_production_with_house_mult():
	var prod := Economy.get_item_production(2.0, 5, 3.0)
	assert_eq(prod, 30.0, "Production should include house multiplier")


func test_total_cps():
	var foods := [{"id": "a", "base_production": 1.0}, {"id": "b", "base_production": 2.0}]
	var toys := [{"id": "c", "base_production": 3.0}]
	var food_counts := {"a": 2, "b": 1}
	var toy_counts := {"c": 3}
	var cps := Economy.get_total_cps(foods, toys, food_counts, toy_counts, 1.0)
	# (1*2 + 2*1 + 3*3) * 1 = 13
	assert_eq(cps, 13.0)


func test_total_cps_with_house_mult():
	var foods := [{"id": "a", "base_production": 1.0}]
	var toys: Array = []
	var food_counts := {"a": 10}
	var toy_counts: Dictionary = {}
	var cps := Economy.get_total_cps(foods, toys, food_counts, toy_counts, 5.0)
	assert_eq(cps, 50.0, "CPS should include house multiplier")


func test_tap_value_base():
	var val := Economy.get_tap_value(1.0, 0, 1.0)
	assert_eq(val, 1.0, "Tap with 0 owned should give base tap bonus")


func test_tap_value_scales_with_owned():
	var val0 := Economy.get_tap_value(1.0, 0, 1.0)
	var val10 := Economy.get_tap_value(1.0, 10, 1.0)
	var val20 := Economy.get_tap_value(1.0, 20, 1.0)
	assert_eq(val0, 1.0)
	assert_eq(val10, floor(1.0 * (1.0 + 10 * 0.05)))  # floor(1.5) = 1
	assert_eq(val20, floor(1.0 * (1.0 + 20 * 0.05)))  # floor(2.0) = 2


func test_tap_value_with_house_mult():
	var val := Economy.get_tap_value(1.0, 20, 5.0)
	# floor(1 * (1 + 20*0.05) * 5) = floor(10) = 10
	assert_eq(val, 10.0)


func test_viewer_count():
	var viewers := Economy.get_viewer_count(5.0, 0.5, 0.0)
	assert_eq(viewers, 5, "Base viewers with 0 CPS")
	var viewers2 := Economy.get_viewer_count(5.0, 0.5, 10.0)
	assert_eq(viewers2, 10, "5 + 0.5*10 = 10")
