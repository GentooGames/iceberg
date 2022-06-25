/// @desc Methods

// Private
_update_edges  = function() {	
    /// @func   _update_edges()
    /// @desc   update the left, right, top, and bottom values based off of the camera's current
    ///         position so that these properties are always easily accessible.
    /// @return NA
    ///
	left   = x - (width  * 0.5) * zoom;
	right  = x + (width  * 0.5) * zoom;
	top	   = y - (height * 0.5) * zoom;
	bottom = y + (height * 0.5) * zoom;
}
_update_depth  = function() {
    /// @func   _update_depth()
    /// @desc   update the camera depth to always keep it maxed out.
    /// @return NA
    ///
	depth = MAX_DEPTH - 1;	
}
_update_pos	   = function() {
    /// @func   _update_pos()
    /// @desc   apply the appropriate modifications to the camera's position based off of the 
    ///         camera's "state", even though there is no explicit state machine for the camera.
    /// @return NA
    ///
	// Panning 1st Priority
	if (panning) {
		var _mouse_x = INPUT.mouse.get_x();
		var _mouse_y = INPUT.mouse.get_y();
		
		// Capture Initial Mouse Position
		if (pan_start_x == null || pan_start_y == null) {
			pan_start_x = _mouse_x;	
			pan_start_y = _mouse_y + TILE_HEIGHT;	
		} 
	    // Center Camera Pan Around Initial Click Position
		var _cursor_xoff = -pan_start_x;
		var _cursor_yoff = -pan_start_y + TILE_HEIGHT;
		
		// Update Camera Position & Camera's Target "to" Position
		x   += -_mouse_x - _cursor_xoff;
		y   += -_mouse_y - _cursor_yoff;
		x_to = x;
		y_to = y;
		
		// Wipe Focus Target
		focus_target = null;
	}
	// Focus Target 2nd Priority
	else if (focus_target != null && instance_exists(focus_target)) {
		x_to = focus_target.x;
		y_to = focus_target.y;
		x   += (x_to - x) * move_speed;
		y   += (y_to - y) * move_speed;
		
		pan_start_x = null;
		pan_start_y = null;
	}
	// Focus Point 3rd Priority
	else if (focus_point != null) {
	    x_to = focus_point.x;
		y_to = focus_point.y;
		x   += (x_to - x) * move_speed;
		y   += (y_to - y) * move_speed;
		
		pan_start_x  = null;
		pan_start_y  = null;
	}
	// Standard Movement Last Priority
	else {
		focus_target = null;
		x += (x_to - x) * move_speed;
		y += (y_to - y) * move_speed;
	
		pan_start_x = null;
		pan_start_y = null;
	}
}
_update_zoom   = function() {
    /// @func   _update_zoom()
    /// @desc   lerp camera's current zoom value towards target zoom value.
    /// @return NA
    ///
	//if (imgui_blocked()) return;
	
    if (!instance_exists(obj_player) || PLAYER.has_camera_control) {
	    if (middle_mouse_wheel_down) zoom_in (0.1);
		if (middle_mouse_wheel_up)	 zoom_out(0.1);
    }
	zoom	  = lerp(zoom, zoom_to, zoom_speed);	
	zoom_draw = zoom + shakers.spring.zoom.val;
	
	/// @event: zoom complete
	if (dist_thresh(zoom, zoom_to, 0.01, true)) {
		if (!zoom_complete) {
			PUBLISH("camera_zoom_completed");
			zoom_complete = true;
		}
	}
	else zoom_complete = false;
}
_update_shakes = function() {
    /// @func   _update_shakes()
    /// @desc   
    /// @return NA
    ///
	with (shakers) {
		rand.x.update();
		rand.y.update();
		spring.x.update();
		spring.y.update();
		spring.zoom.update();
	}
	pos_x = x + (shakers.rand.x.val + shakers.spring.x.val); 
	pos_y = y + (shakers.rand.y.val + shakers.spring.y.val);
}
_check_for_pan = function() {
    /// @func   _check_for_pan()
    /// @desc   if the camera can pan, and the user clicks the middle mouse wheel, then start pan.
    /// @return NA
    ///
	if (instance_exists(obj_player) && !PLAYER.has_camera_control) return;
		
	if (middle_mouse_pressed) {
		if (!imgui_blocked()) {
			panning = true;
			clear_focus_target();
		}
	}
	else if (middle_mouse_released) {
		panning = false;
		//camera_reset_focus();
	}
}

#region Getters /////////////

