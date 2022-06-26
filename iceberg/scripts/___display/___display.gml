global.___system_display = {
    initialized:  false,
	
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) exit;
		#region ----------------
		
        log("<DISPLAY> setup()");
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
	
    get_width:  function() {
        /// @func   get_width()
		/// @desc	...
        /// @return width {real}
        ///
        return display_get_width();
    },
    get_height: function() {
        /// @func   get_height()
		/// @desc	...
        /// @return height {real}
        ///
        return display_get_height();
    },
};
#macro DISPLAY global.___system_display

