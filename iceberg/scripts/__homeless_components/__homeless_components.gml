function Method(_config = {}) constructor {
	/// @func	Method(config)
	/// @desc	Method is a fairly basic class that contains two primary properties:
	///			a method, and a name. This allows for class encapsulation of a method with an 
	///			associated name property. 
	/// @param	{struct} config
	/// @return {Method} self
	///
	__generate_data(_config);
	
	static execute = function() {	/// @OVERRIDE
		/// @func	execute(data)
		/// @param  {any} data
		/// @return {any} execute_return
		///
		var _method = get_method();
		return _method(get_data());
	};
	
	#region Private ////////
	
	static __generate_name				   = function(_name, _method) {
		/// @func	__generate_name(name, method)
		/// @param	{string} name
		/// @param	{method} method
		/// @return {Method} self
		///
		if (_method == undefined) {
			return "";	
		}
		if (_name == undefined || _name == "") {
			_name  = string(ptr(_method));
		}
		__name = _name;
		return self;
	};
	static __generate_data				   = function(_config) {
		/// @func	__generate_data(config)
		/// @param	{struct} config
		/// @return {Method} self
		///
		__owner	 = _config[$ "owner" ] ?? other;
		__active = _config[$ "active"] ?? true;
		__name	 = _config[$ "name"  ] ?? undefined;
		__method = _config[$ "method"] ?? undefined;
		__data	 = _config[$ "data"  ] ?? undefined;
		__generate_name(__name, __method);
		return self;
	};
	static __update_name				   = function() {
		/// @func	__update_name()
		/// @return {Method} self
		///
		__generate_name(__name, __method);
		return self;
	};
	static __update_data				   = function() {
		/// @func	__update_data()
		/// @return {Method} self
		///
		__owner	 = _config[$ "owner" ] ?? __owner;
		__active = _config[$ "active"] ?? __active;
		__name	 = _config[$ "name"  ] ?? __name;
		__method = _config[$ "method"] ?? __method;
		__data	 = _config[$ "data"  ] ?? __data;
		__update_name();
		return self;
	};
	static __method_execute_no_data		   = function() {
		/// @func	__method_execute_no_data()
		/// @return {any} method_return
		///
		return __method();
	};
	static __method_execute				   = function() {
		/// @func	__method_execute()
		/// @return {any} method_return
		///
		return __method(__data);
	};
	static __method_execute_script_no_data = function() {
		/// @func	__method_execute_script_no_data()
		/// @return {any} method_return
		///
		//return script_execute_
	};
	static __method_execute_script		   = function() {
		/// @func	__method_execute_script()
		/// @return {any} method_return
		///
		return script_execute_ext(__method, __data);
	};
	
	#endregion
	#region Getters ////////
	
	static get_owner  = function() {
		/// @func	get_owner()
		/// @return {struct} owner
		///
		return __owner;
	};
	static get_active = function() {
		/// @func	get_active()
		/// @return {boolean} active
		///
		return __active;
	};
	static get_name	  = function() {
		/// @func	get_name()
		/// @return {string} name
		///
		return __name;
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
		/// @return {Method} self
		///
		__active = _active;
		return self;	
	};
	static set_name	  = function(_name) {
		/// @func	set_name(name)
		/// @param	{string} name
		/// @return {Method} self
		///
		__name = _name;
		return self;	
	};
	static set_method = function(_method) {
		/// @func	set_method(method)
		/// @param	{method} method
		/// @return {Method} self
		///
		__method = _method;
		__update_name();
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
function Action(_config = {}) : Method(_config) constructor {
	/// @func	Action(config)
	/// @param	{struct} config
	/// @return {Action} self
	///
	ITriggerContainer();
		
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
	/// @func	Trigger(config)
	/// @param	{struct} config
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
function TriggerContainer() constructor {
	/// @func	TriggerContainer()
	/// @return {TriggerContainer} self
	///
	__owner		= other;
	__ITriggers = {
		__active:   true,
		__names:    [],
		__count:    0,
		__triggers: {},
	};
	
	static add_trigger	    = function(_trigger_name, _trigger_method) {
		/// @func	add_trigger(trigger_name, trigger_method)
		/// @param	{string} trigger_name
		/// @param	{method} trigger_method
		/// @return {Action} self
		///
		if (!has_trigger(_trigger_name)) {
			var _action = self;
			with (__ITriggers) {
				__triggers[$ _trigger_name] = new Trigger({
					owner:  _action,
					name:	_trigger_name,
					method: _trigger_method,
				});
				array_push(__names, _trigger_name);
				__count++;
			}
			/// Register Trigger PubSub Event
			var _component = get_owner();
			_component.event_register( "trigger_executed_" + _trigger_name);
			_component.event_subscribe("trigger_executed_" + _trigger_name, method(self, execute));
		}
		return self;
	};
	static destroy_trigger  = function(_trigger_name) {
		/// @func	destroy_trigger(trigger_name)
		/// @param	{string} trigger_name
		/// @return {Action} self
		///
		if (has_trigger(_trigger_name)) {
			with (__ITriggers) {
				variable_struct_remove(__triggers, _trigger_name);
			
				/// array_find_delete();
				for (var _i = array_length(__names) - 1; _i >= 0; _i--) {
					if (__names[_i] == _trigger_name) {
						array_delete(__names, _i, 1);
						break;
					}
				}
				__count--;
			}
		}
		return self;
	};
	static destroy_triggers = function() {
		/// @func	destroy_triggers()
		/// @return {Action} self
		///
		__ITriggers = {
			__names:	[],
			__count:	0,
			__triggers: {},
		};
		return self;
	};
	static update_triggers	= function() {
		/// @func	update_triggers()
		/// @return {Action} self
		///
		with (__ITriggers) {
			if (__active) {
				for (var _i = 0; _i < __count; _i++) {
					var _name	 = __names[_i];
					var _trigger = __triggers[$ _name];
					if (_trigger.get_active()) {
						_trigger.execute();
					}
				}
			}
		}
		return self;
	};
	
	#region Getters ////////////
		
	static get_triggers_active = function() {
		/// @func	get_triggers_active()
		/// @return {boolean} are_active?
		///
		return __ITriggers.__active;
	};
	static get_trigger		   = function(_trigger_name) {
		/// @func	get_trigger(trigger_name)
		/// @param	{string} trigger_name
		/// @return {Trigger} trigger
		///
		return __ITriggers.__triggers[$ _trigger_name];
	};
	static get_trigger_active  = function(_trigger_name) {
		/// @func	get_trigger_active(trigger_name)
		/// @param	{string}  trigger_name
		/// @return {boolean} active?
		///
		if (has_trigger(_trigger_name)) {
			return (get_trigger(_trigger_name)).get_active();
		}
		return false;
	};
	static get_trigger_method  = function(_trigger_name) {
		/// @func	get_trigger_method(trigger_name)
		/// @param	{string} trigger_name
		/// @return {method} method
		///
		if (has_trigger(_trigger_name)) {
			return (get_trigger(_trigger_name)).get_method();
		}
		return undefined;
	};
	static get_trigger_data	   = function(_trigger_name) {
		/// @func	get_trigger_data(trigger_name)
		/// @param	{string} trigger_name
		/// @return {method} method
		///
		if (has_trigger(_trigger_name)) {
			return (get_trigger(_trigger_name)).get_data();
		}
		return undefined;
	};
		
	#endregion
	#region Setters	////////////
		
	static set_triggers_active = function(_active) {
		/// @func	set_triggers_active(active?)
		/// @param	{boolean} active?
		/// @return {Action} self
		///
		__ITriggers.__active = _active;
		return self;
	};
	static set_trigger_active  = function(_trigger_name, _active) {
		/// @func	set_trigger_active(trigger_name, active?)
		/// @param	{string}  trigger_name
		/// @param	{boolean} active?
		/// @return {Action} self
		///
		if (has_trigger(_trigger_name)) {
			(get_trigger(_trigger_name)).set_active(_active);
		}
		return self;
	};
	static set_trigger_method  = function(_trigger_name, _trigger_method) {
		/// @func	set_trigger_active(trigger_name, trigger_method)
		/// @param	{string} trigger_name
		/// @param	{method} method
		/// @return {Action} self
		///
		if (has_trigger(_trigger_name)) {
			(get_trigger(_trigger_name)).set_method(_trigger_method);
		}
		return self;
	};
	static set_trigger_data	   = function(_trigger_name, _trigger_data) {
		/// @func	set_trigger_data(trigger_name, trigger_data)
		/// @param	{string} trigger_name
		/// @param	{method} method
		/// @return {Action} self
		///
		if (has_trigger(_trigger_name)) {
			(get_trigger(_trigger_name)).set_data(_trigger_data);
		}
		return self;
	};
		
	#endregion
	#region Checkers ///////////
		
	static has_trigger = function(_trigger_name) {
		/// @func	has_trigger(trigger_name)
		/// @param	{string}  trigger_name
		/// @return {boolean} has_trigger?
		///
		return get_trigger(_trigger_name) != undefined;
	};
			
	#endregion
	
	var _self = self;
	with (__owner) {
		trigger_container_add_trigger = method(_self, function(_trigger_name, _trigger_method) {
			return add_trigger(_trigger_name, _trigger_method);
		});
	}
};
