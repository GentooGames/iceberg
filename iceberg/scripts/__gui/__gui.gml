global._gui = {};
#macro GUI	 global._gui
////////////////////////////
#macro SURF_W		  surface_get_width(application_surface)
#macro SURF_H		  surface_get_height(application_surface)
#macro GUI_W		  display_get_gui_width()
#macro GUI_H		  display_get_gui_height()
#macro BASE_W		  1600
#macro BASE_H		  900
#macro FONT_DEFAULT	 -1
#macro FONT_SCRIBBLE -1 // font_scribbles

GUI = {
    initialized: false,
	
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
		#region Border /////////
		
		border_trees_bottom	= new BorderTrees();
		border_trees_top	= new BorderTrees();
		
		border_trees_bottom
			.set_x_offset(-80)
			.set_y_offset(-40)
			.set_color(CONFIG.color.white)
		
		border_trees_top
			.set_color(color_get_random())
		
		#endregion
    },    
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		
		if (keyboard_check_pressed(ord("1"))) {
			border_trees_bottom.width.set_target(200);	
			border_trees_top.width.set_target(230);	
		}
		if (keyboard_check_pressed(vk_enter)) {
			var _width = irandom_range(10, 80);
			border_trees_bottom.spring_width(_width);	
			border_trees_top.spring_width(_width);	
			
			var _height = irandom_range(50, 200);
			border_trees_bottom.spring_height(_height);	
			border_trees_top.spring_height(_height);	
		}
		if (keyboard_check(vk_left)) {
			border_trees_bottom.x.adjust_offset(-1);
			border_trees_top.x.adjust_offset(-1);
		}
		if (keyboard_check(vk_right)) {
			border_trees_bottom.x.adjust_offset(1);
			border_trees_top.x.adjust_offset(1);
		}
		if (keyboard_check(vk_up)) {
			border_trees_bottom.y.adjust_offset(-1);
			border_trees_top.y.adjust_offset(-1);
		}
		if (keyboard_check(vk_down)) {
			border_trees_bottom.y.adjust_offset(1);
			border_trees_top.y.adjust_offset(1);
		}
		
		border_trees_bottom.update();
		border_trees_top.update();
	},
	render: function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		
		border_trees_bottom.render();
		border_trees_top.render();
	},
		
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
};
