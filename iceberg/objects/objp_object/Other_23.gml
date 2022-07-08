/// @desc CALLBACKS

setup_callback		= function() {
	/// @func	setup_callback()
	/// @return {struct} self
	///
	initialized = true;
	event_publish("setup_completed");
	return self;
};
teardown_callback	= function() {
	/// @func	teardown_callback()
	/// @return {struct} self
	///
	initialized = false;
	event_publish("teardown_completed");
	return self;
};
rebuild_callback	= function() {
	/// @func	rebuild_callback()
	/// @return {struct} self
	///
	event_publish("rebuild_completed");
	return self;
};
activate_callback	= function() {
	/// @func	activate_callback()
	/// @return {struct} self
	///
	active = true;
	event_publish("activated",,true);
	return self;
};
deactivate_callback = function() {
	/// @func	deactivate_callback
	/// @return {struct} self
	///
	active = false;
	event_publish("deactivated",,true);
	return self;
};
destroy_callback	= function() {
	/// @func	destroy_callback()
	/// @return {struct} self
	///
	destroyed = true;
	event_publish("destroyed",,true);
	instance_destroy();
	return self;
};
