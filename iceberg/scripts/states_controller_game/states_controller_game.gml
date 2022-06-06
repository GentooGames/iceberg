#macro STATE_CONTROLLER_GAME_INIT "state_controller_game_init"
#macro STATE_CONTROLLER_GAME_MAIN "state_controller_game_main"

function state_controller_game_draw_default() {
	/// @func	state_controller_game_draw_default()
	/// @desc	...
	/// @return NA
	///
};
function state_controller_game_init() {
	/// @func	state_controller_game_init()
	/// @desc	...
	/// @return NA
	///
	return {
		enter: function() {
			if (!LOGGING) show_debug_message("LOGGING Disabled. Good-bye...");
			log("<LOGGING> initialized.");

			#region Global Data Files
			
			log("<OBJC_GAME> Setting Up Data Files...");
			//global_..._data_init();
			
			#endregion
			#region Core Systems

			log("<OBJC_GAME> Setting Up Core Systems...");
			AUDIO.setup();
			CLOCKS.setup();
			DEBUG.setup();
			DISPLAY.setup();
			EVENT.setup();
			GUI.setup();
			INPUT.setup();
			PARTICLES.setup();
			TRANSITION.setup();
			WINDOW.setup();
			
			#endregion
			#region Unit Tests

			log("<OBJC_GAME> Running Unit Tests...");
			UNIT_TEST.run_tests();
			
			#endregion
			
			log("##################################################");
			log("################## Game Started ##################");
			log("##################################################");
			
			#region Spawn Persistent Instances
			
			log("<OBJC_GAME> Spawning Game Controllers");
			camera_create_instance();
			instance_create_layer(0, 0, "Controllers", objc_world).setup();
			
			#endregion
			
			fsm.change(STATE_CONTROLLER_GAME_MAIN);
		},
		leave: function() {
			/// Exit __rm_init
			TRANSITION.room.goto(ROOM_FIRST);	
		},
	};
};
function state_controller_game_main() {
	/// @func	state_controller_game_main()
	/// @desc	...
	/// @return NA
	///
	return {
		step: function() {
			AUDIO.update();
			CLOCKS.update();
			DEBUG.update();
			DISPLAY.update();
			EVENT.update();
			GUI.update();
			INPUT.update();
			PARTICLES.update();
			TRANSITION.update();
			WINDOW.update();
		},
		draw: function() {
			DEBUG.render();	
		},
	};
};
