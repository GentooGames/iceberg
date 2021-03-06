/// @desc objp_object
log("<object> \"{0}\" created with id: {1}", object_get_name(object_index), id);
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
		
		component_system_setup(
			Eventable,
		);
		get_component(Eventable)
			.register(
				"setup_completed",
				"teardown_completed",
				"rebuild_completed",
				"activated",
				"deactivated",
				"destroyed",
			)
		
		INPUT.get_component(Eventable)
			.listen("mouse_button_pressed",  on_mouse_button_pressed)
			.listen("mouse_button",			 on_mouse_button)
			.listen("mouse_button_released", on_mouse_button_released)
		
		#endregion
	}
	return self;	
},	callback_on_setup);
teardown = method_inherit(,function() {
	/// @func	teardown()
	/// @return {struct} self
	///
	if (initialized) {
		#region Components /////
		
		teardown_components();
		
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

