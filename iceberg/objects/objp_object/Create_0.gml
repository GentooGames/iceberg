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

setup	 = method_inherit(,function() {
	/// @func	setup()
	/// @return {instance} id
	///
	if (!initialized) {
		#region ------------
	
		active	  = true;
		destroyed = false;
		rendering = true;
	
		#endregion
		#region Events /////
	
		EventObject(, event_id);
		event_register([
			"setup",
			"teardown",
			"rebuild",
			"activated",
			"deactivated",
			"destroyed",
		]);
		
		INPUT.event_subscribe("mouse_button_pressed",  on_mouse_button_pressed);
		INPUT.event_subscribe("mouse_button",		   on_mouse_button);
		INPUT.event_subscribe("mouse_button_released", on_mouse_button_released);
		event_publish("setup");
		
		#endregion
	}
	return id;	
	
}, function() { initialized = true; });
teardown = method_inherit(,function() {
	/// @func	teardown()
	/// @return {instance} id
	///
	if (initialized) {
		#region Events /////////
	
		//clear_subscriptions();
		event_publish("teardown");
	
		#endregion
		#region ----------------
	
		active	  = true;
		destroyed = false;
		rendering = true;
	
		#endregion
	}
	return id;
	
}, function() { initialized = false; });
rebuild  = method_inherit(,function() {
	/// @func	rebuild()
	/// @return {instance} id
	///
	if (initialized) {
		teardown();
		setup();
		event_publish("rebuild");
	}
	return id;
});
update	 = method_inherit(,function() {
	/// @func	update()
	/// @return {instance} id
	/// 
	if (initialized) {}
	return id;
});
render	 = method_inherit(,function() {
	/// @func	render()
	/// @return {instance} id
	/// 
	if (initialized) {}
	return id;
});
	
	

