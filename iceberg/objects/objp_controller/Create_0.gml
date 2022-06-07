/// @desc objp_controller
/////////////////////////////////////////////////////////////////
// .---- .---. .   . ----- .---. .---. .     .     .---- .---. //
// |     |   | | \ |   |   r---J |   | |     |     r--   r---J //
// L---- L---J |   V   |   |  \  L---J L---- L---- L---- |  \  //
/////////////////////////////////////////////////////////////////
event_inherited();
event_user(METHODS);
event_user(EVENTS);
event_id = "controller";

setup_controller	= function() {
	/// @func	setup_controller()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (initialized) exit;
	#region ----------------
	
	setup_object();
	
	#endregion
};
teardown_controller = function() {
	/// @func	teardown_controller()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	teardown_object();
	
	#endregion
};
rebuild_controller  = function() {
	/// @func	rebuild_controller()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	teardown_controller();
	setup_controller();
};
update_controller	= function() {
	/// @func	update_controller()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	update_object();
	
	#endregion
};
render_controller	= function() {
	/// @func	render_controller()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	render_object();
	
	#endregion
};
	
#region @OVERRIDE 

setup	 = function() {
	/// @func	setup()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	setup_controller();
};
teardown = function() {
	/// @func	teardown()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	teardown_controller();
};
rebuild	 = function() {
	/// @func	rebuild()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	rebuild_controller();
};
update	 = function() {
	/// @func	update()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	update_controller();
};
render	 = function() {
	/// @func	render()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	render_controller();
};
	
#endregion
