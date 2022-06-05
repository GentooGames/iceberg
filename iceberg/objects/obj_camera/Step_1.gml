_update_edges();
_update_depth();
audio_listener_position(x, y, 0);

// Detach Mouse Input From Iota
if (INPUT.mouse.button(mb_middle))			middle_mouse_down		= true;
if (INPUT.mouse.button_pressed(mb_middle))	middle_mouse_pressed	= true;
if (INPUT.mouse.button_released(mb_middle))	middle_mouse_released	= true;
if (INPUT.mouse.wheel_down())				middle_mouse_wheel_down = true;
if (INPUT.mouse.wheel_up())					middle_mouse_wheel_up	= true;