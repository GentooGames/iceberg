/// @desc METHODS

#region General ////////

activate	 = function() {
	/// @func	activate()
	/// @desc	...
	/// @return NA
	///
	if (active) return;
	////////////////////
	active = true;
	instance_activate_object(id);
};
deactivate	 = function() {
	/// @func	deactivate()
	/// @desc	...
	/// @return NA
	///
	if (!active) return;
	////////////////////
	active = false;
	instance_deactivate_object(id);
};
destroy		 = function() {
	/// @func	destroy()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (destroyed) return;
	////////////////////////
	if (!active) activate();
	on_destroyed({ id: id });
	teardown();
	instance_destroy();
	destroyed = true;
};
is_destroyed = function() {
	/// @func	is_destroyed()
	/// @desc	...
	/// @return destroyed? -> {bool}
	/// @tested false
	///
	return destroyed;
};
	
#endregion
#region Util ///////////

i_am = function(_id) {
	/// @func	i_am(id)
	/// @param	id -> {real}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	return _id == id;
};
	
#endregion

