extends Control

@onready var panel: PanelContainer = $Panel
@onready var trophy: ColorRect = $Panel/VBox/TrophyRow/Trophy
@onready var star_l: ColorRect = $Panel/VBox/TrophyRow/StarL
@onready var star_r: ColorRect = $Panel/VBox/TrophyRow/StarR
@onready var name_label: Label = %AchNameLabel
@onready var desc_label: Label = %AchDescLabel
@onready var reward_label: Label = %AchRewardLabel
@onready var close_button: Button = %CloseButton

var _ach_id: String = ""


func setup(ach_id: String) -> void:
	_ach_id = ach_id
	if is_node_ready():
		_populate()


func _ready() -> void:
	_style_popup()
	_style_collect_btn()
	close_button.pressed.connect(queue_free)
	if _ach_id != "":
		_populate()
	_play_trophy_animation()


func _populate() -> void:
	for ach in AchievementManager.get_achievements():
		if ach.id == _ach_id:
			name_label.text = ach.name
			desc_label.text = ach.desc
			reward_label.text = "+" + BigNumber.format(ach.reward) + " coins!"
			return


func _style_popup() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.08, 0.1, 0.06, 1)
	s.set_border_width_all(3)
	s.border_color = Color(0.55, 0.75, 0.3, 1)
	s.set_corner_radius_all(20)
	s.set_content_margin_all(32)
	panel.add_theme_stylebox_override("panel", s)

	panel.pivot_offset = panel.size / 2
	panel.scale = Vector2(0.7, 0.7)
	panel.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(panel, "scale", Vector2(1.05, 1.05), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(panel, "modulate:a", 1.0, 0.15)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.1)


func _style_collect_btn() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.2, 0.55, 0.22)
	s.set_corner_radius_all(14)
	s.set_content_margin_all(14)
	s.set_border_width_all(1)
	s.border_color = Color(0.35, 0.75, 0.35)
	close_button.add_theme_stylebox_override("normal", s)
	var h := s.duplicate()
	h.bg_color = Color(0.25, 0.62, 0.28)
	close_button.add_theme_stylebox_override("hover", h)
	var p := s.duplicate()
	p.bg_color = Color(0.15, 0.45, 0.18)
	close_button.add_theme_stylebox_override("pressed", p)


func _play_trophy_animation() -> void:
	# Stars spin/pulse
	var tw := create_tween().set_loops(3)
	tw.tween_property(star_l, "scale", Vector2(1.3, 1.3), 0.3)
	tw.parallel().tween_property(star_r, "scale", Vector2(1.3, 1.3), 0.3)
	tw.tween_property(star_l, "scale", Vector2.ONE, 0.3)
	tw.parallel().tween_property(star_r, "scale", Vector2.ONE, 0.3)

	# Trophy pulse
	var tw2 := create_tween().set_loops(2)
	tw2.tween_property(trophy, "scale", Vector2(1.15, 1.15), 0.4)
	tw2.tween_property(trophy, "scale", Vector2.ONE, 0.4)
