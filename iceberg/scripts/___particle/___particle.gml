global.___particles_system = {
    initialized: false,
	system:	part_system_create(),

	/// Internal ///////////////////
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) exit;
		#region ----------------
		
        log("<PARTICLE> setup()");
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
	
	/// Getters ////////////////////
    get_system: function() {
        /// @func   get_system()
		/// @desc	...
        /// @return system -> {part_system}
        ///
        return system;
    },
};
#macro PARTICLES global.___particles_system
