extends Control

var _idle_time: float = 0.0
var _target_pos: Vector2 = Vector2.ZERO
var _moving: bool = false
var _destroying: bool = false
var _move_speed: float = 280.0

@onready var body: ColorRect = $Body
@onready var head: ColorRect = $Head
@onready var left_ear: ColorRect = $LeftEar
@onready var right_ear: ColorRect = $RightEar
@onready var tail: ColorRect = $Tail


func _process(delta: float) -> void:
	if _moving:
		var dir := (_target_pos - position).normalized()
		var dist := position.distance_to(_target_pos)
		if dist < 5.0:
			_moving = false
			position = _target_pos
		else:
			position += dir * _move_speed * delta
			# Flip cat based on direction
			if dir.x < 0:
				tail.position.x = body.size.x - 2
			else:
				tail.position.x = -tail.size.x + 2
			# Walking bounce
			body.position.y = abs(sin(_idle_time * 12.0)) * -6.0
			_idle_time += delta
	else:
		# Idle bobbing
		_idle_time += delta
		body.position.y = sin(_idle_time * 2.5) * 3.0
		# Tail wag
		tail.rotation_degrees = sin(_idle_time * 4.0) * 20.0


func move_to(target: Vector2) -> void:
	_target_pos = target
	_moving = true


func play_destroy() -> void:
	_destroying = true
	var tween := create_tween()
	tween.tween_property(self, "rotation_degrees", 15.0, 0.08)
	tween.tween_property(self, "rotation_degrees", -15.0, 0.08)
	tween.tween_property(self, "rotation_degrees", 12.0, 0.07)
	tween.tween_property(self, "rotation_degrees", -8.0, 0.07)
	tween.tween_property(self, "rotation_degrees", 0.0, 0.06)
	tween.tween_callback(func(): _destroying = false)


func play_celebrate() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1.3, 0.85), 0.06)
	tween.tween_property(self, "scale", Vector2(0.9, 1.2), 0.08)
	tween.tween_property(self, "scale", Vector2(1.05, 0.95), 0.06)
	tween.tween_property(self, "scale", Vector2.ONE, 0.05)
