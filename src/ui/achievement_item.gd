extends PanelContainer

var _ach_data: Dictionary = {}

@onready var name_label: Label = %AchName
@onready var desc_label: Label = %AchDesc
@onready var progress_bar: ProgressBar = %AchProgress
@onready var progress_label: Label = %AchProgressLabel
@onready var reward_label: Label = %AchReward
@onready var check_label: Label = %AchCheck


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
	progress_bar.max_value = target
	progress_bar.value = minf(progress, target)
	progress_label.text = BigNumber.format(minf(progress, target)) + "/" + BigNumber.format(target)

	if completed:
		check_label.text = "DONE"
		check_label.add_theme_color_override("font_color", Color(0.3, 0.9, 0.35))
		reward_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.55))
		modulate = Color(0.7, 0.7, 0.7, 1)
	else:
		check_label.text = ""
		reward_label.add_theme_color_override("font_color", Color(1, 0.85, 0.3))

	# Card style
	var accent := Color(0.4, 0.7, 1.0) if not completed else Color(0.3, 0.5, 0.3)
	var card := StyleBoxFlat.new()
	card.bg_color = Color(0.12, 0.12, 0.19, 1)
	card.border_width_left = 5
	card.border_color = accent
	card.set_corner_radius_all(10)
	card.content_margin_left = 16.0
	card.content_margin_right = 12.0
	card.content_margin_top = 10.0
	card.content_margin_bottom = 10.0
	add_theme_stylebox_override("panel", card)
