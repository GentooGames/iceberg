global._particles = {}
#macro PARTICLES   global._particles
////////////////////////////////////////

PARTICLES = {
	/// Properties & Associations
    initialized:  false,
    system: part_system_create(),
	
	/// Methods
    setup:      function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) exit;
		////////////////////////
        log("<PARTICLE> setup()");
        part_system_depth(system, -1000);  
        initialized = true;
    },
    get_system: function() {
        /// @func   get_system()
		/// @desc	...
        /// @return system -> {part_system}
        ///
        return system;
    },
};
