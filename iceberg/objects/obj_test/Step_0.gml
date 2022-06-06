if (!can_act) exit;

var _speed = 5;
if (INPUT.keyboard.button(vk_right))	x += _speed;
if (INPUT.keyboard.button(vk_left))		x -= _speed;
if (INPUT.keyboard.button(vk_down))		y += _speed;
if (INPUT.keyboard.button(vk_up))		y -= _speed;