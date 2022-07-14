/// Insert Ascii Art Here***

function Class(_config = {}) constructor {
	/// @func	Class(config*)
	/// @param	{struct} config={}
	/// @return {Class}  self
	///
	__config = _config;
	__owner	 = _config[$ "owner" ] ?? other;
	__active = _config[$ "active"] ?? true;
	__name	 = _config[$ "name"  ] ?? get_name_unique();

	#region Getters ////////
	
	static get_owner	   = function() {
		/// @func	get_owner()
		/// @return {struct} owner
		///
		return __owner;
	};
	static get_active	   = function() {
		/// @func	get_active()
		/// @return {boolean} active?
		///
		return __active;
	};
	static get_name		   = function() {
		/// @func	get_name()
		/// @return {string} name
		///
		return __name;
	};
	static get_name_unique = function() {	
		/// @func	get_name_unique()
		/// @return {string} name
		///
		return instanceof(self) + "_" + string(ptr(self));
	};
	
	#endregion
	#region Setters	////////
	
	static set_owner  = function(_owner) {
		/// @func	set_owner(owner)
		/// @param	{instance/struct} owner
		/// @return {Component}	  self
		///
		__owner = _owner;
		return self;
	};
	static set_active = function(_active) {
		/// @func	set_active(active?)
		/// @param	{boolean}	active?
		/// @return {Component} self
		///
		__active = _active;
		return self;
	};
	static set_name   = function(_name) {
		/// @func	set_name(name)
		/// @param	{string}	name
		/// @return {Component} self
		///
		__name = _name;
		return self;
	};
		
	#endregion
	#region Checkers ///////
	
	static is_active = function() {
		/// @func	is_active()
		/// @return {boolean} is_active?
		///
		return get_active();
	};
	
	#endregion
	
	/// ANY CHANGES MADE TO CONFIG STRUCT SHOULD BE UPDATED IN CODE_SNIPPET
};

#region Collections ////////////

function Stash(_config = {}) : Class(_config) constructor {
	/// @func	Stash(config*)
	/// @param	{struct} config={}
	/// @return {Stash}  self
	///
	__items = {};
	__names = [];
	__size  = 0;
	
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
			__size++;
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
				__size--;		
			}
		}
		return self;
	};
	static clear			  = function() {
		/// @func	clear()
		/// @return {Stash} self
		///
		__size  = 0;
		__names = [];
		__items = {};
		return self;
	};
	static get				  = function(_name) {
		/// @func	get(name)
		/// @param	{string} name
		/// @return {any}    item
		///
		return __items[$ _name];
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
	static get_size			  = function() {
		/// @func	get_size()
		/// @return {real} size
		///
		return __size;
	};
};

#endregion
#region Methods ////////////////

function Method (_config = {}) : Class (_config) constructor {
	/// @func	Method(config*)
	/// @param	{struct} config={}
	/// @return {Method} self
	///
	__method = _config[$ "method"] ?? undefined;
	__data	 = _config[$ "data"  ] ?? undefined;
	
	static execute = function() {	/// @OVERRIDE
		/// @func	execute(data)
		/// @param  {any} data
		/// @return {any} execute_return
		///
		if (is_method(__method)) {
			return __method_execute();	
		}
		return __method_execute_script();
	};
	
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
};
function Action (_config = {}) : Method(_config) constructor {
	/// @func	Action(config*)
	/// @param	{struct} config={}
	/// @return {Action} self
	///
	__triggers = new Stash();
	
	/// Register Trigger PubSub Event
	var _component = get_owner();
	_component.eventer.register(["action_executed_" + get_name()]);
	
	static update  = function() {
		/// @func	update()
		/// @return {Action} self
		///
		if (is_active()) {
			if (__triggers.is_active()) {
				var _names = __triggers.get_names();
				var _size  = __triggers.get_size();
				for (var _i = 0; _i < _size; _i++) {
					var _trigger = __triggers.get(_names[_i]);
					if (_trigger.is_active()) {
						_trigger.execute();
					}
				}
			}
		}
		return self;
	};
	static execute = function() {	/// @OVERIDE
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
	
	triggers_add   = function(_name, _method) {	/// @OVERRIDE
		/// @func	triggers_add(name, method)
		/// @param	{string} name
		/// @param	{method} method
		/// @return {Action} self
		///
		__triggers.add(_name, new Trigger({
			name:	_name, 
			method: _method,
		}));
		/// Register Trigger PubSub Event
		var _component = get_owner();
		_component.eventer.register(["trigger_executed_" + _name]);
		_component.eventer.listen("trigger_executed_" + _name, method(self, execute));
		return self;
	};
};
function Trigger(_config = {}) : Method(_config) constructor {
	/// @func	Trigger(config*)
	/// @param	{struct} config={}
	/// @return {Trigger} self
	///
	static execute_super = execute;
	static execute		 = function() {
		/// @func	execute(data)
		/// @param  {any} data
		/// @return {any} execute_return
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

