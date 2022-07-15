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

function Container(_config = {}) : Class(_config) constructor {
	/// @func	Container(config*)
	/// @param	{struct}	config={}
	/// @return {Container} self
	///
	__items = {};
	__names = [];
	__size  = 0;
	
	#region Getters ////////
	
	static get		 = function(_name) {
		/// @func	get(name)
		/// @param	{string} name
		/// @return {any}    item
		///
		return __items[$ _name];
	};
	static get_size	 = function() {
		/// @func	get_size()
		/// @return {real} size
		///
		return __size;
	};
	static get_names = function() {
		/// @func	get_names()
		/// @return {array} names
		/// 
		return __names;
	};
	static get_items = function() {
		/// @func	get_items()
		/// @return {struct} items
		/// 
		return __items;
	};
		
	#endregion
	#region Checkers ///////
	
	static has = function(_name) {
		/// @func	has(name)
		/// @param	{string}  name
		/// @return {boolean} exists?
		///
		return get(_name) != undefined;
	};
		
	#endregion
	
	static add	  = function(_name, _item) {
		/// @func	add(name, item)
		/// @param	{string}	name
		/// @param	{any}		item
		/// @return {Container} self
		/// 
		/// Add To Existing Entry
		if (has(_name)) {
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
			__size++;
		}
		return self;
	};
	static remove = function(_name, _item = undefined) {
		/// @func	remove(name, item*)
		/// @param	{string}	name
		/// @param	{any}		item=undefined
		/// @return {Container} self
		///
		if (has(_name)) {
			var _entry = get(_name);
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
};
function Batch(_config = {}) : Container(_config) constructor {
	/// @func	Batch(config*)
	/// @param	{struct} config={}
	/// @return {Batch}  self
	///
	__empty_on_execute = _config[$ "empty_on_execute"] ?? false;
	
	#region Getters ////////
	
	static get_empty_on_execute = function() {
		/// @func	get_empty_on_execute()
		/// @return {bool} empty_on_execute?
		///
		return __empty_on_execute;
	};
	
	#endregion
	#region Setters ////////
	
	static set_empty_on_execute = function(_empty) {
		/// @func	set_empty_on_execute(empty?)
		/// @param	{bool}  empty?
		/// @return {Batch} self
		///
		__empty_on_execute = _empty;
		return self;
	};
		
	#endregion
	
	static execute = function(_empty_after = false) {
		/// @func	execute(empty_after?*)
		/// @param	{boolean} empty_after=false
		/// @return {Batch}   self
		///
		var _items = get_items();
		var _names = get_names();
		for (var _i = 0, _len = get_size(); _i < _len; _i++) {
			var _name = _names[_i];
			var _item = _items[$ _name];
			_item();
		}
		if (__empty_on_execute || _empty_after) {
			empty();	
		}
		return self;
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
	
	static execute = function() {	/// @OVERRIDE
		/// @func	execute()
		/// @return {any} execute_return
		///
		if (is_method(__method)) {
			return __execute_method();	
		}
		return __execute_method_script();
	};
};
function Action(_config = {}) : Method(_config) constructor {
	/// @func	Action(config*)
	/// @param	{struct} config={}
	/// @return {Action} self
	///
	__triggers = new Container();
		
	#region Core ///////////
	
	static update = function() {
		/// @func	update()
		/// @return {Action} self
		///
		var _names = __triggers.get_names();
		for (var _i = 0; _i < __triggers.get_size(); _i++) {
			var _trigger = __triggers.get(_names[_i]);
			_trigger.execute();
		}
		return self;
	};
	
	#endregion
	
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
	static add_trigger = function(_name, _method) {
		/// @func	add_trigger(name, method)
		/// @param	{string} name
		/// @param	{method} method
		/// @return {Action} self
		///
		__triggers.add(_name, new Trigger({
			name:	_name, 
			method: _method,
		}));
		
		var _component = get_owner();
		_component.eventer.register(["trigger_executed_" + _name]);
		_component.eventer.listen("trigger_executed_" + _name, method(self, execute));
		
		return self;
	};
	
	get_owner().eventer.register(["action_executed_" + get_name()]);
};
function Trigger(_config = {}) : Method(_config) constructor {
	/// @func	Trigger(config*)
	/// @param	{struct} config={}
	/// @return {Trigger} self
	///
	#region Private ////////
	
	static __execute = execute;
	
	#endregion
	
	static execute = function() {
		/// @func	execute()
		/// @return {any} result
		///
		var _result = __execute();
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
	
	#region Setters ////////
	
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
		
	#endregion
};

