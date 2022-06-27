global.___system_publisher = {
    initialized: false,
	
	/// Internal ///////////////////
    setup: function() {
        /// @func   setup()
        /// @return NA
        ///
        if (initialized) exit;
		#region ----------------
		
        log("<PUBLISHER> setup()");
		initialized = true;
		
		#endregion
		
		EventObject(,"event");
		get_publisher	  = get_event_publisher;
		register		  = event_register;			
		registered		  = event_registered;			
		publish			  = event_publish;				
		subscribe		  = event_subscribe;			
		unsubscribe		  = event_unsubscribe;			
		clear_subscribers = event_clear_subscribers;	
    },
};
#macro PUBLISHER global.___system_publisher

