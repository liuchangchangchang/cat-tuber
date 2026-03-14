extends GutTest


func test_zero():
	assert_eq(BigNumber.format(0.0), "0")


func test_small_integer():
	assert_eq(BigNumber.format(42.0), "42")


func test_small_decimal():
	assert_eq(BigNumber.format(3.5), "3.5")


func test_just_under_thousand():
	assert_eq(BigNumber.format(999.0), "999")


func test_one_thousand():
	assert_eq(BigNumber.format(1000.0), "1.00K")


func test_fifteen_hundred():
	assert_eq(BigNumber.format(1500.0), "1.50K")


func test_tens_of_thousands():
	assert_eq(BigNumber.format(45000.0), "45.0K")


func test_hundreds_of_thousands():
	assert_eq(BigNumber.format(500000.0), "500K")


func test_one_million():
	assert_eq(BigNumber.format(1000000.0), "1.00M")


func test_two_point_three_million():
	assert_eq(BigNumber.format(2300000.0), "2.30M")


func test_one_billion():
	assert_eq(BigNumber.format(1000000000.0), "1.00B")


func test_negative_number():
	assert_eq(BigNumber.format(-1500.0), "-1.50K")
