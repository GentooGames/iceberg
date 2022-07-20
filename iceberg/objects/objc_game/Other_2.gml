/// @desc Setup

/// Log
if (!LOGGING) show_debug_message("LOGGING Disabled. Good-bye...");
log("<OBJC_GAME> initializing log...");

/// GameMaker
log("<OBJC_GAME> randomizing seed...");
randomize();

/// Global 
log("<OBJC_GAME> initializing global...");
___enums();
___macros();
___config();
___control();
___user_settings();

/// Systems
log("<OBJC_GAME> initializing systems...");
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
log("<OBJC_GAME> initializing data files...");
//global_..._data_init();

/// Unit Tests
UNIT_TEST.run_tests();
			
/// Controllers
log("<OBJC_GAME> initializing controller instances...");
GAME.setup();
//camera_create_instance();
//global._camera = new Camera(0, 0, 0, false);
//#macro CAMERA global._camera
//(instance_create_layer(0, 0, "Controllers", objc_world)).setup();
(instance_create_layer(0, 0, "Controllers", objc_save)).setup();

