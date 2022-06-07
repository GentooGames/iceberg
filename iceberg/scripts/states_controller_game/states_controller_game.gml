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

			#region Data Files
			
			log("<OBJC_GAME> Setting Up Data Files...");
			//global_..._data_init();
			
			#endregion
			#region Systems

			log("<OBJC_GAME> Setting Up Core Systems...");
			AUDIO.setup();
			CLOCKS.setup();
			DISPLAY.setup();
			EVENT.setup();
			GUI.setup();
			INPUT.setup();
			PARTICLES.setup();
			TRANSITION.setup();
			WINDOW.setup();
			DEBUG.setup();
			
			#endregion
			#region Unit Tests

			log("<OBJC_GAME> Running Unit Tests...");
			UNIT_TEST.run_tests();
			
			#endregion
			
			log("##################################################");
			log("################## Game Started ##################");
			log("##################################################");
			
			#region Instances
			
			log("<OBJC_GAME> Spawning Game Controllers");
			//camera_create_instance();
			global._camera = new Camera(0, 0, 0, false);
			#macro CAMERA global._camera
			//instance_create_layer(0, 0, "Controllers", objc_world).setup();
			
			#endregion
			
			fsm.change(STATE_CONTROLLER_GAME_MAIN);
		},
		leave: function() {
			/// Exit __rm_init
			TRANSITION.goto({ 
				room: ROOM_FIRST,
				on_change: new_callback(function() {
					TRANSITION.complete();	
				})
			});	
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
			DISPLAY.update();
			EVENT.update();
			GUI.update();
			INPUT.update();
			PARTICLES.update();
			TRANSITION.update();
			WINDOW.update();
			DEBUG.update();
		},
		draw: function() {
			TRANSITION.render();
			DEBUG.render();	
		},
	};
};
