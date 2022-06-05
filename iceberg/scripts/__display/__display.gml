global._display = {};
#macro DISPLAY	 global._display
////////////////////////////////////

DISPLAY = {
	/// Properties & Associations
    initialized:  false,
	
	/// Methods
    setup:          function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) exit;
		////////////////////////
        log("<DISPLAY> setup()");
        initialized = true;
    },
    get_width:      function() {
        /// @func   get_width()
		/// @desc	...
        /// @return width {real}
        ///
        return display_get_width();
    },
    get_height:     function() {
        /// @func   get_height()
		/// @desc	...
        /// @return height {real}
        ///
        return display_get_height();
    },
};

