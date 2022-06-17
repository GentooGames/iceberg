enum __GENTUI_ACTION_TYPE {
	UPDATE,
	RENDER,
	CUSTOM,
}

function GentuiUtil(_config) constructor {
	/// @func	GentuiUtil(config)
	/// @param	{struct} config
	/// @return {GentuiUtil} self
	///
	__generate_data(_config);
	
	/// Private
	static __generate_name = function(_name, _method) {
		/// @func	__generate_name(name, method)
		/// @param	{string} name
		/// @param	{method} method
		/// @return {string} name
		///
		if (_method == undefined) {
			return "";	
		}
		if (_name == undefined || _name == "") {
			_name  = string(ptr(_method));
		}
		return _name;
	};
	static __generate_data = function(_config) {
		/// @func	__generate_data(config)
		/// @param	{struct} config
		/// @return {GentuiAction} self
		///
		__config = _config;
		__owner	 = _config[$ "owner" ] ?? other;
		__active = _config[$ "active"] ?? true;
		__name	 = _config[$ "name"  ] ?? "";
		__method = _config[$ "method"] ?? undefined;
		__generate_name(__name, __method);
		
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
		/// @return {GentuiAction} self
		///
		__generate_data(_config);
		return self;
	};
	static set_owner   = function(_owner) {
		/// @func	set_owner(owner)
		/// @param	{instance/struct} owner
		/// @return {GentuiAction} self
		///
		__owner = _owner;
		return self;	
	};
	static set_active  = function(_active) {
		/// @func	set_active(active?)
		/// @param	{boolean} active?
		/// @return {GentuiAction} self
		///
		__active = _active;
		return self;	
	};
	static set_name    = function(_name) {
		/// @func	set_name(name)
		/// @param	{string} name
		/// @return {GentuiAction} self
		///
		__name = _name;
		return self;	
	};
	static set_method  = function(_method) {
		/// @func	set_method(method)
		/// @param	{method} method
		/// @return {GentuiAction} self
		///
		__method = _method;
		return self;
	}
};
function GentuiAction(_config) : GentuiUtil(_config) constructor {
	/// @func	GentuiAction(config)
	/// @param	{struct} config
	/// @return {UiTrigger} self
	///
	__triggers		= {};
	__trigger_names = [];
	__trigger_count	= 0;
	
	/// Getters
	static get_trigger = function(_trigger_name) {
		/// @func	get_trigger(trigger_name)
		/// @param	{string} trigger_name
		/// @return {GentuiTrigger} trigger
		///
		return __triggers[$ _trigger_name];
	};
	
	/// Setters
	static set_trigger = function(_trigger_name, _trigger_method) {
		/// @func	set_trigger(trigger_name, trigger_method)
		/// @param	{string} trigger_name
		/// @param	{method} trigger_method
		/// @return {GentuiAction} self
		///
		
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
function GentuiTrigger(_config) : GentuiUtil(_config) constructor {
	/// @func	GentuiTrigger(config)
	/// @param	{struct} config
	/// @return {UiTrigger} self
	///
};
function GentuiState(_config) : GentuiUtil(_config) constructor {
	/// @func	GentuiState(config)
	/// @param	{struct} conig
	/// @return {GentuiState} self
	///
};
