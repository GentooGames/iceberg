#macro __TRANSITION_LOG					LOGGING
#macro __TRANSITION_DEFAULT_EFFECT_IN	__FLOE_DEFAULT_EFFECT_IN
#macro __TRANSITION_DEFAULT_EFFECT_OUT	__FLOE_DEFAULT_EFFECT_OUT
#macro __TRANSITION_DEFAULT_WAIT		false	// if true, then TRANSITION.complete() must be manually invoked

global._transition = { 
    initialized: false,
		
	#region Internal ///////
	
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) return;
		#region ----------------
		
        log("<FLOE> setup()");
		initialized = true;
		
		#endregion
		#region FloeEffects/////
		
		effect_in  = undefined;
		effect_out = undefined;
		effect	   = undefined;
		
		#endregion
		#region Callbacks //////
		
		on_start  = {
			callback: undefined,
			data:	  undefined,
		};
		on_change = {
			callback: undefined,
			data:	  undefined,
		};
		on_end    = {
			callback: undefined,
			data:	  undefined,
		};
			
		#endregion
		#region Other //////////
		
		is_waiting = false;
		
		#endregion
    },
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		
		if (effect != undefined) {
			effect.update();
		}
	},
	render: function() {
		/// @func   render()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		
		if (effect != undefined) {
			effect.render();	
		}
	},
	
	#endregion
	#region Private ////////
	
	__begin_transition: function(_effect_in, _effect_out) {
		/// @func	__begin_transition(effect_in, effect_out) 
		/// @param	{FloeEffect} effect_in
		/// @param	{FloeEffect} effect_out
		///
		if (__TRANSITION_LOG) {
			show_debug_message("TRANSITION.begin_transition()");	
		}
		/// Instantiate Effect_In()
		effect_in = new _effect_in();
		effect_in.set_on_leave(function() {
			effect_in.cleanup();
			effect = effect_out;
			effect.reverse();
			__run_on_change();
			
			if (!is_waiting) {
				__end_transition();	
			}
		});
		
		/// Instantiate Effect_Out()
		effect_out = new _effect_out();
		effect_out.set_on_end(function() {
			effect_out.cleanup();
			effect = undefined;
			__run_on_end();
		});
		
		/// Set Effect Pointer & Begin Transition
		effect = effect_in;
		effect.enter();
		__run_on_start();
	},
	__end_transition:	function() {
		/// @func	__end_transition()
		/// @desc	sometimes we may want transitions to wait for a certain condition to be met, before completing
		///			the transition. this method is abstracted so that we can bind it to a conditional check.
		///
		if (__TRANSITION_LOG) {
			show_debug_message("TRANSITION.end_transition()");	
		}
		effect_out.enter();
	},
	__is_transitioning:	function() {
		/// @func	__is_transitioning()
		/// @return {bool} is_transitioning
		/// 
		return effect != undefined;
	},
	__set_on_start:		function(_callback, _data) {
		/// @func	__set_on_start(callback, data*)
		/// @param	{method} callback
		/// @param	{any}	 data=undefined
		/// @return NA
		///
		with (on_start) {
			callback = _callback;	
			data	 = _data;	
		}
	},
	__set_on_change:	function(_callback, _data) {
		/// @func	__set_on_change(callback, data*)
		/// @param	{method} callback
		/// @param	{any}	 data=undefined
		/// @return NA
		///
		with (on_change) {
			callback = _callback;	
			data	 = _data;	
		}
	},
	__set_on_end:		function(_callback, _data) {
		/// @func	__set_on_end(callback, data*)
		/// @param	{method} callback
		/// @param	{any}	 data=undefined
		/// @return NA
		///
		with (on_end) {
			callback = _callback;	
			data	 = _data;	
		}
	},
	__run_on_start:		function() {
		/// @func	__run_on_start()
		/// @return	NA
		///
		if (on_start.callback != undefined) {
			if (__TRANSITION_LOG) {
				show_debug_message("executing TRANSITION.on_start()");	
			}
			on_start.callback(on_start.data);
		}
	},
	__run_on_change:	function() {
		/// @func	__run_on_change()
		/// @return	NA
		///
		if (on_change.callback != undefined) {
			if (__TRANSITION_LOG) {
				show_debug_message("executing TRANSITION.on_change()");	
			}
			on_change.callback(on_change.data);	
		}
	},
	__run_on_end:		function() {
		/// @func	__run_on_end()
		/// @return	NA
		///
		if (on_end.callback != undefined) {
			if (__TRANSITION_LOG) {
				show_debug_message("executing TRANSITION.on_end()");	
			}
			on_end.callback(on_end.data);	
		}
	},
	
	#endregion
	#region Public /////////
	
	goto:				function(_data) {
		/// @func   goto({room, effect_in*, effect_out*, on_start*, on_change*, on_end*, wait?*})
        /// @param  {room}		 data.room
        /// @param  {FloeEffect} data.effect_in=__TRANSITION_DEFAULT_EFFECT_IN
        /// @param  {FloeEffect} data.effect_out=__TRANSITION_DEFAULT_EFFECT_OUT
        /// @param  {callback}	 data.on_start=undefined
        /// @param  {callback}	 data.on_change=undefined
        /// @param  {callback}	 data.on_end=undefined
		/// @param	{boolean}	 data.wait=__TRANSITION_DEFAULT_WAIT
		/// @desc	...
        /// @return NA
        ///
		if (__is_transitioning()) exit;
		
		if (__TRANSITION_LOG) {
			show_debug_message("TRANSITION.goto()");	
		}
		
		var _room		= _data[$ "room"	  ] 
		var _effect_in	= _data[$ "effect_in" ] ?? __TRANSITION_DEFAULT_EFFECT_IN;
		var _effect_out	= _data[$ "effect_out"] ?? __TRANSITION_DEFAULT_EFFECT_OUT;
		var _on_start	= _data[$ "on_start"  ] ?? undefined;
		var _on_change	= _data[$ "on_change" ] ?? undefined;
		var _on_end		= _data[$ "on_end"	  ] ?? undefined;
		var _wait		= _data[$ "wait"	  ]	?? __TRANSITION_DEFAULT_WAIT;
		
		/// Wire on_start Callback
		if (_on_start != undefined) {
			__set_on_start(_on_start.callback, _on_start.data);
		}
		
		/// Wire on_change Callback
		__set_on_change(
			function(_data) {
				/// Do Room Transition on_change
				var _room = _data.room;
				PUBLISH("transition_room_changed", { room: _room });	
				room_goto(_room);
				
				/// Handle Custom on_change Callback
				var _on_change  = _data.on_change;
				if (_on_change != undefined) {
					_on_change.callback(_on_change.data);
				}
			}, 
			{ room:	_room, on_change: _on_change }
		);
		
		/// Wire on_end Callback
		if (_on_end != undefined) {
			__set_on_end(_on_end.callback, _on_end.data);
		}
			
		is_waiting = _wait;
		__begin_transition(_effect_in, _effect_out);
	},
    goto_next:			function(_data = {}) {
        /// @func   goto_next({effect_in*, effect_out*, on_start*, on_change*, on_end*, wait?*})
		/// @param  {FloeEffect} data.effect_in=__FLOE_DEFAULT_EFFECT_IN
        /// @param  {FloeEffect} data.effect_out=__FLOE_DEFAULT_EFFECT_OUT
        /// @param  {callback}	 data.on_start=undefined
        /// @param  {callback}	 data.on_change=undefined
        /// @param  {callback}	 data.on_end=undefined
		/// @param	{boolean}	 data.wait=__TRANSITION_DEFAULT_WAIT
		/// @desc	...
        /// @return NA
        ///
		if (__TRANSITION_LOG) {
			show_debug_message("TRANSITION.goto_next()");	
		}
		_data[$ "room"] = get_room_next();
		goto(_data);
    },
    goto_previous:		function(_data = {}) {
        /// @func   goto_previous({effect_in*, effect_out*, on_start*, on_change*, on_end*, wait?*})
		/// @param  {FloeEffect} data.effect_in=__FLOE_DEFAULT_EFFECT_IN
        /// @param  {FloeEffect} data.effect_out=__FLOE_DEFAULT_EFFECT_OUT
        /// @param  {callback}	 data.on_start=undefined
        /// @param  {callback}	 data.on_change=undefined
        /// @param  {callback}	 data.on_end=undefined
		/// @param	{boolean}	 data.wait=__TRANSITION_DEFAULT_WAIT
		/// @desc	...
        /// @return NA
        ///
		if (__TRANSITION_LOG) {
			show_debug_message("TRANSITION.goto_previous()");	
		}
        _data[$ "room"] = get_room_previous();
		goto(_data);
    },
    restart:			function(_data) {
        /// @func   restart({effect_in*, effect_out*, on_start*, on_change*, on_end*, wait?*})
		/// @param	{FloeEffect} effect_in=__TRANSITION_DEFAULT_EFFECT_IN
		/// @param	{FloeEffect} effect_out=__TRANSITION_DEFAULT_EFFECT_OUT
		/// @param  {callback}	 data.on_start=undefined
        /// @param  {callback}	 data.on_change=undefined
        /// @param  {callback}	 data.on_end=undefined
		/// @param	{boolean}	 data.wait=__TRANSITION_DEFAULT_WAIT
		/// @desc	...
        /// @return NA
        ///
		if (__is_transitioning()) exit;
		
		if (__TRANSITION_LOG) {
			show_debug_message("TRANSITION.restart()");	
		}
		
		var _effect_in	= _data[$ "effect_in" ] ?? __TRANSITION_DEFAULT_EFFECT_IN;
		var _effect_out	= _data[$ "effect_out"] ?? __TRANSITION_DEFAULT_EFFECT_OUT;
		var _on_start	= _data[$ "on_start"  ] ?? undefined;
		var _on_change	= _data[$ "on_change" ] ?? undefined;
		var _on_end		= _data[$ "on_end"	  ] ?? undefined;
		var _wait		= _data[$ "wait"	  ]	?? __TRANSITION_DEFAULT_WAIT;
		
		/// Wire on_start Callback
		if (_on_start != undefined) {
			__set_on_start(_on_start.callback, _on_start.data);
		}
		
		/// Wire on_change Callback
		__set_on_change(
			function(_data) {
				/// Do Room Restart on_change
				PUBLISH("transition_room_restarted");	
				room_restart();
			
				/// Handle Custom on_change Callback
				var _on_change  = _data.on_change;
				if (_on_change != undefined) {
					_on_change.callback(_on_change.data);
				}
			}, 
			{ on_change: _on_change }
		);
		
		/// Wire on_end Callback
		if (_on_end != undefined) {
			__set_on_end(_on_end.callback, _on_end.data);
		}
			
		is_waiting = _wait;
		__begin_transition(_effect_in, _effect_out);
    },
    get_room_next:		function(_room = room) {
        /// @func   get_room_next(room*<room>)
        /// @param  room_id -> {real}
		/// @desc	...
        /// @return room_id -> {real}
        ///
        var _next_room = _room + 1;
        if (room_exists(_next_room)) {
            return _next_room;
        }
        throw("<ERROR in FLOE.get_room_next()>:room with index " + string(_next_room) + " does not exist.");
    },
    get_room_previous:	function(_room = room) {
        /// @func   get_room_previous(room*<room>)
        /// @param  room_id -> {real}
		/// @desc	...
        /// @return room_id -> {real}
        ///
        var _previous_room = _room - 1;
        if (room_exists(_previous_room)) {
            return _previous_room;
        }
        throw("<ERROR in FLOE.get_room_previous()>:room with index " + string(_previous_room) + " does not exist.");
    },
	complete:			function() {
		/// @func	complete()
		/// @return NA
		///
		__end_transition();	
	},
		
	#endregion
};
#macro TRANSITION global._transition