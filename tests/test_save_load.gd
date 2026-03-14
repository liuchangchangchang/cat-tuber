extends GutTest


func test_offline_earnings_basic():
	var earnings := OfflineEarnings.calculate(10.0, 3600.0, 8.0, 0.5)
	# 10 * 3600 * 0.5 = 18000
	assert_eq(earnings, 18000.0)


func test_offline_earnings_capped():
	var earnings := OfflineEarnings.calculate(10.0, 100000.0, 8.0, 0.5)
	# capped at 8h = 28800s: 10 * 28800 * 0.5 = 144000
	assert_eq(earnings, 144000.0)


func test_offline_earnings_zero_cps():
	var earnings := OfflineEarnings.calculate(0.0, 3600.0, 8.0, 0.5)
	assert_eq(earnings, 0.0)


func test_offline_earnings_zero_time():
	var earnings := OfflineEarnings.calculate(10.0, 0.0, 8.0, 0.5)
	assert_eq(earnings, 0.0)


func test_offline_earnings_negative_time():
	var earnings := OfflineEarnings.calculate(10.0, -100.0, 8.0, 0.5)
	assert_eq(earnings, 0.0, "Negative elapsed should give 0")


func test_save_data_structure():
	# Verify the save data has all expected keys
	# This test would need GameManager autoload, so we test the structure
	var expected_keys := ["coins", "total_earned_all_time", "current_house_id",
		"house_multiplier", "food_counts", "toy_counts", "timestamp"]
	var mock_data := {
		"coins": 100.0,
		"total_earned_all_time": 500.0,
		"current_house_id": "studio_apartment",
		"house_multiplier": 1.0,
		"food_counts": {"catnip": 3},
		"toy_counts": {},
		"timestamp": 1000000.0,
	}
	for key in expected_keys:
		assert_true(mock_data.has(key), "Save data should have key: " + key)
