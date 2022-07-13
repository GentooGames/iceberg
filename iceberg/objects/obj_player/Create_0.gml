/// @desc obj_player
global._player = self;
#macro PLAYER global._player
/////////////////////////////////////////
// .---. .     .---. .   . .---- .---. //
// r---J |     r---j   V   r--   r---J //
// |     L---- |   |   |   L---- |  \  //
/////////////////////////////////////////
event_inherited();
events_user(CALLBACKS, EVENTS, METHODS);

setup	 = method_inherit(setup,	function() {
	/// @func	setup()
	/// @return {struct} self
	///
	if (!initialized) {
		#region Interactions ///
	
		has_camera_control = true;  // can interact with camera
		can_interact_hard  = true;  // can execute actions and selections on board/board-instances
		can_interact_soft  = true;  // can hover and view real-time board/board-instance properties
	
		#endregion
		#region States /////////
	
		fsm = new WeeState();
		fsm.set_default_draw(state_player_draw_default);
		fsm.add(STATE_PLAYER_IDLE, state_player_idle())
		;
		fsm.change(STATE_PLAYER_IDLE);
	
		#endregion
	}
	return self;
});
teardown = method_inherit(teardown,	function() {
	/// @func	teardown()
	/// @return {struct} self
	///
	if (initialized) {
		#region States /////////
	
		fsm = undefined;
	
		#endregion
	}
	return self;
	
});
rebuild  = method_inherit(rebuild,	function() {
	/// @func	rebuild()
	/// @return {struct} self
	///
	if (initialized) {
		/// ...
	}
	return self;
});
update   = method_inherit(update,	function() {
	/// @func	update()
	/// @return {struct} self
	///
	if (initialized) {
		#region States /////////
	
		fsm.step();	
	
		#endregion
	}
	return self;
});
render   = method_inherit(render,	function() {
	/// @func	render()
	/// @return {struct} self
	///
	if (initialized) {
		#region States /////////
	
		fsm.draw();	
	
		#endregion
	}
	return self;
});
	
