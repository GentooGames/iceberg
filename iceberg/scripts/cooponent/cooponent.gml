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
		/// @eturn	{Component} component
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

