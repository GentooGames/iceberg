#macro __FLOE_DEFAULT_EFFECT_IN  FloeEffectBorderCenter
#macro __FLOE_DEFAULT_EFFECT_OUT __FLOE_DEFAULT_EFFECT_IN

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
		/// Instantiate Effect_In()
		effect_in = new _effect_in();
		effect_in.set_on_change(function() {
			effect_in.cleanup();
			effect = effect_out;
			effect.reverse();
			effect.enter();
			__run_on_change();
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
			on_start.callback(on_start.data);	
		}
	},
	__run_on_change:	function() {
		/// @func	__run_on_change()
		/// @return	NA
		///
		if (on_change.callback != undefined) {
			on_change.callback(on_change.data);	
		}
	},
	__run_on_end:		function() {
		/// @func	__run_on_end()
		/// @return	NA
		///
		if (on_end.callback != undefined) {
			on_end.callback(on_end.data);	
		}
	},
	
	#endregion
	#region Public /////////
	
    goto:				function(_room, _effect_in = __FLOE_DEFAULT_EFFECT_IN, _effect_out = __FLOE_DEFAULT_EFFECT_OUT, _callback, _data) {
        /// @func   goto(room, effect_in*, effect_out*, callback*, data*)
        /// @param  {room}		 room
		/// @param	{FloeEffect} effect_in
		/// @param	{FloeEffect} effect_out
		/// @param	{method}	 callback=undefined
		/// @param	{any}		 data=undefined
		/// @desc	...
        /// @return NA
        //
		if (__is_transitioning()) exit;
		
		__set_on_change(function(_room) {
			PUBLISH("transition_room_changed", { room: _room });	
			room_goto(_room);
		}, _room);
		__set_on_end(_callback, _data);
		__begin_transition(_effect_in, _effect_out);
    },
    goto_next:			function(_effect_in = __FLOE_DEFAULT_EFFECT_IN, _effect_out = __FLOE_DEFAULT_EFFECT_OUT, _callback, _data) {
        /// @func   goto_next(effect_in*, effect_out*, callback*, data*)
		/// @param	{FloeEffect} effect_in
		/// @param	{FloeEffect} effect_out
		/// @param	{method}	 callback=undefined
		/// @param	{any}		 data=undefined
		/// @desc	...
        /// @return NA
        ///
        goto(get_room_next(), _effect_in, _effect_out, _callback, _data);
    },
    goto_previous:		function(_effect_in = __FLOE_DEFAULT_EFFECT_IN, _effect_out = __FLOE_DEFAULT_EFFECT_OUT, _callback, _data) {
        /// @func   goto_previous(effect_in*, effect_out*, callback*, data*)
		/// @param	{FloeEffect} effect_in
		/// @param	{FloeEffect} effect_out
		/// @param	{method}	 callback=undefined
		/// @param	{any}		 data=undefined
		/// @desc	...
        /// @return NA
        ///
        goto(get_room_previous(), _effect_in, _effect_out, _callback, _data);
    },
    restart:			function(_effect_in = __FLOE_DEFAULT_EFFECT_IN, _effect_out = __FLOE_DEFAULT_EFFECT_OUT, _callback, _data) {
        /// @func   restart(effect_in*, effect_out*, callback*, data*)
		/// @param	{FloeEffect} effect_in
		/// @param	{FloeEffect} effect_out
		/// @param	{method}	 callback=undefined
		/// @param	{any}		 data=undefined
		/// @desc	...
        /// @return NA
        ///
		if (__is_transitioning()) exit;
		
		__set_on_change(function() {
			PUBLISH("transition_room_restarted");
			room_restart();
		});
		__set_on_end(_callback, _data);
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
		
	#endregion
};
#macro TRANSITION global._transition