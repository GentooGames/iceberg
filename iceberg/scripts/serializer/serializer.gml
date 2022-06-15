//_written_by:_//////////////////////////
// .---. r---. .   . .---. .---. .---. //
// |  -. r--   | \ |   |   |   | |   | //
// L---J L---J |   V   |   L---J L---J //
//////////////////////////////////$(º)>//
#region docs, info & configs ////////////
/*
	- handle on_serialize()/on_deserialize() callbacks
	- replace typeof(var) with custom type checker so that we can utilize customly created Translator classes
		- account for possibility that other users will want to extend this class and add their own custom Translators
	- finish Translators for other data types
		- maybe we need to create a new class called SerializerType(var_name, VAR_TYPE.BUFFER)
			- new class would take var_name and an explicitly defined var_type, so that the system doesnt need to try 
			and infer the serialization technique. if no type is declared, then type inference can act as the backup solution.
			- if this is the case, use this method to standardize implementation with all other existing data types
*/
#endregion

function Serializer(_owner = other, _vars) constructor {	
	/// @func  Serializer(owner*, vars)
	/// @param {struct/instance} owner=other
	/// @param {array} vars
	/// @desc  ...
	///
	owner			= _owner;
	on_serialize	=  undefined;
	on_deserialize	=  undefined;
	var_names		= _vars;
	
	/// Core
	static serialize   = function() {
		/// @func	serialize()
		/// @return {json_string} data_serialized
		/// 
		var _data = {};
		for (var _i = 0, _len = array_length(var_names); _i < _len; _i++) {
			var _var_name	   =  var_names[_i];
			var _translator	   =  var_to_translator(_var_name);
			_data[$ _var_name] = _translator.serialize();
			
			///	if (on_serialize != undefined) {
			///		on_serialize(_var, _value);
			///	}
		}
		return json_stringify(_data);
	};
	static deserialize = function(_data_string) {
		/// @func   deserialize(data_string)
		/// @param	{string} data_string
		/// @return {struct} data_loaded
		///
		var _data_out		  = {};
		var _data_struct	  = json_parse(_data_string);
		var _data_string_vars = variable_struct_get_names(_data_struct);
		
		for (var _i = 0, _len = array_length(_data_string_vars); _i < _len; _i++) {
			var _var_name	= _data_string_vars[_i];
			var _var_value  = _data_struct[$ _var_name];
			var _translator =  var_to_translator(_var_name);
			_translator.deserialize(_var_value);
			_data_out[$ _var_name] = _var_value;
			
			//if (on_deserialize != undefined) {
			//	on_deserialize(_var, _value);
			//}
		}
		return _data_out;
	};
	
	/// Extensions
	static set_on_serialize	  = function(_func) {
		/// @func	set_on_serialize(func)
		/// @param	{method/function} func
		/// @return {Serializer}	  self
		/// 
		on_serialize = _func;
		return self;
	};
	static set_on_deserialize = function(_func) {
		/// @func	set_on_deserialize(func)
		/// @param	{method/function} func
		/// @return {Serializer}	  self
		/// 
		on_deserialize = _func;
		return self;
	};
		
	/// Util
	static var_to_translator  = function(_var_name) {
		/// @func	var_to_translator(var_name)
		/// @param	{string} var_name
		/// @return {SerializerTranslator} translator
		///
		
		/// Check If Custom "Lookup" Has Been Defined For var_name
		/// ...
		
		var _instanceof = undefined;
		var _value		= variable_owner_get()(owner, _var_name);
		
		switch (typeof(_value)) {
			case "number":	  _instanceof = SerializerTranslator_Number;	break;
			case "string":	  _instanceof = SerializerTranslator_String;	break;
			case "array":	  _instanceof = SerializerTranslator_Array;		break;
			case "bool":	  _instanceof = SerializerTranslator_Bool;		break;
			case "ptr":		  _instanceof = SerializerTranslator_Ptr;		break;
			case "undefined": _instanceof = SerializerTranslator_Undefined; break;
			case "method":	  _instanceof = SerializerTranslator_Method;	break;
			case "struct":	  _instanceof = SerializerTranslator_Struct;	break;
			//case "int32":	  _instanceof = SerializerTranslator_Int32;		break;
			//case "int64":	  _instanceof = SerializerTranslator_Int64;		break;
			//case "null":	  _instanceof = SerializerTranslator_Null;		break;
			//case "vec3":	  _instanceof = SerializerTranslator_vec3;		break;
			//case "vec4":	  _instanceof = SerializerTranslator_vec4;		break;
		};
		return new _instanceof(owner, _var_name);
	};
	static variable_owner_get = function() {
		/// @func	variable_owner_get()
		/// @return {function} variable_x_get
		///
		if (is_struct(owner)) {
			return variable_struct_get;
		}
		return variable_instance_get;
	};
	static variable_owner_set = function() {
		/// @func	variable_owner_set()
		/// @return {function} variable_x_set
		///
		if (is_struct(owner)) {
			return variable_struct_set;
		}
		return variable_instance_set;
	};
};
////////////////////////////////////////////////////////////////////////////////////////////////////////
function SerializerTranslator(_owner, _name) constructor {
	/// @func	SerializerTranslator(owner, name)
	/// @param	{instance/struct} owner
	/// @param	{string} name
	///
	__serializer =  other;
	__var_owner  = _owner;
	__var_name	 = _name;
	
	/// Core
	static serialize   = function() {
		/// @func serialize()
		///
		return string(get_var_value());
	};
	static deserialize = function(_var_value) {
		/// @func	deserialize(var_value)
		/// @param	{number} var_value
		/// @return {SerializerTranslator} self
		///
		set_var_value(_var_value);
		return self;
	};
		
	/// Getters
	static get_owner	 = function() {
		/// @func	get_owner()
		/// @return {instance/struct} var_owner
		///
		return __var_owner;
	};
	static get_var_name  = function() {
		/// @func	get_var_name()
		/// @return {string} var_name
		///
		return __var_name;
	};
	static get_var_value = function() {
		/// @func	get_var_value()
		/// @return {any} var_value
		///
		var _variable_owner_get = __serializer.variable_owner_get();
		return _variable_owner_get(__var_owner, __var_name);
	};
		
	/// Setters
	static set_var_value = function(_var_value) {
		/// @func	set_var_value(var_value)
		/// @param	{any} var_value
		/// @return {SerializerTranslator} self
		///
		var _variable_owner_set = __serializer.variable_owner_set();
		_variable_owner_set(__var_owner, __var_name, _var_value);
		return self;
	};
};
function SerializerTranslator_Number(_owner, _name) : SerializerTranslator(_owner, _name) constructor {};
function SerializerTranslator_String(_owner, _name) : SerializerTranslator(_owner, _name) constructor {};
function SerializerTranslator_Array(_owner, _name) : SerializerTranslator(_owner, _name) constructor {
	/// ... handle array serialization. account for possibly nested value
};
function SerializerTranslator_Bool(_owner, _name) : SerializerTranslator(_owner, _name) constructor {
	/// ... account for fact that 0 & 1 can be used, but would be interpreted as a number ...
};
function SerializerTranslator_Ptr(_owner, _name) : SerializerTranslator(_owner, _name) constructor {
	/// ... can serialize as a number, but must deserialize as a ptr
};
function SerializerTranslator_Undefined(_owner, _name) : SerializerTranslator(_owner, _name) constructor {};
function SerializerTranslator_Method(_owner, _name) : SerializerTranslator(_owner, _name) constructor {
	/// ... todo ...
};
function SerializerTranslator_Struct(_owner, _name) : SerializerTranslator(_owner, _name) constructor {
	/// ... todo ... account for possible nested values
	/// also, check if we need to handle Constructors differently than anonymous structs
};
////////////////////////////////////////////////////////////////////////////////////////////////////////
function SerializerTranslator_ObjectName(_owner, _name) : SerializerTranslator(_owner, _name) constructor {};
function SerializerTranslator_SpriteName(_owner, _name) : SerializerTranslator(_owner, _name) constructor {};
function SerializerTranslator_PathName(_owner, _name) : SerializerTranslator(_owner, _name) constructor {};
function SerializerTranslator_RoomName(_owner, _name) : SerializerTranslator(_owner, _name) constructor {};
function SerializerTranslator_Surface(_owner, _name) : SerializerTranslator(_owner, _name) constructor {
	/// convert into buffer, and serialize as buffer ...
};
function SerializerTranslator_Buffer(_owner, _name) : SerializerTranslator(_owner, _name) constructor {
	/// buffer_base64_encode() ...
};


/*
	lookup_write = {
		object_index: function(_id) {
			return object_get_name(_id.object_index);
		},
		sprite_index: function(_id) {
			return sprite_get_name(_id.sprite_index);
		},
		image_index:  function(_id) {
			return string(_id.image_index);	
		},
		mask_index:   function(_id) {
			return sprite_get_name(_id.mask_index);	
		},
		path_index:   function(_id) {
			return path_get_name(_id.path_index);	
		},
		room:		  function() {
			return room_get_name(room);
		},
	};
	lookup_read  = {
		object_index: function(_asset_name) {
			return asset_get_index(_asset_name);
		},
		sprite_index: function(_asset_name) {
			return asset_get_index(_asset_name);
		},
		image_index:  function(_asset_name) {
			return real(_asset_name);
		},
		mask_index:   function(_asset_name) {
			return asset_get_index(_asset_name);
		},
		path_index:	  function(_asset_name) {
			return asset_get_index(_asset_name);
		},
		room:		  function(_asset_name) {
			return asset_get_index(_asset_name);
		},
	};
*/















