/////////////////////////////
// .---. .---. .---. .---. //
// |     |   | |   | r---J //
// L---' L---J L---J |     //
//////////////////////$(º)>//

function Coop() constructor {
	/// @func Coop()
	///
	__owner = other;
	__unique_components  = {};
	__unique_names		 = [];
	__generic_components = {};
	__generic_names		 = [];
	__ordered_components = [];
	
	static update		 = function() {
		/// @func	update()
		/// @return {Coop} self
		///
		for (var _i = 0, _len = array_length(__ordered_components); _i < _len; _i++) {
			__ordered_components[_i].__update();	
		}
		return self;
	};
	static add_component = function(_instance, _name = undefined) {
		/// @func add_component(instance, name*)
		/// @param	{instanceof} instance
		/// @param	{string}	 name=undefined
		/// @return {Coop}		 self
		///
		if (_name != undefined && _name != "") {
			_instance.__set_name(_name);
		}
		////////////////////////////
		var _constructor = instanceof(_instance);
		if (_instance.__singleton) {
			if (!variable_struct_exists(__unique_components, _constructor)) {
				__unique_components[$ _constructor] = _instance;	
				array_push(__unique_names, _constructor);
				array_push(__ordered_components, _instance);
			}
		}
		else {
			if (__generic_components[$ _constructor] == undefined) {
				__generic_components[$ _constructor]  = {};
				array_push(__generic_names, _constructor);
			}
			var _components = __generic_components[$ _constructor];
			_components[$ _instance.__name] = _instance;
			array_push(__ordered_components, _instance);
		}
		return self;
	};
};
function Cooponent() constructor {
	/// @func	Cooponent()
	/// @return {Cooponent} self
	///
	__singleton = false;
	__active	= true;
	__name		= string(ptr(self));
	__name_set	= false; // name set manually?
	
	#region Private Methods
	
	static __update	  = function() {};
	static __set_name = function(_name) {
		__name	   = _name;
		__name_set =  true;
		return self;
	};
		
	#endregion
};
function Actionable() : Cooponent() constructor {
	/// @func	Actionable()
	/// @return {Cooponent} self
	///
	__singleton = true;
	__actor		= other;
	__fsm		= undefined;
	
	#region Private Methods
	
	static __update	= function() {
		if (__fsm != undefined) {
			__fsm.step();
		}
		return self;
	};
		
	#endregion
	
	static add_state = function(_state_name, _state_struct) {
		if (__fsm == undefined) {
			__fsm  = new SnowState(_state_name);
		}
		__fsm.add(_state_name, _state_struct);
		return self;
	};
};
function Moveable() : Cooponent() constructor {
	/// @func	Moveable()
	/// @return {Cooponent} self
	///
	__singleton = true;
};
function Scriptable() : Cooponent() constructor {
	/// @func	Scriptable()
	/// @return {Cooponent} self
	///
};






















