/// @desc objc_world
///////////////////////////////////
// .   . .---. .---. .     .---\ //
// |. .| |	 | r---J |     |   | //
// | V | L---J |  \  L---- L---/ //
///////////////////////////////////
event_inherited();
events_user(CALLBACKS, EVENTS, METHODS);

setup	 = method_inherit(setup,	function() {
	/// @func	setup()
	/// @return {instance} id
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
	if (initialized) {
		/// ...
	}
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
	if (initialized) {
		/// ...
	}
	return id;
});
render	 = method_inherit(render,	function() {
	/// @func	render_save()
	/// @return {instance} id
	///
	if (initialized) {
		/// ...
	}
	return id;
});

