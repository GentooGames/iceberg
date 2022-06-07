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

setup_player    = function() {
	/// @func	setup_player()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (initialized) exit;
	#region ----------------
	
	setup_object();
	
	#endregion
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
};
teardown_player = function() {
	/// @func	teardown_player()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region States /////////
	
	fsm = null;
	
	#endregion
	#region ----------------
	
	teardown_object();
	
	#endregion
};
rebuild_player  = function() {
	/// @func	rebuild_player()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	teardown_player();
	setup_player();
};
update_player	= function() {
	/// @func	update_player()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	update_object();
	
	#endregion
	#region States /////////
	
	fsm.step();	
	
	#endregion
};
render_player	= function() {
	/// @func	render_player()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	render_object();
	
	#endregion
	#region States /////////
	
	fsm.draw();	
	
	#endregion
};

#region @OVERRIDE

setup	 = function() {
	/// @func	setup()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	setup_player();
};
teardown = function() {
	/// @func	teardown()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	teardown_player();
};
update	 = function() {
	/// @func	update()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	update_player();
};
render	 = function() {
	/// @func	render()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	render_player();
};
	
#endregion