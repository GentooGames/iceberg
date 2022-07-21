CURRENT_FRAME++;

if (keyboard_check_pressed(ord("f1"))) {
	show_message("string pressed!");	
}
if (keyboard_check_pressed(vk_f1)) {
	show_message("vk pressed!");	
}