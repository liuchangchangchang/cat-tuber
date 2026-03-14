class_name Economy


static func get_item_cost(base_cost: float, cost_multiplier: float, owned_count: int) -> float:
	return floor(base_cost * pow(cost_multiplier, owned_count))


static func get_item_production(base_production: float, owned_count: int, house_multiplier: float) -> float:
	return base_production * owned_count * house_multiplier


static func get_total_cps(foods: Array, toys: Array, food_counts: Dictionary, toy_counts: Dictionary, house_multiplier: float) -> float:
	var total := 0.0
	for item in foods:
		var count: int = food_counts.get(item.id, 0)
		total += item.base_production * count
	for item in toys:
		var count: int = toy_counts.get(item.id, 0)
		total += item.base_production * count
	return total * house_multiplier


static func get_tap_value(tap_bonus: float, total_owned: int, house_multiplier: float) -> float:
	return floor(tap_bonus * (1.0 + total_owned * 0.05) * house_multiplier)


static func get_viewer_count(viewer_base: float, viewer_per_cps: float, cps: float) -> int:
	return int(floor(viewer_base + viewer_per_cps * cps))
