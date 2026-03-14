extends HBoxContainer

@onready var live_dot: ColorRect = %LiveDot
@onready var viewer_label: Label = %ViewerLabel
@onready var time_label: Label = %TimeLabel

var _blink_timer: float = 0.0
var _time_update: float = 0.0


func _ready() -> void:
	GameManager.viewers_changed.connect(_on_viewers_changed)
	_on_viewers_changed(GameManager.viewer_count)
	_update_time_label()


func _process(delta: float) -> void:
	_blink_timer += delta
	if _blink_timer >= 1.0:
		_blink_timer = 0.0
	live_dot.visible = _blink_timer < 0.7
	live_dot.color = Color(1, 0.15, 0.15, 1) if live_dot.visible else Color(0.4, 0.1, 0.1, 1)

	_time_update += delta
	if _time_update >= 10.0:
		_time_update = 0.0
		_update_time_label()


func _on_viewers_changed(count: int) -> void:
	viewer_label.text = str(count) + " viewers"


func _update_time_label() -> void:
	var tod := DayCycle.get_current_time_of_day()
	time_label.text = DayCycle.get_time_label(tod)
