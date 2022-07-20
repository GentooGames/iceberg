/// @desc INITIALIZE

/// Log
if (!LOGGING) show_debug_message("LOGGING Disabled. Good-bye...");
log("<game_start> initializing log...");

/// GameMaker
log("<game_start> randomizing seed...");
randomize();

/// Global 
log("<game_start> initializing global...");
___enums();
___macros();
___config();
___control();
___user_settings();

/// Systems
log("<game_start> initializing systems...");
CLOCK.setup();
INPUT.setup();
AUDIO.setup();
DISPLAY.setup();
WINDOW.setup();
PARTICLE.setup();
GUI.setup();
TRANSITION.setup();
TRUINST.setup();
DEBUG.setup();

/// Data Files
log("<game_start> initializing data files...");
//global_..._data_init();

/// Unit Tests
UNIT_TEST.run_tests();
			
/// Controllers
log("<game_start> initializing controller instances...");
GAME.setup();
//camera_create_instance();
//global._camera = new Camera(0, 0, 0, false);
//#macro CAMERA global._camera
//(instance_create_layer(0, 0, "Controllers", objc_world)).setup();
(instance_create_layer(0, 0, "Controllers", objc_save)).setup();

