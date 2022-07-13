/// @desc objc_game
global._game = self;
#macro GAME global._game
/////////////////////////////
// .---. .---. .   . .---- //
// |  -. r---j | V | r--   //
// L---J |   | |   | L---- //
/////////////////////////////
event_inherited();

//////////////////////////////////////////////////////////////////////
/// Game Instances, Libraries, & Data Files Loaded In "Game Start" ///
//////////////////////////////////////////////////////////////////////

setup	 = method_inherit(setup,	function() {
	/// @func	setup()
	/// @return {struct} self
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
	return self;
});
teardown = method_inherit(teardown, function() {
	/// @func	teardown()
	/// @return {struct} self
	///
	if (initialized) {
		#region States /////
	
		fsm = undefined;
	
		#endregion
	}
	return self;
});
rebuild  = method_inherit(rebuild,  function() {
	/// @func	rebuild()
	/// @return {struct} self
	///
	if (initialized) {
		/// ...
	}
	return self;
});
update	 = method_inherit(update,   function() {
	/// @func	update()
	/// @return {struct} self
	///
	if (initialized) {
		#region States /////
	
		fsm.step();		
	
		#endregion
	}
	return self;
});
render	 = method_inherit(render,   function() {
	/// @func	render()
	/// @return {struct} self
	///
	if (initialized) {
		#region States /////
	
		fsm.draw();
	
		#endregion
	}
	return self;
});

