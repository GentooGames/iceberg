/// @desc METHODS

/// Core 
activate   = method_inherit(,function() {
	/// @func	activate()
	/// @return {instance} id
	///
	if (!active) {
		instance_activate_object(id);
	}
	return id;
	/// v== callback
},	function() { activate_callback(); });
deactivate = method_inherit(,function() {
	/// @func	deactivate()
	/// @return {instance} id
	///
	if (active) {
		instance_deactivate_object(id);
	}
	return id;
	/// v== callback
},	function() { deactivate_callback(); });
destroy	   = method_inherit(,function() {
	/// @func	destroy()
	/// @return {instance} id
	///
	if (!destroyed) {
		activate();
		teardown();
	}
	return id;
},	function() { destroy_callback(); });
	
/// Interactions
mouse_touching = function() {	/// @OVERRIDE
	/// @func	mouse_touching()
	/// @return {boolean} mouse_touching?
	///
	return false;	// <-- false always returned here, because objp_object is abstract
					// override this method in any children objects that can interact.
};

/// Inherited Method Callbacks
setup_callback		= function() {
	/// @func	setup_callback()
	/// @return {instance} id
	///
	initialized = true;
	event_publish("setup_completed");
	return id;
};
teardown_callback	= function() {
	/// @func	teardown_callback()
	/// @return {instance} id
	///
	initialized = false;
	event_publish("teardown_completed");
	return id;
};
rebuild_callback	= function() {
	/// @func	rebuild_callback()
	/// @return {instance} id
	///
	event_publish("rebuild_completed");
	return id;
};
activate_callback	= function() {
	/// @func	activate_callback()
	/// @return {instance} id
	///
	active = true;
	event_publish("activated",,true);
	return id;
};
deactivate_callback = function() {
	/// @func	deactivate_callback
	/// @return {instance} id
	///
	active = false;
	event_publish("deactivated",,true);
	return id;
};
destroy_callback	= function() {
	/// @func	destroy_callback()
	/// @return {instance} id
	///
	destroyed = true;
	event_publish("destroyed",,true);
	instance_destroy();
	return id;
};


