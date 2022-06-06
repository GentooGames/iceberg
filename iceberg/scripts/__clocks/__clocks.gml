global._clocks	= {};
#macro CLOCKS	global._clocks
////////////////////////////////

CLOCKS = {
	initialized:	false,
    clock_stable:	new iota_clock(), // core system
    clock_camera:	new iota_clock(), // camera
    clock_action:	new iota_clock(), // gameplay entities
    clock_ui:		new iota_clock(), // ui overlays and action frames
    clock_tutorial: new iota_clock(), // tutorial entities
	
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) exit;
		////////////////////////
        log("<CLOCKS> setup()");
        
        static _frequency = 60;
        clock_stable.set_update_frequency(_frequency);
        clock_camera.set_update_frequency(_frequency);
        clock_action.set_update_frequency(_frequency);
        clock_ui.set_update_frequency(_frequency);
        clock_tutorial.set_update_frequency(_frequency);
        
        #macro CLOCK_STABLE   CLOCKS.clock_stable
        #macro CLOCK_CAMERA   CLOCKS.clock_camera
        #macro CLOCK_ACTION   CLOCKS.clock_action
        #macro CLOCK_UI 	  CLOCKS.clock_ui
        #macro CLOCK_TUTORIAL CLOCKS.clock_tutorial
        
        initialized = true;
    },
    update: function() {
        /// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		////////////////////////
        CLOCK_STABLE.tick();
        CLOCK_CAMERA.tick();
        CLOCK_ACTION.tick();
        CLOCK_UI.tick();
        CLOCK_TUTORIAL.tick();
    },
};

