function ___gui() {
	/// @func ___gui()
	///
	global.___system_gui = {
	    initialized: false,
		
		#region Core ///////
		
	    setup:    function() {
	        /// @func   setup()
	        /// @return {struct} self
	        ///
	        if (!initialized) {
				#region __ /////////////
		
		        log("<GUI> setup()");
		        initialized = true;
			
				#endregion
				#region Resolution /////
		
				width_base  = 1600;
				height_base = 900;
		
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
			}
			
			label = new UiLabel(, {
				text: "test label here...",
				x: SURF_W * 0.5,
				y: SURF_H * 0.5,
			})
			.action_add("change_color", function(_color) {
				set_color(_color);
			})
			.action_add_trigger("change_color", "space_bar", function() {
				var _result = keyboard_check_pressed(vk_space);	
				if (_result) {
					action_send_payload("change_color", c_red);
				}
				return _result;
			})
			
			return self;
	    },    
		update:	  function() {
			/// @func   update()
	        /// @return {struct} self
	        ///
	        if (initialized) {
				#region Border /////////
		
				border_mouth.update();
				border_teeth.update();
		
				#endregion
			}
				
			label.update();
				
			return self;
		},
		render:   function() {
			/// @func   update()
	        /// @return {struct} self
	        ///
	        if (initialized) {
				#region Border /////////
		
				border_teeth.render();
				border_mouth.render();
		
				#endregion
			}
				
			label.render();
			
			return self;
		},
		teardown: function() {
			/// @func	teardown()
			/// @return {struct} self
			///
			if (initialized) {};
			return self;
		},
	
		#endregion
		#region Actions ////
		
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
		
		#endregion
		#region Getters ////
		
		
		
		#endregion
		#region Setters ////
		
		
		
		#endregion
		#region Checkers ///
		
		
		
		#endregion
		#region __Private //
		
		
		
		#endregion
	};
	#region Macros /////////
	
	#macro GUI		global.___system_gui
	#macro SURF_W	surface_get_width(application_surface)
	#macro SURF_H	surface_get_height(application_surface)
	#macro GUI_W	display_get_gui_width()
	#macro GUI_H	display_get_gui_height()
	
	#endregion
	GUI.setup(); /// <-- automatically invoke setup()
};
