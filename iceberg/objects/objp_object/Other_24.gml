/// @desc EVENTS

#region Input //////////

on_object_mouse_left_button_pressed	   = function(_data) {
	/// @func	on_object_mouse_left_button_pressed(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	publish(event_id + "_mouse_left_button_pressed", { id: id });
};
on_object_mouse_right_button_pressed   = function(_data) {
	/// @func	on_object_mouse_right_button_pressed(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	publish(event_id + "_mouse_right_button_pressed", { id: id });
};
on_object_mouse_middle_button_pressed  = function(_data) {
	/// @func	on_object_mouse_middle_button_pressed(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	publish(event_id + "_mouse_middle_button_pressed", { id: id });
};
on_object_mouse_left_button			   = function(_data) {
	/// @func	on_object_mouse_left_button(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	publish(event_id + "_mouse_left_button", { id: id });
};
on_object_mouse_right_button		   = function(_data) {
	/// @func	on_object_mouse_right_button(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	publish(event_id + "_mouse_right_button", { id: id });
};
on_object_mouse_middle_button		   = function(_data) {
	/// @func	on_object_mouse_middle_button(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	publish(event_id + "_mouse_middle_button", { id: id });
};
on_object_mouse_left_button_released   = function(_data) {
	/// @func	on_object_mouse_left_button_released(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	publish(event_id + "_mouse_left_button_released", { id: id });
};
on_object_mouse_right_button_released  = function(_data) {
	/// @func	on_object_mouse_right_button_released(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	publish(event_id + "_mouse_right_button_released", { id: id });
};
on_object_mouse_middle_button_released = function(_data) {
	/// @func	on_object_mouse_middle_button_released(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	publish(event_id + "_mouse_middle_button_released", { id: id });
};

#endregion
#region Other //////////

on_object_destroyed = function(_data) {
	/// @func	on_object_destroyed(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!i_am(_data.id)) exit;
	////////////////////////
	publish(event_id + "_destroyed", _data.id);
};

#endregion
#region @OVERRIDE //////

/// Input
on_mouse_button_pressed			= function(_data) { // <-- DO NOT OVERRIDE THIS EVENT
	/// @func	on_mouse_button_pressed(mouse_data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return	NA
	/// @tested false
	///
	switch (_data.button) {
		case mb_left:   return on_mouse_left_button_pressed(_data);
		case mb_right:  return on_mouse_right_button_pressed(_data);
		case mb_middle: return on_mouse_middle_button_pressed(_data);
	}
};
on_mouse_left_button_pressed	= function(_data) {
	/// @func	on_mouse_left_button_pressed(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	on_object_mouse_left_button_pressed();
};
on_mouse_right_button_pressed	= function(_data) {
	/// @func	on_mouse_right_button_pressed(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	on_object_mouse_right_button_pressed();
};
on_mouse_middle_button_pressed	= function(_data) {
	/// @func	on_mouse_middle_button_pressed(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	on_object_mouse_middle_button_pressed();
};
on_mouse_button					= function(_data) {	// <-- DO NOT OVERRIDE THIS EVENT
	/// @func	on_mouse_button(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return	NA
	/// @tested false
	///
	switch (_data.button) {
		case mb_left:   return on_mouse_left_button(_data);
		case mb_right:  return on_mouse_right_button(_data);
		case mb_middle: return on_mouse_middle_button(_data);
	}
};
on_mouse_left_button			= function(_data) {
	/// @func	on_mouse_left_button(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	on_object_mouse_left_button();
};
on_mouse_right_button			= function(_data) {
	/// @func	on_mouse_right_button(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	on_object_mouse_right_button();
};
on_mouse_middle_button			= function(_data) {
	/// @func	on_mouse_middle_button(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	on_object_mouse_middle_button();
};
on_mouse_button_released		= function(_data) {	// <-- DO NOT OVERRIDE THIS EVENT
	/// @func	on_mouse_button_released(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return	NA
	/// @tested false
	///
	switch (_data.button) {
		case mb_left:   return on_mouse_left_button_released(_data);
		case mb_right:  return on_mouse_right_button_released(_data);
		case mb_middle: return on_mouse_middle_button_released(_data);
	}
};
on_mouse_left_button_released	= function(_data) {
	/// @func	on_mouse_left_button_released(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	on_object_mouse_left_button_released();
};
on_mouse_right_button_released	= function(_data) {
	/// @func	on_mouse_right_button_released(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	on_object_mouse_right_button_released();
};
on_mouse_middle_button_released	= function(_data) {
	/// @func	on_mouse_middle_button_released(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	on_object_mouse_middle_button_released();
};

/// Other
on_destroyed = function(_data) {
	/// @func	on_destroyed(data)
	/// @param	data -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	on_object_destroyed(_data);
};
	
#endregion
