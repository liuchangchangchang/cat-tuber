extends Node

signal currency_changed(new_coins: float, coins_per_second: float)
signal item_purchased(category: String, item_id: String, new_count: int)
signal house_upgraded(house_id: String, new_multiplier: float)
signal viewers_changed(count: int)
signal tap_earned(amount: float)
signal furniture_hit(furniture_id: String)
signal ad_boost_changed(active: bool, remaining: float)

var coins: float = 0.0
var total_earned_all_time: float = 0.0
var coins_per_second: float = 0.0
var current_house_id: String = "studio_apartment"
var house_multiplier: float = 1.0
var viewer_count: int = 5
var food_counts: Dictionary = {}
var toy_counts: Dictionary = {}

var ad_boost_active: bool = false
var ad_boost_remaining: float = 0.0
var tap_count: int = 0

var _balance: Dictionary = {}
var _foods: Array = []
var _toys: Array = []
var _houses: Array = []

var _tick_accumulator: float = 0.0


func _ready() -> void:
	_load_data()
	_recalculate_cps()


func _load_data() -> void:
	_balance = _load_json("res://data/balance.json")
	var foods_data := _load_json("res://data/foods.json")
	_foods = foods_data.get("items", [])
	var toys_data := _load_json("res://data/toys.json")
	_toys = toys_data.get("items", [])
	var houses_data := _load_json("res://data/houses.json")
	_houses = houses_data.get("houses", [])
	coins = _balance.get("starting_coins", 0)


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to load: " + path)
		return {}
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	if err != OK:
		push_error("JSON parse error in " + path + ": " + json.get_error_message())
		return {}
	return json.data


func _process(delta: float) -> void:
	if ad_boost_active:
		ad_boost_remaining -= delta
		if ad_boost_remaining <= 0:
			ad_boost_active = false
			ad_boost_remaining = 0.0
			_recalculate_cps()
			ad_boost_changed.emit(false, 0.0)

	if coins_per_second > 0:
		_tick_accumulator += delta
		if _tick_accumulator >= 0.1:
			var earned := coins_per_second * _tick_accumulator
			_add_coins(earned)
			_tick_accumulator = 0.0


func _add_coins(amount: float) -> void:
	coins += amount
	total_earned_all_time += amount
	_update_viewers()
	currency_changed.emit(coins, coins_per_second)


func _recalculate_cps() -> void:
	coins_per_second = Economy.get_total_cps(_foods, _toys, food_counts, toy_counts, house_multiplier)
	coins_per_second += _balance.get("base_coins_per_second", 0.1)
	if ad_boost_active:
		coins_per_second *= _balance.get("ad_boost_multiplier", 2.0)
	currency_changed.emit(coins, coins_per_second)
	_update_viewers()


func _update_viewers() -> void:
	var new_count := Economy.get_viewer_count(
		_balance.get("viewer_base", 5),
		_balance.get("viewer_per_coins_per_second", 0.5),
		coins_per_second
	)
	if new_count != viewer_count:
		viewer_count = new_count
		viewers_changed.emit(viewer_count)


func tap() -> void:
	tap_count += 1
	var total_owned := _get_total_owned()
	var amount := Economy.get_tap_value(
		_balance.get("tap_bonus_coins", 1),
		total_owned,
		house_multiplier
	)
	_add_coins(amount)
	tap_earned.emit(amount)


func buy_food(item_id: String) -> bool:
	return _buy_item("food", item_id, _foods, food_counts)


func buy_toy(item_id: String) -> bool:
	return _buy_item("toy", item_id, _toys, toy_counts)


func buy_house(house_id: String) -> bool:
	var house := _find_item(_houses, house_id)
	if house.is_empty():
		return false
	if not HousePrestige.can_buy_house(house, total_earned_all_time, coins):
		return false
	coins -= house.cost
	var result := HousePrestige.apply_prestige(house)
	current_house_id = result.house_id
	house_multiplier = result.house_multiplier
	food_counts = result.food_counts
	toy_counts = result.toy_counts
	_recalculate_cps()
	house_upgraded.emit(current_house_id, house_multiplier)
	currency_changed.emit(coins, coins_per_second)
	return true


