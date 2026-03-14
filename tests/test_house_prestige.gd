extends GutTest


var _houses := [
	{"id": "studio", "name": "Studio", "cost": 0, "multiplier": 1.0, "unlock_requirement": 0},
	{"id": "small", "name": "Small", "cost": 10000, "multiplier": 2.0, "unlock_requirement": 5000},
	{"id": "big", "name": "Big", "cost": 100000, "multiplier": 5.0, "unlock_requirement": 50000},
]


func test_can_buy_first_house():
	var result := HousePrestige.can_buy_house(_houses[0], 0.0, 0.0)
	assert_true(result, "Should always be able to get first house")


func test_cannot_buy_house_without_earnings():
	var result := HousePrestige.can_buy_house(_houses[1], 1000.0, 50000.0)
	assert_false(result, "Should not buy house without enough total earnings")


func test_cannot_buy_house_without_coins():
	var result := HousePrestige.can_buy_house(_houses[1], 10000.0, 5000.0)
	assert_false(result, "Should not buy house without enough coins")


func test_can_buy_house_with_both():
	var result := HousePrestige.can_buy_house(_houses[1], 10000.0, 20000.0)
	assert_true(result, "Should buy house with enough earnings and coins")


func test_apply_prestige_resets_counts():
	var result := HousePrestige.apply_prestige(_houses[1])
	assert_eq(result.house_id, "small")
	assert_eq(result.house_multiplier, 2.0)
	assert_true(result.food_counts.is_empty(), "Food counts should reset")
	assert_true(result.toy_counts.is_empty(), "Toy counts should reset")


func test_get_house_multiplier():
	var mult := HousePrestige.get_house_multiplier(_houses, "small")
	assert_eq(mult, 2.0)


func test_get_house_multiplier_not_found():
	var mult := HousePrestige.get_house_multiplier(_houses, "nonexistent")
	assert_eq(mult, 1.0, "Should default to 1.0 for unknown house")


func test_get_next_house():
	var next := HousePrestige.get_next_house(_houses, "studio")
	assert_eq(next.id, "small")


func test_get_next_house_from_last():
	var next := HousePrestige.get_next_house(_houses, "big")
	assert_true(next.is_empty(), "No next house from last house")
