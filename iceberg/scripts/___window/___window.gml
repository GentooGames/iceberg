function ___window() {
	/// @func ___window()
	///
	global.___system_window = {
	    initialized: false,
		
		#region Core ///////
		
	    setup:	  function() {
	        /// @func   setup()
	        /// @return {struct} self
	        ///
	        if (!initialized) {
				#region ----------------
		
		        log("<WINDOW> setup()");
		        initialized = true;
		
				#endregion
				#region Events /////////
			
				EventObject("window");
				event_register([
					"fullscreen_assigned",
					"position_assigned",
				]);
			
				#endregion
			}
			return self;
	    },
		update:	  function() {
			/// @func	update()
			/// @return {struct} self
			///
			if (initialized) {};
			return self;
		},
		render:	  function() {
			/// @func	render()
			/// @return {struct} self
			///
			if (initialized) {};
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
		
		toggle_fullscreen: function() {
			/// @func   toggle_fullscreen()
	        /// @return {struct} self
	        ///
			set_fullscreen(!get_fullscreen());
		},
			
		#endregion
		#region Getters ////
		
	    get_width:		function() {
	        /// @func   get_width()
	        /// @return {real} width
	        ///
	        return window_get_width();
	    },
	    get_height:		function() {
	        /// @func   get_height()
	        /// @return {real} height
	        ///
	        return window_get_height();
	    },
	    get_fullscreen:	function() {
	        /// @func   get_fullscreen()
	        /// @return {bool} is_fullscreen?
	        ///
	        return window_get_fullscreen();
	    },
	
		#endregion
		#region Setters ////
		
	    set_fullscreen: function(_fullscreen) {
	        /// @func   set_fullscreen(fullscreen?)
	        /// @return {bool} is_fullscreen?
	        /// @return {struct} self
	        ///
	        window_set_fullscreen(_fullscreen);
			//var _w = _fullscreen ? display_get_width()  : GUI.width_base;
			//var _h = _fullscreen ? display_get_height() : GUI.height_base;
			//log("fullscreen: {2}, w:{0}, h:{1}", _w, _h, _fullscreen);
			//surface_resize(application_surface, _w, _h);
			//display_set_gui_size(_w, _h);
			event_publish("fullscreen_assigned", _fullscreen);
			return self;
	    },
	    set_position:   function(_x, _y) {
	        /// @func   set_position(x, y)
	        /// @param  {real} x
	        /// @param  {real} y
	        /// @return {struct} self
	        ///
	        window_set_position(_x, _y);  
			event_publish("position_assigned", { x: _x, y: _y });
			return self;
	    },
			
		#endregion
		#region Checkers ///
		
		
		
		#endregion
		#region __Private //
		
		
		
		#endregion
	};
	#region Macros /////////
	
	#macro WINDOW global.___system_window
	
	#endregion
	WINDOW.setup(); /// <-- automatically invoke setup()
};