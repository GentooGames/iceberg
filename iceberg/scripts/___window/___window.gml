global.___window_system = {
    initialized: false,
	
	/// Internal ///////////////////
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) exit;
		#region ----------------
		
        log("<WINDOW> setup()");
        initialized = true;
		
		#endregion
		
    },
	update: function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
	},
	
	/// Core ///////////////////////
	toggle_fullscreen:	function() {
		/// @func   toggle_fullscreen()
		/// @desc	...
        /// @return NA
        ///
		set_fullscreen(!get_fullscreen());
	},
	
	/// Getters ////////////////////
    get_width:		function() {
        /// @func   get_width()
		/// @desc	...
        /// @return width -> {real}
        ///
        return window_get_width();
    },
    get_height:		function() {
        /// @func   get_height()
		/// @desc	...
        /// @return height -> {real}
        ///
        return window_get_height();
    },
    get_fullscreen:	function() {
        /// @func   get_fullscreen()
		/// @desc	...
        /// @return fullscreen -> {bool}
        ///
        return window_get_fullscreen();
    },
	
	/// Setters ////////////////////
    set_fullscreen: function(_fullscreen) {
        /// @func   set_fullscreen(fullscreen?)
        /// @param  fullscreen? -> {bool}
		/// @desc	...
        /// @return NA
        ///
        window_set_fullscreen(_fullscreen);
		//var _w = _fullscreen ? display_get_width()  : GUI.width_base;
		//var _h = _fullscreen ? display_get_height() : GUI.height_base;
		//log("fullscreen: {2}, w:{0}, h:{1}", _w, _h, _fullscreen);
		//surface_resize(application_surface, _w, _h);
		//display_set_gui_size(_w, _h);
    },
    set_position:   function(_x, _y) {
        /// @func   set_position(x, y)
        /// @param  x -> {real}
        /// @param  y -> {real}
		/// @desc	...
        /// @return NA
        ///
        window_set_position(_x, _y);  
    },
};
#macro WINDOW global.___window_system