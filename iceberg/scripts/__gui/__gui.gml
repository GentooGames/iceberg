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

/*
	shader_set(shader);
	shader_set_uniform_f(u_time, current_time);
	var _texel_min    = 0.003;
	var _texel_max    = 0.03;
	var _texel_ratio  = 1;
	var _texel_width  = (_texel_max - _texel_min) * _texel_ratio;
	var _texel_height = (_texel_max - _texel_min) * _texel_ratio;
	shader_set_uniform_f(u_texel, _texel_width, _texel_height);
	shader_set_uniform_f_array(u_x_props, [0.005, 20.0, 0.05]);
	shader_set_uniform_f_array(u_y_props, [0.005, 20.0, 0.05]);
	draw_surface(surface, 0, 0);
	shader_reset();
*/

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
		
		border_trees = new BorderTrees();
		
		#endregion
    },    
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		
		if (INPUT.keyboard.button_pressed(vk_right)) {
			with (border_trees) {
				//x_scale.target = 0.5;
				width.target = SURF_W * 0.25;
			}
		}
		if (INPUT.keyboard.button_pressed(vk_left)) {
			with (border_trees) {
				//x_scale.target = 1.0;
				width.target = SURF_W;
			}
		}
		
		border_trees.update();
	},
	render: function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		
		border_trees.render();
		draw_circle(SURF_W * 0.5, SURF_H * 0.5, 5, false);
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






















