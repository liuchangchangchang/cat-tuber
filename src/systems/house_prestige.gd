class_name HousePrestige


static func can_buy_house(house_data: Dictionary, total_earned_all_time: float, current_coins: float) -> bool:
	return total_earned_all_time >= house_data.unlock_requirement and current_coins >= house_data.cost


static func apply_prestige(house_data: Dictionary) -> Dictionary:
	return {
		"house_id": house_data.id,
		"house_multiplier": house_data.multiplier,
		"food_counts": {},
		"toy_counts": {},
	}


static func get_house_multiplier(houses_data: Array, house_id: String) -> float:
	for house in houses_data:
		if house.id == house_id:
			return house.multiplier
	return 1.0


static func get_next_house(houses_data: Array, current_house_id: String) -> Dictionary:
	for i in range(houses_data.size() - 1):
		if houses_data[i].id == current_house_id:
			return houses_data[i + 1]
	return {}
