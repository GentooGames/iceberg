/// @desc objp_object
log("<INSTANCE> created " + string(object_get_name(object_index)) + ": " + string(id));
/////////////////////////////////////////
// .---. .---.     . .---- .---- ----- //
// |   | r--<  .   | r--   |       |   //
// L---J L---J L---J L---- L----   |   //
/////////////////////////////////////////
event_user(METHODS);
event_user(EVENTS);
event_id	= "object";
initialized	= false;
active		= true;
destroyed	= false;
rendering	= true;

setup_object	= function() {
	/// @func	setup_object()
	/// @desc	setup() methods are encapsulated to allow for re-initialization without 
	///			having to destroy the instance, and also prevents order-dependencies
	/// @return NA
	/// @tested true
	///
	if (initialized) exit;
	////////////////////////
	#region ----------------
	
	initialized	= true;
	active		= true;
	destroyed	= false;
	rendering	= true;
	
	#endregion
	#region Events /////////
	
	subscriptions	= [];
	n_subscriptions = 0;
	
	subscribe("input_mouse_button_pressed",	 on_mouse_button_pressed);
	subscribe("input_mouse_button",			 on_mouse_button);
	subscribe("input_mouse_button_released", on_mouse_button_released);
	
	#endregion
};
teardown_object = function() {
	/// @func	teardown_object()
	/// @desc	teardown() methods are encapsulated to allow for modular destruction of
	///			core props, associations, and declarations without having to destroy the
	///			instance
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	////////////////////////
	#region Events /////////
	
	clear_subscriptions();
	
	#endregion
	#region ----------------
	
	initialized = false;
	active		= true;
	destroyed	= false;
	rendering	= true;
	
	#endregion
};
rebuild_object  = function() {
	/// @func	rebuild_object()
	/// @desc	wrapper method to handle invoking teardown() & then setup()
	/// @return NA
	/// @tested false
	///
	teardown_object();
	setup_object();
};
update_object   = function() {
	/// @func	update_object()
	/// @desc	abstracted method to handle updating. invoke in step event.
	/// @return NA
	/// @tested false
	/// 
	if (!initialized) exit;
	////////////////////////
};
render_object   = function() {
	/// @func	render_object()
	/// @desc	abstracted method to handle rendering. invoke in draw event.
	/// @return NA
	/// @tested false
	/// 
	if (!initialized) exit;
	////////////////////////
};
	
#region @OVERRIDE

setup	 = function() {
	/// @func	setup()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	setup_object();
};
teardown = function() {
	/// @func	teardown()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	teardown_object();
};
rebuild	 = function() {
	/// @func	rebuild()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	rebuild_object();
};
update	 = function() {
	/// @func	update()
	/// @desc	...
	/// @return NA
	/// @tested false
	/// 
	update_object();
};
render	 = function() {
	/// @func	render()
	/// @desc	...
	/// @return NA
	/// @tested false
	/// 
	render_object();
};
	
#endregion

