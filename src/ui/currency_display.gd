extends HBoxContainer

@onready var coins_label: Label = %CoinsLabel
@onready var cps_label: Label = %CPSLabel


func _ready() -> void:
	GameManager.currency_changed.connect(_on_currency_changed)
	_on_currency_changed(GameManager.coins, GameManager.coins_per_second)


func _on_currency_changed(new_coins: float, cps: float) -> void:
	coins_label.text = BigNumber.format(new_coins)
	cps_label.text = BigNumber.format(cps) + "/s"
