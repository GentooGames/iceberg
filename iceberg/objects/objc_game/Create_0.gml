/// @desc objc_game
global._game = id;
#macro GAME global._game
/////////////////////////////
// .---. .---. .   . .---- //
// |  -. r---j | V | r--   //
// L---J |   | |   | L---- //
/////////////////////////////
event_inherited();
event_id = "game";

//////////////////////////////////////////////////////////////////////
/// Game Instances, Libraries, & Data Files Loaded In "Game Start" ///
//////////////////////////////////////////////////////////////////////

setup_game	  = function() {
	/// @func	setup_game()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (initialized) exit;
	#region ----------------
	
	setup_controller();
	
	#endregion
	#region States /////////
	
	fsm = new WeeState();
	fsm.set_default_draw(state_controller_game_draw_default);
	state_start = STATE_CONTROLLER_GAME_INIT;
	fsm.add(STATE_CONTROLLER_GAME_INIT, state_controller_game_init())
	   .add(STATE_CONTROLLER_GAME_MAIN, state_controller_game_main())
	;
	fsm.change(state_start);
	
	#endregion
};
teardown_game = function() {
	/// @func	teardown_game()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region States /////////
	
	fsm = null;
	
	#endregion
	#region ----------------
	
	teardown_controller();
	
	#endregion
};
rebuild_game  = function() {
	/// @func	rebuild_game()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	teardown_game();
	setup_game();
};
update_game	  = function() {
	/// @func	update_game()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	update_controller();
	
	#endregion
	#region States /////////
	
	fsm.step();		
	
	#endregion
};
render_game	  = function() {
	/// @func	render_game()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	render_controller();
	
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
	setup_game();
};
teardown = function() {
	/// @func	teardown()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	teardown_game();
};
rebuild	 = function() {
	/// @func	rebuild()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	rebuild_game();
}
update	 = function() {
	/// @func	update()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	update_game();
};
render	 = function() {
	/// @func	render()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	render_game();
};
	
#endregion