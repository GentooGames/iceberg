function ___transition() {
	/// @func ___transition()
	///
	global.___system_transition = { 
	    initialized: false,
	
	    setup:  function() {
	        /// @func   setup()
	        /// @return {struct} self
	        ///
	        if (!initialized) {
				#region --------------------
		
		        log("<FLOE> setup()");
				initialized = true;
		
				#endregion
				#region Room ///////////////
		
				room_target		= undefined;
				room_hold		= false;	// should the room be held until manual exit execution?
				room_holding	= false;	// is the room currently holding?
				room_to_release = false;	// is the room ready to be released?

				#endregion
				#region State Machine //////
		
				state_start = STATE_SYSTEM_TRANSITION_IDLE;
				fsm = new SnowState(state_start);
				fsm.event_set_default_function("draw", state_system_transition_draw_default);
				fsm.add(STATE_SYSTEM_TRANSITION_IDLE,		   state_system_transition_idle())
				   .add(STATE_SYSTEM_TRANSITION_TRANSITIONING, state_system_transition_transitioning())
				   .add(STATE_SYSTEM_TRANSITION_CHANGE,		   state_system_transition_change())
				   .add(STATE_SYSTEM_TRANSITION_HOLD,		   state_system_transition_hold())
				   .add(STATE_SYSTEM_TRANSITION_ENDING,		   state_system_transition_ending())
				;
				fsm.change(state_start);
		
				#endregion
				#region Floe Effects ///////
		
				effect_default = FloeEffectFade;
				effect_in	   = undefined;
				effect_out	   = undefined;
				effect		   = undefined;
		
				#endregion
				#region Events /////////////
		
				EventObject(self, "transition");
				event_register([
					"enter_started",
					"enter_completed",
					"change_started",
					"change_completed",
					"hold_started",
					"hold_completed",
					"exit_started",
					"exit_completed",
					"room_changed",
					"room_restarted",
				]);
		
				#endregion
			}
			return self;
	    },
		update:	function() {
			/// @func   update()
	        /// @return {struct} self
	        ///
	        if (initialized) {
				#region State Machine //////
			
				fsm.step();
			
				#endregion
		
				if (keyboard_check_pressed(ord("R"))) {
					TRANSITION.restart({
						room_hold:  true,
						effect_in:  FloeEffectBorderTrees,
						effect_out: FloeEffectBorderTrees
					});
				}
			}
			return self;
		},
		render: function() {
			/// @func   render()
	        /// @return {struct} self
	        ///
			if (initialized) {
				fsm.draw();
			}
			return self;
		},
	
		/// Core ///////////////////
		goto:			   function(_room, _data = undefined) {
			/// @func   goto(room, data*)
			/// @param	{room_index} room
			/// @param	{struct}	 data=undefined
	        /// @return {struct}	 self
	        ///
			if (start_transition_is_ready()) {
				set_transition_data(_room, _data);
				start_transition();
			}
			return self;
		},
	    goto_next:		   function(_data) {
	        /// @func   goto_next()
			/// @param	{struct} data
	        /// @return {struct} self
	        ///
			return goto(get_room_next(), _data);
	    },
	    goto_previous:	   function(_data) {
	        /// @func   goto_previous()
			/// @param	{struct} data
	        /// @return {struct} self
	        ///
			return goto(get_room_previous(), _data);
	    },
	    restart:		   function(_data) {
	        /// @func   restart(data)
			/// @param	{struct} data
	        /// @return {struct} self
	        ///
			return goto(room, _data);
	    },
		
		/// Transitions ////////////
		start_transition_is_ready: function() {
			/// @func	start_transition_is_ready()
			/// @return {boolean} is_ready?
			///
			return !is_transitioning();
		},
		start_transition:		   function() {
			/// @func	start_transition()
			/// @return {struct} self
			///
			fsm.change(STATE_SYSTEM_TRANSITION_TRANSITIONING);
			return self;
		},
		end_transition_is_ready:   function() {
			/// @func	end_transition_is_ready()
			/// @return {boolean} is_ready?
			///
			return (is_transitioning() 
				&& !room_hold
				&&	room_holding 
				&&  room_to_release
			);
		},
		end_transition:			   function() {
			/// @func	end_transition()
			/// @return {struct} self
			///
			room_holding = false;
			fsm.change(STATE_SYSTEM_TRANSITION_ENDING);
			return self;
		},
		is_transitioning:		   function() {
			/// @func	is_transitioning()
			/// @return	{boolean} is_transitioning?
			///
			return !fsm.state_is(STATE_SYSTEM_TRANSITION_IDLE);
		},
		set_transition_data:	   function(_room, _data = undefined) {
			/// @func	set_transition_data(room, data*)
			/// @param	{room_index} room
			/// @param	{struct}	 data=undefined
			/// @return {struct}	 self
			///
			room_target	= _room;
			if (_data != undefined) {
				effect_in  = _data[$ "effect"	] ?? (_data[$ "effect_in" ] ?? effect_default);
				effect_out = _data[$ "effect"	] ?? (_data[$ "effect_out"] ?? effect_default);
				room_hold  = _data[$ "room_hold"] ?? room_hold; 
			}
			return self;
		},	
		
		/// Getters ////////////////
	    get_room_next:	   function(_room = room) {
	        /// @func   get_room_next()
	        /// @param  {room_index} room
	        /// @return {room_index} room_next
	        ///
	        var _next_room = _room + 1;
	        if (room_exists(_next_room)) {
	            return _next_room;
	        }
	        throw("<ERROR in TRANSITION.get_room_next()>:room with index " + string(_next_room) + " does not exist.");
	    },
	    get_room_previous: function(_room = room) {
	        /// @func   get_room_previous()
	        /// @param  {room_index} room
	        /// @return {room_index} room_previous
	        ///
	        var _previous_room = _room - 1;
	        if (room_exists(_previous_room)) {
	            return _previous_room;
	        }
	        throw("<ERROR in TRANSITION.get_room_previous()>:room with index " + string(_previous_room) + " does not exist.");
	    },
	};
	#macro TRANSITION global.___system_transition
	////////////////////////
	TRANSITION.setup(); /// <-- automatically invoke setup()
}