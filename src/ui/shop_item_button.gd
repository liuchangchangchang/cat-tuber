extends PanelContainer

var item_data: Dictionary = {}
var category: String = ""

var _buy_affordable_style: StyleBoxFlat
var _buy_affordable_hover: StyleBoxFlat
var _buy_unaffordable_style: StyleBoxFlat

@onready var icon_rect: ColorRect = %IconRect
@onready var name_label: Label = %NameLabel
@onready var desc_label: Label = %DescLabel
@onready var income_label: Label = %IncomeLabel
@onready var owned_label: Label = %OwnedLabel
@onready var buy_button: Button = %BuyButton


func setup(data: Dictionary, cat: String) -> void:
	item_data = data
	category = cat
	var accent := Color(data.get("color", "#FFFFFF"))
	icon_rect.color = accent
	name_label.text = data.name
	desc_label.text = data.description
	income_label.text = "+" + BigNumber.format(data.base_production) + "/s"

	# Card style with colored left accent border
	var card := StyleBoxFlat.new()
	card.bg_color = Color(0.12, 0.12, 0.19, 1)
	card.border_width_left = 6
	card.border_color = accent
	card.set_corner_radius_all(10)
	card.content_margin_left = 16.0
	card.content_margin_right = 12.0
	card.content_margin_top = 10.0
	card.content_margin_bottom = 10.0
	add_theme_stylebox_override("panel", card)

	# Pre-create buy button styles
	_buy_affordable_style = _make_btn_style(Color(0.18, 0.52, 0.22))
	_buy_affordable_hover = _make_btn_style(Color(0.22, 0.60, 0.26))
	_buy_unaffordable_style = _make_btn_style(Color(0.18, 0.18, 0.26))
	_refresh()


func _ready() -> void:
	buy_button.pressed.connect(_on_buy_pressed)
	GameManager.currency_changed.connect(_on_currency_changed)
	GameManager.item_purchased.connect(_on_item_purchased)


func _on_buy_pressed() -> void:
	if category == "food":
		GameManager.buy_food(item_data.id)
	else:
		GameManager.buy_toy(item_data.id)


func _on_currency_changed(_coins: float, _cps: float) -> void:
	_refresh_button()


func _on_item_purchased(cat: String, item_id: String, _new_count: int) -> void:
	if cat == category and item_id == item_data.id:
		_refresh()
		# Purchase feedback: brief scale pop
		var tween := create_tween()
		tween.tween_property(self, "scale", Vector2(1.02, 1.02), 0.08)
		tween.tween_property(self, "scale", Vector2.ONE, 0.08)


func _refresh() -> void:
	if item_data.is_empty():
		return
	var count := GameManager.get_item_count(category, item_data.id)
	owned_label.text = str(count)
	_refresh_button()


func _refresh_button() -> void:
	if item_data.is_empty():
		return
	var cost := GameManager.get_item_cost(category, item_data.id)
	buy_button.text = BigNumber.format(cost)
	var can_afford: bool = GameManager.coins >= cost
	buy_button.disabled = not can_afford
	if can_afford:
		buy_button.add_theme_stylebox_override("normal", _buy_affordable_style)
		buy_button.add_theme_stylebox_override("hover", _buy_affordable_hover)
		buy_button.add_theme_color_override("font_color", Color.WHITE)
	else:
		buy_button.add_theme_stylebox_override("normal", _buy_unaffordable_style)
		buy_button.add_theme_stylebox_override("hover", _buy_unaffordable_style)
		buy_button.add_theme_color_override("font_color", Color(0.45, 0.45, 0.55))


func _make_btn_style(color: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.set_corner_radius_all(10)
	s.content_margin_left = 14.0
	s.content_margin_right = 14.0
	s.content_margin_top = 8.0
	s.content_margin_bottom = 8.0
	return s
