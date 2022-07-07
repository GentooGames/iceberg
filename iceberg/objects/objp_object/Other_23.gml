/// @desc CALLBACKS

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
