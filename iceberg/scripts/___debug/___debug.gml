function ___debug() {
	/// @func ___debug()
	///
	global.___system_debug = {
		initialized:  false,
	    setup:    function() {
	        /// @func   setup()
	        /// @return {struct} self
	        /// 
	        if (DEBUGGING && !initialized) {
				#region ----------------
		
		        log("<DEBUG> setup()");
				initialized = true;	
				show_debug_overlay(true);
		
				#endregion
				#region gm_live ////////
		
			instance_create_depth(0, 0, 0, obj_gmlive);
		
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
			if (initialized) {};
			return self;
		},
			
		#region Actions ////
		
		
		
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
	
	#macro DEBUG	 global.___system_debug
	#macro DEBUGGING 0
	#macro LOGGING   1
	
	#endregion
	DEBUG.setup(); /// <-- automatically invoke setup()
};