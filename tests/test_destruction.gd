extends GutTest


func test_interval_at_zero_cps():
	var interval := Destruction.get_destruction_interval(0.0)
	# 2.0 - log(1) * 0.3 = 2.0 - 0 = 2.0
	assert_almost_eq(interval, 2.0, 0.01)


func test_interval_decreases_with_cps():
	var i0 := Destruction.get_destruction_interval(0.0)
	var i10 := Destruction.get_destruction_interval(10.0)
	var i100 := Destruction.get_destruction_interval(100.0)
	assert_true(i10 < i0, "Interval should decrease with more CPS")
	assert_true(i100 < i10, "Interval should keep decreasing")


func test_interval_has_minimum():
	var interval := Destruction.get_destruction_interval(999999.0)
	assert_true(interval >= 0.3, "Interval should never go below 0.3")


func test_interval_at_moderate_cps():
	var interval := Destruction.get_destruction_interval(10.0)
	var expected := maxf(0.3, 2.0 - log(11.0) * 0.3)
	assert_almost_eq(interval, expected, 0.01)
