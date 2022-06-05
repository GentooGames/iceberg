/// @desc Init
if (!LOGGING) show_debug_message("LOGGING Disabled. Good-bye...");
log("<LOGGING> initialized.");
////////////////////////////////////////////////////////////
randomize();

/// Global Data Files
log("<OBJC_GAME> Setting Up Data Files...");
//global_..._data_init();

/// Core Systems
log("<OBJC_GAME> Setting Up Core Systems...");
EVENT.setup();
CLOCKS.setup();
DEBUG.setup();
INPUT.setup();
AUDIO.setup();
DISPLAY.setup();
WINDOW.setup();
GUI.setup();
TRANSITION.setup();
PARTICLES.setup();

/// Unit Tests
log("<OBJC_GAME> Running Unit Tests...");
UNIT_TEST.run_tests();

log("##################################################");
log("################## Game Started ##################");
log("##################################################");

/// Spawn Persistent Instances
log("<OBJC_GAME> Spawning Game Controllers");
camera_create_instance();
instance_create_layer(0, 0, "Controllers", objc_world).setup();

/// Exit __rm_init
#macro ROOM_FIRST rm_test
TRANSITION.room.goto(ROOM_FIRST);
////////////////////////////
setup();
