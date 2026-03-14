class_name DayCycle

enum TimeOfDay { MORNING, MIDDAY, AFTERNOON, EVENING, MIDNIGHT }


static func get_current_time_of_day() -> int:
	var hour: int = Time.get_time_dict_from_system().hour
	if hour >= 6 and hour < 10:
		return TimeOfDay.MORNING
	elif hour >= 10 and hour < 14:
		return TimeOfDay.MIDDAY
	elif hour >= 14 and hour < 18:
		return TimeOfDay.AFTERNOON
	elif hour >= 18 and hour < 22:
		return TimeOfDay.EVENING
	else:
		return TimeOfDay.MIDNIGHT


static func get_window_color(tod: int) -> Color:
	match tod:
		TimeOfDay.MORNING:
			return Color(1, 0.88, 0.6, 0.35)
		TimeOfDay.MIDDAY:
			return Color(0.85, 0.93, 1, 0.3)
		TimeOfDay.AFTERNOON:
			return Color(1, 0.78, 0.45, 0.3)
		TimeOfDay.EVENING:
			return Color(0.08, 0.08, 0.22, 0.85)
		TimeOfDay.MIDNIGHT:
			return Color(0.03, 0.03, 0.1, 0.92)
	return Color.TRANSPARENT


static func get_room_tint(tod: int) -> Color:
	match tod:
		TimeOfDay.MORNING:
			return Color(1, 0.92, 0.7, 0.06)
		TimeOfDay.MIDDAY:
			return Color(1, 1, 1, 0.0)
		TimeOfDay.AFTERNOON:
			return Color(1, 0.82, 0.5, 0.08)
		TimeOfDay.EVENING:
			return Color(0.2, 0.2, 0.4, 0.18)
		TimeOfDay.MIDNIGHT:
			return Color(0.08, 0.08, 0.2, 0.28)
	return Color.TRANSPARENT


static func is_lamp_on(tod: int) -> bool:
	return tod == TimeOfDay.EVENING or tod == TimeOfDay.MIDNIGHT


static func show_sun(tod: int) -> bool:
	return tod == TimeOfDay.MORNING or tod == TimeOfDay.MIDDAY or tod == TimeOfDay.AFTERNOON


static func show_moon(tod: int) -> bool:
	return tod == TimeOfDay.MIDNIGHT


static func get_time_label(tod: int) -> String:
	match tod:
		TimeOfDay.MORNING:
			return "Morning"
		TimeOfDay.MIDDAY:
			return "Midday"
		TimeOfDay.AFTERNOON:
			return "Afternoon"
		TimeOfDay.EVENING:
			return "Evening"
		TimeOfDay.MIDNIGHT:
			return "Night"
	return ""
