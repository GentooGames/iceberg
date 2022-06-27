/// @desc EVENTS

on_mouse_button_pressed			= method_inherit(,function(_data) { /// encapsulation
	/// @func	on_mouse_button_pressed(mouse_data)
	/// @param	{struct}   data
	/// @return	{instance} id
	///
	if (active && mouse_touching()) {
		switch (_data.button) {
			case mb_left:   return on_mouse_left_button_pressed(_data);
			case mb_right:  return on_mouse_right_button_pressed(_data);
			case mb_middle: return on_mouse_middle_button_pressed(_data);
		};
	}
	return id;
});
on_mouse_left_button_pressed	= method_inherit(,function(_data) {
	/// @func	on_mouse_left_button_pressed(data)
	/// @param	{struct}   data
	/// @return {instance} id
	///
	if (active) {}
	return id;
	/// v== callback
},	function() { event_publish("mouse_left_button_pressed"); });
on_mouse_right_button_pressed   = method_inherit(,function(_data) {
	/// @func	on_mouse_right_button_pressed(data)
	/// @param	{struct}   data
	/// @return {instance} id
	///
	if (active) {}
	return id;
	/// v== callback
},	function() { event_publish("mouse_right_button_pressed"); });
on_mouse_middle_button_pressed  = method_inherit(,function(_data) {
	/// @func	on_mouse_middle_button_pressed(data)
	/// @param	{struct}   data
	/// @return {instance} id
	///
	if (active) {}
	return id;
	/// v== callback
}, function() { event_publish("mouse_middle_button_pressed"); });
on_mouse_button					= method_inherit(,function(_data) { /// encapsulation
	/// @func	on_mouse_button(data)
	/// @param	{struct}   data
	/// @return	{instance} id
	///
	if (active && mouse_touching()) {
		switch (_data.button) {
			case mb_left:   return on_mouse_left_button(_data);
			case mb_right:  return on_mouse_right_button(_data);
			case mb_middle: return on_mouse_middle_button(_data);
		}
	}
	return id;
});
on_mouse_left_button			= method_inherit(,function(_data) {
	/// @func	on_mouse_left_button(data)
	/// @param	{struct}   data
	/// @return {instance} id
	///
	if (active) {}
	return id;
	/// v== callback
},	function() { event_publish("mouse_left_button"); });
on_mouse_right_button		    = method_inherit(,function(_data) {
	/// @func	on_mouse_right_button(data)
	/// @param	{struct}   data
	/// @return {instance} id
	///
	if (active) {}
	return id;
	/// v== callback
},	function() { event_publish("mouse_right_button"); });
on_mouse_middle_button		    = method_inherit(,function(_data) {
	/// @func	on_mouse_middle_button(data)
	/// @param	{struct}   data
	/// @return {instance} id
	///
	if (active) {}
	return id;
	/// v== callback
},	function() { event_publish("mouse_middle_button"); });
on_mouse_button_released		= method_inherit(,function(_data) { /// encapsulation
	/// @func	on_mouse_button_released(data)
	/// @param	{struct}   data
	/// @return	{instance} id
	///
	if (active && mouse_touching()) {
		switch (_data.button) {
			case mb_left:   return on_mouse_left_button_released(_data);
			case mb_right:  return on_mouse_right_button_released(_data);
			case mb_middle: return on_mouse_middle_button_released(_data);
		}
	}
	return id;
});
on_mouse_left_button_released   = method_inherit(,function(_data) {
	/// @func	on_mouse_left_button_released(data)
	/// @param	{struct}   data
	/// @return {instance} id
	///
	if (active) {}
	return id;
	/// v== callback
},	function() { event_publish("mouse_left_button_released"); });
on_mouse_right_button_released  = method_inherit(,function(_data) {
	/// @func	on_mouse_right_button_released(data)
	/// @param	{struct}   data
	/// @return	{instance} id
	///
	if (active) {}
	return id;
	/// v== callback
},	function() { event_publish("mouse_right_button_released"); });
on_mouse_middle_button_released = method_inherit(,function(_data) {
	/// @func	on_mouse_middle_button_released(data)
	/// @param	{struct}   data
	/// @return	{instance} id
	///
	if (active) {}
	return id;
	/// v== callback
},	function() { event_publish("mouse_middle_button_released"); });




