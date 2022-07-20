global.___system_particle = {
	initialized: false,
		
	#region Core ///////
		
	setup:    function() {
	    /// @func   setup()
	    /// @return {struct} self
	    ///
	    if (!initialized) {
			#region __ /////////////
		
		    log("<__particle> setup()");
		    initialized = true;
				
			#endregion
				
			system = part_system_create();
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
			
			log("<__particle> teardown()");
			initialized = false;
			
			#endregion
		};
		return self;
	},
		
	#endregion
	#region Getters ////
		
	get_system: function() {
	    /// @func   get_system()
	    /// @return {system_index} system
	    ///
	    return system;
	},
			
	#endregion
};
#macro PARTICLE global.___system_particle