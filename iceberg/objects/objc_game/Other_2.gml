/// @desc Setup

#region Log ////////////

if (!LOGGING) show_debug_message("LOGGING Disabled. Good-bye...");
log("<OBJC_GAME> initializing log...");

#endregion
#region GameMaker //////

log("<OBJC_GAME> randomizing seed...");
randomize();

#endregion
#region Global /////////

log("<OBJC_GAME> initializing global...");
___enums();
___macros();
___config();
___control();
___user_settings();

#endregion
#region Systems ////////

log("<OBJC_GAME> initializing systems...");
___publisher();
___clock();
___input();
___audio();
___display();
___window();
___particle();
___gui();
___transition();
___truInst();
___unit_test();
___debug();
			
#endregion
#region Data Files /////
			
log("<OBJC_GAME> initializing data files...");
//global_..._data_init();
			
#endregion
#region Controllers ////
			
log("<OBJC_GAME> initializing controller instances...");
GAME.setup();
//camera_create_instance();
//global._camera = new Camera(0, 0, 0, false);
//#macro CAMERA global._camera
//instance_create_layer(0, 0, "Controllers", objc_world).setup();
instance_create_layer(0, 0, "Controllers", objc_save).setup();

#endregion
