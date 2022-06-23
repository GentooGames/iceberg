global._transition = { 
    initialized: false,
	////////////////////
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) exit;
		#region --------------------
		
        log("<FLOE> setup()");
		initialized = true;
		
		#endregion
		#region State Machine //////
		
		state_start = STATE_SYSTEM_TRANSITION_IDLE;
		fsm = new SnowState(state_start);
		fsm.set_default_draw(state_system_transition_draw_default);
		fsm.add(STATE_SYSTEM_TRANSITION_IDLE,		   state_system_transition_idle())
		   .add(STATE_SYSTEM_TRANSITION_TRANSITIONING, state_system_transition_transitioning())
		   .add(STATE_SYSTEM_TRANSITION_CHANGE,		   state_system_transition_change())
		   .add(STATE_SYSTEM_TRANSITION_HOLD,		   state_system_transition_hold())
		   .add(STATE_SYSTEM_TRANSITION_ENDING,		   state_system_transition_ending())
		;
		fsm.change(state_start);
		
		#endregion
		#region Floe Effects ///////
		
		effect_in  = undefined;
		effect_out = undefined;
		effect	   = undefined;
		
		#endregion
    },
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		////////////////////
		fsm.step();
	},
	render: function() {
		/// @func   render()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		////////////////////
		fsm.draw();
	},
	////////////////////
	goto:			   function() {
		/// @func   goto()
        /// @return 
        ///
		
	},
    goto_next:		   function(_data = {}) {
        /// @func   goto_next()
        /// @return 
        ///
		
    },
    goto_previous:	   function(_data = {}) {
        /// @func   goto_previous()
        /// @return 
        ///
		
    },
    restart:		   function(_data) {
        /// @func   restart()
        /// @return 
        ///
		
    },
    get_room_next:	   function(_room = room) {
        /// @func   get_room_next()
        /// @param  
        /// @return 
        ///
        var _next_room = _room + 1;
        if (room_exists(_next_room)) {
            return _next_room;
        }
        throw("<ERROR in FLOE.get_room_next()>:room with index " + string(_next_room) + " does not exist.");
    },
    get_room_previous: function(_room = room) {
        /// @func   get_room_previous()
        /// @param  
        /// @return 
        ///
        var _previous_room = _room - 1;
        if (room_exists(_previous_room)) {
            return _previous_room;
        }
        throw("<ERROR in FLOE.get_room_previous()>:room with index " + string(_previous_room) + " does not exist.");
    },
};
#macro TRANSITION global._transition

