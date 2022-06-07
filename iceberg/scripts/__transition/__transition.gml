/////////////////////////////
// r---. .     .---. r---. //
// r--   |     |   | r--   //
// L     L---- L---J L---J //
#region //////////////$(*)>//

#region about
/*
	written_by:__gentoo______
	version:_____0.1.0_______
*/ 
#endregion
#region change log

#region version 0.1.0
/*	
	Date: 06/06/2022
	1. Released first version.
*/
#endregion

#endregion
#region docs & help

/// ...

#endregion
#region upcoming features
/*
	- define custom sprites to draw for transitions
	- optimize performance through not drawing the surface every frame
	- transition hold time
	- make sure to garbage collect surfaces on FloeEffects()
	- transitions to do
		- "old school tv shutdown"
		- cross-fade
		- pixelation
*/
#endregion
#region enums

enum FLOE_STATE {
	HIDDEN,
	ENTER,
	CHANGE,
	HOLD,
	LEAVE,
	END,
};

#endregion
#region default config values

#macro __FLOE_DEFAULT_EFFECT_IN  FloeEffectFade
#macro __FLOE_DEFAULT_EFFECT_OUT __FLOE_DEFAULT_EFFECT_IN

#endregion

#endregion

global._floe = { 
    initialized: false,
		
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
		
	__begin_transition: function(_effect_in, _effect_out) {
		/// @func	__begin_transition(effect_in, effect_out) 
		/// @param	{FloeEffect} effect_in
		/// @param	{FloeEffect} effect_out
		///
		effect_in = new _effect_in();
		effect_in.on_change.callback = function() {
			effect_in.cleanup();
			effect = effect_out;
			effect.reverse();
			effect.enter();
				
			if (on_change.callback != undefined) {
				on_change.callback(on_change.data);	
			}
		};
		
		effect_out = new _effect_out();
		effect_out.on_end.callback = function() {
			effect_out.cleanup();
			effect = undefined;
				
			if (on_end.callback != undefined) {
				on_end.callback(on_end.data);	
			}
		};
		
		effect = effect_in;
		effect.enter();
	},
		
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
		if (is_transitioning()) exit;
		
		on_change.data	   = _room;
		on_change.callback = function(_room) {
			PUBLISH("transition_room_changed", { room: _room });	
			room_goto(_room);
		};
		on_end.data		 = _data;
		on_end.callback	 = _callback;
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
		if (is_transitioning()) exit;
		
		on_change.data	   = undefined;
		on_change.callback = function() {
			PUBLISH("transition_room_restarted");
			room_restart();
		};
		on_end.data		 = _data;
		on_end.callback	 = _callback;
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
	is_transitioning:	function() {
		/// @func	is_transitioning()
		/// @return {bool} is_transitioning
		/// 
		return effect != undefined;
	},
	set_on_start:		function(_callback, _data) {
		/// @func	set_on_start(callback, data*)
		/// @param	{method} callback
		/// @param	{any}	 data=undefined
		/// @return NA
		///
		with (on_start) {
			callback = _callback;	
			data	 = _data;	
		}
	},
	set_on_change:		function(_callback, _data) {
		/// @func	set_on_change(callback, data*)
		/// @param	{method} callback
		/// @param	{any}	 data=undefined
		/// @return NA
		///
		with (on_change) {
			callback = _callback;	
			data	 = _data;	
		}
	},
	set_on_end:			function(_callback, _data) {
		/// @func	set_on_end(callback, data*)
		/// @param	{method} callback
		/// @param	{any}	 data=undefined
		/// @return NA
		///
		with (on_end) {
			callback = _callback;	
			data	 = _data;	
		}
	},
};
#macro TRANSITION global._floe

#region Floe Effects 

#region Parent Constructors

