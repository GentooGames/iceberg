/// @desc CALLBACKS

setup_callback		= function() {
	/// @func	setup_callback()
	/// @return {struct} self
	///
	initialized = true;
	eventer.publish("setup_completed");
	return self;
};
teardown_callback	= function() {
	/// @func	teardown_callback()
	/// @return {struct} self
	///
	initialized = false;
	eventer.publish("teardown_completed");
	return self;
};
rebuild_callback	= function() {
	/// @func	rebuild_callback()
	/// @return {struct} self
	///
	eventer.publish("rebuild_completed");
	return self;
};
activate_callback	= function() {
	/// @func	activate_callback()
	/// @return {struct} self
	///
	active = true;
	eventer.publish("activated",,true);
	return self;
};
deactivate_callback = function() {
	/// @func	deactivate_callback
	/// @return {struct} self
	///
	active = false;
	eventer.publish("deactivated",,true);
	return self;
};
destroy_callback	= function() {
	/// @func	destroy_callback()
	/// @return {struct} self
	///
	destroyed = true;
	eventer.publish("destroyed",,true);
	instance_destroy();
	return self;
};
