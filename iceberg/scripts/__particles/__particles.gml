global._particles = {}
#macro PARTICLES   global._particles
////////////////////////////////////////

PARTICLES = {
    initialized: false,
	system: undefined,
	
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
		
		depth  = -1000;
		system = part_system_create();
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
