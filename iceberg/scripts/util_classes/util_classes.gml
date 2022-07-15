/// Insert Ascii Art Here***

//var _enemies = new Set();
//_enemies.add_item("enemy1", obj_enemy1);
//_enemies.add_item("enemy1", obj_enemy2);	// should fail

//var _entities = new Family();
//_entities.add_item("enemy", obj_enemy1);
//_entities.add_item("enemy", obj_enemy2);	// should insert into array

function Class(_config = {}) constructor {
	/// @func	Class(config*)
	/// @param	{struct} config={}
	/// @return {Class}  self
	///
	__config = _config;
	__owner	 = _config[$ "owner" ] ?? other;
	__name	 = _config[$ "name"  ] ?? __get_name_unique();

	#region Private ////////
	
	static __get_name_unique = function() {	
		/// @func	__get_name_unique()
		/// @return {string} name
		///
		return instanceof(self) + "_" + string(ptr(self));
	};
	
	#endregion
	#region Getters ////////
	
	static get_owner = function() {
		/// @func	get_owner()
		/// @return {struct} owner
		///
		return __owner;
	};
	static get_name	 = function() {
		/// @func	get_name()
		/// @return {string} name
		///
		return __name;
	};
	
	#endregion
	#region Setters ////////
	
	static set_owner = function(_owner) {
		/// @func	set_owner(owner)
		/// @param	{struct} owner
		/// @return {Class}	 self
		///
		__owner = _owner;
		return self;
	};
	static set_name	 = function(_name) {
		/// @func	set_name(name)
		/// @param	{string} name
		/// @return {Class}  self
		///
		__name = _name;
		return self;
	};
	
	#endregion
	
	/// ANY CHANGES MADE TO CONFIG STRUCT SHOULD BE UPDATED IN CODE_SNIPPET
};
function Set(_config = {}) : Class(_config) constructor {
	/// @func	Set(config*)
	/// @param	{struct} config={}
	/// @return {Set} self
	///
	__items = {};
	__names = [];
	__size  = 0;
	
	#region Getters ////////
	
	static get_items = function() {
		/// @func	get_items()
		/// @return {struct} items
		///
		return __items;
	};
	static get_names = function() {
		/// @func	get_names()
		/// @return {array} names
		///
		return __names;
	};
	static get_size  = function() {
		/// @func	get_size()
		/// @return {real} size
		///
		return __size;
	};
	static get_item  = function(_name) {
		/// @func	get_item(name)
		/// @param	{string} name
		/// @return {any}	 item
		///
		return __items[$ _name];
	};
	
	#endregion
	#region Checkers ///////
	
	static has_item = function(_name) {
		/// @func	has_item(name)
		/// @param	{bool} name
		/// @return {any}  item
		///
		return get_item(_name) != undefined;
	};	
	static is_empty = function() {
		/// @func	is_empty()
		/// @return {bool} is_empty?
		///
		return get_size() == 0;
	};
	
	#endregion
	
	static add_item	   = function(_name, _item) {
		/// @func	add_item(name, item)
		/// @param	{string} name
		/// @param	{any}    item
		/// @return {Set}    self
		///
		if (!has_item(_name)) {
			__items[$ _name] = _item;
			__size++;
			array_push(__names, _name);
		}
		return self;
	};
	static remove_item = function(_name) {
		/// @func	remove_item(name)
		/// @param	{string} name
		/// @return {Set}    self
		///
		if (has_item(_name)) {
			variable_struct_remove(__items, _name);
			array_find_delete(__names, _name);
			__size--;
		}
		return self;
	};
	static empty	   = function() {
		/// @func	empty()
		/// @return {Set} self
		///
		if (__size  > 0) {
			__items = {};
			__names = [];
			__size  = 0;
		}
		return self;
	};
};
function Family(_config = {}) : Class(_config) constructor {
	/// @func	Family(config*)
	/// @param	{struct} config={}
	/// @return {Family} self
	///
	__sets  = {};
	__names = [];
	__size  = 0;
	
	#region Getters ////////
	
	static get_sets  = function() {
		/// @func	get_sets()
		/// @return {struct} sets
		///
		return __sets;
	};
	static get_names = function() {
		/// @func	get_names()
		/// @return {array} names
		///
		return __names;
	};
	static get_size  = function() {
		/// @func	get_size()
		/// @return {real} size
		///
		return __size;
	};
	static get_set	 = function(_name) {
		/// @func	get_set(name)
		/// @param	{string} name
		/// @return {Set}	 set
		///
		return __sets[$ _name];
	};
	
	#endregion
	#region Checkers ///////
	
	static has_set  = function(_name) {
		/// @func	has_set(name)
		/// @param	{string}  name
		/// @return {boolean} has_set?
		///
		return get_set(_name) != undefined;
	};
	static is_empty = function() {
		/// @func	is_empty()
		/// @return {bool} is_empty?
		///
		return get_size() == 0;
	};
	
	#endregion
	
	/// Set Operations
	static add_set	   = function(_name) {
		/// @func	add_set(name)
		/// @param	{string} name
		/// @return {Family} self
		///
		if (!has_set(_name)) {
			__sets[$ _name] = new Set();
			__size++;
			array_push(__names, _name);
		}
		return self;
	};
	static remove_set  = function(_name) {
		/// @func	remove_set(name)
		/// @param	{string} name
		/// @return {Family} self
		///
		if (has_set(_name)) {
			variable_struct_remove(__sets, _name);
			array_find_delete(__names, _name);
			__size--;
		}
		return self;
	};
	static empty_set   = function(_name) {
		/// @func	empty_set(name)
		/// @param	{string} name
		/// @return {Family} self
		///
		if (has_set(_name)) {
			get_set(_name).empty();
		}
		return self;
	};
	
	/// Item Operations
	static add_item	   = function(_name, _item) {	
		/// @func	add_item(name, item)
		/// @param	{string} name
		/// @param	{any}    item
		/// @return {Set}    self
		///
		if (!has_set(_name)) {
			add_set(_name);
		}
		get_set(_name).add_item(_item);
		return self;
	};
	static remove_item = function(_name) {			
		/// @func	remove_item(name)
		/// @param	{string} name
		/// @return {Set}    self
		///
		variable_struct_remove(__items, _name);
		return self;
	};
	static empty	   = function() {
		/// @func	empty()
		/// @return {Family} self
		///
		if (__size > 0) {
			__sets  = {};
			__names = [];
			__size  = 0;
		}
		return self;
	};
};
//function Batch(_config = {}) : Family(_config) constructor {
//	/// @func	Batch(config*)
//	/// @param	{struct} config={}
//	/// @return {Batch}  self
//	///
//	__empty_on_execute = _config[$ "empty_on_execute"] ?? false;
	
