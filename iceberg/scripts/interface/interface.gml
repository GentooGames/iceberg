//////////////////////////////////////////////////////
//	Interfaces										//					
//		--- interfaces are pre-defined definitions 	//
//		|	of which methods should be implemented 	//
//		|	in a given object (constructor or 		//
//		|	GameMaker object)						//
//		--- interfaces can contain definitions of	//
//		|	methods that are required and/or 		//
//		|	methods that are optional. required 	//
//		|	methods defined in an interface and not	//
//		|	properly declared in the object will 	//
//		|	cause the game to close on failure, but	//
//		|	methods that are defined as optional in	//
//		|	the interface and not properly declared //
//		|	in the object will not cause the game 	//
//		|	to close, but will log those failures 	//
//		|	into the console.						//
//////////////////////////////////////////////////////

function implements(_interface) {
	/// @func	implements(interface)
	/// @param	{function} interface
	/// @return NA
	///
	return Interface(_interface());
};
function Interface(_methods_struct) {
	/// @func	Interface(methods_struct)
	/// @param	{struct} methods_struct
	/// @return NA
	///
	var _methods_required = _methods_struct[$ "required"] ?? [];
	var _methods_optional = _methods_struct[$ "optional"] ?? [];
	
	/// Optional
	for (var _i = 0, _len = array_length(_methods_optional); _i < _len; _i++) {
		var _method = _methods_optional[_i];
		if (!variable_struct_exists(self, _method)) {
			if (instanceof(self) == "instance") {
				var _error = "<INTERFACE> optional method " + _method + "() not implemented in object " + object_get_name(self.object_index);
			}
			else {
				var _error = "<INTERFACE> optional method " + _method + "() not implemented in constructor " + instanceof(self) + "()";
			}
			log(_error);
		}
	}
	
	/// Required
	for (var _i = 0, _len = array_length(_methods_required); _i < _len; _i++) {
		var _method = _methods_required[_i];
		if (!variable_struct_exists(self, _method)) {
			if (instanceof(self) == "instance") {
				var _error = "<INTERFACE> required method " + _method + "() not implemented in object " + object_get_name(self.object_index);
			}
			else {
				var _error = "<INTERFACE> required method " + _method + "() not implemented in constructor " + instanceof(self) + "()";
			}
			show_message(_error);
			game_end();
		}
	};
};
////////////////////////////////////////////////////////////////
function IIntegral() {
	/// @func	IIntegral()
	/// @return {struct} method_data
	///
	return {
		optional: [
			"setup",
			"teardown",
		],
		required: [
			"update",	
			"render",	
		],
	};
};
function IIntegralComplete() {
	/// @func	IIntegralComplete()
	/// @return {struct} method_data
	///
	return {
		required: [
			"setup",
			"teardown",
			"rebuild",
			"update",	
			"render",	
		],
	};
};
