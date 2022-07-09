function Moveable() : Component() constructor {
	/// @func	Moveable()
	/// @return {Component} self
	///
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
	__dir		 = undefined;
	__collisions = undefined;	// instantiated in setup()
	__path		 = undefined;	// instantiated in setup()
	
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
		//__update_move_values();
		//__check_for_collisions();
		//__update_hspd_vspd();
		//__update_xy();
		return self;
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
	
	#region Private
	
	static __update_move_values = function() {
		/// @func	__update_move_values()
		/// @return {Actionable} self
		///
		__speed = (__moveset_get_current()).__speed;
		__accel = (__moveset_get_current()).__accel;
		__fric  = (__moveset_get_current()).__fric;
		return self;
	};
	
	/// Move Sets
	static __moveset_get_current_name	= function() {
		/// @func	__moveset_get_current_name()
		///	@return {string} name
		///
		return __movesets.__current.__name;
	};
	static __moveset_get_current		= function() {
		/// @func	__moveset_get_current()
		/// @return {struct} move_set
		///
		return __movesets.__current.__set;
	};
	static __moveset_get				= function(_name) {
		///	@func	__moveset_get(name)
		/// @param	{string} name
		/// @return {struct} moveset
		///
		return __movesets.__sets[$ _name];
	};
	static __moveset_set_current		= function(_name) {
		/// @func	__moveset_set_current(name)
		/// @param	{string}	 name
		/// @return {Actionable} self
		///
		if (__moveset_exists(_name)) {
			__movesets.__current.__name = _name;
			__movesets.__current.__set  = __moveset_get(_name);
		}
		return self;
	};
	static __moveset_exists				= function(_name) {
		/// @func	__moveset_exists(name)
		/// @param	{string}  name
		/// @return {boolean} exists?
		///
		return __moveset_get(_name) != undefined;
	};
	static __moveset_add				= function(_name, _moveset) {
		/// @func	__moveset_add(name, moveset)
		/// @param	{string}   name
		/// @param	{MoveSet}  moveset
		/// @return {Moveable} self
		///
		__movesets.__sets[$ _name] = _moveset;
		array_push(__movesets.__names, _name);
		return self;
	};
	static __moveset_remove				= function(_name) {
		/// @func	__moveset_remove(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		if (__moveset_exists(_name)) {
			variable_struct_remove(__movesets.__sets, _name);
			
			/// array_find_delete()
			for (var _i = array_length(__movesets.__names) - 1; _i >= 0; _i--) {
				if (__movesets.__names[_i] == _name) {
					array_delete(__movesets.__names, _i, 1);
					break;
				}
			}
		}
		return self;
	};
	
	#endregion
	
	static new_moveset		   = function(_name) {
		/// @func	new_moveset(name)
		/// @param	...
		/// @return {Moveable} self
		///
		var _moveset = new Moveable_MoveSet();
		__moveset_add(_name, _moveset);
		return self;
	};
	static add_moveset_trigger = function() {
		
	};
};
function Moveable_MoveSet() constructor {
	/// @func	Moveable_MoveSet()
	/// @return {Moveable_MoveSet} self
	///
	__moveable	= other;
	__name		= undefined;
	__speed		= 0;
	__accel		= 0;
	__fric		= 0;
	__mult		= 1;
};