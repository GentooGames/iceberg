/// @desc obj_player
global._player = id;
#macro PLAYER global._player
/////////////////////////////////////////
// .---. .     .---. .   . .---- .---. //
// r---J |     r---j   V   r--   r---J //
// |     L---- |   |   |   L---- |  \  //
/////////////////////////////////////////
event_inherited();
event_user(METHODS);
event_user(EVENTS);
event_id = "player";

setup	 = method_inherit(setup,	function() {
	/// @func	setup()
	/// @return {instance} id
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
	return id;
});
teardown = method_inherit(teardown,	function() {
	/// @func	teardown()
	/// @return {instance} id
	///
	if (initialized) {
		#region States /////////
	
		fsm = null;
	
		#endregion
	}
	return id;
	
});
rebuild  = method_inherit(rebuild,	function() {
	/// @func	rebuild()
	/// @return {instance} id
	///
	if (initialized) {
		teardown();
		setup();
	}
	return id;
});
update   = method_inherit(update,	function() {
	/// @func	update()
	/// @return {instance} id
	///
	if (initialized) {
		#region States /////////
	
		fsm.step();	
	
		#endregion
	}
	return id;
});
render   = method_inherit(render,	function() {
	/// @func	render()
	/// @return {instance} id
	///
	if (initialized) {
		#region States /////////
	
		fsm.draw();	
	
		#endregion
	}
	return id;
});
	
