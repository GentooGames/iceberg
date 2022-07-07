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
	
	static update			= function() {
		/// @func	update()
		/// @return {Coop} self
		///
		for (var _i = 0, _len = array_length(__names); _i < _len; _i++) {
			get_component(__names[_i]).update();	
		}
		return self;
	};
	static render			= function() {
		/// @func	render()
		/// @return {Coop} self
		///
		for (var _i = 0, _len = array_length(__names); _i < _len; _i++) {
			get_component(__names[_i]).render();	
		}
		return self;
	};
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
};
function Cooponent() constructor {
	/// @func	Cooponent()
	/// @return {Cooponent} self
	///
	__name	 = undefined;
	__active = true;
	
	#region Private Methods
	
	#endregion
	
	static update = function() {}; /// @OVERRIDE
	static render = function() {}; /// @OVERRIDE
};
function Actionable() : Cooponent() constructor {
	/// @func	Actionable()
	/// @return {Cooponent} self
	///
	__actor	= other;
	__fsm	= undefined;
	
	#region Private Methods
		
	#endregion
	
	static update = function() {
		if (__fsm != undefined) {
			__fsm.step();
		}
		return self;
	};
	static render = function() {
		if (__fsm != undefined) {
			__fsm.draw();	
		}
		return self;
	};
		
	static actionable_state_add	   = function(_state_name, _state_struct) {
		if (__fsm == undefined) {
			__fsm  = new SnowState(_state_name, false);
		}
		__fsm.add(_state_name, _state_struct);
		return self;
	};
	static actionable_state_change = function(_state_name) {
		__fsm.change(_state_name);
		return self;
	};
	static state_add			   = actionable_state_add;
	static state_change			   = actionable_state_change;
};
function Moveable() : Cooponent() constructor {
	/// @func	Moveable()
	/// @return {Cooponent} self
	///
};
function Scriptable() : Cooponent() constructor {
	/// @func	Scriptable()
	/// @return {Cooponent} self
	///
};



