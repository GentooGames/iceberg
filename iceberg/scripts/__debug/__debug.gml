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
		show_debug_overlay(true);
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
		
		if (INPUT.keyboard.button_pressed(ord("R"))) {	// room restart
			TRANSITION.restart({
				wait:		true,
				on_change:	new_callback(function() {
					SAVE.save_game(,, function() {
						TRANSITION.complete();
					});
				})
			});
		}
		if (INPUT.keyboard.button_pressed(ord("O"))) {	// room goto next
			TRANSITION.goto_previous({
				wait:		true,
				on_change:	new_callback(function() {
					SAVE.save_game(,, function() {
						TRANSITION.complete();
					});
				})
			});
		}
		if (INPUT.keyboard.button_pressed(ord("P"))) {	// room goto previous
			TRANSITION.goto_next({
				wait:		true,
				on_change:	new_callback(function() {
					SAVE.save_game(,, function() {
						TRANSITION.complete();
					});
				}),
			});
		}
		
        if (INPUT.keyboard.button_pressed(vk_f11))   {
			WINDOW.toggle_fullscreen();
		}
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
    },
};

