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
	{	/// DEBUG
		var _sprite = __spr_transition_border_silhouette_trees;
		var _offset = 60;
		var _x		= -_offset;
		var _y		= -_offset;
		var _width	= SURF_W + (_offset * 2);
		var _height = SURF_H + (_offset * 2) + 5;
		
		/// Leaves Shadow
		shader_set(shdr_alpha_dither);
		var _offset = 15;
		draw_sprite_stretched_ext(_sprite, 0, _x + _offset, _y + _offset, _width - (_offset * 2), _height - (_offset * 2), c_white, alpha);
		shader_reset();
		
		if (!surface_exists(surface)) {
			surface = surface_create(SURF_W, SURF_H);
		}
		surface_set_target(surface);
		draw_clear_alpha(c_black, 0.0);
		
		/// Leaves
		draw_sprite_stretched_ext(_sprite, 1, _x, _y, _width, _height, color, 1);
			
		surface_reset_target();
			
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
	}
*/

GUI = {
    initialized: false,
    surface: {
        application: {
            width:  surface_get_width(application_surface),
            height: surface_get_height(application_surface),    
        },
    },
    cursor: {
        preset: {
            standard: -1, //spr_cursor_default  
            select:   -1, //spr_cursor_select
            place:    -1, //spr_cursor_place
        },
        scale: 1,
        color: c_white,
    },
	
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
    },    
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
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
