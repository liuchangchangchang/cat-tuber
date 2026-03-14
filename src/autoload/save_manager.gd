extends Node

const SAVE_PATH := "user://save_data.json"

var _save_timer: float = 0.0
var _save_interval: float = 30.0


func _ready() -> void:
	_save_interval = GameManager.get_balance().get("save_interval_seconds", 30.0)
	load_game()


func _process(delta: float) -> void:
	_save_timer += delta
	if _save_timer >= _save_interval:
		_save_timer = 0.0
		save_game()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_game()


func save_game() -> void:
	var data := GameManager.get_save_data()
	data["achievements"] = AchievementManager.get_save_data()
	var json_string := JSON.stringify(data, "  ")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	if err != OK:
		return
	var data: Dictionary = json.data
	var saved_time: float = data.get("timestamp", 0.0)
	var current_time := Time.get_unix_time_from_system()
	var elapsed := current_time - saved_time
	GameManager.load_save_data(data)
	if data.has("achievements"):
		AchievementManager.load_save_data(data.achievements)
	if elapsed > 1.0 and GameManager.coins_per_second > 0:
		var balance := GameManager.get_balance()
		var offline_coins := OfflineEarnings.calculate(
			GameManager.coins_per_second,
			elapsed,
			balance.get("max_offline_hours", 8.0),
			balance.get("offline_efficiency", 0.5)
		)
		if offline_coins > 0:
			GameManager.coins += offline_coins
			GameManager.total_earned_all_time += offline_coins
			GameManager.currency_changed.emit(GameManager.coins, GameManager.coins_per_second)


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
