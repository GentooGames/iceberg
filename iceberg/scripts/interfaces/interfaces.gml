//////////////////////////////////////////////////////
//	Interfaces										//					
//		--- ... 									//
//////////////////////////////////////////////////////

function Interface(_component, _owner, _name) constructor {
	/// @func	Interface(component, owner, name)
	/// @param	{constructor} component
	/// @param	{struct}	  owner
	/// @param	{string}	  name
	/// @return {Interface}	  self
	///
	__component = _component;
	__owner		= _owner;
	__name		= _name;
	
	__component.get_interface = method(self, function() {
		return self;
	});
};
function IStash(_component, _owner, _name) : Interface(_component, _owner, _name) constructor {
	/// @func	IStash(component, owner, name)
	/// @param	{constructor} component
	/// @param	{struct}	  owner
	/// @param	{string}	  name
	/// @return {Interface}	  self
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