//_written_by:_//////////////////////////
// .---. r---. .   . .---. .---. .---. //
// |  -. r--   | \ |   |   |   | |   | //
// L---J L---J |   V   |   L---J L---J //
//////////////////////////////////$(*)>//

function Serializer(_owner = other, _vars) constructor {	
	/// @func  Serializer(owner*, vars)
	/// @param {struct/instance} owner=other
	/// @param {array} vars
	/// @desc  ...
	///
	owner = _owner;
	vars  = _vars;
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
	
 	on_serialize   = undefined;
	on_deserialize = undefined;
	
	/// Core
	static serialize   = function() {
		/// @func	serialize()
		/// @return {json_string} data_serialized
		/// 
		var _data = {};
		for (var _i = 0, _var, _value, _len = array_length(vars); _i < _len; _i++) {
			_var   = vars[_i];
			_value = variable_instance_get(owner, _var);	
			
			/// Check For Lookup Table Translation
			if (_var_name_uses_lookup(_var)) {
				_value = _get_lookup_write_value(_var, owner);
			}
			_data[$ _var] = _value;
			
			if (on_serialize != undefined) {
				on_serialize(_var, _value);
			}
		}
		return json_stringify(_data);
	};
	static deserialize = function(_serialized_string) {
		/// @func   deserialize(serialized_string)
		/// @param  {string} serialized_string
		/// @return {struct} data_loaded
		///
		var _data_out = {};
		var _data_in  = json_parse(_serialized_string);
		
		for (var _i = 0, _var, _value, _len = array_length(vars); _i < _len; _i++) {
			_var   =  vars[_i];
			_value = _data_in[$ _var];	
			
			if (_var_name_uses_lookup(_var)) {
				_value = _get_lookup_read_value(_var, _value);
			}
			_data_out[$ _var] = _value;
			variable_instance_set(owner, _var, _value);
			
			if (on_deserialize != undefined) {
				on_deserialize(_var, _value);
			}
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
	static add_lookup		  = function(_name, _func_write, _func_read, _bind_to_serializer = true) {
		/// @func	add_lookup(name, func_write, func_read, bind_to_serializer?*)
		/// @param  {string}		  name
		/// @param  {method/function} func_write
		/// @param  {method/function} func_read
		/// @param  {boolean}		  bind_to_serializer?=true
		/// @return {Serializer}	  self
		///
		add_lookup_write(_name, _func_write, _bind_to_serializer);
		add_lookup_read (_name, _func_read,  _bind_to_serializer);
		return self;
	};
	static add_lookup_write	  = function(_name, _func_write, _bind_to_serializer = true) {
		/// @func	add_lookup_write(name, func_write, bind_to_serializer?*)
		/// @param  {string}		  name
		/// @param  {method/function} func_write
		/// @param  {boolean}		  bind_to_serializer?=true
		/// @return {Serializer}	  self
		///
		if (_bind_to_serializer) {
			_func_write = method(self, _func_write);	
		}
		variable_struct_set(lookup_write, _name, _func_write);
		return self;
	};
	static add_lookup_read	  = function(_name, _func_read, _bind_to_serializer = true) {
		/// @func	add_lookup_read(name, func_read, bind_to_serializer?*)
		/// @param  {string}		  name
		/// @param  {method/function} func_read
		/// @param  {boolean}		  bind_to_serializer?=true
		/// @return {Serializer}	  self
		///
		if (_bind_to_serializer) {
			_func_read = method(self, _func_read);	
		}
		variable_struct_set(lookup_read, _name, _func_read);
		return self;
	};
		
	/// Util
	static _var_name_uses_lookup   = function(_lookup_name) {
		/// @func   _var_name_uses_lookup(lookup_name)
		/// @param  {string} lookup_name
		/// @return {bool} use_lookup?
		///
		return variable_struct_exists(lookup_write, _lookup_name);	
	};
	static _get_lookup_write_value = function(_lookup_name, _param) {
		/// @func   _get_lookup_write_value(lookup_name, param)
		/// @param  {string} lookup_name
		/// @param  {any} param
		/// @return {any} value
		///
		return lookup_write[$ _lookup_name](_param);		
	};
	static _get_lookup_read_value  = function(_lookup_name, _param) {
		/// @func	_get_lookup_read_value(lookup_name, param)
		/// @param	{string} lookup_name
		/// @param  {any} param
		/// @return {any} value
		///
		return lookup_read[$ _lookup_name](_param); 	
	};
	static _execute_ext_method	   = function(_context = self, _func, _params = undefined) {
		/// @func	_execute_ext_method(context*, func, params*)
	    /// @param	{struct/instance} context=self
	    /// @param	{method/function} func
	    /// @param	{any}			 params=undefined
		/// @return NA
	    ///
	    if (_func == undefined) {
	        throw("script_execute_ext_method() requires a valid script, function, or method reference.\n" + 
	            "func: " + string(_func) + " is undefined.");
	    }
	    if (is_method(_func)) {
	        _func = method_get_index(_func);    
	    }
	    with (_context) {
	        if (_params != undefined) {
	            if (!is_array(_params)) {
	                return _func(_params);
	            }    
	            else return script_execute_ext(_func, _params);    
	        }
	        else return _func();
	    }
	};	
};
