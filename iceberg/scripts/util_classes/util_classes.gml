/// Insert Ascii Art Here***

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

function Collection(_config = {}) : Class(_config) constructor {
	/// @func	Collection(config*)
	/// @param	{struct}	 config={}
	/// @return {Collection} self
	///
	__array =	[];
	__items = __array;
	__size  =	0;
	
	static get_items = function() {			
		/// @func	get_items()
		/// @return {array} items
		///
		return __items;
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
	
	static __add_item_collection	= function(_item) {
		/// @func	__add_item_collection(item)
		/// @param	{any}		 item
		/// @return {Collection} self
		///
		array_push(__array, _item);
		__size++;
		return self;
	};
	static __remove_item_collection = function(_item) {
		/// @func	__remove_item_collection(item)
		/// @param	{any}		 item
		/// @return {Collection} self
		///
		var _index  = array_find_index(__array, _item);
		if (_index != -1) {
			array_delete(__array, _index, 1);
			__size--;	
		}
		return self;
	};
	static __empty_collection		= function() {
		/// @func	__empty_collection()
		/// @return {Collection} self
		///
		__array = [];
		__size  = 0;
		return self;
	};
	
	/// @OVERRIDE
	static get_item    = function(_item) {
		/// @func	get_item(item)
		/// @param	{any} item
		/// @return {any} item
		///
		return _item;
	};
	static add_item	   = function(_item) {
		/// @func	add_item(item)
		/// @param	{any}		 item
		/// @return {Collection} self
		///	
		__add_item_collection(_item);
		return self;
	};
	static remove_item = function(_item) {		
		/// @func	remove_item(item)
		/// @param	{any}		 item
		/// @return {Collection} self
		///
		if (!is_empty()) {
			__remove_item_collection(_item);
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
function Set(_config = {}) : Collection(_config) constructor {
	/// @func	Set(config*)
	/// @param	{struct} config={}
	/// @return {Set}	 self
	///
	__items = {};
	__names = [];	
	
	static get_names = function() {
		/// @func	get_names()
		/// @return {array} names
		///
		return __names;
	};
		
	////////////////////////////////////////
	
	/// @LOCAL
	static __add_item_set	 = function(_name, _item) {
		/// @func	__add_item_set(name, item)
		/// @param	{string} name
		/// @param	{any}    item
		/// @return {Set}    self
		///
		__items[$ _name] = _item;
		array_push(__names, _name);
		return self;
	};
	static __remove_item_set = function(_name) {
		/// @func	__remove_item_set(name)
		/// @param	{string} name
		/// @return {Set}    self
		///
		variable_struct_remove(__items, _name);
		array_find_delete(__names, _name);
		return self;
	};
	static __empty_set	     = function() {
		/// @func	__empty_set()
		/// @return {Set} self
		///
		__items = {};
		__names = [];
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
			__add_item_collection(_item);
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
function Family(_config = {}) : Set(_config) constructor {
	/// @func	Family(config*)
	/// @param	{struct} config={}
	/// @return {Family} self
	///
	static get_sets		= get_items;
	static get_set		= get_item;
	static add_set		= add_item;
	static has_set		= has_item;
	static remove_set	= remove_item;
	static new_set		= function() {
		/// @func	new_set()
		/// @return {Collection} set
		/// 
		return new Collection();
		/// if this changes from a Collection(). make sure to update
		///	add_item(), remove_item(), and get_item() default return
		/// to account for an item_name param and type change
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
	static get_items	= function(_set_name) {
		/// @func	get_items(set_name)
		/// @param	{string} set_name
		/// @return {array}  items
		///
		if (has_set(_set_name)) {
			return get_set(_set_name).get_items();
		}
		return [];
	};
	static add_item	    = function(_set_name, _item) {	
		/// @func	add_item(set_name, item)
		/// @param	{string} set_name
		/// @param	{any}    item
		/// @return {Family} self
		///
		if (!has_set(_set_name)) {
			add_set(_set_name, new_set());
		}
		get_set(_set_name).add_item(_item);
		return self;
	};
	static remove_item  = function(_set_name, _item) {			
		/// @func	remove_item(set_name, item)
		/// @param	{string} set_name
		/// @param	{any}    item
		/// @return {Family} self
		///
		if (has_set(_set_name)) {
			var _set = get_set(_set_name);
			_set.remove_item(_item);	
			
			if (_set.is_empty()) {
				remove_set(_set_name);
			};
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
