/// @desc objp_controller
/////////////////////////////////////////////////////////////////
// .---- .---. .   . ----- .---. .---. .     .     .---- .---. //
// |     |   | | \ |   |   r---J |   | |     |     r--   r---J //
// L---- L---J |   V   |   |  \  L---J L---- L---- L---- |  \  //
/////////////////////////////////////////////////////////////////
event_inherited();
events_user(CALLBACKS, EVENTS, METHODS);
event_id = "controller";

setup	 = method_inherit(setup,	function() {
	/// @func	setup()
	/// @return {struct} self
	///
	if (!initialized) {
		/// ...
	}
	return self;
});
teardown = method_inherit(teardown, function() {
	/// @func	teardown()
	/// @return {struct} self
	///
	if (initialized) {
		/// ...
	}
	return self;
});
rebuild  = method_inherit(rebuild,	function() {
	/// @func	rebuild()
	/// @return {struct} self
	///
	if (initialized) {
		/// ...
	}
	return self;
});
update	 = method_inherit(update,	function() {
	/// @func	update()
	/// @return {struct} self
	///
	if (initialized) {
		/// ...
	}
	return self;
});
render	 = method_inherit(render,	function() {
	/// @func	render()
	/// @return {struct} self
	///
	if (initialized) {
		/// ...
	}
	return self;
});



