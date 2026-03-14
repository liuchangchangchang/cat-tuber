class_name OfflineEarnings


static func calculate(cps: float, elapsed_seconds: float, max_offline_hours: float, efficiency: float) -> float:
	var clamped_time := clampf(elapsed_seconds, 0.0, max_offline_hours * 3600.0)
	return floor(cps * clamped_time * efficiency)
