global._transition = { 
    initialized: false,
	
	/// Internal ///////////////////
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
				
		/// Transition Publisher
		publisher = new Publisher();
		event_register(
			"enter_started",
			"enter_completed",
			"change_started",
			"change_completed",
			"hold_started",
			"hold_completed",
			"exit_started",
			"exit_completed",
		);
		
		#endregion
    },
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		////////////////////////////
		fsm.step();
		
		if (keyboard_check_pressed(ord("R"))) {
			TRANSITION.restart({
				room_hold: true,
			});
		}
	},
	render: function() {
		/// @func   render()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		////////////////////////////
		fsm.draw();
	},
	
	/// Core ///////////////////////
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
        /// @return NA
        ///
    },
    goto_previous:	   function(_data) {
        /// @func   goto_previous()
		/// @param	{struct} data
        /// @return NA
        ///
    },
    restart:		   function(_data) {
        /// @func   restart(data)
		/// @param	{struct} data
        /// @return NA
        ///
		goto(room, _data);
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
	
	/// Transitions ////////////////
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
	
	/// Events /////////////////////
	get_event_publisher:	 function() {
		/// @func	get_event_publisher()
		/// @return {Publisher} publisher
		///
		return publisher;
	},
	event_register:			 function() {
		/// @func	event_register(event_name_1, ..., event_name_n)
		/// @param	{string} event_name
		/// @return	{Ui} self
		///
		for (var _i = 0; _i < argument_count; _i++) {
			get_event_publisher().register_channel(argument[_i]);
		}
		return self;
	},
	event_registered:		 function(_event_name) {
		/// @func	event_registered(event_name)
		/// @param	{string}  event_name
		/// @return {boolean} event_is_registered?
		///
		return get_event_publisher().has_registered_channel(_event_name);
	},
	event_publish:			 function(_event_name, _data = undefined) {
		/// @func	 event_publish(event_name, data*)
		/// @param	{string} event_name
		/// @param	{any}    data=undefined
		/// @return {Ui}	 self
		///
		get_event_publisher().publish(_event_name, _data);
		return self;
	},
	event_subscribe:		 function(_event_name, _callback, _weak_reference = false) {
		/// @func	event_subscribe(event_name, callback, weak_reference?)
		/// @param	{string}  event_name
		/// @param	{method}  callback_method
		/// @param	{boolean} weak_reference?=false
		/// @return {Ui}	  self
		///
		get_event_publisher().subscribe(_event_name, _callback, _weak_reference);
		return self;
	},
	event_unsubscribe:		 function(_event_name, _force = false) {
		/// @func	event_unsubscribe(event_name, force?*)
		/// @param	{string}  event_name
		/// @parma	{boolean} force?=false
		/// @return {Ui} self
		///
		get_event_publisher().unsubscribe(_event_name, _force);
		return self;
	},
	event_clear_subscribers: function(_event_name) {
		/// @func	event_clear_subscribers(event_name)
		/// @param	{string} event_name
		/// @return {Ui} self
		///
		get_event_publisher().clear_channel(_event_name);
		return self;
	},
};
#macro TRANSITION global._transition































