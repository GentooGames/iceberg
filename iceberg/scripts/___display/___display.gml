function ___display() {
	/// @func ___display()
	///
	global.___system_display = {
	    initialized:  false,

	    setup:  function() {
	        /// @func   setup()
	        /// @return {struct} self
	        ///
	        if (!initialized) {
				#region ----------------
		
		        log("<DISPLAY> setup()");
		        initialized = true;
		
				#endregion
				#region Events /////////
			
				EventObject(self, "display");
				//event_register([]);
			
				#endregion
			}
			return self;
	    },
		update:	function() {
			/// @func   update()
	        /// @return {struct} self
	        ///
	        if (initialized) {}
			return self;
		},
	
		/// Getters ////////////
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
	};
	#macro DISPLAY global.___system_display
	////////////////////////
	DISPLAY.setup(); /// <-- automatically invoke setup()
};