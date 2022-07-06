function ___particle() {
	/// @func ___particle()
	///
	global.___system_particle = {
	    initialized: false,
	    setup:    function() {
	        /// @func   setup()
	        /// @return {struct} self
	        ///
	        if (!initialized) {
				#region ----------------
		
		        log("<PARTICLE> setup()");
		        initialized = true;
				
				system = part_system_create();
		
				#endregion
				#region Events /////////
			
				EventObject(self, "particle");
				//event_register([]);
			
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
			if (initialized) {};
			return self;
		},
		
		#region Actions ////
		
		
		
		#endregion
		#region Getters ////
		
	    get_system: function() {
	        /// @func   get_system()
	        /// @return {system_index} system
	        ///
	        return system;
	    },
			
		#endregion
		#region Setters ////
		
		
		
		#endregion
		#region Checkers ///
		
		
		
		#endregion
		#region __Private //
		
		
		
		#endregion
	};
	#region Macros /////////
	
	#macro PARTICLE global.___system_particle
	
	#endregion
	PARTICLE.setup(); /// <-- automatically invoke setup()
};