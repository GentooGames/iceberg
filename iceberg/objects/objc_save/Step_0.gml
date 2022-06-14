/// @desc ...

exit;
if (keyboard_check_pressed(vk_enter)) {
	var _test_data = {
		test_number: -1,	
		test_name: "",
		test_life: 1000,
	};
	test_serializer.deserialize(json_stringify(_test_data));
	
	show_message("number: " + string(test_number));
	show_message("name: " + string(test_name));
	show_message("life: " + string(test_life));
}