enum __EXECUTE {
	// ...		
}

function GentuiUtilMethod(_config) constructor {
	/// @func	GentuiUtilMethod(config)
	/// @desc	GentuiUtilMethod is a fairly basic class that contains two primary properties:
	///			a method, and a name. This allows for class encapsulation of a method with an 
	///			associated name property. This is used for Action, Trigger, and State binding
	///			with the Gentui() library, so that previously bound methods can be accessed
	///			and modified with knowledge of just the name.
	/// @param	{struct} config
	/// @return {GentuiUtilMethod} self
	///
	__generate_data(_config);
	
	/// Private ////////////////////////////////////////////////////
	static __generate_name				   = function(_name, _method) {
		/// @func	__generate_name(name, method)
		/// @param	{string} name
		/// @param	{method} method
		/// @return {GentuiUtilMethod} self
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
		/// @return {GentuiUtilMethod} self
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
		/// @return {GentuiUtilMethod} self
		///
		__generate_name(__name, __method);
		return self;
	};
	static __update_data				   = function() {
		/// @func	__update_data()
		/// @return {GentuiUtilMethod} self
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
	
	/// Core ///////////////////////////////////////////////////////
	static execute = function() {
		/// @func	execute()
		/// @return {any} execute_return
		///
		return __method();
	};
	
	/// Getters ////////////////////////////////////////////////////
	static get_owner  = function() {
		/// @func	get_owner()
		/// @return {instance/struct} owner
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
		
	/// Setters ////////////////////////////////////////////////////
	static set_owner  = function(_owner) {
		/// @func	set_owner(owner)
		/// @param	{instance/struct} owner
		/// @return {GentuiUtilMethod} self
		///
		__owner = _owner;
		return self;	
	};
	static set_active = function(_active) {
		/// @func	set_active(active?)
		/// @param	{boolean} active?
		/// @return {GentuiUtilMethod} self
		///
		__active = _active;
		return self;	
	};
	static set_name	  = function(_name) {
		/// @func	set_name(name)
		/// @param	{string} name
		/// @return {GentuiUtilMethod} self
		///
		__name = _name;
		return self;	
	};
	static set_method = function(_method) {
		/// @func	set_method(method)
		/// @param	{method} method
		/// @return {GentuiUtilMethod} self
		///
		__method = _method;
		__update_name();
		return self;
	};
	static set_data	  = function(_data) {
		/// @func	set_data(data)
		/// @param	{any} data
		/// @return {GentuiUtilMethod} self
		///
		__data = _data;
		return self;
	}
};
function GentuiAction(_config) : GentuiUtilMethod(_config) constructor {
	/// @func	GentuiAction(config)
	/// @param	{struct} config
	/// @return {GentuiAction} self
	///
	__triggers = {
		__active:   true,
		__names:    [],
		__count:    0,
		__triggers: {},
	};
	
	static update = function() {
		/// @func	update()
		/// @return {GentuiAction} self
		///
		if (get_active()) {
			update_triggers();
		}
		return self;
	};
		
	#region Triggers ///////////
	
	/// Core ///////////////////////////////////////////////////////////
	static update_triggers	= function() {
		/// @func	update_triggers()
		/// @return	{GentuiAction} self
		///
		var _validated = false;
		with (__triggers) {
			if (__active) {
				for (var _i = 0; _i < __count; _i++) {
					var _name	 = __names[_i];
					var _trigger = __triggers[$ _name];
					if (_trigger.get_active() && _trigger.execute()) {
						_validated = true;
						break;	
					}
				}
			}
		}
		if (_validated) {
			execute();
		}
		return self;
	};
	static add_trigger	    = function(_trigger_name, _trigger_method) {
		/// @func	add_trigger(trigger_name, trigger_method)
		/// @param	{string} trigger_name
		/// @param	{method} trigger_method
		/// @return {GentuiAction} self
		///
		if (!has_trigger(_trigger_name)) {
			with (__triggers) {
				__triggers[$ _trigger_name] = new GentuiTrigger({
					name:	_trigger_name,
					method: _trigger_method,
				});
				array_push(__names, _trigger_name);
				__count++;
			}
		}
		return self;
	};
	static destroy_trigger  = function(_trigger_name) {
		/// @func	destroy_trigger(trigger_name)
		/// @param	{string} trigger_name
		/// @return {GentuiAction} self
		///
		if (has_trigger(_trigger_name)) {
			with (__triggers) {
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
		/// @return {GentuiAction} self
		///
		__triggers = {
			__names:	[],
			__count:	0,
			__triggers: {},
		};
		return self;
	};
	
	/// Getters ////////////////////////////////////////////////////////
	static get_triggers_active = function() {
		/// @func	get_triggers_active()
		/// @return {boolean} are_active?
		///
		return __triggers.__active;
	};
	static get_trigger		   = function(_trigger_name) {
		/// @func	get_trigger(trigger_name)
		/// @param	{string} trigger_name
		/// @return {GentuiTrigger} trigger
		///
		return __triggers.__triggers[$ _trigger_name];
	};
	static get_trigger_active  = function(_trigger_name) {
		/// @func	get_trigger_active(trigger_name)
		/// @param	{string}  trigger_name
		/// @return {boolean} active?
		///
		if (has_trigger(_trigger_name)) {
			return get_trigger(_trigger_name).get_active();
		}
		return false;
		
	};
	static get_trigger_method  = function(_trigger_name) {
		/// @func	get_trigger_method(trigger_name)
		/// @param	{string} trigger_name
		/// @return {method} method
		///
		if (has_trigger(_trigger_name)) {
			return get_trigger(_trigger_name).get_method();
		}
		return undefined;
	};
		
	/// Setters ////////////////////////////////////////////////////////
	static set_triggers_active = function(_active) {
		/// @func	set_triggers_active(active?)
		/// @param	{boolean} active?
		/// @return {GentuiAction} self
		///
		__triggers.__active = _active;
		return self;
	};
	static set_trigger_active  = function(_trigger_name, _active) {
		/// @func	set_trigger_active(trigger_name, active?)
		/// @param	{string}  trigger_name
		/// @param	{boolean} active?
		/// @return {GentuiAction} self
		///
		if (has_trigger(_trigger_name)) {
			get_trigger(_trigger_name).set_active(_active);
		}
		return self;
	};
	static set_trigger_method  = function(_trigger_name, _trigger_method) {
		/// @func	set_trigger_active(trigger_name, active?)
		/// @param	{string} trigger_name
		/// @param	{method} method
		/// @return {GentuiAction} self
		///
		if (has_trigger(_trigger_name)) {
			get_trigger(_trigger_name).set_method(_trigger_method);
		}
		return self;
	};
		
	/// Checkers ///////////////////////////////////////////////////////
	static has_trigger = function(_trigger_name) {
		/// @func	has_trigger(trigger_name)
		/// @param	{string}  trigger_name
		/// @return {boolean} has_trigger?
		///
		return get_trigger(_trigger_name) != undefined;
	};
		
	#endregion
};
function GentuiTrigger(_config) : GentuiUtilMethod(_config) constructor {
	/// @func	GentuiTrigger(config)
	/// @param	{struct} config
	/// @return {GentuiTrigger} self
	///
};
function GentuiState(_config) constructor {
	/// @func	GentuiState(config)
	/// @param	{struct} conig
	/// @return {GentuiState} self
	///
	__owner	   = _config[$ "owner"	 ] ?? other;
	__active   = _config[$ "active"  ] ?? true;
	__name	   = _config[$ "name"    ] ?? undefined;
	__on_enter = _config[$ "on_enter"] ?? undefined;
	__on_loop  = _config[$ "on_loop" ] ?? undefined;
	__on_exit  = _config[$ "on_exit" ] ?? undefined;
	__config   = _config[$ "config"  ] ?? undefined;	// string pointer to associated config
	
	/// Core ///////////////////////////////////
	static update			= function() {
		/// @func	update()
		/// @return {GentuiState} self
		///
		return execute_on_loop();
	};	
	static execute_on_enter = function() {
		/// @func	execute_on_enter()
		/// @return {any} on_enter_return
		///
		if (has_on_enter()) {
			return __on_enter();
		}
		return undefined;
	};
	static execute_on_loop  = function() {
		/// @func	execute_on_loop()
		/// @return {any} execute_on_loop
		///
		if (has_on_loop()) {
			return __on_loop();
		}
		return undefined;
	};
	static execute_on_exit  = function() {
		/// @func	execute_on_exit()
		/// @return {any} on_exit_return
		///
		if (has_on_exit()) {
			return __on_exit();
		}
		return undefined;
	};
	
	/// Getters ////////////////////////////////
	static get_active      = function() {
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
	static get_on_enter	   = function() {
		/// @func	get_on_enter()
		/// @return {method} on_enter
		///
		return __on_enter;
	};
	static get_on_loop	   = function() {
		/// @func	get_on_loop()
		/// @return {method} on_loop
		///
		return __on_loop;
	};
	static get_on_exit	   = function() {
		/// @func	get_on_exit()
		/// @return {method} on_exit
		///
		return __on_exit;
	};
	static get_config_bind = function() {
		/// @func	get_config_bind()
		/// @return {string} config_name
		///
		return __config;
	};
	
	/// Setters ////////////////////////////////
	static set_active	   = function(_active) {
		/// @func	set_active(active)
		/// @param	{boolean} active?
		/// @return {GentuiState} self
		///
		__active = _active;
		return self;
	};
	static set_name		   = function(_name) {
		/// @func	set_name(name)
		/// @param	{string} name
		/// @return {GentuiState} self
		///
		__name = _name;
		return self;
	};
	static set_on_enter	   = function(_on_enter) {
		/// @func	set_on_enter(on_enter)
		/// @param	{method}	  on_enter
		/// @return {GentuiState} self
		///
		__on_enter = _on_enter;
		return self;
	};
	static set_on_loop	   = function(_on_loop) {
		/// @func	set_on_enter(on_loop)
		/// @param	{method}	  on_loop
		/// @return {GentuiState} self
		///
		__on_loop = _on_loop;
		return self;
	};
	static set_on_exit	   = function(_on_exit) {
		/// @func	set_on_enter(on_exit)
		/// @param	{method}	  on_exit
		/// @return {GentuiState} self
		///
		__on_exit = _on_exit;
		return self;
	};
	static set_config_bind = function(_config_name) {
		/// @func	set_config_bind(config_name)
		/// @param	{string} config_name
		/// @return	{GentuiState} self
		///
		__config = _config_name;
		return self;
	};
		
	/// Checkers ///////////////////////////////
	static has_on_enter	= function() {
		/// @func	has_on_enter()
		/// @return	{boolean} has_on_enter?
		///
		return get_on_enter() != undefined;
	};
	static has_on_loop  = function() {
		/// @func	has_on_loop()
		/// @return	{boolean} has_on_loop?
		///
		return get_on_loop() != undefined;
	};
	static has_on_exit  = function() {
		/// @func	has_on_exit()
		/// @return	{boolean} has_on_exit?
		///
		return get_on_exit() != undefined;
	};
};





