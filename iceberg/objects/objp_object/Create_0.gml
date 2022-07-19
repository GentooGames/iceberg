/// @desc objp_object
log("<INSTANCE> created " + string(object_get_name(object_index)) + ": " + string(self.id));
/////////////////////////////////////////
// .---. .---.     . .---- .---- ----- //
// |   | r--<  .   | r--   |       |   //
// L---J L---J L---J L---- L----   |   //
/////////////////////////////////////////
events_user(CALLBACKS, EVENTS, METHODS);
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
		#region __ /////////////
		
		updating  = true;
		rendering = true;
		active	  = true;
		destroyed = false;
		
		#endregion
		#region Components /////
		
		components = new ComponentSystem().setup();
		components
			.create(Eventable)
			//.create(Moveable)
		
		components
			.get(Eventable)
				.register([
					"setup_completed",
					"teardown_completed",
					"rebuild_completed",
					"activated",
					"deactivated",
					"destroyed",
				])
		
		//INPUT.eventer.listen("mouse_button_pressed",  on_mouse_button_pressed);
		//INPUT.eventer.listen("mouse_button",		  on_mouse_button);
		//INPUT.eventer.listen("mouse_button_released", on_mouse_button_released);
		
		#endregion
	}
	return self;	
},	callback_on_setup);
teardown = method_inherit(,function() {
	/// @func	teardown()
	/// @return {struct} self
	///
	if (initialized) {
		#region Events /////////
	
		//clear_subscriptions();
	
		#endregion
		#region Components /////
		
		component_system_teardown();
		
		#endregion
		#region __ /////////////
		
		updating  = true;
		rendering = true;
		active	  = true;
		destroyed = false;
		
		#endregion
	}
	return self;
},	callback_on_teardown);
rebuild  = method_inherit(,function() {
	/// @func	rebuild()
	/// @return {struct} self
	///
	if (initialized) {
		teardown();
		setup();
	}
	return self;
},	callback_on_rebuild);
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

