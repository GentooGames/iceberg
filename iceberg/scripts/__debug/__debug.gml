global._debug = {};
#macro DEBUG   global._debug
////////////////////////////////
#macro DEBUGGING 1
#macro LOGGING   1

DEBUG = {
	/// Properties & Associations
	initialized:  false,
	
	/// Methods
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
		/// @tested false
        /// 
        if (!DEBUGGING || initialized) exit;
		////////////////////////////////////
        log("<DEBUG> setup()");
		instance_create_depth(0, 0, 0, obj_gmlive);
		initialized = true;
    },
    update: function() {
        /// @func   update()
		/// @desc	...
        /// @return NA
		/// @tested false
        ///
        if (!DEBUGGING || !initialized) exit;
		////////////////////////////////////
		//INPUT.keyboard.switch_check({
		//	R: function() {
		//		TRANSITION.room.restart();
		//	},
		//	E: function() {
		//		game_end();	
		//	},
		//});	
	
        //if (INPUT.keyboard.button_pressed(ord("R"))) TRANSITION.room.restart();
        //if (INPUT.keyboard.button_pressed(vk_f11))   WINDOW.set_fullscreen(!WINDOW.get_fullscreen());
    },
    render: function() {
        /// @func   render()
		/// @desc	...
        /// @return NA
		/// @tested false
        ///
        if (!DEBUGGING || !initialized) exit;
		////////////////////////////////////
		draw_text(10, GUI_H - 30, room_get_name(room));
    },
};

