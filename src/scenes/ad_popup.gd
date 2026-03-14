extends Control

@onready var panel: PanelContainer = $Panel
@onready var info_label: Label = %InfoLabel
@onready var countdown_label: Label = %CountdownLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var cancel_button: Button = %CancelButton
@onready var watch_button: Button = %WatchButton

var _watching: bool = false
var _countdown: float = 30.0
var _total_duration: float = 30.0


func _ready() -> void:
	_style_popup()
	cancel_button.pressed.connect(_on_cancel)
	watch_button.pressed.connect(_on_watch)
	countdown_label.visible = false
	progress_bar.visible = false
	progress_bar.max_value = _total_duration
	progress_bar.value = 0
	info_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.95))
	countdown_label.add_theme_color_override("font_color", Color(1, 0.85, 0.3))
	_style_btn(watch_button, Color(0.18, 0.52, 0.22))


func _process(delta: float) -> void:
	if not _watching:
		return
	_countdown -= delta
	progress_bar.value = _total_duration - _countdown
	countdown_label.text = str(int(ceil(_countdown))) + "s remaining"
	if _countdown <= 0:
		_watching = false
		GameManager.activate_ad_boost()
		queue_free()


func _on_cancel() -> void:
	queue_free()


func _on_watch() -> void:
	_watching = true
	watch_button.visible = false
	cancel_button.visible = false
	countdown_label.visible = true
	progress_bar.visible = true
	info_label.text = "Watching ad..."


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
