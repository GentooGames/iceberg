/// @desc METHODS

/// Core 
activate   = method_inherit(,function() {
	/// @func	activate()
	/// @return {struct} self
	///
	if (!active) {
		instance_activate_object(self.id);
	}
	return self;
},	activate_callback);
deactivate = method_inherit(,function() {
	/// @func	deactivate()
	/// @return {struct} self
	///
	if (active) {
		instance_deactivate_object(self.id);
	}
	return self;
},	function() { deactivate_callback(); });
destroy	   = method_inherit(,function() {
	/// @func	destroy()
	/// @return {struct} self
	///
	if (!destroyed) {
		activate();
		teardown();
	}
	return self;
},	function() { destroy_callback(); });
	
/// Interactions
mouse_touching = function() {	/// @OVERRIDE
	/// @func	mouse_touching()
	/// @return {boolean} mouse_touching?
	///
	return false;	// <-- false always returned here, because objp_object is abstract
					// override this method in any children objects that can interact.
};

