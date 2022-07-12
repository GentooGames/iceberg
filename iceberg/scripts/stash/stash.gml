//////////////////////////////////////////////////////
//	Stash											//
//		--- ... 									//
//////////////////////////////////////////////////////

/// Component
function Stash(_config = {}) : Component(_config) constructor {
	/// @func	Stash(config*)
	/// @param	{struct} config={}
	/// @return {Stash}  self
	///
	__interface = new IStash();
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
		return __stash.__items[$ _name];
	};
	static set			   = function(_name, _value) {
		/// @func	set(name, value)
		/// @param	{string} name
		/// @param	{any}    value
		/// @return {Stash}  self
		///
		with (__stash) {
			__items[$ _name] = _value;
		}
		return self;
	};
	static add			   = function(_name, _value) {
		/// @func	add(name, value)
		/// @param	{string} name
		/// @param	{any}	 value
		/// @return {Stash}  self
		///
		if (!exists(_name)) {
			with (__stash) {
				array_push(__names, _name);
				__count++;
			}
			set(_name, _value);
		}
		return self;
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
	static exists		   = function(_name) {
		/// @func	exists(name)
		/// @param	{string}  name
		/// @return {boolean} exists?
		///
		return get(_name) != undefined;
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

/// Interface
function IStash() constructor {
	/// @func	IStash()
	/// @return {IStash} self
	///
	__component = other;
		
	static get_stash = function() {
		return __component;
	};
	static get		 = function(_name) {
		return (get_stash()).get(_name);	
	};
	static set		 = function(_name, _value) {
		return (get_stash()).set(_name, _value);	
	};
	static add		 = function(_name, _value) {
		return (get_stash()).add(_name, _value);	
	};
	static remove	 = function(_name) {
		return (get_stash()).remove(_name);	
	};
	static exists	 = function(_name) {
		return (get_stash()).exists(_name);	
	};
	static clear	 = function() {
		return (get_stash()).clear();	
	};
	
	var _stash = __component;
	with (__component.__owner) {
		if (!variable_struct_exists(self, "__stashes")) {
			variable_struct_set(self, "__stashes", undefined);
			__stashes = new Stash({ name: "Stash" });
			
			stash_add		  = function(_stash_name, _stash) {
				return __stashes.add(_stash_name, _stash);
			};
			stash_new		  = function(_stash_name) {
				return __stashes.add(_stash_name, new Stash());
			};
			stash_get		  = function(_stash_name) {
				return __stashes.get(_stash_name);
			};
			stash_exists	  = function(_stash_name) {
				return __stashes.exists(_stash_name);
			};
			stash_item_get	  = function(_stash_name, _item_name) {
				return (stash_get(_stash_name)).get(_item_name);
			};
			stash_item_set	  = function(_stash_name, _item_name, _item_value) {
				return (stash_get(_stash_name)).set(_item_name, _item_value);
			};
			stash_item_add	  = function(_stash_name, _item_name, _item_value) {
				return (stash_get(_stash_name)).add(_item_name, _item_value);
			};
			stash_item_remove = function(_stash_name, _item_name) {
				return (stash_get(_stash_name)).remove(_item_name);
			};
			stash_item_exists = function(_stash_name, _item_name) {
				return (stash_get(_stash_name)).exists(_item_name);
			};
			stash_clear		  = function(_stash_name) {
				return (stash_get(_stash_name)).clear();
			};
				
			stash_add(_stash.get_name(), _stash);
		}
	}
};