//	#region Getters ////////
	
//	static get_empty_on_execute = function() {
//		/// @func	get_empty_on_execute()
//		/// @return {bool} empty_on_execute?
//		///
//		return __empty_on_execute;
//	};
	
//	#endregion
//	#region Setters ////////
	
//	static set_empty_on_execute = function(_empty) {
//		/// @func	set_empty_on_execute(empty?)
//		/// @param	{bool}  empty?
//		/// @return {Batch} self
//		///
//		__empty_on_execute = _empty;
//		return self;
//	};
		
//	#endregion
	
//	static execute = function(_empty_after = false) {
//		/// @func	execute(empty_after?*)
//		/// @param	{boolean} empty_after=false
//		/// @return {Batch}   self
//		///
//		var _items = get_items();
//		var _names = get_names();
//		for (var _i = 0, _len = get_size(); _i < _len; _i++) {
//			var _name = _names[_i];
//			var _item = _items[$ _name];
//			_item();
//		}
//		if (__empty_on_execute || _empty_after) {
//			empty();	
//		}
//		return self;
//	};
//};

/// method takes some method/function, may also contain some data, and executes when invoked
function Method (_config = {}) : Class(_config) constructor {
	/// @func	Method(config*)
	/// @param	{struct} config={}
	/// @return {Method} self
	///
	__method = _config[$ "method"] ?? undefined;
	__data	 = _config[$ "data"  ] ?? undefined;
	
	#region Private ////////
	
	static __execute_method		   = function() {
		/// @func	__execute_method()
		/// @return {any} method_return
		///
		return __method(__data);
	};
	static __execute_method_script = function() {
		/// @func	__execute_method_script()
		/// @return {any} method_return
		///
		return script_execute_ext(__method, __data);
	};
	
	#endregion
	#region Getters ////////
	
	static get_method = function() {
		/// @func	get_method()
		/// @return {method} method
		///
		return __method;
	};
	static get_data	  = function() {
		/// @func	get_data()
		/// @return {any} data
		///
		return __data;
	};
	
	#endregion
	#region Setters ////////
	
	static set_method = function(_method) {
		/// @func	set_method(method)
		/// @param	{method} method
		/// @return {Method} self
		///
		__method = _method;
		return self;
	};
	static set_data	  = function(_data) {
		/// @func	set_data(data)
		/// @param	{any} data
		/// @return {Method} self
		///
		__data = _data;
		return self;
	}
		
	#endregion
	
	static execute = function() {
		/// @func	execute()
		/// @return {any} execute_return
		///
		if (is_method(__method)) {
			return __execute_method();	
		}
		return __execute_method_script();
	};
};

function Trigger(_config = {}) : Class(_config) constructor {
	/// @func	Trigger(config*)
	/// @param	{struct}  config={}
	/// @return	{Trigger} self
	///
};
