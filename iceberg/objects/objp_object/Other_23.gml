/// @desc CALLBACKS

/// Core
callback_on_setup	 = function() {
	/// @func	callback_on_setup()
	/// @return {struct} self
	///
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("setup_completed");
	//		
	initialized = true;
	return self;
};
callback_on_teardown = function() {
	/// @func	callback_on_teardown()
	/// @return {struct} self
	///
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("teardown_completed");
		
	initialized = false;
	return self;
};
callback_on_rebuild	 = function() {
	/// @func	callback_on_rebuild()
	/// @return {struct} self
	///
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("rebuild_completed");
			
	return self;
};

/// Methods
callback_on_activate	= function() {
	/// @func	callback_on_activate()
	/// @return {struct} self
	///
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("activated");
	
	active = true;
	return self;
};
callback_on_deactivate	= function() {
	/// @func	callback_on_deactivate
	/// @return {struct} self
	///
	component_system()
		.get_component("eventer")
			.broadcast("deactivated");
	
	active = false;
	return self;
};
callback_on_destroy		= function() {
	/// @func	callback_on_destroy()
	/// @return {struct} self
	///	
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("destroyed");
		
	destroyed = true;
	instance_destroy();
	return self;
};

/// Events
callback_on_mouse_left_button_pressed	 = function() {
	/// @func	callback_on_mouse_left_button_pressed()
	/// @return {struct} self
	///	
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("mouse_left_button_pressed");
			
	return self;
};
callback_on_mouse_right_button_pressed	 = function() {
	/// @func	callback_on_mouse_right_button_pressed()
	/// @return {struct} self
	///	
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("mouse_right_button_pressed");
			
	return self;
};
callback_on_mouse_middle_button_pressed  = function() {
	/// @func	callback_on_mouse_middle_button_pressed()
	/// @return {struct} self
	///	
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("mouse_middle_button_pressed");
			
	return self;
};
callback_on_mouse_left_button			 = function() {
	/// @func	callback_on_mouse_left_button()
	/// @return {struct} self
	///	
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("mouse_left_button");
			
	return self;
};
callback_on_mouse_right_button			 = function() {
	/// @func	callback_on_mouse_right_button()
	/// @return {struct} self
	///	
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("mouse_right_button");
			
	return self;
};
callback_on_mouse_middle_button			 = function() {
	/// @func	callback_on_mouse_middle_button()
	/// @return {struct} self
	///	
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("mouse_middle_button");
			
	return self;
};
callback_on_mouse_left_button_released   = function() {
	/// @func	callback_on_mouse_left_button_released()
	/// @return {struct} self
	///	
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("mouse_left_button_released");
			
	return self;
};
callback_on_mouse_right_button_released  = function() {
	/// @func	callback_on_mouse_right_button_released()
	/// @return {struct} self
	///	
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("mouse_right_button_released");
			
	return self;
};
callback_on_mouse_middle_button_released = function() {
	/// @func	callback_on_mouse_middle_button_released()
	/// @return {struct} self
	///	
	//component_system()
	//	.get_component("eventer")
	//		.broadcast("mouse_middle_button_released");
			
	return self;
};
