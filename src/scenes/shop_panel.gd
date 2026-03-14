extends PanelContainer

const ShopItemScene := preload("res://src/ui/shop_item_button.tscn")
const AchievementItemScene := preload("res://src/ui/achievement_item.tscn")

@onready var food_tab_btn: Button = %FoodTabBtn
@onready var toy_tab_btn: Button = %ToyTabBtn
@onready var ach_tab_btn: Button = %AchTabBtn
@onready var food_scroll: ScrollContainer = %FoodScroll
@onready var toy_scroll: ScrollContainer = %ToyScroll
@onready var ach_scroll: ScrollContainer = %AchScroll
@onready var food_list: VBoxContainer = %FoodList
@onready var toy_list: VBoxContainer = %ToyList
@onready var ach_list: VBoxContainer = %AchList

var _active_tab: int = 0
var _tab_active_style: StyleBoxFlat
var _tab_inactive_style: StyleBoxFlat


func _ready() -> void:
	_tab_active_style = StyleBoxFlat.new()
	_tab_active_style.bg_color = Color(0.22, 0.25, 0.38, 1)
	_tab_active_style.border_width_bottom = 3
	_tab_active_style.border_color = Color(0.4, 0.7, 1.0, 1)
	_tab_active_style.set_corner_radius_all(8)
	_tab_active_style.corner_radius_bottom_left = 0
	_tab_active_style.corner_radius_bottom_right = 0
	_tab_active_style.set_content_margin_all(12)

	_tab_inactive_style = StyleBoxFlat.new()
	_tab_inactive_style.bg_color = Color(0.12, 0.12, 0.18, 1)
	_tab_inactive_style.set_corner_radius_all(8)
	_tab_inactive_style.corner_radius_bottom_left = 0
	_tab_inactive_style.corner_radius_bottom_right = 0
	_tab_inactive_style.set_content_margin_all(12)

	food_tab_btn.pressed.connect(func(): _switch_tab(0))
	toy_tab_btn.pressed.connect(func(): _switch_tab(1))
	ach_tab_btn.pressed.connect(func(): _switch_tab(2))
	_populate_items()
	_switch_tab(0)
	GameManager.house_upgraded.connect(_on_house_upgraded)
	AchievementManager.achievement_completed.connect(func(_id): _populate_achievements())


func _populate_items() -> void:
	_clear_list(food_list)
	_clear_list(toy_list)
	for item in GameManager.get_foods():
		var btn: PanelContainer = ShopItemScene.instantiate()
		food_list.add_child(btn)
		btn.setup(item, "food")
	for item in GameManager.get_toys():
		var btn: PanelContainer = ShopItemScene.instantiate()
		toy_list.add_child(btn)
		btn.setup(item, "toy")
	_populate_achievements()


func _populate_achievements() -> void:
	_clear_list(ach_list)
	for ach in AchievementManager.get_achievements():
		var item: PanelContainer = AchievementItemScene.instantiate()
		ach_list.add_child(item)
		item.setup(ach)


func _switch_tab(tab_idx: int) -> void:
	_active_tab = tab_idx
	food_scroll.visible = tab_idx == 0
	toy_scroll.visible = tab_idx == 1
	ach_scroll.visible = tab_idx == 2
	_apply_tab_style(food_tab_btn, tab_idx == 0)
	_apply_tab_style(toy_tab_btn, tab_idx == 1)
	_apply_tab_style(ach_tab_btn, tab_idx == 2)
	if tab_idx == 2:
		_populate_achievements()


func _apply_tab_style(btn: Button, active: bool) -> void:
	if active:
		btn.add_theme_stylebox_override("normal", _tab_active_style)
		btn.add_theme_stylebox_override("hover", _tab_active_style)
		btn.add_theme_color_override("font_color", Color.WHITE)
	else:
		btn.add_theme_stylebox_override("normal", _tab_inactive_style)
		btn.add_theme_stylebox_override("hover", _tab_inactive_style)
		btn.add_theme_color_override("font_color", Color(0.5, 0.5, 0.6))


func _on_house_upgraded(_house_id: String, _mult: float) -> void:
	_populate_items()
	_switch_tab(_active_tab)


func _clear_list(container: VBoxContainer) -> void:
	for child in container.get_children():
		child.queue_free()
