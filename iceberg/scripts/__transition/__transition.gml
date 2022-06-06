global._transition = {};
#macro TRANSITION	global._transition
/*
	- restrict transitions to only be allowed if a transition is not already in progress
	- add ability to define which transition is executed on each method invokation
	- transition modes
		- tiles
		- circle growth
		- edges lerp to center
		- pixelated (screenshot of surface, save, pixelate, etc)
*/

enum TRANSITION_STATE {
	HIDDEN,
	START,
	IN,
	HOLD,
	OUT,
	END,
};
enum TRANSITION_TYPE  {
	FADE,	
};

#macro TRANSITION_DEFAULT_TYPE		TRANSITION_TYPE.FADE
#macro TRANSITION_DEFAULT_COLOR		c_black
#macro TRANSITION_DEFAULT_ALPHA		1.0
#macro TRANSITION_DEFAULT_SPEED_IN	0.1
#macro TRANSITION_DEFAULT_SPEED_OUT	0.1

TRANSITION = { 
    initialized: false,
	
	/// Internal
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) return;
		////////////////////////////
        log("<TRANSITION> setup()");
		
		#region Customizable
		
		type		= TRANSITION_DEFAULT_TYPE;
		color		= TRANSITION_DEFAULT_COLOR;
		alpha		= TRANSITION_DEFAULT_ALPHA;
		speed_in	= TRANSITION_DEFAULT_SPEED_IN;
		speed_out	= TRANSITION_DEFAULT_SPEED_OUT;
		threshold	= 0.01;
		
		#endregion
		#region Private
		
		__state		= TRANSITION_STATE.HIDDEN;
		__progress	= 0.0;	// from 0 to 1
		__target	= 1.0;
		__on_hold	= {
			callback: undefined,
			data:	  undefined,
		};
		__on_end	= {
			callback: undefined,
			data:	  undefined,
		};
		
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
			case TRANSITION_STATE.START: {
				__progress = 0;
				__state	   = TRANSITION_STATE.IN;
				break;	
			}
			case TRANSITION_STATE.IN: {
				__target   = 1.0;
				__progress = lerp(__progress, __target, speed_in);
				
				if (abs(__progress - __target) <= threshold) {
					__progress = __target;
					__state	   = TRANSITION_STATE.HOLD;
				}
				break;	
			}
			case TRANSITION_STATE.HOLD: {
				if (__on_hold.callback != undefined) {
					__on_hold.callback(__on_hold.data);	
				}
				__state = TRANSITION_STATE.OUT;
				break;	
			}
			case TRANSITION_STATE.OUT: {
				__target   = 0.0;
				__progress = lerp(__progress, __target, speed_out);
				
				if (abs(__progress - __target) <= threshold) {
					__progress = __target;
					__state	   = TRANSITION_STATE.END;
				}
				break;	
			}
			case TRANSITION_STATE.END: {
				if (__on_end.callback != undefined) {
					__on_end.callback(__on_end.data);	
				}
				__state = TRANSITION_STATE.HIDDEN;
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
		switch (type) {
			case TRANSITION_TYPE.FADE: {
				var _alpha = alpha * __progress;
				draw_rectangle_alt(0, 0, SW, SH, 0, color, _alpha);
				break;	
			}
		};
	},
	
	/// Private
	__transition_start: function(_type) {
		/// @func	__transition_start(type)
		/// @param	{TRANSITION_TYPE} type
		/// @return NA
		///
		type    = _type;
		__state = TRANSITION_STATE.START;
	},
	
	/// Public
    goto:				function(_room, _type = TRANSITION_DEFAULT_TYPE) {
        /// @func   goto(room, type*)
        /// @param  {room}			  room
		/// @param	{TRANSITION_TYPE} type
		/// @desc	...
        /// @return NA
        //
		__on_hold.data	   = _room;
		__on_hold.callback = function(_room) {
			PUBLISH("transition_room_changed", { room: _room });	
			room_goto(_room);
		};
		__transition_start(_type);
    },
    goto_next:			function(_type = TRANSITION_DEFAULT_TYPE) {
        /// @func   goto_next()
		/// @param	{TRANSITION_TYPE} type
		/// @desc	...
        /// @return NA
        ///
        goto(get_room_next(), _type);
    },
    goto_previous:		function(_type = TRANSITION_DEFAULT_TYPE) {
        /// @func   goto_previous()
		/// @param	{TRANSITION_TYPE} type
		/// @desc	...
        /// @return NA
        ///
        goto(get_room_previous(), _type);
    },
    restart:			function(_type = TRANSITION_DEFAULT_TYPE) {
        /// @func   restart()
		/// @param	{TRANSITION_TYPE} type
		/// @desc	...
        /// @return NA
        ///
		__on_hold.data	   = undefined;
		__on_hold.callback = function() {
			PUBLISH("transition_room_restarted");
			room_restart();
		};
		__transition_start(_type);
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
};


















