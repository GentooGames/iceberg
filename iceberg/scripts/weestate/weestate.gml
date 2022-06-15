/////////////////////////////////////////////////////
// .   . r---. r---. .---- .---. .---. .---. r---. //
// |. .| r--   r--   L---.   |   r---j   |   r--   //
// | V | L---J L---J ----J   |   |   |   |   L---J //
//////////////////////////////////////////////$(º)>//
#region docs, info & configs ////////////////////////

#region about ///////////////////////////////////////
/*
	written_by:__gentoo__________________
	version:_____0.1.0___________________
*/   
#endregion
#region change log //////////////////////////////////

#region version 0.1.0
/*	
	Date: xx/xx/2022
	1. Released first version.
*/
#endregion

#endregion
#region docs & help ///////////////////////////////// 

/// ...

#endregion
#region upcoming features /////////////////////////// 

/// ...

#endregion
#region default config values ///////////////////////

/// ...

#endregion
#region enums ///////////////////////////////////////

/// ...

#endregion

#endregion

function WeeState() constructor {
	/// @func	WeeState() constructor
	/// @desc	...
    /// @return self {struct}
    ///
    owner              = other;
    default_draw       = null;
    states             = {};
    state_current_name = "";
    state_current      = null;
    
    // System
    static step = function() {
        /// @func   step()
		/// @desc	...
        /// @return NA
        ///
        state_current.data.step();
    };
    static draw = function() {
        /// @func   draw()
		/// @desc	...
        /// @return NA
        ///
        if (state_current.has_draw) {
            state_current.data.draw();
        }
        else default_draw();
    };
       
    // Methods
    static add               = function(_state_name, _state_struct) {
        /// @func   add(state_name, state_struct)
        /// @param  state_name   {string}
        /// @param  state_struct {struct}
		/// @desc	...
        /// @return self {struct}
        ///
        states[$ _state_name] = _new_state(_state_struct);
        return self;
    };
    static change            = function(_state_name) {
        /// @func   change(state_name)
        /// @param  state_name {string}
		/// @desc	...
        /// @return self {struct}
        ///
        /// Execute Previous State's Leave Event
        if (state_current_name != "") {
            if (state_current.has_leave) {
                state_current.data.leave();
            }
        }
        state_current_name = _state_name;
        state_current      = states[$ state_current_name];
        
        /// Execute New State's Enter Event
        if (state_current.has_enter) {
            state_current.data.enter();
        }
        return self;
    };
    static get_current       = function() {
        /// @func   get_current()
		/// @desc	...
        /// @return state {function/struct}
        ///
        return state_current;
    };
    static get_current_name  = function() {
        /// @func   get_current_name()
		/// @desc	...
        /// @return state_name {string}
        ///
        return state_current_name;
    };
    static state_is          = function(_state_name) {
        /// @func   state_is(state_name)
        /// @param  state_name {string}
		/// @desc	...
        /// @return state_is? {bool}
        ///
        return state_current_name == _state_name;
    };
    static set_default_draw  = function(_draw_function) {
        /// @func   set_default_draw(draw_function)
        /// @param  draw_function {function}
		/// @desc	...
        /// @return NA
        ///
        default_draw = method(owner, _draw_function);
    };
    
    // Private
    static _new_state = function(_state_struct) {
        /// @func   _new_state(state_struct)
        /// @param  state_struct {struct}
		/// @desc	...
        /// @return state {struct}
        /// 
        var _enter_func = undefined;
        var _leave_func = undefined;
        var _step_func  = undefined;
        var _draw_func  = undefined;
        var _has_enter  = variable_struct_exists(_state_struct, "enter");
        var _has_leave  = variable_struct_exists(_state_struct, "leave");
        var _has_step   = variable_struct_exists(_state_struct, "step");
        var _has_draw   = variable_struct_exists(_state_struct, "draw");
        
        if (_has_enter) _enter_func = method(owner, _state_struct.enter);
        if (_has_leave) _leave_func = method(owner, _state_struct.leave);
        if (_has_step)  _step_func  = method(owner, _state_struct.step);
        if (_has_draw)  _draw_func  = method(owner, _state_struct.draw);
        
        return {
            data: {
                enter: _enter_func,
                leave: _leave_func,
                step:  _step_func,
                draw:  _draw_func,
            },
            has_enter: _has_enter,
            has_leave: _has_leave,
            has_step:  _has_step,
            has_draw:  _has_draw,
        };
    };
};
