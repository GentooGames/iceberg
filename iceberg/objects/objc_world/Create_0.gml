/// @desc objc_world
///////////////////////////////////
// .   . .---. .---. .     .---\ //
// |. .| |	 | r---J |     |   | //
// | V | L---J |  \  L---- L---/ //
///////////////////////////////////
event_inherited();
event_user(METHODS);
event_user(EVENTS);

setup_world	   = function() {
	/// @func	setup_world()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (initialized) exit;
	#region ----------------
	
	setup_controller();
	
	#endregion
};
teardown_world = function() {
	/// @func	teardown_world()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	teardown_controller();
	
	#endregion
};
rebuild_world  = function() {
	/// @func	rebuild_world()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	teardown_world();
	setup_world();
};
update_world   = function() {
	/// @func	update_world()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	update_controller();
	
	#endregion
};
render_world   = function() {
	/// @func	render_world()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	render_controller();
	
	#endregion
	render_bg();
};

#region @OVERRIDE 

setup	 = function() {
	/// @func	setup()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	setup_world();
};
teardown = function() {
	/// @func	teardown()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	teardown_world();
};
rebuild  = function() {
	/// @func	rebuild()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	rebuild_world();
};
update	 = function() {
	/// @func	update()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	update_world();
};
render	 = function() {
	/// @func	render()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	render_world();
};
	
#endregion
