global._particles = {}
#macro PARTICLES   global._particles
////////////////////////////////////////

PARTICLES = {
    initialized: false,
    system: part_system_create(),
	
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
		part_system_depth(system, -1000);  
    },
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
	},
	
    get_system: function() {
        /// @func   get_system()
		/// @desc	...
        /// @return system -> {part_system}
        ///
        return system;
    },
};
