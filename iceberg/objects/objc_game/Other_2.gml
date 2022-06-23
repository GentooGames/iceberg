/// @desc Setup

#region System /////////////

randomize();

#endregion
#region Init Log ///////////

if (!LOGGING) show_debug_message("LOGGING Disabled. Good-bye...");
log("<LOGGING> initialized.");

#endregion
#region Data Files /////////
			
log("<OBJC_GAME> Setting Up Data Files...");
//global_..._data_init();
			
#endregion
#region Custom Systems /////

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
#region Unit Tests /////////

log("<OBJC_GAME> Running Unit Tests...");
UNIT_TEST.run_tests();
			
#endregion
#region Instances //////////
			
log("<OBJC_GAME> Spawning Game Controllers...");
//camera_create_instance();
//global._camera = new Camera(0, 0, 0, false);
//#macro CAMERA global._camera
//instance_create_layer(0, 0, "Controllers", objc_world).setup();
instance_create_layer(0, 0, "Controllers", objc_save).setup();

#endregion

setup();
