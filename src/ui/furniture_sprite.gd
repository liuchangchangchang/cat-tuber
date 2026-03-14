extends Control

var furniture_id: String = ""
var furniture_name: String = ""

@onready var base_rect: ColorRect = $Base
@onready var damage_overlay: ColorRect = $DamageOverlay
@onready var name_label: Label = $NameLabel
@onready var particles: CPUParticles2D = $Particles

var _shadow: ColorRect


func setup(data: Dictionary) -> void:
	furniture_id = data.id
	furniture_name = data.name
	var base_color := Color(data.color)
	base_rect.color = base_color
	var w: float = data.size[0]
	var h: float = data.size[1]
	base_rect.size = Vector2(w, h)
	damage_overlay.size = Vector2(w, h)
	size = Vector2(w, h)
	name_label.text = data.name
	name_label.size = Vector2(w, 24)
	name_label.position = Vector2(0, h + 2)

	# Add shadow beneath furniture
	_shadow = ColorRect.new()
	_shadow.color = Color(0, 0, 0, 0.25)
	_shadow.size = Vector2(w - 4, 8)
	_shadow.position = Vector2(2, h - 2)
	add_child(_shadow)
	move_child(_shadow, 0)

	# Add highlight strip on top edge for depth
	var highlight := ColorRect.new()
	highlight.color = base_color.lightened(0.2)
	highlight.size = Vector2(w, 4)
	highlight.position = Vector2.ZERO
	add_child(highlight)

	# Setup particles
	particles.position = Vector2(w / 2.0, h / 2.0)
	particles.emitting = false
	particles.amount = 12
	particles.lifetime = 0.6
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	particles.emission_rect_extents = Vector2(w / 2.0, h / 2.0)
	particles.direction = Vector2(0, -1)
	particles.spread = 45.0
	particles.initial_velocity_min = 60.0
	particles.initial_velocity_max = 120.0
	particles.gravity = Vector2(0, 250)
	particles.scale_amount_min = 3.0
	particles.scale_amount_max = 6.0
	particles.color = base_color.lightened(0.4)


func take_hit() -> void:
	# Flash damage overlay
	damage_overlay.color = Color(1, 0.2, 0.1, 0.6)
	var tween := create_tween()
	tween.tween_property(damage_overlay, "color:a", 0.0, 0.35)

	# Shake with more intensity
	var orig_pos := position
	var shake_tween := create_tween()
	shake_tween.tween_property(self, "position", orig_pos + Vector2(10, -3), 0.04)
	shake_tween.tween_property(self, "position", orig_pos + Vector2(-10, 3), 0.04)
	shake_tween.tween_property(self, "position", orig_pos + Vector2(6, -2), 0.035)
	shake_tween.tween_property(self, "position", orig_pos + Vector2(-4, 1), 0.03)
	shake_tween.tween_property(self, "position", orig_pos, 0.03)

	# Particles
	particles.restart()
	particles.emitting = true
