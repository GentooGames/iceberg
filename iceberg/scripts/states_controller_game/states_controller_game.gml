#macro STATE_CONTROLLER_GAME_MAIN "state_controller_game_main"

function state_controller_game_draw_default() {
	/// @func	state_controller_game_draw_default()
	/// @return NA
	///
};
function state_controller_game_main() {
	/// @func	state_controller_game_main()
	/// @return {struct} state_data
	///
	return {
		enter: function() {},
		step:  function() {
			AUDIO.update();
			CLOCK.update();
			DISPLAY.update();
			GUI.update();
			INPUT.update();
			PARTICLE.update();
			TRANSITION.update();
			DEBUG.update();
		},
		leave: function() {},
		draw:  function() {
			GUI.render();
			TRANSITION.render();
			DEBUG.render();	
		},
	};
};



