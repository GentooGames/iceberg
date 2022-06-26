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

setup	 = function() {
	/// @func	setup()
	/// @return {instance} id
	///
	//if (!initialized) {
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
		
		event_subscribe("setup",	method(id, function() { initialized = true;  })); // initialized only to be modified after inherited_methods execute
		event_subscribe("teardown", method(id, function() { initialized = false; })); // initialized only to be modified after inherited_methods execute
		INPUT.event_subscribe("mouse_button_pressed",  on_mouse_button_pressed);
		INPUT.event_subscribe("mouse_button",		   on_mouse_button);
		INPUT.event_subscribe("mouse_button_released", on_mouse_button_released);
	
		event_publish("setup");
		
		#endregion
	//}
	log("object.setup");
	return id;
};
teardown = function() {
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
};
rebuild  = function() {
	/// @func	rebuild()
	/// @return {instance} id
	///
	if (initialized) {
		teardown();
		setup();
	}
	return id;
};
update	 = function() {
	/// @func	update()
	/// @return {instance} id
	/// 
	if (initialized) {}
	return id;
};
render	 = function() {
	/// @func	render()
	/// @return {instance} id
	/// 
	if (initialized) {}
	return id;
};
	
