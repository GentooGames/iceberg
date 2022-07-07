/// @desc objp_object
log("<INSTANCE> created " + string(object_get_name(object_index)) + ": " + string(id));
/////////////////////////////////////////
// .---. .---.     . .---- .---- ----- //
// |   | r--<  .   | r--   |       |   //
// L---J L---J L---J L---- L----   |   //
/////////////////////////////////////////
events_user(CALLBACKS, EVENTS, METHODS);
event_id	= "object";
initialized	= false;
updating	= true;
rendering	= true;
active		= true;
destroyed	= false;

setup	 = method_inherit(,function() {
	/// @func	setup()
	/// @return {instance} id
	///
	if (!initialized) {
		#region ------------
	
		updating  = true;
		rendering = true;
		active	  = true;
		destroyed = false;
	
		#endregion
		#region Events /////
	
		EventObject(id, event_id);
		event_register([
			"setup_completed",
			"teardown_completed",
			"rebuild_completed",
			"activated",
			"deactivated",
			"destroyed",
		]);
		
		INPUT.event_subscribe("mouse_button_pressed",  on_mouse_button_pressed);
		INPUT.event_subscribe("mouse_button",		   on_mouse_button);
		INPUT.event_subscribe("mouse_button_released", on_mouse_button_released);
		
		#endregion
	}
	return id;	
},	setup_callback);
teardown = method_inherit(,function() {
	/// @func	teardown()
	/// @return {instance} id
	///
	if (initialized) {
		#region Events /////////
	
		//clear_subscriptions();
	
		#endregion
	
		updating  = true;
		rendering = true;
		active	  = true;
		destroyed = false;
	}
	return id;
},	teardown_callback);
rebuild  = method_inherit(,function() {
	/// @func	rebuild()
	/// @return {instance} id
	///
	if (initialized) {
		teardown();
		setup();
	}
	return id;
},	rebuild_callback);
update	 = method_inherit(,function() {
	/// @func	update()
	/// @return {instance} id
	/// 
	if (initialized) {
		/// ...
	}
	return id;
});
render	 = method_inherit(,function() {
	/// @func	render()
	/// @return {instance} id
	/// 
	if (initialized) {
		/// ...
	}
	return id;
});
	
	

