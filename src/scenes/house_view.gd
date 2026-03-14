extends Control

const FurnitureScene := preload("res://src/ui/furniture_sprite.tscn")

@onready var room_bg: ColorRect = $RoomBG
@onready var floor_rect: ColorRect = $Floor
@onready var furniture_container: Node2D = $FurnitureContainer
@onready var cat: Control = $Cat

var _furniture_nodes: Array[Control] = []
var _destruction_timer: float = 0.0
var _current_target_idx: int = -1


func _ready() -> void:
	GameManager.house_upgraded.connect(_on_house_upgraded)
	GameManager.tap_earned.connect(_on_tap_earned)
	_setup_house(GameManager.get_current_house())


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		GameManager.tap()
		accept_event()
	elif event is InputEventScreenTouch and event.pressed:
		GameManager.tap()
		accept_event()


func _process(delta: float) -> void:
	if _furniture_nodes.is_empty():
		return
	_destruction_timer -= delta
	if _destruction_timer <= 0:
		_destruction_timer = GameManager.get_destruction_interval()
		_destroy_random_furniture()


func _setup_house(house_data: Dictionary) -> void:
	if house_data.is_empty():
		return
	room_bg.color = Color(house_data.get("room_color", "#5D4037"))
	floor_rect.color = Color(house_data.get("floor_color", "#8D6E63"))
	# Clear old furniture
	for child in furniture_container.get_children():
		child.queue_free()
	_furniture_nodes.clear()
	# Spawn furniture
	var furniture_list: Array = house_data.get("furniture", [])
	for fdata in furniture_list:
		var fnode: Control = FurnitureScene.instantiate()
		furniture_container.add_child(fnode)
		fnode.position = Vector2(fdata.position[0], fdata.position[1])
		fnode.setup(fdata)
		_furniture_nodes.append(fnode)
	# Position cat
	if _furniture_nodes.size() > 0:
		cat.position = Vector2(480, 520)
	_destruction_timer = GameManager.get_destruction_interval()


func _destroy_random_furniture() -> void:
	if _furniture_nodes.is_empty():
		return
	var idx := randi() % _furniture_nodes.size()
	var target: Control = _furniture_nodes[idx]
	_current_target_idx = idx
	# Move cat to furniture then destroy
	var target_pos := target.position + Vector2(-80, 0)
	cat.move_to(target_pos)
	# Delay the hit until cat arrives (approximate)
	var dist := cat.position.distance_to(target_pos)
	var delay := maxf(0.1, dist / 280.0)
	get_tree().create_timer(delay).timeout.connect(func():
		if is_instance_valid(target):
			target.take_hit()
			cat.play_destroy()
			GameManager.furniture_hit.emit(target.furniture_id)
	)


func _on_house_upgraded(_house_id: String, _mult: float) -> void:
	_setup_house(GameManager.get_current_house())


func _on_tap_earned(amount: float) -> void:
	cat.play_celebrate()
	_show_floating_text("+" + BigNumber.format(amount), cat.position + Vector2(40, -20))


func _show_floating_text(text: String, pos: Vector2) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_color_override("font_color", Color(1, 0.92, 0.3, 1))
	label.add_theme_font_size_override("font_size", 42)
	label.position = pos
	label.z_index = 10
	label.pivot_offset = label.size / 2
	add_child(label)

	var tween := create_tween()
	# Pop in
	label.scale = Vector2(0.5, 0.5)
	tween.tween_property(label, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(label, "scale", Vector2.ONE, 0.05)
	# Float up and fade
	tween.tween_property(label, "position:y", pos.y - 80, 0.5)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(label.queue_free)
