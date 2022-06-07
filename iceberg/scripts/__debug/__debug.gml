global._debug = {};
#macro DEBUG   global._debug
////////////////////////////////
#macro DEBUGGING 1
#macro LOGGING   1

DEBUG = {
	initialized:  false,
	
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
		/// @tested false
        /// 
        if (!DEBUGGING)  exit;
		if (initialized) exit;
		#region ----------------
		
        log("<DEBUG> setup()");
		initialized = true;	
		
		#endregion
		#region gm_live ////////
		
		instance_create_depth(0, 0, 0, obj_gmlive);
		
		#endregion
    },
    update: function() {
        /// @func   update()
		/// @desc	...
        /// @return NA
		/// @tested false
        ///
        if (!DEBUGGING)   exit
		if (!initialized) exit;
		
		//INPUT.keyboard.switch_check({
		//	R: function() {
		//		TRANSITION.restart();
		//	},
		//	E: function() {
		//		game_end();	
		//	},
		//});	
		
		if (INPUT.keyboard.button_pressed(ord("R"))) {
			//TRANSITION.restart({
			//	on_change_hold: true,
			//	on_change: new_callback(function() {
			//		TRANSITION.complete();	
			//	})
			//});
			TRANSITION.restart();
		}
		if (INPUT.keyboard.button_pressed(ord("O"))) {
			//TRANSITION.goto_previous({
			//	on_change: new_callback(function() {
			//		TRANSITION.complete();	
			//	})
			//});
			TRANSITION.goto_previous();
		}
		if (INPUT.keyboard.button_pressed(ord("P"))) {
			TRANSITION.goto_next({
				wait:		true,
				on_change:	new_callback(function() {
					SAVE.save_game(,, function() {
						TRANSITION.complete();
					});
				})
			});
		}
		
        
        //if (INPUT.keyboard.button_pressed(vk_f11))   WINDOW.set_fullscreen(!WINDOW.get_fullscreen());
    },
    render: function() {
        /// @func   render()
		/// @desc	...
        /// @return NA
		/// @tested false
        ///
        if (!DEBUGGING)   exit
		if (!initialized) exit;
		
		var _y = GUI_H - 30;
		draw_text(10, _y, room_get_name(room));
		
		if (TRANSITION.effect != undefined) {
			draw_text(10, _y - 20, TRANSITION.effect.state);
		}
    },
};

