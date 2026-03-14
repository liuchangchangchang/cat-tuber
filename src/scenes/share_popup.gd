extends Control

@onready var panel: PanelContainer = $Panel
@onready var earned_label: Label = %EarnedLabel
@onready var house_label: Label = %HouseLabel
@onready var houses_count_label: Label = %HousesCountLabel
@onready var food_label: Label = %FoodLabel
@onready var toy_label: Label = %ToyLabel
@onready var cps_label: Label = %CPSLabel
@onready var close_button: Button = %CloseButton


func _ready() -> void:
	_style_popup()
	close_button.pressed.connect(queue_free)

	var current_house := GameManager.get_current_house()
	earned_label.text = "Total Earned:  " + BigNumber.format(GameManager.total_earned_all_time)
	earned_label.add_theme_color_override("font_color", Color(1, 0.85, 0.3))
	house_label.text = "Current House:  " + current_house.get("name", "Unknown")
	house_label.add_theme_color_override("font_color", Color(0.5, 0.8, 1.0))
	houses_count_label.text = "Houses Upgraded:  " + str(GameManager.get_current_house_index())
	food_label.text = "Food Items:  " + str(GameManager.get_total_food_count())
	food_label.add_theme_color_override("font_color", Color(0.5, 0.9, 0.5))
	toy_label.text = "Toy Items:  " + str(GameManager.get_total_toy_count())
	toy_label.add_theme_color_override("font_color", Color(0.9, 0.5, 0.5))
	cps_label.text = "Earning:  " + BigNumber.format(GameManager.coins_per_second) + "/s"


func _style_popup() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.1, 0.1, 0.18, 1)
	s.set_border_width_all(2)
	s.border_color = Color(0.3, 0.35, 0.5, 1)
	s.set_corner_radius_all(16)
	s.set_content_margin_all(28)
	panel.add_theme_stylebox_override("panel", s)
	panel.pivot_offset = panel.size / 2
	panel.scale = Vector2(0.85, 0.85)
	panel.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(panel, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(panel, "modulate:a", 1.0, 0.15)
