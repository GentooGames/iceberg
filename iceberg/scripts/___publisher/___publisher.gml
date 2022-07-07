function ___publisher() {
	/// @func ___publisher()
	///
	global.___system_publisher = {
	    initialized: false,
		
		#region Core ///////
		
	    setup:    function() {
	        /// @func   setup()
	        /// @return {struct} self
	        ///
	        if (initialized) {
				#region ----------------
		
		        log("<PUBLISHER> setup()");
				initialized = true;
		
				#endregion
				#region Events /////////
			
				EventObject(self, "publisher");
				get_publisher	  = event_get_publisher;
				register		  = event_register;			
				registered		  = event_registered;			
				publish			  = event_publish;				
				subscribe		  = event_subscribe;			
				unsubscribe		  = event_unsubscribe;			
				clear_subscribers = event_clear_subscribers;	
			
				#endregion
			}
			return self;
	    },
		update:	  function() {
			/// @func	update()
			/// @return {struct} self
			///
			if (initialized) {};
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
		
		#endregion
		#region Actions ////
		
		
		
		#endregion
		#region Getters ////
		
		
		
		#endregion
		#region Setters ////
		
		
		
		#endregion
		#region Checkers ///
		
		
		
		#endregion
		#region __Private //
		
		
		
		#endregion
	};
	#region Macros /////////
	
	#macro PUBLISHER global.___system_publisher
	
	#endregion
	PUBLISHER.setup();	/// <-- automatically invoke setup()
};