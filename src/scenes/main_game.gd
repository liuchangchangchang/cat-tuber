extends Control

const AchievementPopupScene := preload("res://src/scenes/achievement_popup.tscn")


func _ready() -> void:
	AchievementManager.achievement_completed.connect(_on_achievement_completed)


func _on_achievement_completed(ach_id: String) -> void:
	# Small delay so the reward coins are already added
	get_tree().create_timer(0.3).timeout.connect(func():
		var popup: Control = AchievementPopupScene.instantiate()
		get_tree().root.add_child(popup)
		popup.setup(ach_id)
	)
