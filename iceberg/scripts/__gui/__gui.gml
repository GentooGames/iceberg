global._gui = {
    initialized: false,
	#region Internal ///////
	
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) exit;
		#region ----------------
		
        log("<GUI> setup()");
        initialized = true;
			
		#endregion
		#region Resolution /////
		
		width_base  = 1600;
		height_base = 900;
		
		#endregion
		#region Font ///////////
		
		font_default = -1;
		
		#endregion
		#region Border /////////
		
		border_mouth = new BorderTrees();
		border_teeth = new BorderTrees();
		
		with (border_mouth) {
			set_color(CONFIG.color.green_lime);
		}
		with (border_teeth) {
			set_x_offset(-80);
			set_y_offset(-40);
			set_color(CONFIG.color.white);
		}
		
		#endregion
		
		//script_execute(function() {
		//	show_message("test message");
		//});
		
		label = new UiLabel(,"state_start", {
			text: "text for config start",
			x: SURF_W * 0.5,
			y: SURF_H * 0.5,
		})
    },    
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		
		#region Border /////////
		
		border_mouth.update();
		border_teeth.update();
		
		#endregion
		
		if (keyboard_check_pressed(ord("1"))) label.state_change("state_start");
		if (keyboard_check_pressed(ord("2"))) label.state_change("state_2");
		if (keyboard_check_pressed(ord("3"))) label.state_change("state_3");
		
		label.update();
	},
	render: function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		#region Border /////////
		
		border_teeth.render();
		border_mouth.render();
		
		#endregion
		
		label.render();
	},
	
	#endregion
	#region Public /////////
	
    world_to_gui_x: function(_x) {
    	/// @func	world_to_gui_x(x)
    	/// @param	x_world {real}
		/// @desc	convert a given x(world) coordinate, return the associated x(gui) coordinate.
    	/// @return x_gui	{real}
    	///
    	var _scaled_ratio = SURF_W / CAMERA.get_width();
    	return (_x - CAMERA.left) * _scaled_ratio;
    },
    world_to_gui_y: function(_y) {
    	/// @func	world_to_gui_y(y)
    	/// @desc	convert a given y(world) coordinate, return the associated y(gui) coordinate.
    	/// @param	y_world {real}
    	/// @return y_gui	{real}
    	///
    	var _scaled_ratio = SURF_H / CAMERA.get_height();
    	return (_y - CAMERA.top) * _scaled_ratio;
    },
    gui_to_world_x: function() { /* need to implement... */ },
    gui_to_world_y: function() { /* need to implement... */ },
	
	#endregion
};
#macro GUI global._gui

#macro SURF_W surface_get_width(application_surface)
#macro SURF_H surface_get_height(application_surface)
#macro GUI_W  display_get_gui_width()
#macro GUI_H  display_get_gui_height()