function FloeEffect() constructor {
	/// @func FloeEffect()
	///
	color		= c_black;
	alpha		= 1.0;
	speed_in	= 0.1;
	speed_out	= 0.1;
	on_enter	= {
		callback: undefined,
		data:	  undefined,
	};
	on_change	= {
		callback: undefined,
		data:	  undefined,
	};
	on_leave	= {
		callback: undefined,
		data:	  undefined,
	};
	on_end		= {
		callback: undefined,
		data:	  undefined,
	};
	
	__surface	= undefined;
	__state		= FLOE_STATE.HIDDEN;
	__progress	= 0.0;
	__target	= 1.0;
	__threshold = 1.0;
	__reverse	= false;
		
	static update  = function() {
		/// @func update()
		///
		switch (__state) {
			case FLOE_STATE.ENTER:	{
				__progress = lerp(__progress, __target, speed_in);
				
				if (abs(__progress - __target) <= __threshold) {
					__progress = __target;
					__state	   = FLOE_STATE.CHANGE;
				}
				break;	
			}
			case FLOE_STATE.CHANGE:	{
				if (on_change.callback != undefined) {
					on_change.callback(on_change.data);	
				}
				__state = FLOE_STATE.HOLD;
				break;	
			}
			case FLOE_STATE.HOLD:	{
				__state = FLOE_STATE.LEAVE;
				break;	
			}
			case FLOE_STATE.LEAVE:	{
				__progress = lerp(__progress, __target, speed_out);
				
				if (abs(__progress - __target) <= __threshold) {
					__progress = __target;
					__state	   = FLOE_STATE.END;
				}
				break;	
			}
			case FLOE_STATE.END:	{
				if (on_end.callback != undefined) {
					on_end.callback(on_end.data);	
				}
				__state = FLOE_STATE.HIDDEN;
				break;	
			}
		};
	};
	static cleanup = function() {
		/// @func cleanup()
		///
		if (__surface != undefined) {
			if (surface_exists(__surface)) {
				surface_free(__surface);
			}
			__surface = undefined;
		}
	};
	static enter   = function() {
		/// @func enter()
		///
		if (on_enter.callback != undefined) {
			on_enter.callback(on_enter.data);		
		}
		__state	 = FLOE_STATE.ENTER;
		__target = __reverse ? 0 : 1;
	};
	static leave   = function() {
		/// @func leave()
		///
		if (on_leave.callback != undefined) {
			on_leave.callback(on_leave.data);		
		}
		__state	 = FLOE_STATE.LEAVE;
		__target = __reverse ? 1 : 0;
	};
	static reverse = function(_reverse_progress = true) {
		/// @func	reverse(reverse_progress?*)
		/// @param	{bool} reverse_progress=true
		///
		__reverse  = !__reverse;
		__target   = 1 - __target;
		
		if (_reverse_progress) {
			__progress = 1 - __progress;
		}
	};
	
	static get_progress = function() {
		/// @func	get_progress()
		/// @return {real} progress : 0 -> 1
		///
		return __progress;
	};
	static did_change	= function() {
		/// @func	 did_change()
		/// @return  {bool}
		///
		return __state == FLOE_STATE.CHANGE;
	};
	static did_end		= function() {
		/// @func	 did_end()
		/// @return  {bool}
		///
		return __state == FLOE_STATE.END;
	};
};
function FloeEffectSurface() : FloeEffect() constructor {
	/// @func FloeEffectSurface()
	///
	__surface = surface_create(SW, SH);
	
	static render_begin = function() {
		/// @func render_begin()
		///
		if (!surface_exists(__surface)) {
			__surface = surface_create(SW, SH);
		}
		surface_set_target(__surface); 
		draw_clear_alpha(c_black, 0.0);
	};
	static render_end   = function() {
		/// @func render_end()
		///
		surface_reset_target();	
	};
};

#endregion

function FloeEffectFade() : FloeEffect() constructor {
	/// @func FloeEffectFade()
	///
	static render = function() {
		/// @func render()
		///
		var _alpha = alpha * get_progress();
		draw_rectangle_alt(0, 0, SW, SH, 0, color, _alpha);
	};	
};
function FloeEffectWipeLeft() : FloeEffect() constructor {
	/// @func FloeEffectWipeLeft()
	///
	static render = function() {
		/// @func render()
		///
		var _x = SW - (SW * get_progress());
		draw_rectangle_alt(_x, 0, SW, SH, 0, color, alpha);
	};	
};
function FloeEffectWipeRight() : FloeEffect() constructor {
	/// @func FloeEffectWipeRight()
	///
	static render = function() {
		/// @func render()
		///
		var _x = -SW + (SW * get_progress());
		draw_rectangle_alt(_x, 0, SW, SH, 0, color, alpha);
	};	
};
function FloeEffectCircleCenter() : FloeEffectSurface() constructor {
	/// @func FloeEffectCircleCenter()
	///
	static render = function() {
		/// @func render()
		///
		render_begin();
		draw_rectangle_alt(0, 0, SW, SH, 0, color, alpha);
		gpu_set_blendmode(bm_subtract);
		
		var _base   = SH;
		var _radius = _base - (_base * get_progress());
		draw_circle_color(SW * 0.5, SH * 0.5, _radius, c_white, c_white, false);
		
		gpu_set_blendmode(bm_normal);
		render_end();
	};	
};
function FloeEffectCircleTarget() : FloeEffectSurface() constructor {
	/// @func FloeEffectCircleTarget()
	///
	static render = function() {
		/// @func render()
		///
		render_begin();
		
		/// ...
		
		render_end();
	};	
};
function FloeEffectBorderCenter() : FloeEffectSurface() constructor {
	/// @func FloeEffectBorderCenter()
	///
	static render = function() {
		/// @func render()
		///
		render_begin();
		draw_rectangle_alt(0, 0, SW, SH, 0, color, alpha);
		gpu_set_blendmode(bm_subtract);
		
		var _width  =  SW - (SW * get_progress());
		var _height =  SH - (SH * get_progress());
		var _x		= (SW - _width ) * 0.5;
		var _y		= (SH - _height) * 0.5;
		draw_rectangle_alt(_x, _y, _width, _height, 0, c_white, 1.0);
		
		gpu_set_blendmode(bm_normal);
		render_end();
	};	
};
function FloeEffectBorderTarget() : FloeEffectSurface() constructor {
	/// @func FloeEffectBorderTarget()
	///
	static render = function() {
		/// @func render()
		///
		render_begin();
		
		/// ...
		
		render_end();
	};	
};

#endregion
