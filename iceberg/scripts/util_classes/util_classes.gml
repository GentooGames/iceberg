#region Collections ////////////

function Stash() constructor {
	/// @func	Stash()
	/// @return {Stash} self
	///
	/*	__items = {
			_item_1: [1, 2],
			_item_2: "some_string",
		},
	*/
	__owner = other;
	__items = {};
	__names = [];
	__count = 0;
	
	static get				  = function(_name) {
		/// @func	get(name)
		/// @param	{string} name
		/// @return {any}    item
		///
		return __items[$ _name];
	};
	static add				  = function(_name, _item) {
		/// @func	add(name, item)
		/// @param	{string} name
		/// @param	{any}	 item
		/// @return {Stash}  self
		/// 
		/// Add To Existing Entry
		if (exists(_name)) {
			var _entry = get(_name);
			if (!is_array(_entry)) {
				_entry = [ get(_name) ];	
			}
			array_push(_entry, _item);
			__items[$ _name] = _entry;
		}
		/// Create New Entry
		else {
			__items[$ _name] = _item;
			array_push(__names, _name);
			__count++;
		}
		return self;
	};
	static exists			  = function(_name) {
		/// @func	exists(name)
		/// @param	{string}  name
		/// @return {boolean} exists?
		///
		return get(_name) != undefined;
	};
	static remove			  = function(_name, _item = undefined) {
		/// @func	remove(name, item*)
		/// @param	{string} name
		/// @param	{any}	 item=undefined
		/// @return {Stash}  self
		///
		if (exists(_name)) {
			var _entry = get(_name);
			if (_item != undefined && is_array(_entry)) {
				array_find_delete(_entry, _item);
				__items[$ _name] = _entry;
			}
			else {
				variable_struct_remove(__items, _name);
				array_find_delete(__names, _name);
				__count--;		
			}
		}
		return self;
	};
	static clear			  = function() {
		/// @func	clear()
		/// @return {Stash} self
		///
		__count = 0;
		__names = [];
		__items = {};
		return self;
	};
	static get_names		  = function() {
		/// @func	get_names()
		/// @return {array} names
		/// 
		return __names;
	};
	static get_items		  = function() {
		/// @func	get_items()
		/// @return {struct} items
		/// 
		return __items;
	};
	static get_items_as_array = function() {
		/// @func	get_items_as_array()
		/// @return {array} items
		/// 
		return struct_to_array(__items, __names, __count);
	};
	static get_count		  = function() {
		/// @func	get_count()
		/// @return {real} count
		///
		return __count;
	};
};

#endregion

