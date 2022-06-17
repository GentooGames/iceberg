function GentuiUtilMethod(_config) constructor {
	/// @func	GentuiUtilMethod(config)
	/// @param	{struct} config
	/// @return {GentuiUtilMethod} self
	///
	__generate_data(_config);
	
	/// Private
	static __generate_name = function(_name, _method) {
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
	static __generate_data = function(_config) {
		/// @func	__generate_data(config)
		/// @param	{struct} config
		/// @return {GentuiUtilMethod} self
		///
		__config = _config;
		__owner	 = _config[$ "owner" ] ?? other;
		__active = _config[$ "active"] ?? true;
		__name	 = _config[$ "name"  ] ?? "";
		__method = _config[$ "method"] ?? undefined;
		__generate_name(__name, __method);
		return self;
	};
	static __update_name   = function() {
		/// @func	__update_name()
		/// @return {GentuiUtilMethod} self
		///
		__generate_name(__name, __method);
		return self;
	};
	static __update_data   = function() {
		/// @func	__update_data()
		/// @return {GentuiUtilMethod} self
		///
		__owner	 = _config[$ "owner" ] ?? __owner;
		__active = _config[$ "active"] ?? __active;
		__name	 = _config[$ "name"  ] ?? __name;
		__method = _config[$ "method"] ?? __method;
		__update_name();
		return self;
	};
	
	/// Getters
	static get_config  = function() {
		/// @func	get_config()
		/// @return {struct} struct
		///
		return __config;	
	};
	static get_owner   = function() {
		/// @func	get_owner()
		/// @return {instance/struct} owner
		///
		return __owner;
	};
	static get_active  = function() {
		/// @func	get_active()
		/// @return {boolean} active
		///
		return __active;
	};
	static get_name	   = function() {
		/// @func	get_name()
		/// @return {string} name
		///
		return __name;
	};
	static get_method  = function() {
		/// @func	get_method()
		/// @return {method} method
		///
		return __method;
	};
		
	/// Setters
	static set_config  = function(_config) {
		/// @func	set_config(config)
		/// @param	{struct} config
		/// @return {GentuiUtilMethod} self
		///
		__config = _config;
		__update_data(_config);
		return self;
	};
	static set_owner   = function(_owner) {
		/// @func	set_owner(owner)
		/// @param	{instance/struct} owner
		/// @return {GentuiUtilMethod} self
		///
		__owner = _owner;
		return self;	
	};
	static set_active  = function(_active) {
		/// @func	set_active(active?)
		/// @param	{boolean} active?
		/// @return {GentuiUtilMethod} self
		///
		__active = _active;
		return self;	
	};
	static set_name    = function(_name) {
		/// @func	set_name(name)
		/// @param	{string} name
		/// @return {GentuiUtilMethod} self
		///
		__name = _name;
		return self;	
	};
	static set_method  = function(_method) {
		/// @func	set_method(method)
		/// @param	{method} method
		/// @return {GentuiUtilMethod} self
		///
		__method = _method;
		__update_name();
		return self;
	}
};
function GentuiAction(_config) : GentuiUtilMethod(_config) constructor {
	/// @func	GentuiAction(config)
	/// @param	{struct} config
	/// @return {GentuiAction} self
	///
	__triggers		= {};
	__trigger_names = [];
	__trigger_count	= 0;
	
	/// Core
	static add_trigger	    = function(_trigger_name, _trigger_method) {
		/// @func	add_trigger(trigger_name, trigger_method)
		/// @param	{string} trigger_name
		/// @param	{method} trigger_method
		/// @return {GentuiAction} self
		///
		if (!has_trigger(_trigger_name)) {
			__triggers[$ _trigger_name] = new GentuiTrigger({
				name:	_trigger_name,
				method: _trigger_method,
			});
			array_push(__trigger_names, _trigger_name);
			__trigger_count++;
		}
		return self;
	};
	static destroy_trigger  = function(_trigger_name) {
		/// @func	destroy_trigger(trigger_name)
		/// @param	{string} trigger_name
		/// @return {GentuiAction} self
		///
		if (has_trigger(_trigger_name)) {
			variable_struct_remove(__triggers, _trigger_name);
			
			/// array_find_delete();
			for (var _i = array_length(__trigger_names) - 1; _i >= 0; _i--) {
				if (__trigger_names[_i] == _trigger_name) {
					array_delete(__trigger_names, _i, 1);
					break;
				}
			}
			__trigger_count--;
		}
		return self;
	};
	static destroy_triggers = function() {
		/// @func	destroy_triggers()
		/// @return {GentuiAction} self
		///
		__triggers		= {};
		__trigger_names = [];
		__trigger_count	= 0;
		return self;
	};
	
	/// Getters
	static get_trigger		  = function(_trigger_name) {
		/// @func	get_trigger(trigger_name)
		/// @param	{string} trigger_name
		/// @return {GentuiTrigger} trigger
		///
		return __triggers[$ _trigger_name];
	};
	static get_trigger_active = function(_trigger_name) {
		/// @func	get_trigger_active(trigger_name)
		/// @param	{string}  trigger_name
		/// @return {boolean} active?
		///
		if (has_trigger(_trigger_name)) {
			return get_trigger(_trigger_name).get_active();
		}
		return false;
		
	};
	static get_trigger_method = function(_trigger_name) {
		/// @func	get_trigger_method(trigger_name)
		/// @param	{string} trigger_name
		/// @return {method} method
		///
		if (has_trigger(_trigger_name)) {
			return get_trigger(_trigger_name).get_method();
		}
		return undefined;
	};
		
	/// Setters
	static set_trigger_active = function(_trigger_name, _active) {
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
	static set_trigger_method = function(_trigger_name, _trigger_method) {
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
		
	/// Checkers
	static has_trigger = function(_trigger_name) {
		/// @func	has_trigger(trigger_name)
		/// @param	{string}  trigger_name
		/// @return {boolean} has_trigger?
		///
		return get_trigger(_trigger_name) != undefined;
	};
};
function GentuiTrigger(_config) : GentuiUtilMethod(_config) constructor {
	/// @func	GentuiTrigger(config)
	/// @param	{struct} config
	/// @return {GentuiTrigger} self
	///
};
function GentuiState(_config) : GentuiUtilMethod(_config) constructor {
	/// @func	GentuiState(config)
	/// @param	{struct} conig
	/// @return {GentuiState} self
	///
};
