function IMoveable(_moveable, _owner = _moveable.get_owner()) : Interface(_moveable, _owner) constructor {
	/// @func	IMoveable(moveable, owner*)
	/// @param	{Moveable}  moveable
	/// @param	{struct}	owner=moveable.get_owner()
	/// @return {IMoveable} self
	///
	__owner.moveset_new = method(__component, __component.moveset_new);
};
function Moveable() : Component() constructor {
	/// @func	Moveable()
	/// @return {Component} self
	///
	__owner	   = other;
	__hspd	   = 0;
	__vspd	   = 0;
	__speed	   = 0;
	__accel	   = 1;
	__fric	   = 1;
	__movesets = {
		__sets:	   {},
		__names:   [],
		__current: {
			__set:  undefined,
			__name: undefined,
		},
	};
	
	// v-- to implement later
	__dir  = undefined;
	__path = undefined;	// instantiated in setup()
	
	static setup_super	  = setup;
	static setup		  = function() {
		/// @func	setup()
		/// @return {Moveable} self
		///
		if (!__initialized) {
			setup_super();
			__path = path_add();
			path_set_kind(__path, 1);
			path_set_closed(__path, false);
		}
		return self;
	};
	static teardown_super = teardown;
	static teardown		  = function() {
		/// @func	teardown()
		/// @return {Moveable} self
		///
		if (__initialized) {
			teardown_super();
			path_delete(__path);
			__path = undefined;
		}
		return self;
	};
	static update		  = function() {
		/// @func	update()
		/// @return {Moveable} self
		///
		//__update_hspd_vspd();
		//__update_xy();
		return self;
	};
	
	#region MoveSet
	
	#region MoveSet - Private
	
	static __moveset_update_values	  = function(_moveset = __moveset_get_current()) {
		/// @func	__moveset_update_values(moveset*)
		/// @param	{MoveableMoveset} moveset = moveset_current
		/// @return {Actionable}	  self
		///
		__speed = _moveset.__speed;
		__accel = _moveset.__accel;
		__fric  = _moveset.__fric;
		return self;
	};
	static __moveset_get_current_name = function() {
		/// @func	__moveset_get_current_name()
		///	@return {string} name
		///
		return __movesets.__current.__name;
	};
	static __moveset_get_current	  = function() {
		/// @func	__moveset_get_current()
		/// @return {struct} move_set
		///
		return __movesets.__current.__set;
	};
	static __moveset_get			  = function(_moveset_name) {
		///	@func	__moveset_get(moveset_name)
		/// @param	{string} moveset_name
		/// @return {struct} moveset
		///
		return __movesets.__sets[$ _moveset_name];
	};
	static __moveset_set_current	  = function(_moveset_name) {
		/// @func	__moveset_set_current(moveset_name)
		/// @param	{string}	 moveset_name
		/// @return {Actionable} self
		///
		if (__moveset_exists(_moveset_name)) {
			__movesets.__current.__name = _moveset_name;
			__movesets.__current.__set  = __moveset_get(_moveset_name);
			__moveset_update_values();
		}
		return self;
	};
	static __moveset_exists			  = function(_moveset_name) {
		/// @func	__moveset_exists(moveset_name)
		/// @param	{string}  moveset_name
		/// @return {boolean} exists?
		///
		return __moveset_get(_moveset_name) != undefined;
	};
	static __moveset_add			  = function(_moveset_name, _moveset) {
		/// @func	__moveset_add(moveset_name, moveset)
		/// @param	{string}   moveset_name
		/// @param	{MoveSet}  moveset
		/// @return {Moveable} self
		///
		__movesets.__sets[$ _moveset_name] = _moveset;
		array_push(__movesets.__names, _moveset_name);
		return self;
	};
	static __moveset_remove			  = function(_moveset_name) {
		/// @func	__moveset_remove(moveset_name)
		/// @param	{string}   moveset_name
		/// @return {Moveable} self
		///
		if (__moveset_exists(_moveset_name)) {
			variable_struct_remove(__movesets.__sets, _moveset_name);
			
			/// array_find_delete()
			for (var _i = array_length(__movesets.__names) - 1; _i >= 0; _i--) {
				if (__movesets.__names[_i] == _moveset_name) {
					array_delete(__movesets.__names, _i, 1);
					break;
				}
			}
		}
		return self;
	};
	
	#endregion
	
	static moveset_new		   = function(_moveset_name, _moveset_data) {
		/// @func	moveset_new(moveset_name, moveset_data)
		/// @param	{string}   moveset_name
		/// @param	{struct}   moveset_data
		/// @return {Moveable} self
		///
		var _moveset = new MoveableMoveSet(_moveset_name, _moveset_data);
		__moveset_add(_moveset_name, _moveset);
		return self;
	};
	static moveset_exists	   = function(_moveset_name) {
		/// @func	moveset_exists(moveset_name)
		/// @param	{string}  moveset_name
		/// @return {boolean} moveset_exists?
		///
		return __moveset_exists(_moveset_name);
	};
	static moveset_change	   = function(_moveset_name) {
		/// @func	moveset_change(moveset_name)
		/// @param	{string}   moveset_name
		/// @return {Moveable} self
		///
		if (__moveset_exists(_moveset_name)) {
			var _moveset = __moveset_get(_moveset_name);
			__moveset_set_current(_moveset);
		}
		return self;
	};
	static moveset_add_trigger = function(_moveset_name, _trigger_name, _trigger) {
		/// @func	moveset_add_trigger(moveset_name, trigger_name, trigger)
		/// @param	...
		/// @return {Moveable} self
		///
		
	};
		
	#endregion
};
function MoveableMoveSet(_name, _config) constructor {
	/// @func	MoveableMoveSet(name, config)
	/// @param	{string}		  name
	/// @param	{struct}		  config
	/// @return {MoveableMoveSet} self
	///
	__moveable	=  other;
	__name		= _name;
	__config	= _config;
	__speed		= _config[$ "speed"] ?? 0;
	__accel		= _config[$ "accel"] ?? 0;
	__fric		= _config[$ "fric" ] ?? 0;
	__mult		= _config[$ "mult" ] ?? 1;
};
