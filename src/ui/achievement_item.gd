extends PanelContainer

var _ach_data: Dictionary = {}

@onready var name_label: Label = %AchName
@onready var desc_label: Label = %AchDesc
@onready var progress_bar: ProgressBar = %AchProgress
@onready var progress_label: Label = %AchProgressLabel
@onready var reward_label: Label = %AchReward
@onready var check_label: Label = %AchCheck
@onready var status_label: Label = %AchStatus
@onready var coin_icon: ColorRect = %CoinIcon


func setup(data: Dictionary) -> void:
	_ach_data = data


func _ready() -> void:
	if not _ach_data.is_empty():
		_refresh()


func _refresh() -> void:
	name_label.text = _ach_data.name
	desc_label.text = _ach_data.desc
	reward_label.text = "+" + BigNumber.format(_ach_data.reward)

	var completed := AchievementManager.is_completed(_ach_data.id)
	var progress := AchievementManager.get_progress(_ach_data)
	var target: float = _ach_data.target
	var clamped := minf(progress, target)
	progress_bar.max_value = target
	progress_bar.value = clamped
	progress_label.text = BigNumber.format(clamped) + " / " + BigNumber.format(target)

	if completed:
		check_label.text = "DONE"
		check_label.add_theme_color_override("font_color", Color(0.3, 0.92, 0.38))
		name_label.add_theme_color_override("font_color", Color(0.6, 0.85, 0.6))
		reward_label.add_theme_color_override("font_color", Color(0.45, 0.6, 0.45))
		status_label.text = "Collected"
		status_label.add_theme_color_override("font_color", Color(0.4, 0.65, 0.4))
		coin_icon.color = Color(0.5, 0.55, 0.4)
		# Completed progress bar style
		var fill := StyleBoxFlat.new()
		fill.bg_color = Color(0.22, 0.5, 0.25)
		fill.set_corner_radius_all(6)
		progress_bar.add_theme_stylebox_override("fill", fill)
		progress_label.add_theme_color_override("font_color", Color(0.45, 0.6, 0.45))
	else:
		check_label.text = ""
		reward_label.add_theme_color_override("font_color", Color(1, 0.85, 0.3))
		var pct := int(clamped / target * 100.0) if target > 0 else 0
		status_label.text = str(pct) + "%"
		status_label.add_theme_color_override("font_color", Color(0.5, 0.7, 1.0))

	# Card style with colored accent
	var accent: Color
	var bg: Color
	if completed:
		accent = Color(0.3, 0.6, 0.32)
		bg = Color(0.1, 0.13, 0.1, 1)
	else:
		accent = Color(0.4, 0.65, 1.0)
		bg = Color(0.12, 0.12, 0.19, 1)

	var card := StyleBoxFlat.new()
	card.bg_color = bg
	card.border_width_left = 5
	card.border_color = accent
	card.set_corner_radius_all(10)
	card.content_margin_left = 16.0
	card.content_margin_right = 14.0
	card.content_margin_top = 10.0
	card.content_margin_bottom = 10.0
	add_theme_stylebox_override("panel", card)
