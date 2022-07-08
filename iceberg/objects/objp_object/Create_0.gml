/// @desc objp_object
log("<INSTANCE> created " + string(object_get_name(object_index)) + ": " + string(self.id));
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
	/// @return {struct} self
	///
	if (!initialized) {
		#region ------------
	
		updating  = true;
		rendering = true;
		active	  = true;
		destroyed = false;
	
		#endregion
		#region Events /////
	
		EventObject(event_id);
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
	return self;	
},	setup_callback);
teardown = method_inherit(,function() {
	/// @func	teardown()
	/// @return {struct} self
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
	return self;
},	teardown_callback);
rebuild  = method_inherit(,function() {
	/// @func	rebuild()
	/// @return {struct} self
	///
	if (initialized) {
		teardown();
		setup();
	}
	return self;
},	rebuild_callback);
update	 = method_inherit(,function() {
	/// @func	update()
	/// @return {struct} self
	/// 
	if (initialized) {
		/// ...
	}
	return self;
});
render	 = method_inherit(,function() {
	/// @func	render()
	/// @return {struct} self
	/// 
	if (initialized) {
		/// ...
	}
	return self;
});
	
	

