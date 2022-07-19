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
},	callback_on_activate);
deactivate = method_inherit(,function() {
	/// @func	deactivate()
	/// @return {struct} self
	///
	if (active) {
		instance_deactivate_object(self.id);
	}
	return self;
},	callback_on_deactivate);
destroy	   = method_inherit(,function() {
	/// @func	destroy()
	/// @return {struct} self
	///
	if (!destroyed) {
		activate();
		teardown();
	}
	return self;
},	callback_on_destroy);
	
/// Interactions
mouse_touching = function() {	/// @OVERRIDE
	/// @func	mouse_touching()
	/// @return {boolean} mouse_touching?
	///
	return false;	// <-- false always returned here, because objp_object is abstract
					// override this method in any children objects that can interact.
};

