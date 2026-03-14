extends PanelContainer

signal upgrade_requested(house_data: Dictionary)

var house_data: Dictionary = {}

@onready var icon_rect: ColorRect = %IconRect
@onready var name_label: Label = %NameLabel
@onready var mult_label: Label = %MultLabel
@onready var status_label: Label = %StatusLabel
@onready var buy_button: Button = %BuyButton


func setup(data: Dictionary) -> void:
	house_data = data
	icon_rect.color = Color(data.get("room_color", "#FFFFFF"))
	name_label.text = data.name
	mult_label.text = str(data.multiplier) + "x earnings"
	_refresh()


func _ready() -> void:
	buy_button.pressed.connect(_on_buy_pressed)
	GameManager.currency_changed.connect(_on_currency_changed)
	GameManager.house_upgraded.connect(_on_house_upgraded)


func _on_buy_pressed() -> void:
	upgrade_requested.emit(house_data)


func _on_currency_changed(_coins: float, _cps: float) -> void:
	_refresh()


func _on_house_upgraded(_house_id: String, _mult: float) -> void:
	_refresh()


func _refresh() -> void:
	if house_data.is_empty():
		return
	if house_data.id == GameManager.current_house_id:
		status_label.text = "CURRENT"
		buy_button.visible = false
		return
	var can_buy := HousePrestige.can_buy_house(house_data, GameManager.total_earned_all_time, GameManager.coins)
	var unlocked: bool = GameManager.total_earned_all_time >= house_data.unlock_requirement
	if not unlocked:
		status_label.text = "Need " + BigNumber.format(house_data.unlock_requirement) + " earned"
		buy_button.visible = false
	else:
		status_label.text = ""
		buy_button.visible = true
		buy_button.text = BigNumber.format(house_data.cost)
		buy_button.disabled = not can_buy
