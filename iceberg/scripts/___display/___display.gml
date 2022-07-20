global.___system_display = {
	initialized:  false,
	#region Core ///////
		
	setup:    function() {
	    /// @func   setup()
	    /// @return {struct} self
	    ///
	    if (!initialized) {
			#region __ /////////////
		
		    log("<__display> setup()");
		    initialized = true;
		
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
		if (initialized) {
			#region __ /////////////////
			
			log("<__display> teardown()");
			initialized = false;
			
			#endregion
		};
		return self;
	},
	
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
};
#macro DISPLAY global.___system_display