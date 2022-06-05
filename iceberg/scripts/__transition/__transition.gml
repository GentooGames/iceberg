global._transition = {};
#macro TRANSITION	global._transition
////////////////////////////////////////

TRANSITION = { 
	/// Properties & Associations
    initialized:  false,
	
	/// Methods
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
		/// @tested false
        ///
        if (initialized) return;
        log("<TRANSITION> setup()");
        initialized = true;
    },
    room:  {
        goto:          function(_room) {
            /// @func   goto(room)
            /// @param  room -> {room}
			/// @desc	...
            /// @return NA
            /// 
            PUBLISH("transition_room_changed", { room: _room });
            room_goto(_room);
        },
        goto_next:     function() {
            /// @func   goto_next()
			/// @desc	...
            /// @return NA
            ///
            goto(get_next());
        },
        goto_previous: function() {
            /// @func   goto_previous()
			/// @desc	...
            /// @return NA
            ///
            goto(get_previous());
        },
        restart:       function() {
            /// @func   restart()
			/// @desc	...
            /// @return NA
            ///
            PUBLISH("transition_room_restarted");
            room_restart();
        },
        get_next:      function(_room = room) {
            /// @func   get_next(room*<room>)
            /// @param  room_id -> {real}
			/// @desc	...
            /// @return room_id -> {real}
            ///
            var _next_room = _room + 1;
            if (room_exists(_next_room)) {
                return _next_room;
            }
            throw("<ERROR in TRANSITION.room.get_next()>:room with index " + string(_next_room) + " does not exist.");
        },
        get_previous:  function(_room = room) {
            /// @func   get_previous(room*<room>)
            /// @param  room_id -> {real}
			/// @desc	...
            /// @return room_id -> {real}
            ///
            var _previous_room = _room - 1;
            if (room_exists(_previous_room)) {
                return _previous_room;
            }
            throw("<ERROR in TRANSITION.room.get_previous()>:room with index " + string(_previous_room) + " does not exist.");
        }  
    },
};