get_zoom		 = function() {
	/// @func   get_zoom()
	/// @return zoom -> {real}
	///
	return zoom;
}
get_width		 = function(_scaled = true) {
	/// @func   get_width(scaled*<t>)
	/// @param  scaled -> {bool}
	/// @return width  -> {real}
	///
	if (_scaled) {
		return width * zoom;
	}
	return width;
}
get_height		 = function(_scaled = true) {
	/// @func   get_height(scaled*<t>)
	/// @param  scaled  -> {bool}
	/// @return height  -> {real}
	///
	if (_scaled) {
		return height * zoom;
	}
	return height;
}
get_focus_point  = function() {
    /// @func   get_focus_point()
    /// @return NA
    ///
    return focus_point;
}
get_focus_target = function() {
    /// @func   get_focus_target()
    /// @return NA
    ///
	return focus_target;	
}

#endregion
#region Setters /////////////

set_zoom		 = function(_zoom) {
    /// @func   set_zoom(zoom)
    /// @param  zoom -> {real}
    /// @return NA
    ///
	zoom_to = clamp(_zoom, preset.zoom.min, preset.zoom.max);
}
set_focus_point  = function(_x, _y) {
    /// @func   set_focus_point(x, y)
    /// @param  x -> {real}
    /// @param  y -> {real}
    /// @return NA
    ///
	focus_point = {x: _x, y: _y };
}
set_focus_target = function(_target_inst) {
    /// @func   set_focus_target(target_inst)
    /// @param  target_inst -> {instance}
    /// @return NA
    ///
	focus_target = _target_inst;	
}

#endregion
#region Checkers ////////////

is_focusing_on_point  = function(_point) {
    /// @func   is_focusing_on_point(point)
    /// @desc   check if the current focus point is the same as the passed in struct.
    /// @param  point -> {struct}
    /// @return NA
    ///
	return get_focus_target() == _point;
}
is_focusing_on_target = function(_inst) {
    /// @func   is_focusing_on_target(inst)
    /// @desc   check if the current focus target is the passed in instance.
    /// @param  inst -> {instance}
    /// @return NA
    ///
	return get_focus_target() == _inst;
}

#endregion
#region Clearers ////////////

clear_focus_point = function() {
    /// @func   clear_focus_point()
    /// @return NA
    ///
    focus_point = null;
}
clear_focus_target = function() {
    /// @func   clear_focus_target()
    /// @return NA
    ///
	focus_target = null;	
}

#endregion
#region Shakers /////////////

shake_random_time	= function(_size = 5, _time = 8) {
	/// @func	shake_random_time()
	/// 
	with (shakers.rand) {
		x.shake_time(_size, _time);
		y.shake_time(_size, _time);
	}
}
shake_random_time_x	= function(_size = 5, _time = 8) {
	/// @func	shake_random_time_x()
	/// 
	shakers.rand.x.shake_time(_size, _time);
}
shake_random_time_y	= function(_size = 5, _time = 8) {
	/// @func	shake_random_time_y()
	/// 
	shakers.rand.y.shake_time(_size, _time);
}

shake_random_damp	= function(_size = 5, _damp = 1) {
	/// @func	shake_random_damp()
	/// 
	with (shakers.rand) {
		x.shake_damp(_size, _damp);
		y.shake_damp(_size, _damp);
	}
}
shake_random_damp_x	= function(_size = 5, _damp = 1) {
	/// @func	shake_random_damp_x()
	/// 
	shakers.rand.x.shake_damp(_size, _damp);
}
shake_random_damp_y	= function(_size = 5, _damp = 1) {
	/// @func	shake_random_damp_y()
	/// 
	shakers.rand.y.shake_damp(_size, _damp);
}

shake_spring_x		= function(_size, _tens, _damp) {
	/// @func	shake_spring_x()
	/// 
	shakers.spring.x.fire(-_size, _tens, _damp);
}
shake_spring_y		= function(_size, _tens, _damp) {
	/// @func	shake_spring_y()
	/// 
	shakers.spring.y.fire(-_size, _tens, _damp);
}
shake_spring_zoom	= function(_size, _tens, _damp) {
	/// @func	shake_spring_zoom()
	/// 
	shakers.spring.zoom.fire(-_size, _tens, _damp);
}

#endregion

zoom_in	 = function(_increment) {
	/// @func   zoom_in(increment)
    /// @desc   increase the zoom value.
    /// @oaran  increment -> {real}
    /// @return NA
    ///
	zoom_to = clamp(zoom + _increment, preset.zoom.min, preset.zoom.max);
}
zoom_out = function(_increment) {
    /// @func   zoom_out(increment)
    /// @desc   decrease the zoom value.
    /// @oaran  increment -> {real}
    /// @return NA
    ///
	zoom_to = clamp(zoom - _increment, preset.zoom.min, preset.zoom.max);
}
	
#region Events /////////////



#endregion