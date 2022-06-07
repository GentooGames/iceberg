global._gui = {};
#macro GUI	 global._gui
////////////////////////////
#macro SW			  surface_get_width(application_surface)
#macro SH			  surface_get_height(application_surface)
#macro GUI_W		  display_get_gui_width()
#macro GUI_H		  display_get_gui_height()
#macro BASE_W		  1600
#macro BASE_H		  900
#macro FONT_DEFAULT	 -1
#macro FONT_SCRIBBLE -1 // font_scribbles

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
    	var _scaled_ratio = SW / CAMERA.get_width();
    	return (_x - CAMERA.left) * _scaled_ratio;
    },
    world_to_gui_y: function(_y) {
    	/// @func	world_to_gui_y(y)
    	/// @desc	convert a given y(world) coordinate, return the associated y(gui) coordinate.
    	/// @param	y_world {real}
    	/// @return y_gui	{real}
    	///
    	var _scaled_ratio = SH / CAMERA.get_height();
    	return (_y - CAMERA.top) * _scaled_ratio;
    },
    gui_to_world_x: function() { /* need to implement... */ },
    gui_to_world_y: function() { /* need to implement... */ },
};
