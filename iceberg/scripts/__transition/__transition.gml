#macro __TRANSITION_LOG						LOGGING
#macro __TRANSITION_DEFAULT_EFFECT_IN		__FLOE_DEFAULT_EFFECT_IN
#macro __TRANSITION_DEFAULT_EFFECT_IN_DATA	__FLOE_DEFAULT_EFFECT_IN_DATA
#macro __TRANSITION_DEFAULT_EFFECT_OUT		__FLOE_DEFAULT_EFFECT_OUT
#macro __TRANSITION_DEFAULT_EFFECT_OUT_DATA	__FLOE_DEFAULT_EFFECT_OUT_DATA
#macro __TRANSITION_DEFAULT_WAIT			false	// if true, then TRANSITION.complete() must be manually invoked

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
		
		{	/// DEBUG
			alpha		= 0.8;
			color_index = 0;
			colors		= variable_struct_get_names(CONFIG.color);
			color		= CONFIG.color.orange;
			
			surface	  = surface_create(SW, SH);
			shader	  = shdr_sine_wave;
			u_time	  = shader_get_uniform(shader, "u_time");
			u_texel	  = shader_get_uniform(shader, "u_texel");
			u_x_props = shader_get_uniform(shader, "u_x_props");
			u_y_props = shader_get_uniform(shader, "u_y_props");
		}
    },
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		#region FloeEffects ////
		
		if (effect != undefined) {
			effect.update();
		}
		
		#endregion
		
		{ /// DEBUG
			if (INPUT.keyboard.button(vk_lcontrol)) {
				if (INPUT.mouse.wheel_down()) {
					if (color_index > 0) {
						color_index--;	
					}
					else color_index = array_length(colors) - 1;
			
					color = CONFIG.color[$ colors[color_index]];
				}
				if (INPUT.mouse.wheel_up()) {
					if (color_index < array_length(colors) - 1) {
						color_index++;	
					}
					else color_index = 0;
			
					color = CONFIG.color[$ colors[color_index]];
				}
			}
			else {
				if (INPUT.mouse.wheel_down()) {
					alpha -= 0.05;
				}
				if (INPUT.mouse.wheel_up()) {
					alpha += 0.05;
				}
			}
		}
	},
	render: function() {
		/// @func   render()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		
		{	/// DEBUG
			var _sprite = __spr_transition_border_silhouette_trees;
			var _offset = 60;
			var _x		= -_offset;
			var _y		= -_offset;
			var _width	= SW + (_offset * 2);
			var _height = SH + (_offset * 2) + 5;
		
			/// Leaves Shadow
			shader_set(shdr_alpha_dither);
			var _offset = 15;
			draw_sprite_stretched_ext(_sprite, 0, _x + _offset, _y + _offset, _width - (_offset * 2), _height - (_offset * 2), c_white, alpha);
			shader_reset();
		
			if (!surface_exists(surface)) {
				surface = surface_create(SW, SH);
			}
			surface_set_target(surface);
			draw_clear_alpha(c_black, 0.0);
		
			/// Leaves
			draw_sprite_stretched_ext(_sprite, 1, _x, _y, _width, _height, color, 1);
			
			surface_reset_target();
			
			shader_set(shader);
			shader_set_uniform_f(u_time, current_time);
			var _texel_min    = 0.003;
			var _texel_max    = 0.03;
			var _texel_ratio  = 1;
			var _texel_width  = (_texel_max - _texel_min) * _texel_ratio;
			var _texel_height = (_texel_max - _texel_min) * _texel_ratio;
			shader_set_uniform_f(u_texel, _texel_width, _texel_height);
			shader_set_uniform_f_array(u_x_props, [0.005, 20.0, 0.05]);
			shader_set_uniform_f_array(u_y_props, [0.005, 20.0, 0.05]);
			
			draw_surface(surface, 0, 0);
			
			shader_reset();
		}
		
		#region FloeEffects ////
		
		if (effect != undefined) {
			effect.render();	
		}
		
		#endregion
	},
	
	#endregion
	#region Private ////////
	
	__begin_transition: function(_effect_in, _effect_in_data, _effect_out, _effect_out_data) {
		/// @func	__begin_transition(effect_in, effect_in_data, effect_out, effect_out_data) 
		/// @param	{FloeEffect} effect_in
		/// @param	{struct}	 effect_in_data
		/// @param	{FloeEffect} effect_out
		/// @param	{struct}	 effect_out_data
		///
		if (__TRANSITION_LOG) {
			show_debug_message("TRANSITION.begin_transition()");	
		}
		
		/// Instantiate Effect_In()
		effect_in = new _effect_in(_effect_in_data);
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
		effect_out = new _effect_out(_effect_out_data);
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
		
		var _room				= _data[$ "room"			] 
		var _effect_in			= _data[$ "effect_in"		] ?? __TRANSITION_DEFAULT_EFFECT_IN;
		var _effect_in_data		= _data[$ "effect_in_data"	] ?? __TRANSITION_DEFAULT_EFFECT_IN_DATA;
		var _effect_out			= _data[$ "effect_out"		] ?? __TRANSITION_DEFAULT_EFFECT_OUT;
		var _effect_out_data	= _data[$ "effect_out_data"	] ?? __TRANSITION_DEFAULT_EFFECT_OUT_DATA;
		var _on_start			= _data[$ "on_start"		] ?? undefined;
		var _on_change			= _data[$ "on_change"		] ?? undefined;
		var _on_end				= _data[$ "on_end"			] ?? undefined;
		var _wait				= _data[$ "wait"			] ?? __TRANSITION_DEFAULT_WAIT;
		
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
		__begin_transition(_effect_in, _effect_in_data, _effect_out, _effect_out_data);
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
		
		var _effect_in			= _data[$ "effect_in"		] ?? __TRANSITION_DEFAULT_EFFECT_IN;
		var _effect_in_data		= _data[$ "effect_in_data"	] ?? __TRANSITION_DEFAULT_EFFECT_IN_DATA;
		var _effect_out			= _data[$ "effect_out"		] ?? __TRANSITION_DEFAULT_EFFECT_OUT;
		var _effect_out_data	= _data[$ "effect_out_data"	] ?? __TRANSITION_DEFAULT_EFFECT_OUT_DATA;
		var _on_start			= _data[$ "on_start"		] ?? undefined;
		var _on_change			= _data[$ "on_change"		] ?? undefined;
		var _on_end				= _data[$ "on_end"			] ?? undefined;
		var _wait				= _data[$ "wait"			] ?? __TRANSITION_DEFAULT_WAIT;
		
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
		__begin_transition(_effect_in, _effect_in_data, _effect_out, _effect_out_data);
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