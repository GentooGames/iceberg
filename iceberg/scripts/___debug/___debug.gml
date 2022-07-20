global.___system_debug = {
	initialized: false,
	#region Core ///////
		
	setup:    function() {
	    /// @func   setup()
	    /// @return {struct} self
	    /// 
	    if (DEBUGGING && !initialized) {
			#region __ /////////////
		
		    log("<__debug> setup()");
			initialized = true;	
			show_debug_overlay(true);
		
			#endregion
			#region gm_live ////////
		
		if (asset_get_index("obj_gmlive") != -1) {
			instance_create_depth(0, 0, 0, obj_gmlive);
		}
		
		#endregion
		}
		return self;
	},
	update:   function() {
	    /// @func   update()
		/// @return {struct} self
	    ///
	    if (DEBUGGING && initialized) {
		    if (INPUT.keyboard.button_pressed(vk_f11))   {
				WINDOW.toggle_fullscreen();
			}
		}
		return self;
	},
	render:   function() {
	    /// @func   render()
	    /// @return {struct} self
	    ///
	    if (DEBUGGING && initialized) {
			var _y = GUI_H - 30;
			draw_text(10, _y, room_get_name(room));
		}
		return self;
	},
	teardown: function() {
		/// @func	teardown()
		/// @return {struct} self
		///
		if (initialized) {
			#region __ /////////////////
			
			log("<__debug> teardown()");
			initialized = false;
			
			#endregion
		};
		return self;
	},
		
	#endregion
};
#macro DEBUG	 global.___system_debug
#macro DEBUGGING 1
#macro LOGGING   DEBUGGING && 1