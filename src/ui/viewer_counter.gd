extends HBoxContainer

@onready var live_dot: ColorRect = %LiveDot
@onready var viewer_label: Label = %ViewerLabel

var _blink_timer: float = 0.0


func _ready() -> void:
	GameManager.viewers_changed.connect(_on_viewers_changed)
	_on_viewers_changed(GameManager.viewer_count)


func _process(delta: float) -> void:
	_blink_timer += delta
	if _blink_timer >= 1.0:
		_blink_timer = 0.0
	live_dot.visible = _blink_timer < 0.7


func _on_viewers_changed(count: int) -> void:
	viewer_label.text = str(count) + " viewers"
