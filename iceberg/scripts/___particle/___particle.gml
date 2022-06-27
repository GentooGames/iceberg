global.___system_particle = {
    initialized: false,
	system:		 part_system_create(),

	/// Internal ///////////////////
    setup:  function() {
        /// @func   setup()
        /// @return {struct} self
        ///
        if (!initialized) {
			#region ----------------
		
	        log("<PARTICLE> setup()");
	        initialized = true;
		
			#endregion
			#region Events /////////
			
			EventObject(,"particle");
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
	
	/// Getters ////////////////////
    get_system: function() {
        /// @func   get_system()
        /// @return {system_index} system
        ///
        return system;
    },
};
#macro PARTICLE global.___system_particle
