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
	////////////////////
},	activate_callback);
deactivate = method_inherit(,function() {
	/// @func	deactivate()
	/// @return {instance} id
	///
	if (active) {
		instance_deactivate_object(id);
	}
	return id;
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

