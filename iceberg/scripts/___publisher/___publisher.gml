function ___publisher() {
	/// @func ___publisher()
	///
	global.___system_publisher = {
	    initialized: false,
	
	    setup: function() {
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
	};
	#macro PUBLISHER global.___system_publisher
	////////////////////////
	PUBLISHER.setup();	/// <-- automatically invoke setup()
};