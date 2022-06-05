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
#region Subscriptions //

publish				= function(_event_name, _event_data) {
	/// @func	publisher(event_name, event_data)
	/// @param	event_name -> {string}
	/// @param	event_data -> {any}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	PUBLISH(_event_name, _event_data);	
};
subscribe			= function(_event_name, _callback, _weak = false) {
	/// @func	subscribe(event_name, callback, weak?*<f>)
	/// @param	event_name -> {string}
	/// @param	callback   -> {function}
	/// @param	weak?	   -> {bool}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	array_push(subscriptions, SUBSCRIBE(_event_name, _callback, _weak));
	n_subscriptions++;
};
clear_subscriptions = function() {
	/// @func	clear_subscriptions()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	for (var _i = 0, _len = array_length(subscriptions); _i < _len; _i++) {
		UNSUB(subscriptions[_i]);
	}
	subscriptions   = [];
	n_subscriptions = 0;
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

