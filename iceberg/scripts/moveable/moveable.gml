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
	
	static moveset_add		   = function(_moveset_name, _moveset_data) {
		/// @func	moveset_add(moveset_name, moveset_data)
		/// @param	{string}   moveset_name
		/// @param	{struct}   moveset_data
		/// @return {Moveable} self
		///
		var _moveset = new MoveableMoveSet(_moveset_data);
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
	static moveset_add_trigger = function() {};
};
function MoveableMoveSet(_config) constructor {
	/// @func	MoveableMoveSet(config)
	/// @param	{struct}		  config
	/// @return {MoveableMoveSet} self
	///
	__moveable	= other;
	__name		= undefined;
	__speed		= 0;
	__accel		= 0;
	__fric		= 0;
	__mult		= 1;
};