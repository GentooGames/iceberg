function ___macros() {
	/// @func ___macros()
	///
	#macro null      undefined
	#macro EMPTY     -1
	#macro MAX_DEPTH -10000
	#macro SECOND    60
	#macro MINUTE    SECOND * 60
	#macro METHODS   15
	#macro EVENTS	 14
	#macro CALLBACKS 13

	#macro lmb_held			INPUT.mouse.button(mb_left)
	#macro lmb_pressed		INPUT.mouse.button_pressed(mb_left)
	#macro lmb_released		INPUT.mouse.button_released(mb_left)
	#macro rmb_held			INPUT.mouse.button(mb_right)
	#macro rmb_pressed		INPUT.mouse.button_pressed(mb_right)
	#macro rmb_released		INPUT.mouse.button_released(mb_right)
	#macro mmb_held			INPUT.mouse.button(mb_middle)
	#macro mmb_pressed		INPUT.mouse.button_pressed(mb_middle)
	#macro mmb_released		INPUT.mouse.button_released(mb_middle)
	#macro anymb_held		INPUT.mouse.button(mb_any)
	#macro anymb_pressed	INPUT.mouse.button_pressed(mb_any)
	#macro anymb_released	INPUT.mouse.button_released(mb_any)
	#macro input_scroll	   (INPUT.mouse.wheel_up() - INPUT.mouse.wheel_down())
};