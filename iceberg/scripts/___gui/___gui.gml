global.___system_gui = {
    initialized: false,
	
	/// Internal ///////////////////
    setup:  function() {
        /// @func   setup()
        /// @return {struct} self
        ///
        if (!initialized) {
			#region ----------------
		
	        log("<GUI> setup()");
	        initialized = true;
			
			#endregion
			#region Resolution /////
		
			width_base  = 1600;
			height_base = 900;
		
			#endregion
			#region Events /////////
			
			EventObject(,"gui");
			//event_register([]);
			
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
		
			label = new UiLabel(,,{
				text: "text for config start",
				x: SURF_W * 0.5,
				y: SURF_H * 0.5,
			})
			.action_add("mouse_clicked_action", function(_data) {
				show_message("mouse_clicked -- " + string(_data));
			})
			.action_add_trigger("mouse_clicked_action", "mouse_clicked_trigger", function() {
				var _result = (mouse_touching() && mouse_check_button_pressed(mb_left));
				return action_set_trigger_result(_result, { x: mouse_x, y: mouse_y });
			})
		}
		return self;
    },    
	update:	function() {
		/// @func   update()
        /// @return {struct} self
        ///
        if (initialized) {
			#region Border /////////
		
			border_mouth.update();
			border_teeth.update();
		
			#endregion
				
			label.update();
		}
		return self;
	},
	render: function() {
		/// @func   update()
        /// @return {struct} self
        ///
        if (initialized) {
			#region Border /////////
		
			border_teeth.render();
			border_mouth.render();
		
			#endregion
			
			label.render();
		}
		return self;
	},
	
	/// Core ///////////////////////
    world_to_gui_x: function(_x) {
    	/// @func	world_to_gui_x(x)
    	/// @param	{real} x_world
    	/// @return {real} x_gui
    	///
    	var _scaled_ratio = SURF_W / CAMERA.get_width();
    	return (_x - CAMERA.left) * _scaled_ratio;
    },
    world_to_gui_y: function(_y) {
    	/// @func	world_to_gui_y(y)
		/// @param	{real} y_world
    	/// @return {real} y_gui
    	///
    	var _scaled_ratio = SURF_H / CAMERA.get_height();
    	return (_y - CAMERA.top) * _scaled_ratio;
    },
    gui_to_world_x: function() { /* need to implement... */ },
    gui_to_world_y: function() { /* need to implement... */ },
};
#macro GUI global.___system_gui

#macro SURF_W surface_get_width(application_surface)
#macro SURF_H surface_get_height(application_surface)
#macro GUI_W  display_get_gui_width()
#macro GUI_H  display_get_gui_height()

