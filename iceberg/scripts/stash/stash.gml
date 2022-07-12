//////////////////////////////////////////////////////
//	Stash											//
//		--- ... 									//
//////////////////////////////////////////////////////

/// Interface
function IStash(_stash, _owner = _stash.get_owner()) : Interface(_stash, _owner) constructor {
	/// @func	IStash(stash, owner*)
	/// @param	{Stash}  stash
	/// @param	{struct} owner=stash.get_owner()
	/// @return {IStash} self
	///
	__owner.stash_get			  = method(__component, __component.get);
	__owner.stash_set			  = method(__component, __component.set);
	__owner.stash_add			  = method(__component, __component.add);
	__owner.stash_exists		  = method(__component, __component.exists);
	__owner.stash_remove		  = method(__component, __component.remove);
	__owner.stash_clear			  = method(__component, __component.clear);
	__owner.stash_get_items		  = method(__component, __component.get_items);
	__owner.stash_get_items_array = method(__component, __component.get_items_array);
	__owner.stash_get_names		  = method(__component, __component.get_names);
	__owner.stash_get_count		  = method(__component, __component.get_count);
	
	if (!variable_struct_exists(__owner, "__stash_stash")) {
		variable_struct_set(__owner, "__stash_stash", undefined);	
		variable_struct_set(__owner, "__stash_stash", new Stash());	
		
		__owner.get_stash = method(__owner, function(_stash_name) {
			return __stash_stash.get(_stash_name);
		});
	}
};

/// Component
function Stash(_config = {}) : Component(_config) constructor {
	/// @func	Stash(config*)
	/// @param	{struct} config={}
	/// @return {Stash}  self
	///
	__interface = new IStash(self);
	__stash		= {
		__items: {},
		__names: [],
		__count: 0,
	};
	
	static get			   = function(_name) {
		/// @func	get(name)
		/// @param	{string} name
		/// @return {any}    value
		///
		with (__stash) {
			return __items[$ _name];
		}
	};
	static add			   = function(_name, _value) {
		/// @func	add(name, value)
		/// @param	{string} name
		/// @param	{any}	 value
		/// @return {Stash}  self
		///
		with (__stash) {
			__items[$ _name] = _value;
			array_push(__names, _name);
			__count++;
		}
		return self;
	};
	static exists		   = function(_name) {
		/// @func	exists(name)
		/// @param	{string}  name
		/// @return {boolean} exists?
		///
		return get(_name) != undefined;
	};
	static remove		   = function(_name) {
		/// @func	remove(name)
		/// @param	{string} name
		/// @return {Stash}  self
		///
		if (exists(_name)) {
			with (__stash) {
				variable_struct_remove(__items, _name);
				array_find_delete(__names, _name);
				__count--;
			}
		}
		return self;
	};
	static clear		   = function() {
		/// @func	clear()
		/// @return {Stash} self
		///
		with (__stash) {
			__count = 0;
			__names = [];
			__items = {};
		}
		return self;
	};
	static get_items	   = function() {
		/// @func	get_items()
		/// @return {struct} items
		/// 
		return __stash.__items;
	};
	static get_items_array = function() {
		/// @func	get_items_array()
		/// @return {array} items
		/// 
		with (__stash) {
			var _items  = array_create(__count);
			for (var _i = 0; _i < __count; _i++) {
				array_push(_items, __items[$ __names[_i]]);
			};
			return _items;
		}
		return [];
	};
	static get_names	   = function() {
		/// @func	get_names()
		/// @return {array} names
		/// 
		return __stash.__names;
	};
	static get_count	   = function() {
		/// @func	get_count()
		/// @return {real} count
		///
		return __stash.__count;
	};
};