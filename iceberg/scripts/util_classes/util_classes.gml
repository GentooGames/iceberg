/// Insert Ascii Art Here***

//entities = new Family();
//entities.add_item("enemy",  obj_enemy_1 );	// success!
//entities.add_item("enemy",  obj_enemy_2 );	// success!
//entities.add_item("enemy",  obj_enemy_2 );	// fails...
//entities.add_item("player", obj_player_1);	// success!
//entities.get_items("enemy");
//entities.get_items("player");

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
	
#region Collections ////////////

function Collection() : Class() constructor {
	/// @func	Collection()
	/// @return {Collection} self
	///
	__array =	[];
	__items = __array;
	__names =	[];
	__size  =	0;
	
	static get_items = function() {			
		/// @func	get_items()
		/// @return {array} items
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
	static has_item  = function(_name) {
		/// @func	has_item(name)
		/// @param	{string}  name
		/// @return	{boolean} has_item?
		///
		if (is_empty()) {
			return false;	
		}
		return get_item(_name) != undefined;
	};	
	static is_empty  = function() {
		/// @func	is_empty()
		/// @return {bool} is_empty?
		///
		return get_size() == 0;
	};
	
	////////////////////////////////////////
	
	static __add_item_collection	= function(_name, _item) {
		/// @func	__add_item_collection(name, item)
		/// @param	{string}	 name
		/// @param	{any}		 item
		/// @return {Collection} self
		///
		array_push(__array, _item);
		array_push(__names, _name);
		__size++;
		return self;
	};
	static __remove_item_collection = function(_name) {
		/// @func	__remove_item_collection(name)
		/// @param	{string}	 name
		/// @return {Collection} self
		///
		var _index  = array_find_index(__names, _name);
		if (_index != -1) {
			array_delete(__array, _index, 1);
			array_delete(__names, _index, 1);
			__count--;	
		}
		return self;
	};
	static __empty_collection		= function() {
		/// @func	__empty_collection()
		/// @return {Collection} self
		///
		__array = [];
		__names = [];
		__size  = 0;
		return self;
	};
	
	/// @OVERRIDE
	static get_item    = function(_name) {
		/// @func	get_item(name)
		/// @param	{string} name
		/// @return {any}	 item
		///
		var _index  =  array_find_index(__names, _name);
		if (_index == -1) {
			return __items[_index];	
		}
		return undefined;
	};
	static add_item	   = function(_name, _item) {
		/// @func	add_item(name, item)
		/// @param	{string}	 name
		/// @param	{any}		 item
		/// @return {Collection} self
		///	
		__add_item_collection(_name, _item);
		return self;
	};
	static remove_item = function(_name) {		
		/// @func	remove_item(name)
		/// @param	{string}	 name
		/// @return {Collection} self
		///
		if (!is_empty()) {
			__remove_item_collection(_name);
		}
		return self;
	};
	static empty	   = function() {			
		/// @func	empty()
		/// @return {Collection} self
		///
		if (!is_empty()) {
			__empty_collection();
		}
		return self;
	};
};
function Set() : Collection() constructor {
	/// @func	Set()
	/// @return {Set} self
	///
	__items = {};
	
	/// @LOCAL
	static __add_item_set	 = function(_name, _item) {
		/// @func	__add_item_set(name, item)
		/// @param	{string} name
		/// @param	{any}    item
		/// @return {Set}    self
		///
		__items[$ _name] = _item;
		return self;
	};
	static __remove_item_set = function(_name) {
		/// @func	__remove_item_set(name)
		/// @param	{string} name
		/// @return {Set}    self
		///
		variable_struct_remove(__items, _name);
		array_find_delete(__names, _name);
		__size--;
		return self;
	};
	static __empty_set	     = function() {
		/// @func	__empty_set()
		/// @return {Set} self
		///
		__items = {};
		return self;
	};
		
	/// @OVERRIDE
	static get_item	   = function(_name) {
		/// @func	get_item(name)
		/// @param	{string} name
		/// @return	{Set}    self
		///
		return __items[$ _name];
	};
	static add_item    = function(_name, _item) {
		/// @func	add_item(name, item)
		/// @param	{string} name
		/// @param	{any}	 item
		/// @return {Set}	 self
		///	
		if (!has_item(_name)) {
			__add_item_collection(_name, _item);
			__add_item_set(_name, _item);
		}
		return self
	};
	static remove_item = function(_name) {
		/// @func	remove_item(name)
		/// @param	{string} name
		/// @return {Set}	 self
		///
		if (has_item(_name)) {
			__remove_item_collection(_name);
			__remove_item_set(_name);
		}
		return self
	};
	static empty	   = function() {
		/// @func	empty()
		/// @return {Set} self
		///
		if (!is_empty()) {
			__empty_collection();
			__empty_set();
		}
		return self
	};
};
function Family() : Set() constructor {
	/// @func	Family()
	/// @return {Family} self
	///
	static get_sets		= get_items;
	static get_set		= get_item;
	static add_set		= add_item;
	static has_set		= has_item;
	static delete_set	= remove_item;
	static new_set		= function() {
		/// @func	new_set()
		/// @return {Coolection} set
		/// 
		return new Collection();
	};
	static empty_set	= function(_set_name) {
		/// @func	empty_set(set_name)
		/// @param	{string} set_name
		/// @return {Family} self
		///
		if (has_set(_set_name)) {
			get_set(_set_name).empty();
		}
		return self;
	};
	static is_set_empty = function(_set) {
		/// @func	is_set_empty(set)
		/// @param	{string}  set_name
		/// @return {boolean} is_set_empty?
		///
		if (has_set(_set_name)) {
			return get_set(_set_name).is_empty();
		}
		return true;
	};
	
	static get_item	    = function(_set_name, _item_name) {
		/// @func	get_item(set_name, item_name, item)
		/// @param	{string} set_name
		/// @param	{string} item_name
		/// @return {any}    item
		///
		if (has_set(_set_name)) {
			return get_set(_set_name).get_item(_item_name);	
		}
		return undefined;
	};
	static has_item	    = function(_set_name, _item_name) {
		/// @func	has_item(set_name, item_name, item)
		/// @param	{string}  set_name
		/// @param	{string}  item_name
		/// @return {boolean} has_item?
		///
		if (has_set(_set_name)) {
			return get_set(_set_name).has_item(_item_name);	
		}
		return false;
	};
	static add_item	    = function(_set_name, _item_name, _item) {	
		/// @func	add_item(set_name, item_name, item)
		/// @param	{string} set_name
		/// @param	{string} item_name
		/// @param	{any}    item
		/// @return {Family} self
		///
		if (!has_set(_set_name)) {
			add_set(_set_name, new_set());
		}
		get_set(_set_name).add_item(_item_name, _item);
		return self;
	};
	static remove_item = function(_set_name, _item_name) {			
		/// @func	remove_item(set_name, item_name)
		/// @param	{string} set_name
		/// @param	{string} item_name
		/// @return {Family} self
		///
		if (has_set(_set_name)) {
			get_set(_set_name).remove_item(_item_name);	
		}
		return self;
	};
};
	
#endregion
	
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
