/// @desc CALLBACKS

setup_callback		= function() {
	/// @func	setup_callback()
	/// @return {struct} self
	///
	initialized = true;
	eventer.broadcast("setup_completed");
	return self;
};
teardown_callback	= function() {
	/// @func	teardown_callback()
	/// @return {struct} self
	///
	initialized = false;
	eventer.broadcast("teardown_completed");
	return self;
};
rebuild_callback	= function() {
	/// @func	rebuild_callback()
	/// @return {struct} self
	///
	eventer.broadcast("rebuild_completed");
	return self;
};
activate_callback	= function() {
	/// @func	activate_callback()
	/// @return {struct} self
	///
	active = true;
	eventer.broadcast("activated",,true);
	return self;
};
deactivate_callback = function() {
	/// @func	deactivate_callback
	/// @return {struct} self
	///
	active = false;
	eventer.broadcast("deactivated",,true);
	return self;
};
destroy_callback	= function() {
	/// @func	destroy_callback()
	/// @return {struct} self
	///
	destroyed = true;
	eventer.broadcast("destroyed",,true);
	instance_destroy();
	return self;
};
