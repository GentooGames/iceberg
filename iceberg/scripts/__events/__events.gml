global._event = {};
#macro EVENT   global._event
////////////////////////////////
#macro PUBLISHER EVENT.publisher
#macro PUBLISH   PUBLISHER.publish
#macro SUBSCRIBE PUBLISHER.subscribe
#macro UNSUB     PUBLISHER.unsubscribe

EVENT = {
    initialized: false,
    publisher: new Publisher(),
	
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) exit;
		#region --------------------
		
        log("<EVENT> setup()");
		initialized = true;
		
		#endregion
		#region Static Events //////
		
		static_events = [
			"mouse_left_button_pressed",
	        "mouse_right_button_pressed",
	        "mouse_middle_button_pressed",  
	        "mouse_left_button",
	        "mouse_right_button",
	        "mouse_middle_button",  
	        "mouse_left_button_released",
	        "mouse_right_button_released",
	        "mouse_middle_button_released",  
			"destroyed",
		];
		
		for (var _i = 0, _n_ids = array_length(OBJECTS_INDEXES); _i < _n_ids; _i++) {
			var _object_index = OBJECTS_INDEXES[_i];
			var _object_name  = object_get_name(_object_index);
			var _prefix_index = string_pos("_", _object_name);
			var _event_name   = string_delete(_object_name, 1, _prefix_index);
			
			for (var _j = 0, _n_events = array_length(static_events); _j < _n_events; _j++) {
				var _static_event  = static_events[_j];
				var _combined_name = _event_name + "_" + _static_event;
				log("event_name: {0}", _combined_name);
				publisher.register_channel(_combined_name);
			}
		}
		
		#endregion
		#region Instance Events ////
		
        publisher.register_channel(
			/// Input 
            "input_mouse_button_pressed",
            "input_mouse_button",
            "input_mouse_button_released",
            "input_keyboard_button_pressed",
            "input_keyboard_button",
            "input_keyboard_button_released",
			
			/// Transition
			"transition_room_changed",
            "transition_room_restarted",
			
			/// Camera
			"camera_zoom_completed", 
			
			/// ...
        );
		
		#endregion
    },
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
	},
}

