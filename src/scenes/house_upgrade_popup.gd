extends Control

@onready var panel: PanelContainer = $Panel
@onready var title_label: Label = %TitleLabel
@onready var desc_label: Label = %DescLabel
@onready var warning_label: Label = %WarningLabel
@onready var cancel_button: Button = %CancelButton
@onready var confirm_button: Button = %ConfirmButton

var _next_house: Dictionary = {}


func _ready() -> void:
	_style_popup()
	cancel_button.pressed.connect(_on_cancel)
	confirm_button.pressed.connect(_on_confirm)
	_next_house = GameManager.get_next_house()
	_refresh()


func _refresh() -> void:
	if _next_house.is_empty():
		title_label.text = "Max Level!"
		title_label.add_theme_color_override("font_color", Color(1, 0.85, 0.3))
		desc_label.text = "You've reached the finest house.\nYour cat rules the penthouse!"
		warning_label.visible = false
		confirm_button.visible = false
		cancel_button.text = "OK"
		return

	var current := GameManager.get_current_house()
	title_label.text = "Move to " + _next_house.name + "?"
	title_label.add_theme_color_override("font_color", Color(0.5, 0.8, 1.0))
	desc_label.text = str(_next_house.multiplier) + "x earnings (currently " + str(current.multiplier) + "x)\nCost: " + BigNumber.format(_next_house.cost)

	var can_buy: bool = HousePrestige.can_buy_house(_next_house, GameManager.total_earned_all_time, GameManager.coins)
	var unlocked: bool = GameManager.total_earned_all_time >= _next_house.unlock_requirement

	if not unlocked:
		warning_label.text = "Need " + BigNumber.format(_next_house.unlock_requirement) + " total earned to unlock"
		warning_label.add_theme_color_override("font_color", Color(1, 0.7, 0.3, 1))
		confirm_button.disabled = true
	elif not can_buy:
		warning_label.text = "All food and toys will be reset!\nNeed " + BigNumber.format(_next_house.cost) + " coins"
		warning_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3, 1))
		confirm_button.disabled = true
	else:
		warning_label.text = "WARNING: All food and toys will be reset!"
		warning_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3, 1))
		confirm_button.disabled = false

	_style_btn(confirm_button, Color(0.18, 0.52, 0.22))


func _on_cancel() -> void:
	queue_free()


func _on_confirm() -> void:
	if not _next_house.is_empty():
		GameManager.buy_house(_next_house.id)
	queue_free()


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


func _style_btn(btn: Button, color: Color) -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.set_corner_radius_all(12)
	s.set_content_margin_all(12)
	btn.add_theme_stylebox_override("normal", s)
	var h := s.duplicate()
	h.bg_color = color.lightened(0.12)
	btn.add_theme_stylebox_override("hover", h)
