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
/// @NOTE: abstract this so that order is only needed to be set once
PUBLISHER.setup();	/// <-- should be first
AUDIO.setup();
CLOCKS.setup();
DISPLAY.setup();
GUI.setup();
INPUT.setup();
PARTICLES.setup();
TRANSITION.setup();
WINDOW.setup();
DEBUG.setup();		/// <-- should be last
			
#endregion
#region Unit Tests /////////

log("<OBJC_GAME> Running Unit Tests...");
UNIT_TEST.run_tests();
			
#endregion
#region Instances //////////
			
log("<OBJC_GAME> Spawning Game Controllers...");
GAME.setup();
//camera_create_instance();
//global._camera = new Camera(0, 0, 0, false);
//#macro CAMERA global._camera
//instance_create_layer(0, 0, "Controllers", objc_world).setup();
instance_create_layer(0, 0, "Controllers", objc_save).setup();

#endregion
