global.___system_clock = {
	initialized:	false,
	clock_stable:	new iota_clock(), // core system
	clock_camera:	new iota_clock(), // camera
	clock_action:	new iota_clock(), // gameplay entities
	clock_ui:		new iota_clock(), // ui overlays and action frames
	clock_tutorial: new iota_clock(), // tutorial entities
	
	setup:    function() {
	    /// @func   setup()
	    /// @return {struct} self
	    ///
	    if (!initialized) {
			#region __ /////////////
		
		    log("<CLOCK> setup()");
			initialized = true;
		
			#endregion
			#region Clocks /////////
			
		    static _frequency = 60;
		    clock_stable.set_update_frequency(_frequency);
		    clock_camera.set_update_frequency(_frequency);
		    clock_action.set_update_frequency(_frequency);
		    clock_ui.set_update_frequency(_frequency);
		    clock_tutorial.set_update_frequency(_frequency);
        
		    #macro CLOCK_STABLE   CLOCK.clock_stable
		    #macro CLOCK_CAMERA   CLOCK.clock_camera
		    #macro CLOCK_ACTION   CLOCK.clock_action
		    #macro CLOCK_UI 	  CLOCK.clock_ui
		    #macro CLOCK_TUTORIAL CLOCK.clock_tutorial
			
			#endregion
		}
		return self;
	},
	update:   function() {
	    /// @func   update()
	    /// @return {struct} self
	    ///
	    if (initialized) {
		    CLOCK_STABLE.tick();
		    CLOCK_CAMERA.tick();
		    CLOCK_ACTION.tick();
		    CLOCK_UI.tick();
		    CLOCK_TUTORIAL.tick();
		}
		return self;
	},
	render:	  function() {
		/// @func	render()
		/// @return {struct} self
		///
		if (initialized) {};
		return self;
	},
	teardown: function() {
		/// @func	teardown()
		/// @return {struct} self
		///
		if (initialized) {};
		return self;
	},
};
#macro CLOCK global.___system_clock