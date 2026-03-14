class_name Destruction


static func get_destruction_interval(cps: float) -> float:
	return maxf(0.3, 2.0 - log(cps + 1.0) * 0.3)
