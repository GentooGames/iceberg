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
	/// @return {instance} 
	///
	if (!initialized) {
		/// ...
	}
	return id;
});
teardown = method_inherit(teardown, function() {
	/// @func	teardown()
	/// @return {instance} id
	///
	if (initialized) {}
	return id;
});
rebuild  = method_inherit(rebuild,	function() {
	/// @func	rebuild()
	/// @return {instance} id
	///
	if (initialized) {
		/// ...
	}
	return id;
});
update	 = method_inherit(update,	function() {
	/// @func	update()
	/// @return {instance} id
	///
	if (initialized) {}
	return id;
});
render	 = method_inherit(render,	function() {
	/// @func	render()
	/// @return {instance} id
	///
	if (initialized) {}
	return id;
});



