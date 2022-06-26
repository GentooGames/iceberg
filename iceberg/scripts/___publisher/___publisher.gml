global.___system_publisher = {
    initialized: false,
	////////////////////////////
    setup:  function() {
        /// @func   setup()
        /// @return NA
        ///
        if (initialized) exit;
		#region ----------------
		
        log("<PUBLISHER> setup()");
		initialized = true;
		
		#endregion
		
		EventObject(, "event");
		/// More Concise Method Interfaces, Removing Redundant Prefix
		get_publisher	  = get_event_publisher;
		register		  = event_register;
		registered		  = event_registered;
		publish			  = event_publish;
		subscribe		  = event_subscribe;
		unsubscribe		  = event_unsubscribe;
		clear_subscribers = event_clear_subscribers;
    },
	update:	function() {
		/// @func   update()
        /// @return NA
        ///
        if (!initialized) exit;
	},
};
#macro PUBLISHER global.___system_publisher

