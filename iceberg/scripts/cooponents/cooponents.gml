/////////////////////////////
// .---. .---. .---. .---. //
// |     |   | |   | r---J //
// L---' L---J L---J |     //
//////////////////////$(º)>//

function Coop() constructor {
	/// @func Coop()
	///
	__owner		 = other;
	__components = {};
	__names		 = [];
	
	static setup	= function() {
		/// @func	setup()
		/// @return {Coop} self
		///
		for (var _i = 0, _len = array_length(__names); _i < _len; _i++) {
			get_component(__names[_i]).setup();	
		}
		return self;
	}
	static update	= function() {
		/// @func	update()
		/// @return {Coop} self
		///
		for (var _i = 0, _len = array_length(__names); _i < _len; _i++) {
			var _component = get_component(__names[_i]);
			if (_component.__active) {
				_component.update();	
			}
		}
		return self;
	};
	static render	= function() {
		/// @func	render()
		/// @return {Coop} self
		///
		for (var _i = 0, _len = array_length(__names); _i < _len; _i++) {
			var _component = get_component(__names[_i]);
			if (_component.__active) {
				_component.render();	
			}
		}
		return self;
	};
	static teardown	= function() {
		/// @func	teardown()
		/// @return {Coop} self
		///
		for (var _i = 0, _len = array_length(__names); _i < _len; _i++) {
			get_component(__names[_i]).teardown();	
		}
		return self;
	};
	
	/// Components
	static add_component	= function(_instance, _name = instanceof(_instance)) {
		/// @func	add_component(instance, name*)
		/// @param	{instanceof} instance
		/// @param	{string}	 name=instanceof
		/// @return {Coop}		 self
		///
		_instance.__name = _name;
		__components[$ _name] = _instance;
		array_push(__names, _name);
		return self;
	};
	static get_component	= function(_name) {
		/// @func	get_component(name)
		/// @param	{string}	name
		/// @eturn	{Cooponent} component
		///
		return __components[$ _name];
	};
	static has_component	= function(_name) {
		/// @func	has_component(name)
		/// @param	{string}  name
		/// @return {boolean} has_component?
		///
		return get_component(_name) != undefined;
	};
	static remove_component = function(_name) {
		/// @func	remove_component(name)
		/// @param	{string} name
		/// @return {Coop}   self
		///
		if (has_component(_name)) {
			variable_struct_remove(__components, _name);
			
			/// array_find_delete()
			for (var _i = array_length(__names) - 1; _i >= 0; _i--) {
				if (__names[_i] == _name) {
					array_delete(__names, _i, 1);
					break;
				}
			}
		}
		return self;
	};
		
	static set_update_order = function() {};
	static set_render_order = function() {};
};
function Cooponent() constructor {
	/// @func	Cooponent()
	/// @return {Cooponent} self
	///
	__name	 = undefined;
	__active = true;
	
	static setup    = function() {}; /// @OVERRIDE
	static update   = function() {}; /// @OVERRIDE
	static render   = function() {}; /// @OVERRIDE
	static teardown = function() {}; /// @OVERRIDE

	static enable	= function() {
		/// @func	enable()
		/// @return {Cooponent} self
		///
		__active = true;
		return self;
	};
	static disable  = function() {
		/// @func	disable()
		/// @return {Cooponent} self
		///
		__active = false;
		return self;
	};
};

#region Actionable 

function Actionable() : Cooponent() constructor {
	/// @func	Actionable()
	/// @return {Cooponent} self 
	///
	__actor	= other;
	__fsm	= undefined;
	
	static update = function() {
		/// @func	update()
		/// @return {Actionable} self
		///
		if (__fsm != undefined) {
			__fsm.step();
		}
		return self;
	};
	static render = function() {
		/// @func	render()
		/// @return {Actionable} self
		///
		if (__fsm != undefined) {
			__fsm.draw();	
		}
		return self;
	};
	
	/// States
	static actionable_state_add			 = function(_state_name, _state_struct) {
		/// @func	actionable_state_add(state_name, state_struct)
		/// @param	{string}	 state_name
		/// @param	{struct}	 state_struct
		/// @return {Actionable} self
		///
		if (__fsm == undefined) {
			__fsm  = new SnowState(_state_name, false);
		}
		__fsm.add(_state_name, _state_struct);
		return self;
	};
	static actionable_state_change		 = function(_state_name) {
		/// @func	actionable_state_change(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		__fsm.change(_state_name);
		return self;
	};
	static actionable_state_is			 = function(_state_name) {
		/// @func	actionable_state_is(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		return __fsm.state_is(_state_name);
	};
	static actionable_state_exists		 = function(_state_name) {
		/// @func	actionable_state_exists(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		return __fsm.state_exists(_state_name);
	};
	static actionable_state_get_states	 = function() {
		/// @func	actionable_state_get_states()
		/// @return {Actionable} self
		///
		return __fsm.get_states();
	};
	static actionable_state_get_current  = function() {
		/// @func	actionable_state_get_current()
		/// @return {Actionable} self
		///
		return __fsm.get_current_state();
	};
	static actionable_state_get_previous = function() {
		/// @func	actionable_state_get_previous()
		/// @return {Actionable} self
		///
		return __fsm.get_previous_state();
	};
	static actionable_state_get_time	 = function(_us = true) {
		/// @func	actionable_state_get_time(us*)
		/// @param	{boolean}	 us?=true
		/// @return {Actionable} self
		///
		return __fsm.get_time(_us);
	};
	static actionable_state_set_time	 = function(_time, _us = true) {
		/// @func	actionable_state_set_time(time, us*)
		/// @param	{milliseconds} time
		/// @param	{boolean}	   us?=true
		/// @return {Actionable}   self
		///
		__fsm.set_time(_time, _us);
		return self;
	};
	static state_add					 = actionable_state_add;
	static state_change					 = actionable_state_change;
	static state_is						 = actionable_state_is;
	static state_exists					 = actionable_state_exists;
	static state_get_states				 = actionable_state_get_states;
	static state_get_current			 = actionable_state_get_current;
	static state_get_previous			 = actionable_state_get_previous;
	static state_get_time				 = actionable_state_get_time;
	static state_set_time				 = actionable_state_set_time;
};
	
#endregion
#region Moveable

function Moveable() : Cooponent() constructor {
	/// @func	Moveable()
	/// @return {Cooponent} self
	///
	__mover		 = other;
	__hspd		 = 0;
	__vspd		 = 0;
	__dir		 = undefined;
	__collisions = undefined;
	__path		 = undefined;
	__sets		 = {};
	
	static setup	= function() {
		/// @func	setup()
		/// @return {Moveable} self
		///
		__collisions = ds_list_create();
		__path		 = path_add();
		path_set_kind(__path, 1);
		path_set_closed(__path, false);
		return self;
	};
	static update	= function() {
		/// @func	update()
		/// @return {Moveable} self
		///
	};
	static teardown = function() {
		/// @func	teardown()
		/// @return {Moveable} self
		///
		ds_list_destroy(__collisions);
		path_delete(__path);
		__collisions = undefined;
		__path		 = undefined;
		return self;
	};
};
function MoveSet() constructor {
	/// @func	MoveSet()
	/// @return {MoveSet} self
	///
	__moveable	= other;
	__name		= "";
	__speed		= 0;
	__accel		= 0;
	__fric		= 0;
	__mult		= 1;
};

#endregion
#region Scriptable

function Scriptable() : Cooponent() constructor {
	/// @func	Scriptable()
	/// @return {Cooponent} self
	///
};

#endregion

