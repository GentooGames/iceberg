/// Insert Ascii Art Here***

function Class(_config = {}) constructor {
	/// @func	Class(config*)
	/// @param	{struct} config={}
	/// @return {Class}  self
	///
	__config = _config;
	__owner	 = _config[$ "owner" ] ?? other;
	__name	 = _config[$ "name"  ] ?? __get_name_unique();

	#region Private ////////////////
	
	static __get_name_unique = function() {	
		/// @func	__get_name_unique()
		/// @return {string} name
		///
		return instanceof(self) + "_" + string(ptr(self));
	};
	
	#endregion

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
	
	/// ANY CHANGES MADE TO CONFIG STRUCT SHOULD BE UPDATED IN CODE_SNIPPET
};

#region Collections ////////////

function Container(_config = {}) : Class(_config) constructor {
	/// @func	Container(config*)
	/// @param	{struct}	config={}
	/// @return {Container} self
	///
	__owner = other;
	__items = {};
	__names = [];
	__size  = 0;
	
	/// Basic Functionality
	static store  = function(_name, _item) {
		/// @func	store(name, item)
		/// @param	{string}	name
		/// @param	{any}		item
		/// @return {Container} self
		/// 
		/// Add To Existing Entry
		if (has(_name)) {
			var _entry = fetch(_name);
			if (!is_array(_entry)) {
				_entry = [ fetch(_name) ];	
			}
			array_push(_entry, _item);
			__items[$ _name] = _entry;
		}
		/// Create New Entry
		else {
			__items[$ _name] = _item;
			array_push(__names, _name);
			__size++;
		}
		return self;
	};
	static fetch  = function(_name) {
		/// @func	fetch(name)
		/// @param	{string} name
		/// @return {any}    item
		///
		return __items[$ _name];
	};
	static has	  = function(_name) {
		/// @func	has(name)
		/// @param	{string}  name
		/// @return {boolean} exists?
		///
		return fetch(_name) != undefined;
	};
	static remove = function(_name, _item = undefined) {
		/// @func	remove(name, item*)
		/// @param	{string}	name
		/// @param	{any}		item=undefined
		/// @return {Container} self
		///
		if (has(_name)) {
			var _entry = fetch(_name);
			if (_item != undefined && is_array(_entry)) {
				array_find_delete(_entry, _item);
				__items[$ _name] = _entry;
			}
			else {
				variable_struct_remove(__items, _name);
				array_find_delete(__names, _name);
				__size--;		
			}
		}
		return self;
	};
	static empty  = function() {
		/// @func	empty()
		/// @return {Container} self
		///
		__size  = 0;
		__names = [];
		__items = {};
		return self;
	};

	/// Extra Functionality
	static get_size			  = function() {
		/// @func	get_size()
		/// @return {real} size
		///
		return __size;
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
};

#endregion
#region Methods ////////////////

function Method(_config = {}) : Class (_config) constructor {
	/// @func	Method(config*)
	/// @param	{struct} config={}
	/// @return {Method} self
	///
	__method = _config[$ "method"] ?? undefined;
	__data	 = _config[$ "data"  ] ?? undefined;
	
	#region Private ////////
	
	static __method_execute		   = function() {
		/// @func	__method_execute()
		/// @return {any} method_return
		///
		return __method(__data);
	};
	static __method_execute_script = function() {
		/// @func	__method_execute_script()
		/// @return {any} method_return
		///
		return script_execute_ext(__method, __data);
	};
	
	#endregion
	
	static execute = function() {	/// @OVERRIDE
		/// @func	execute()
		/// @return {any} execute_return
		///
		if (is_method(__method)) {
			return __method_execute();	
		}
		return __method_execute_script();
	};
	
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
};
function Action(_config = {}) : Method(_config) constructor {
	/// @func	Action(config*)
	/// @param	{struct} config={}
	/// @return {Action} self
	///
	__triggers = new Container();
		
	static update	   = function() {
		/// @func	update()
		/// @return {Action} self
		///
		var _names = __triggers.get_names();
		for (var _i = 0; _i < __triggers.get_size(); _i++) {
			var _trigger = __triggers.fetch(_names[_i]);
			_trigger.execute();
		}
		return self;
	};
	static execute	   = function() {	/// @OVERRIDE
		/// @func	execute()
		/// @return {any} execute_return
		///
		var _method =  get_method();
		var _return = _method(get_data());
		set_data(undefined);	// <--	wipe data after execution, so that temporarily
								//		set data through action_send_payload() does not 
								//		become persistent.
		var _component = get_owner();
		_component.eventer.broadcast("action_executed_" + get_name());
		
		return _return;
	};
	static trigger_add = function(_name, _method) {
		/// @func	trigger_add(name, method)
		/// @param	{string} name
		/// @param	{method} method
		/// @return {Action} self
		///
		__triggers.store(_name, new Trigger({
			name:	_name, 
			method: _method,
		}));
		
		var _component = get_owner();
		_component.eventer.register(["trigger_executed_" + _name]);
		_component.eventer.listen("trigger_executed_" + _name, method(self, execute));
		
		return self;
	};
		
	var _component = get_owner();
	_component.eventer.register(["action_executed_" + get_name()]);
};
function Trigger(_config = {}) : Method(_config) constructor {
	/// @func	Trigger(config*)
	/// @param	{struct} config={}
	/// @return {Trigger} self
	///
	static execute_super = execute;
	static execute		 = function() {
		/// @func	execute()
		/// @return {any} result
		///
		var _result = execute_super();
		if (_result) {
			var _action	   =  get_owner();
			var _component = _action.get_owner();
			_component.eventer.broadcast("trigger_executed_" + get_name());
		}
		return _result;
	};
};

#endregion

/// MOVE BACK INTO COMPONENTS
function MoveSet(_config = {}) : Class(_config) constructor {
	/// @func	MoveSet(config*)
	/// @param	{struct}  config={}
	/// @return {MoveSet} self
	///
	__moveable	= other;
	__owner		= __moveable.get_owner();
	__config	= _config;
	__speed		= _config[$ "speed"] ?? 0;
	__accel		= _config[$ "accel"] ?? 0;
	__fric		= _config[$ "fric" ] ?? 0;
	__mult		= _config[$ "mult" ] ?? 1;
	
	static set_data = function(_data) {
		/// @func	set_data(data)
		/// @param	{struct}  data
		/// @return {MoveSet} self
		///
		if (_data[$ "speed"] != undefined) __speed = _data.speed;
		if (_data[$ "accel"] != undefined) __accel = _data.accel;
		if (_data[$ "fric" ] != undefined) __fric  = _data.fric;
		if (_data[$ "mult" ] != undefined) __mult  = _data.mult;
		
		return self;
	};
};



