func activate_ad_boost() -> void:
	ad_boost_active = true
	ad_boost_remaining = _balance.get("ad_boost_duration_seconds", 120.0)
	_recalculate_cps()
	ad_boost_changed.emit(true, ad_boost_remaining)


func get_item_cost(category: String, item_id: String) -> float:
	var items: Array = _foods if category == "food" else _toys
	var counts: Dictionary = food_counts if category == "food" else toy_counts
	var item := _find_item(items, item_id)
	if item.is_empty():
		return 0.0
	return Economy.get_item_cost(item.base_cost, item.cost_multiplier, counts.get(item_id, 0))


func get_item_count(category: String, item_id: String) -> int:
	var counts: Dictionary = food_counts if category == "food" else toy_counts
	return counts.get(item_id, 0)


func get_foods() -> Array:
	return _foods


func get_toys() -> Array:
	return _toys


func get_houses() -> Array:
	return _houses


func get_balance() -> Dictionary:
	return _balance


func get_current_house() -> Dictionary:
	return _find_item(_houses, current_house_id)


func get_current_house_index() -> int:
	for i in range(_houses.size()):
		if _houses[i].id == current_house_id:
			return i
	return 0


func get_next_house() -> Dictionary:
	return HousePrestige.get_next_house(_houses, current_house_id)


func get_total_food_count() -> int:
	var total := 0
	for count in food_counts.values():
		total += count
	return total


func get_total_toy_count() -> int:
	var total := 0
	for count in toy_counts.values():
		total += count
	return total


func get_destruction_interval() -> float:
	return Destruction.get_destruction_interval(coins_per_second)


func _buy_item(category: String, item_id: String, items: Array, counts: Dictionary) -> bool:
	var item := _find_item(items, item_id)
	if item.is_empty():
		return false
	var owned: int = counts.get(item_id, 0)
	var cost := Economy.get_item_cost(item.base_cost, item.cost_multiplier, owned)
	if coins < cost:
		return false
	coins -= cost
	counts[item_id] = owned + 1
	_recalculate_cps()
	item_purchased.emit(category, item_id, counts[item_id])
	currency_changed.emit(coins, coins_per_second)
	return true


func _find_item(items: Array, item_id: String) -> Dictionary:
	for item in items:
		if item.id == item_id:
			return item
	return {}


func _get_total_owned() -> int:
	var total := 0
	for count in food_counts.values():
		total += count
	for count in toy_counts.values():
		total += count
	return total


func get_save_data() -> Dictionary:
	return {
		"coins": coins,
		"total_earned_all_time": total_earned_all_time,
		"current_house_id": current_house_id,
		"house_multiplier": house_multiplier,
		"food_counts": food_counts.duplicate(),
		"toy_counts": toy_counts.duplicate(),
		"ad_boost_remaining": ad_boost_remaining,
		"tap_count": tap_count,
		"timestamp": Time.get_unix_time_from_system(),
	}


func load_save_data(data: Dictionary) -> void:
	coins = data.get("coins", 0.0)
	total_earned_all_time = data.get("total_earned_all_time", 0.0)
	current_house_id = data.get("current_house_id", "studio_apartment")
	house_multiplier = data.get("house_multiplier", 1.0)
	food_counts = data.get("food_counts", {})
	toy_counts = data.get("toy_counts", {})
	ad_boost_remaining = data.get("ad_boost_remaining", 0.0)
	tap_count = int(data.get("tap_count", 0))
	if ad_boost_remaining > 0:
		ad_boost_active = true
	_recalculate_cps()
	house_upgraded.emit(current_house_id, house_multiplier)
