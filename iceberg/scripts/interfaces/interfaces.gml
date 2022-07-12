//////////////////////////////////////////////////////
//	Interfaces										//					
//		--- ... 									//
//////////////////////////////////////////////////////

function Interface(_config) : Class(_config) constructor {
	/// @func	Interface(config)
	/// @param	{struct}	config
	/// @return {Interface}	self
	///
	__component = _config.component;
	__owner		= _config.owner;
	__name		= _config.name;
	
	static bind_method = function(_method_suffix, _method) {
		/// @func	bind_method(method_suffix, method)
		/// @param	{string}	method_suffix
		/// @param	{method}	method
		/// @return {Interface} self
		///
		variable_struct_set(__owner, __name + "_" + _method_suffix, method(self, _method));
		return self;
	};
	
	__component.get_interface = method(self, function() {
		return self;
	});
};
function IStash(_config) : Interface(_config) constructor {
	/// @func	IStash(config)
	/// @param	{struct}	config
	/// @return {Interface}	self
	///
	bind_method("get",					function(_name) {
		return __component.get(_name);
	});
	bind_method("add",					function(_name, _item) {
		return __component.add(_name, _item);
	});
	bind_method("exists",				function(_name) {
		return __component.exists(_name);
	});
	bind_method("remove",				function(_name) {
		return __component.remove(_name);
	});
	bind_method("clear",				function() {
		return __component.clear();
	});
	bind_method("get_names",			function() {
		return __component.get_names();
	});
	bind_method("get_items",			function() {
		return __component.get_items();
	});
	bind_method("get_items_as_array",	function() {
		return __component.get_items_as_array();
	});
	bind_method("get_count",			function() {
		return __component.get_count();
	});
};