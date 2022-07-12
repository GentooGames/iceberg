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
	variable_struct_set(__owner, __name + "_get",				 method(self, function(_name) {
		return __component.get(_name);
	}));
	variable_struct_set(__owner, __name + "_add",				 method(self, function(_name, _item) {
		return __component.add(_name, _item);
	}));
	variable_struct_set(__owner, __name + "_exists",			 method(self, function(_name) {
		return __component.exists(_name);
	}));
	variable_struct_set(__owner, __name + "_remove",			 method(self, function(_name) {
		return __component.remove(_name);
	}));
	variable_struct_set(__owner, __name + "_clear",				 method(self, function() {
		return __component.clear();
	}));
	variable_struct_set(__owner, __name + "_get_names",			 method(self, function() {
		return __component.get_names();
	}));
	variable_struct_set(__owner, __name + "_get_items",			 method(self, function() {
		return __component.get_items();
	}));
	variable_struct_set(__owner, __name + "_get_items_as_array", method(self, function() {
		return __component.get_items_as_array();
	}));
	variable_struct_set(__owner, __name + "_get_count",			 method(self, function() {
		return __component.get_count();
	}));
};