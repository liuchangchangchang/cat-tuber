extends HBoxContainer

@onready var coins_label: Label = %CoinsLabel
@onready var cps_label: Label = %CPSLabel
@onready var boost_indicator: Label = %BoostIndicator


func _ready() -> void:
	GameManager.currency_changed.connect(_on_currency_changed)
	GameManager.ad_boost_changed.connect(_on_boost_changed)
	_on_currency_changed(GameManager.coins, GameManager.coins_per_second)
	_update_boost()


func _process(_delta: float) -> void:
	if GameManager.ad_boost_active:
		_update_boost()


func _on_currency_changed(new_coins: float, cps: float) -> void:
	coins_label.text = BigNumber.format(new_coins)
	cps_label.text = BigNumber.format(cps) + "/s"


func _on_boost_changed(_active: bool, _remaining: float) -> void:
	_update_boost()


func _update_boost() -> void:
	if GameManager.ad_boost_active:
		boost_indicator.visible = true
		boost_indicator.text = "2x " + str(int(GameManager.ad_boost_remaining)) + "s"
		# Pulsing effect
		var t := fmod(Time.get_ticks_msec() / 500.0, 1.0)
		boost_indicator.modulate.a = 0.7 + sin(t * TAU) * 0.3
	else:
		boost_indicator.visible = false
