#region Collections ////////////

function Stash(_name, _init_interface = true) constructor {
	/// @func	Stash(name, init_interface?)
	/// @param	{string}  name
	/// @param	{boolean} init_interface=true
	/// @return {Stash}   self
	///
	__owner	= other;
	__name	= _name;
	__items	= {};
	__names	= [];
	__count	= 0;
	
	if (_init_interface) {
		__interface = new IStash(self, __owner, __name);
	}
	
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
#region Methods ////////////////

function Method(_config = {}) constructor {
	/// @func	Method(config*)
	/// @param	{struct} config={}
	/// @return {Method} self
	///
	__config = _config;
	__owner  = _config[$ "owner" ] ?? other;
	__active = _config[$ "active"] ?? true;
	__method = _config[$ "method"] ?? undefined;
	__data	 = _config[$ "data"  ] ?? undefined;
	__name	 = _config[$ "name"  ] ?? __get_name_unique();
	
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
	static __get_name_unique	   = function() {
		/// @func	__get_name_unique()
		/// @return {string} name
		///
		return instanceof(self) + "_" + string(ptr(self));
	};
	
	#endregion
	
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
	
	#region Getters ////////
	
	static get_owner  = function() {
		/// @func	get_owner()
		/// @return {struct} owner
		///
		return __owner;
	};
	static get_active = function() {
		/// @func	get_active()
		/// @return {boolean} active?
		///
		return __active;
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
	static get_name   = function() {
		/// @func	get_name()
		/// @return {string} name
		///
		return __name;
	};
		
	#endregion
	#region Setters ////////
	
	static set_owner  = function(_owner) {
		/// @func	set_owner(owner)
		/// @param	{struct} owner
		/// @return {Method} self
		///
		__owner = _owner;
		return self;
	};
	static set_active = function(_active) {
		/// @func	set_active(active?)
		/// @param	{boolean} active?
		/// @return {Method}  self
		///
		__active = _active;
		return self;
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
	static set_name   = function(_name) {
		/// @func	set_name(name)
		/// @param	{string} name
		/// @return {Method} self
		///
		__name = _name;
		return self;
	};
		
	#endregion
};
function Action(_config = {}) : Method(_config) constructor {
	/// @func	Action(config*)
	/// @param	{struct} config={}
	/// @return {Action} self
	///
	///ITrigger();
		
	/// Register Trigger PubSub Event
	var _component = get_owner();
	_component.event_register( "action_executed_" + get_name());
	
	static update  = function() {
		/// @func	update()
		/// @return {Action} self
		///
		if (get_active()) {
			update_triggers();
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
		_component.event_publish("action_executed_" + get_name(), self);
		
		return _return;
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
			_component.event_publish("trigger_executed_" + get_name());
		}
		return _result;
	};
};

#endregion