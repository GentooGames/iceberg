/// @desc METHODS

activate	   = function() {
	/// @func	activate()
	/// @return {instance} id
	///
	if (!active) {
		active = true;
		instance_activate_object(id);
		event_publish("activated",, true);
	}
	return id;
};
deactivate	   = function() {
	/// @func	deactivate()
	/// @return {instance} id
	///
	if (active) {
		active = false;
		instance_deactivate_object(id);
		event_publish("deactivated",, true);
	}
	return id;
};
destroy		   = function() {
	/// @func	destroy()
	/// @return {instance} id
	///
	if (!destroyed) {
		activate();
		teardown();
		instance_destroy();
		destroyed = true;
		event_publish("destroyed",, true);
	}
	return id;
};
is_destroyed   = function() {
	/// @func	is_destroyed()
	/// @return {boolean} is_destroyed?
	///
	return destroyed;
};
mouse_touching = function() {	/// @OVERRIDE
	/// @func	mouse_touching()
	/// @return {boolean} mouse_touching?
	///
	return false;	// <-- false always returned here, because objp_object is abstract
					// override this method in any children objects that can interact.
};
