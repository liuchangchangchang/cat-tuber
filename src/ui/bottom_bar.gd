extends HBoxContainer

const HousePopupScene := preload("res://src/scenes/house_upgrade_popup.tscn")
const AdPopupScene := preload("res://src/scenes/ad_popup.tscn")
const SharePopupScene := preload("res://src/scenes/share_popup.tscn")

@onready var boost_btn: Button = %BoostBtn
@onready var upgrade_btn: Button = %UpgradeBtn
@onready var share_btn: Button = %ShareBtn


func _ready() -> void:
	boost_btn.pressed.connect(_on_boost_pressed)
	upgrade_btn.pressed.connect(_on_upgrade_pressed)
	share_btn.pressed.connect(_on_share_pressed)
	GameManager.ad_boost_changed.connect(_on_ad_boost_changed)
	_style_button(boost_btn, Color(0.15, 0.42, 0.22))
	_style_button(upgrade_btn, Color(0.15, 0.28, 0.48))
	_style_button(share_btn, Color(0.38, 0.15, 0.42))
	_update_boost_label()


func _process(_delta: float) -> void:
	if GameManager.ad_boost_active:
		_update_boost_label()


func _update_boost_label() -> void:
	if GameManager.ad_boost_active:
		var secs := int(GameManager.ad_boost_remaining)
		boost_btn.text = "Boost\n" + str(secs) + "s"
	else:
		boost_btn.text = "Boost\n2x"


func _on_boost_pressed() -> void:
	if GameManager.ad_boost_active:
		return
	var popup: Control = AdPopupScene.instantiate()
	get_tree().root.add_child(popup)


func _on_upgrade_pressed() -> void:
	var popup: Control = HousePopupScene.instantiate()
	get_tree().root.add_child(popup)


func _on_share_pressed() -> void:
	var popup: Control = SharePopupScene.instantiate()
	get_tree().root.add_child(popup)


func _on_ad_boost_changed(_active: bool, _remaining: float) -> void:
	_update_boost_label()


func _style_button(btn: Button, color: Color) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = color
	normal.set_corner_radius_all(16)
	normal.set_content_margin_all(12)
	normal.border_color = color.lightened(0.2)
	normal.set_border_width_all(1)
	btn.add_theme_stylebox_override("normal", normal)

	var hover := normal.duplicate()
	hover.bg_color = color.lightened(0.15)
	btn.add_theme_stylebox_override("hover", hover)

	var pressed := normal.duplicate()
	pressed.bg_color = color.darkened(0.1)
	btn.add_theme_stylebox_override("pressed", pressed)

	var disabled := normal.duplicate()
	disabled.bg_color = color.darkened(0.3)
	disabled.border_color = color.darkened(0.1)
	btn.add_theme_stylebox_override("disabled", disabled)
