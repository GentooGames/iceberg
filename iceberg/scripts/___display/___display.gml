function ___display() {
	/// @func ___display()
	///
	global.___system_display = {
	    initialized:  false,
		
		#region Core ///////
		
	    setup:    function() {
	        /// @func   setup()
	        /// @return {struct} self
	        ///
	        if (!initialized) {
				#region ----------------
		
		        log("<DISPLAY> setup()");
		        initialized = true;
		
				#endregion
				#region Events /////////
			
				EventObject("display");
				//event_register([]);
			
				#endregion
			}
			return self;
	    },
		update:	  function() {
			/// @func   update()
	        /// @return {struct} self
	        ///
	        if (initialized) {}
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
		
		
		
		#endregion
		#region Getters ////
		
	    get_width:  function() {
	        /// @func   get_width()
	        /// @return {real} width
	        ///
	        return display_get_width();
	    },
	    get_height: function() {
	        /// @func   get_height()
	        /// @return {real} height
	        ///
	        return display_get_height();
	    },
			
		#endregion
		#region Setters ////
		
		
		
		#endregion
		#region Checkers ///
		
		
		
		#endregion
		#region __Private //
		
		
		
		#endregion
	};
	#region Macros /////////
	
	#macro DISPLAY global.___system_display
	
	#endregion
	DISPLAY.setup(); /// <-- automatically invoke setup()
};