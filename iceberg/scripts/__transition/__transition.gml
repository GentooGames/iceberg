/*
	- define custom sprites to draw for transitions
*/
enum TRANSITION_STATE {
	HIDDEN,
	START,
	IN,
	CHANGE,
	HOLD,
	OUT,
	END,
};
enum TRANSITION_TYPE  {
	FADE,	
	LINEAR_WIPE_RIGHT,
	LINEAR_WIPE_LEFT,		
	CIRCLE_SHRINK_CENTER,
	CIRCLE_SHRINK_TARGET,	//
	BORDER_SHRINK_CENTER,	
	BORDER_SHRINK_TARGET,	//
	TILES,					//
};

global._transition					= {};
#macro TRANSITION					global._transition
#macro TRANSITION_DEFAULT_TYPE_IN	TRANSITION_TYPE.BORDER_SHRINK_CENTER
#macro TRANSITION_DEFAULT_TYPE_OUT	TRANSITION_DEFAULT_TYPE_IN
#macro TRANSITION_DEFAULT_COLOR		c_black
#macro TRANSITION_DEFAULT_ALPHA		1.0
#macro TRANSITION_DEFAULT_SPEED_IN	0.1
#macro TRANSITION_DEFAULT_SPEED_OUT	0.1

TRANSITION = { 
    initialized: false,
	
	#region Internal 
	
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) return;
		////////////////////////////
        log("<TRANSITION> setup()");
		
		#region Customizable
		
		type_in		= TRANSITION_DEFAULT_TYPE_IN;
		type_out	= TRANSITION_DEFAULT_TYPE_OUT;
		type		= type_in;
		color		= TRANSITION_DEFAULT_COLOR;
		alpha		= TRANSITION_DEFAULT_ALPHA;
		speed_in	= TRANSITION_DEFAULT_SPEED_IN;
		speed_out	= TRANSITION_DEFAULT_SPEED_OUT;
		
		#endregion
		#region Private
		
		__surface	 = surface_create(SW, SH);
		__state		 = TRANSITION_STATE.HIDDEN;
		__progress	 = 0.0;	// from 0 to 1
		__target	 = 1.0;
		__thresholds = [
			0.010,			// FADE
			0.001,			// LINEAR_WIPE_RIGHT
			0.001,			// LINEAR_WIPE_LEFT
			0.005,			// CIRCLE_SHRINK_CENTER
			0.005,			// CIRCLE_SHRINK_TARGET
			0.005,			// BORDER_SHRINK_CENTER
			0.005,			// BORDER_SHRINK_TARGET
		];
		__on_change	 = {	// internal callback used to manage room changes
			callback: undefined,
			data:	  undefined,
		};
		__on_end	 = {	// internal callback passed in from user on each room change invokation, will change frequently
			callback: undefined,
			data:	  undefined,
		};
		__callbacks  = {	// more "static" callbacks set to execute every iteration
			on_start:  {
				callback: undefined,
				data:	  undefined,
			},
			on_change: {
				callback: undefined,
				data:	  undefined,
			},
			on_end:    {
				callback: undefined,
				data:	  undefined,
			},
		};
							// see set_on_start(), set_on_change(), set_on_end(),
		#endregion
		
        initialized = true;
    },
	update:	function() {
		/// @func   update()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		////////////////////////
		switch (__state) {
			case TRANSITION_STATE.START:  {
				__progress = 0;
				__state	   = TRANSITION_STATE.IN;
				break;	
			}
			case TRANSITION_STATE.IN:	  {
				__target   = 1.0;
				__progress = lerp(__progress, __target, speed_in);
				
				if (abs(__progress - __target) <= __thresholds[type]) {
					__progress = __target;
					__state	   = TRANSITION_STATE.CHANGE;
				}
				break;	
			}
			case TRANSITION_STATE.CHANGE: {
				__transition_change();
				break;	
			}
			case TRANSITION_STATE.HOLD:   {
				__state = TRANSITION_STATE.OUT;
				break;	
			}
			case TRANSITION_STATE.OUT:	  {
				__target   = 0.0;
				__progress = lerp(__progress, __target, speed_out);
				
				if (abs(__progress - __target) <= __thresholds[type]) {
					__progress = __target;
					__state	   = TRANSITION_STATE.END;
				}
				break;	
			}
			case TRANSITION_STATE.END:	  {
				__transition_end();
				break;	
			}
		};
	},
	render: function() {
		/// @func   render()
		/// @desc	...
        /// @return NA
        ///
        if (!initialized) exit;
		////////////////////////
		surface_set_target(__surface);
		draw_clear_alpha(c_black, 0.0);
		switch (type) {
			case TRANSITION_TYPE.FADE:					__render_transition_fade();					break;
			case TRANSITION_TYPE.LINEAR_WIPE_RIGHT:		__render_transition_linear_wipe_right();	break;
			case TRANSITION_TYPE.LINEAR_WIPE_LEFT:		__render_transition_linear_wipe_left();		break;
			case TRANSITION_TYPE.CIRCLE_SHRINK_CENTER:	__render_transition_circle_shrink_center();	break;
			case TRANSITION_TYPE.CIRCLE_SHRINK_TARGET:	__render_transition_circle_shrink_target();	break;
			case TRANSITION_TYPE.BORDER_SHRINK_CENTER:	__render_transition_border_shrink_center();	break;
			case TRANSITION_TYPE.BORDER_SHRINK_TARGET:	__render_transition_border_shrink_target();	break;
		};
		surface_reset_target();
		draw_surface(__surface, 0, 0);
	},
	
	#endregion
	#region Private
	
	__transition_start:	 function(_type_in, _type_out = _type_in) {
		/// Handle Consistent on_start Callback
		if (__callbacks.on_start.callback != undefined) {
			__callbacks.on_start.callback(__callbacks.on_start.data);		
		}
		type_in  = _type_in;
		type_out = _type_out;
		type	 =  type_in;
		__state  =  TRANSITION_STATE.START;
	},
	__transition_change: function() {
		
		type = type_out;
		
		/// Handle One-Time on_change Callback
		if (__on_change.callback != undefined) {
			__on_change.callback(__on_change.data);	
		}
		/// Handle Consistent on_end Callback
		if (__callbacks.on_change.callback != undefined) {
			__callbacks.on_change.callback(__callbacks.on_change.data);		
		}
		__state = TRANSITION_STATE.HOLD;
	},
	__transition_end:	 function() {
		/// Handle One-Time on_end Callback
		if (__on_end.callback != undefined) {
			__on_end.callback(__on_end.data);	
		}
		/// Handle Consistent on_end Callback
		if (__callbacks.on_end.callback != undefined) {
			__callbacks.on_end.callback(__callbacks.on_end.data);		
		}
		type_in  = TRANSITION_DEFAULT_TYPE_IN;
		type_out = TRANSITION_DEFAULT_TYPE_OUT;
		type     = type_in;
		__state  = TRANSITION_STATE.HIDDEN;
	},
		
	__render_transition_fade:					function() {
		var _alpha = alpha * __progress;
		draw_rectangle_alt(0, 0, SW, SH, 0, color, _alpha);
	},
	__render_transition_linear_wipe_right:		function() {
		var _x = -SW + (SW * __progress);
		draw_rectangle_alt(_x, 0, SW, SH, 0, color, alpha);
	},
	__render_transition_linear_wipe_left:		function() {
		var _x = SW - (SW * __progress);
		draw_rectangle_alt(_x, 0, SW, SH, 0, color, alpha);
	},
	__render_transition_circle_shrink_center:	function() {
		draw_rectangle_alt(0, 0, SW, SH, 0, color, alpha);
		gpu_set_blendmode(bm_subtract);
		var _base   = SH;
		var _radius = _base - (_base * __progress);
		draw_circle_color(SW * 0.5, SH * 0.5, _radius, c_white, c_white, false);
		gpu_set_blendmode(bm_normal);
	},
	__render_transition_circle_shrink_target:	function() {
	
	},
	__render_transition_border_shrink_center:	function() {
		draw_rectangle_alt(0, 0, SW, SH, 0, color, alpha);
		gpu_set_blendmode(bm_subtract);
		var _width  =  SW - (SW * __progress);
		var _height =  SH - (SH * __progress);
		var _x		= (SW - _width ) * 0.5;
		var _y		= (SH - _height) * 0.5;
		draw_rectangle_alt(_x, _y, _width, _height, 0, c_white, 1.0);
		gpu_set_blendmode(bm_normal);
	},
	__render_transition_border_shrink_target:	function() {
	
	},
	
	#endregion
	#region Public
	
    goto:				function(_room, _type_in = TRANSITION_DEFAULT_TYPE_IN, _type_out = TRANSITION_DEFAULT_TYPE_OUT, _callback, _data) {
        /// @func   goto(room, type_in*, type_out*, callback*, data*)
        /// @param  {room}			  room
		/// @param	{TRANSITION_TYPE} type_in
		/// @param	{TRANSITION_TYPE} type_out
		/// @param	{method}		  callback=undefined
		/// @param	{any}			  data=undefined
		/// @desc	...
        /// @return NA
        //
		if (is_transitioning()) exit;
		
		__on_change.data	 = _room;
		__on_change.callback = function(_room) {
			PUBLISH("transition_room_changed", { room: _room });	
			room_goto(_room);
		};
		__on_end.data		 = _data;
		__on_end.callback	 = _callback;
		__transition_start(_type_in, _type_out);
    },
    goto_next:			function(_type_in = TRANSITION_DEFAULT_TYPE_IN, _type_out = TRANSITION_DEFAULT_TYPE_OUT, _callback, _data) {
        /// @func   goto_next(type_in*, type_out*, callback*, data*)
		/// @param	{TRANSITION_TYPE} type_in
		/// @param	{TRANSITION_TYPE} type_out
		/// @param	{method}		  callback=undefined
		/// @param	{any}			  data=undefined
		/// @desc	...
        /// @return NA
        ///
        goto(get_room_next(), _type_in, _type_out, _callback, _data);
    },
    goto_previous:		function(_type_in = TRANSITION_DEFAULT_TYPE_IN, _type_out = TRANSITION_DEFAULT_TYPE_OUT, _callback, _data) {
        /// @func   goto_previous(type_in*, type_out*, callback*, data*)
		/// @param	{TRANSITION_TYPE} type_in
		/// @param	{TRANSITION_TYPE} type_out
		/// @param	{method}		  callback=undefined
		/// @param	{any}			  data=undefined
		/// @desc	...
        /// @return NA
        ///
        goto(get_room_previous(), _type_in, _type_out, _callback, _data);
    },
    restart:			function(_type_in = TRANSITION_DEFAULT_TYPE_IN, _type_out = TRANSITION_DEFAULT_TYPE_OUT, _callback, _data) {
        /// @func   restart(type_in*, type_out*, callback*, data*)
		/// @param	{TRANSITION_TYPE} type_in
		/// @param	{TRANSITION_TYPE} type_out
		/// @param	{method}		  callback=undefined
		/// @param	{any}			  data=undefined
		/// @desc	...
        /// @return NA
        ///
		if (is_transitioning()) exit;
		
		__on_change.data	 = undefined;
		__on_change.callback = function() {
			PUBLISH("transition_room_restarted");
			room_restart();
		};
		__on_end.data		 = _data;
		__on_end.callback	 = _callback;
		__transition_start(_type_in, _type_out);
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
        throw("<ERROR in TRANSITION.get_room_next()>:room with index " + string(_next_room) + " does not exist.");
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
        throw("<ERROR in TRANSITION.get_room_previous()>:room with index " + string(_previous_room) + " does not exist.");
    },
	is_transitioning:	function() {
		/// @func	is_transitioning()
		/// @return {bool} is_transitioning
		/// 
		return __progress != 0;
	},
	set_on_start:		function(_callback, _data) {
		/// @func	set_on_start(callback, data*)
		/// @param	{method} callback
		/// @param	{any}	 data=undefined
		/// @return NA
		///
		with (__callbacks.on_start) {
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
		with (__callbacks.on_change) {
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
		with (__callbacks.on_end) {
			callback = _callback;	
			data	 = _data;	
		}
	},
		
	#endregion
};
