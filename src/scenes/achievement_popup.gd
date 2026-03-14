extends Control

@onready var panel: PanelContainer = $Panel
@onready var name_label: Label = %AchNameLabel
@onready var desc_label: Label = %AchDescLabel
@onready var reward_label: Label = %AchRewardLabel
@onready var close_button: Button = %CloseButton

var _ach_id: String = ""


func setup(ach_id: String) -> void:
	_ach_id = ach_id


func _ready() -> void:
	_style_popup()
	close_button.pressed.connect(queue_free)
	if _ach_id != "":
		_populate()


func _populate() -> void:
	for ach in AchievementManager.get_achievements():
		if ach.id == _ach_id:
			name_label.text = ach.name
			desc_label.text = ach.desc
			reward_label.text = "+" + BigNumber.format(ach.reward) + " coins!"
			return


func _style_popup() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.08, 0.12, 0.08, 1)
	s.set_border_width_all(2)
	s.border_color = Color(0.3, 0.6, 0.3, 1)
	s.set_corner_radius_all(16)
	s.set_content_margin_all(28)
	panel.add_theme_stylebox_override("panel", s)
	panel.pivot_offset = panel.size / 2
	panel.scale = Vector2(0.85, 0.85)
	panel.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(panel, "scale", Vector2.ONE, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(panel, "modulate:a", 1.0, 0.15)
