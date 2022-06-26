#macro DEBUGGING 1
#macro LOGGING   1

global.___system_debug = {
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
#macro DEBUG global.___system_debug
