global._event = {
    initialized: false,
	////////////////////////////////
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
		
		EventObject();
		
		/// Static Events //////////
		static_events = [
			"destroyed",
		];
		//static _exclude = obj_gmlive;
		//for (var _i = 0, _n_ids = array_length(OBJECTS_INDEXES); _i < _n_ids; _i++) {
		//	var _object_index  =  OBJECTS_INDEXES[_i];
		//	if (_object_index == _exclude) continue;
		//	
		//	var _object_name  = object_get_name(_object_index);
		//	var _prefix_index = string_pos("_", _object_name);
		//	var _event_name   = string_delete(_object_name, 1, _prefix_index);
		//	
		//	for (var _j = 0, _n_events = array_length(static_events); _j < _n_events; _j++) {
		//		var _static_event  = static_events[_j];
		//		var _combined_name = _event_name + "_" + _static_event;
		//		publisher.register_channel(_combined_name);
		//	}
		//}
    },
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
	},
};
#macro EVENT global._event