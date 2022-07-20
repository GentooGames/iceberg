/// Insert Ascii Art Here***

function Class(_config = {}) constructor {
	/// @func	Class(config*)
	/// @param	{struct} config={}
	/// @return {Class}  self
	///
	__config = _config;
	__owner	 = _config[$ "owner"] ?? other;
	__name	 = _config[$ "name" ] ?? __get_name_unique();

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
	
	/// @LOCAL
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
	
	static get_names		  = function() {
		/// @func	get_names()
		/// @return {array} names
		///
		return __names;
	};
	static get_items_as_array = function() {
		/// @func	get_items_as_array()
		/// @return {array} items
		///
		return struct_to_array(__items, __names, __size);
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
	
////////////////////////////////////////////////////////////////
	
function Trigger(_config = {}) : Class(_config) constructor {
	/// @func	Trigger(config*)
	/// @param	{struct}  config={}
	/// @return {Trigger} self
	///
	__conditions = new Set();
	
	static add_condition	= function(_name, _method) {
		/// @func	add_condition(name, method)
		/// @param	{string}  name
		/// @param	{method}  method
		/// @return {Trigger} self
		///
		__conditions.add_item(_name, _method);
		return self;
	};
	static remove_condition = function(_name) {
		/// @func	remove_condition(name, method)
		/// @param	{string}  name
		/// @return {Trigger} self
		///
		__conditions.remove_item(_name);
		return self;
	};
	static clear_conditions = function() {
		/// @func	clear_conditions()
		/// @return {Trigger} self
		///
		__conditions.empty();
		return self;
	};
	static check_activation = function() {
		/// @func	check_activation()
		/// @return {Trigger} self
		///
		var _names = __conditions.get_names();
		var _count = __conditions.get_size();
		for (var _i = 0; _i < _count; _i++) {
			var _condition = __conditions.get_item(_names[_i]);
			if (_condition()) {
				return true;	
			}
		}
		return false;
	};
};

/* 
 var _trigger_save = new Trigger();
 _trigger_save.add_action("print", function() {
	show_message("SAVED"); 
 });
 _trigger_save.add_action("save", function() {
	// do save ... 
 });
 _trigger_save.add_condition("input", function() {
	return keyboard_check(ord("S")); 
 });
 _trigger_save.add_region(TRIGGER_REGION.CIRCLE, 
 _trigger_save.add_condition("enter_region", function() {
	return collision_circle(x, y, 100, obj_player, false, false) != noone; 
 });