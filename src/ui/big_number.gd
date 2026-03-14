class_name BigNumber


static func format(value: float) -> String:
	if value < 0:
		return "-" + format(-value)
	if value < 1000.0:
		if value == floor(value):
			return str(int(value))
		return "%.1f" % value

	var suffixes := ["", "K", "M", "B", "T", "Qa", "Qi"]
	var magnitude := 0
	var display := value
	while display >= 1000.0 and magnitude < suffixes.size() - 1:
		display /= 1000.0
		magnitude += 1

	if display >= 100.0:
		return "%d%s" % [int(display), suffixes[magnitude]]
	elif display >= 10.0:
		return "%.1f%s" % [display, suffixes[magnitude]]
	else:
		return "%.2f%s" % [display, suffixes[magnitude]]
