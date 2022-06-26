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

setup	 = method_inherit(setup,	function() {
	/// @func	setup()
	/// @return {instance} id
	///
	if (!initialized) {
		#region States /////
	
		state_start = STATE_CONTROLLER_GAME_MAIN;
		fsm = new WeeState();
		fsm.set_default_draw(state_controller_game_draw_default);
		fsm.add(STATE_CONTROLLER_GAME_MAIN, state_controller_game_main())
		;
		fsm.change(state_start);
	
		#endregion
	}
	return id;
});
teardown = method_inherit(teardown, function() {
	/// @func	teardown()
	/// @return {instance} id
	///
	if (initialized) {
		#region States /////
	
		fsm = null;
	
		#endregion
	}
	return id;
});
rebuild  = method_inherit(rebuild,  function() {
	/// @func	rebuild()
	/// @return {instance} id
	///
	if (initialized) {}
	return id;
});
update	 = method_inherit(update,   function() {
	/// @func	update()
	/// @return {instance} id
	///
	if (initialized) {
		#region States /////
	
		fsm.step();		
	
		#endregion
	}
	return id;
});
render	 = method_inherit(render,   function() {
	/// @func	render()
	/// @return {instance} id
	///
	if (initialized) {
		#region States /////
	
		fsm.draw();
	
		#endregion
	}
	return id;
});



