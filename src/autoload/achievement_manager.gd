extends Node

signal achievement_completed(achievement_id: String)

var _achievements: Array = []
var _completed: Dictionary = {}
var _notified: Dictionary = {}
var _check_timer: float = 0.0


func _ready() -> void:
	var file := FileAccess.open("res://data/achievements.json", FileAccess.READ)
	if file:
		var json := JSON.new()
		json.parse(file.get_as_text())
		_achievements = json.data.get("achievements", [])

	GameManager.item_purchased.connect(func(_c, _i, _n): _check_all())
	GameManager.house_upgraded.connect(func(_h, _m): _check_all())


func _process(delta: float) -> void:
	_check_timer += delta
	if _check_timer >= 2.0:
		_check_timer = 0.0
		_check_all()


func _check_all() -> void:
	for ach in _achievements:
		if _completed.get(ach.id, false):
			continue
		var progress := get_progress(ach)
		if progress >= ach.target:
			_completed[ach.id] = true
			if not _notified.get(ach.id, false):
				_notified[ach.id] = true
				GameManager.coins += ach.reward
				GameManager.total_earned_all_time += ach.reward
				GameManager.currency_changed.emit(GameManager.coins, GameManager.coins_per_second)
				achievement_completed.emit(ach.id)


func get_progress(ach: Dictionary) -> float:
	match ach.type:
		"earned":
			return GameManager.total_earned_all_time
		"food_count":
			return GameManager.get_total_food_count()
		"toy_count":
			return GameManager.get_total_toy_count()
		"cps":
			return GameManager.coins_per_second
		"house_index":
			return GameManager.get_current_house_index()
	return 0.0


func get_achievements() -> Array:
	return _achievements


func is_completed(id: String) -> bool:
	return _completed.get(id, false)


func get_completed_count() -> int:
	var count := 0
	for v in _completed.values():
		if v:
			count += 1
	return count


func get_save_data() -> Dictionary:
	return {
		"completed": _completed.duplicate(),
		"notified": _notified.duplicate(),
	}


func load_save_data(data: Dictionary) -> void:
	_completed = data.get("completed", {})
	_notified = data.get("notified", {})
