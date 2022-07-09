#region system /////////////

function do_every_frame(_interval) {
	/// @func   do_every_frame(interval)
	/// @param  interval -> {real}
	/// @desc   conditional check for if the current frame interval has been triggered.
	/// @return do_this_frame -> {bool}
	/// @tested false
	///
	return (CURRENT_FRAME % _interval == 0);
}

#region DYNAMIC GETTERS AND SETTERS
/*
function System() constructor {
    static __Param = function(_name, _val) constructor {
        name = _name;
        val = {
            init: _val,
            curr: _val,
        };
        static get = function() {
            return val.curr;        
        };
        static set = function(_val) {
            val.curr = _val;
        };
        static reset = function() {
            val.curr = val.init;
        };
    };
    
    __params = {};
    static add_param = function(_name, _val) {
        __params[$ _name] = new __Param(_name, _val);
        
        var _system = self;
        var _bridge = {
            param_name: _name,
            system: _system,
        };
        
        // Add getter:
        var _getter_name = "get_" + _name;
        self[$ _getter_name] = method(_bridge, function() {
            return system.__params[$ param_name].get();
        });
        
        // Add setter:
        var _setter_name = "set_" + _name;
        self[$ _setter_name] = method(_bridge, function(_val) {
            system.__params[$ param_name].set(_val);
            return system;
        });
        
        // Add resetter:
        var _resetter_name = "reset_" + _name;
        self[$ _resetter_name] = method(_bridge, function() {
            system.__params[$ param_name].reset();
            return system;
        });
        
        return self;
    };
};
*/
#endregion

#endregion
#region unit tests /////////

function objects_count() {
	/// @func	objects_count()
	/// @desc	...
	/// @return struct -> { object_index_0: instance_number_0, object_index_n, instance_number_n }
	/// @tested false
	///
	var _return_data	= {};
	var _object_indexes = resource_tree_get_objects();
	for (var _i = 0, _len = array_length(_object_indexes); _i < _len; _i++) {
		var _object_index = _object_indexes[_i];
		var _object_name  = object_get_name(_object_index);
		var _object_count = instance_number(_object_index);
		_return_data[$ _object_name] = _object_count;
	}
	return _return_data;
};
function objects_count_equal(_object_count_1, _object_count_2) {
	/// @func	objects_count_equal(object_count_1, object_count_2)
	/// @param	object_count_1 -> {struct}
	/// @param	object_count_2 -> {struct}
	/// @desc	...
	/// @return equals? -> {bool}
	/// @tested false
	///
	var _return_data = { 
		equals: true, 
		data:	{} 
	};
	var _object_indexes = resource_tree_get_objects();
	for (var _i = 0, _len = array_length(_object_indexes); _i < _len; _i++) {
		var _object_index = _object_indexes[_i];
		var _object_name  = object_get_name(_object_index);
		var _value_1	  = _object_count_1[$ _object_name];
		var _value_2	  = _object_count_2[$ _object_name];
		if (_value_1 != _value_2) {
			_return_data.equals = false;
			_return_data.data   = {
				object_index: _object_index,
				count_delta:  abs( _value_2 - _value_1),
				count_sign:   sign(_value_2 - _value_1),
			};
			break;
		}
	}
	return _return_data;
};
function log_objects_number(_prefix_msg = "") {
	/// @func	log_objects_number(prefix_msg*<"">)
	/// @param	prefix_msg -> {string}
	/// @desc	Log the number of key instances that exist to console. Mostly used for unit_testing.
	/// @return NA
	///
	static _instances = [
		{ msg: "n_boards",	data: obj_board  },
		{ msg: "n_cursors", data: obj_cursor },
		{ msg: "n_tiles",	data: obj_tile   },
		{ msg: "n_units",	data: obj_unit   },
	];
	var _output = "";
	for (var _i = 0, _len = array_length(_instances); _i < _len; _i++) {
		var _instance  = _instances[_i];
		var _substring = _instance.msg + ": " + string(instance_number(_instance.data));
		if (_i != _len - 1) _substring += ",";
		_output += " " + _substring;
	}
	log("<NUMBER_OF_OBJECTS> " + _prefix_msg + "- " + _output);
};

#endregion
#region array_3d ///////////

function array_3d_get_width(_array) {
	/// @func	array_3d_get_width(array)
	/// @param	array -> {array_3d}
	/// @desc	...
	/// @return width -> {real}
	/// @tested false
	///
	return array_length(_array);
};
function array_3d_get_length(_array) {
	/// @func	array_3d_get_length(array)
	/// @param	array -> {array_3d}
	/// @desc	...
	/// @return length -> {real}
	/// @tested false
	///
	return array_length(_array[0]);
};
function array_3d_get_height(_array) {
	/// @func	array_3d_get_height(array)
	/// @param	array -> {array_3d}
	/// @desc	...
	/// @return height -> {real}
	/// @tested false
	///
	return array_length(_array[0][0]);
};
function array_3d_get_at_index(_array, _i, _j, _k) {
	/// @func	array_3d_get_at_index(array, coord)
	/// @param	array -> {array_3d}
	/// @param	i	  -> {real}
	/// @param	j	  -> {real}
	/// @param	k	  -> {real}
	/// @desc	...
	/// @return value -> {any}
	/// @tested false
	/// 
	return _array[_i][_j][_k];
};
function array_3d_insert_at_index(_array, _i, _j, _k, _value) {
	/// @func	array_3d_insert_at_index(array, i, j, k, value)
	/// @param	array -> {array_3d}
	/// @param	i	  -> {real}
	/// @param	j	  -> {real}
	/// @param	k	  -> {real}
	/// @param	value -> {any}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	_array[_i][_j][_k] = _value;
	return _array;
};
function array_3d_index_in_bounds(_array, _i, _j, _k) {
	/// @func	array_3d_index_in_bounds(array, i, j, k) 
	/// @param	array -> {array_3d}
	/// @param	i	  -> {real}
	/// @param	j	  -> {real}
	/// @param	k	  -> {real}
	/// @desc	...
	/// @return in_bounds? -> {bool}
	/// @tested false
	///
	return (
			(_i >= 0 && _i < array_3d_get_width (_array))
		&&	(_j >= 0 && _j < array_3d_get_length(_array))
		&&	(_k >= 0 && _k < array_3d_get_height(_array))
	);
};
function array_3d_upsize(_array, _width, _length, _height) {
	/// @func	array_3d_upsize(array, width, length, height)
	/// @param	array  -> {array_3d}
	/// @param	width  -> {real}
	/// @param	length -> {real}
	/// @param	height -> {real}
	/// @desc	...
	/// @return array -> {array_3d}
	/// @tested false
	///
	var _insert;
	var _new_grid = array_create_nd(_width, _length, _height);
	for (var _i = 0; _i < _width; _i++) {
		for (var _j = 0; _j < _length; _j++) {
			for (var _k = 0; _k < _height; _k++) {
				_insert = EMPTY;
				if (array_3d_index_in_bounds(_array, _i, _j, _k)) {
					_insert = _array[_i][_j][_k];
				}
				array_3d_insert_at_index(_new_grid, _i, _j, _k, _insert);
			}
		}
	}
	return _new_grid;
};
function array_3d_downsize(_array, _width, _length, _height) {
	/// @func	array_3d_downsize(array, width, length, height)
	/// @param	array  -> {array_3d}
	/// @param	width  -> {real}
	/// @param	length -> {real}
	/// @param	height -> {real}
	/// @desc	...
	/// @return array -> {array_3d}
	/// @tested false
	///
	var _new_grid = array_create_nd(_width, _length, _height);
	for (var _i = 0; _i < _width; _i++) {
		for (var _j = 0; _j < _length; _j++) {
			for (var _k = 0; _k < _height; _k++) {
				array_3d_insert_at_index(_new_grid, _i, _j, _k, _array[_i][_j][_k]);
			}
		}
	}
	return _new_grid;
};

#endregion
#region arrays /////////////

function array_get_random(_array) {
	/// @func   array_get_random(array)
	/// @param  array -> {array}
	/// @desc   return a random value stored in the given array.
	/// @return value -> {any}
	/// @tested false
	///
	if (array_length(_array) <= 0) return undefined;
	var _index = irandom(array_length(_array) - 1);
	var _value = _array[_index];
	return _value;
};
function array_peek_bottom(_array) {
	/// @func   array_peek_bottom(array)
	/// @param  array -> {array}
	/// @desc   return the last element of the given array.
	/// @return value -> {any}
	/// @tested false
	///
	var _n_items  = array_length(_array);
	if (_n_items == 0) return undefined;
	//
	return _array[_n_items - 1];	
};
function array_index_in_bounds(_array, _index) {
	/// @func   array_index_in_bounds(array, index)
	/// @param  array -> {array}
	/// @param  index -> {real}
	/// @desc   check if a given index is in-bounds of the given array
	/// @return in_bounds -> {bool}
	/// @tested false
	///
	var _n_elements  = array_length(_array);
	if (_n_elements == 0) return false;
	return (_index >= 0 && _index <= _n_elements - 1);
};
function array_create_nd() {
	/// @func   array_create_nd(size1, size2,...)
	/// @param  size_1	 -> {real}
	/// @param  size_... -> {real}
	/// @param	size_n   -> {real}
	/// @desc   create an array of n-dimensions.
	/// @return array -> {array}
	/// @tested false
	///
    if (argument_count == 0) return EMPTY;
    var _array = array_create(argument[0], EMPTY);
	var _args  = array_create(argument_count - 1, EMPTY);
    var _i	   = 0;
        
	repeat (argument_count - 1) {
        _args[_i] = argument[_i + 1];
        _i++;
    }
    _i = 0; 
	repeat (argument[0]) {
        _array[@ _i] = script_execute_ext(array_create_nd, _args);
        _i++;
    }
    return _array;
};
function array_is_empty(_array) {
	/// @func   array_is_empty(array)
	/// @param  array -> {array}
	/// @desc   check if a given array has any entries stored in it.
	/// @return is_empty -> {bool}
	/// @tested false
	///
	return array_length(_array) == 0;	
};
function array_find_delete(_array, _value) {
	/// @func   array_find_delete(array, value)
	/// @param  array -> {array}
	/// @param  value -> {any}
	/// @desc   search an array for a value, and remove it from the array.
	/// @return did_delete? -> {bool}
	/// @tested false
	///
	for (var _i = 0, _len = array_length(_array); _i < _len; _i++) {
		if (_array[_i] == _value) {
			array_delete(_array, _i, 1);	
			return true;
		}
	}
	return false;
};
function array_find_delete_all(_array, _value) {
	/// @func   array_find_delete_all(array, value)
	/// @param  array -> {array}
	/// @param  value -> {any}
	/// @desc   search an array for a value, and remove all of them from the array.
	/// @return n_entries_deleted -> {real}
	/// @tested false
	///
	var _count = 0;
	for (var _i = array_length(_array) - 1; _i >= 0; _i--) {
		if (_array[_i] == _value) {
			array_delete(_array, _i, 1);	
			_count++;
		}
	}
	return _count;
};
function array_find_index(_array, _value) {
	/// @func	array_find_index(array, value)
	/// @param	array -> {array}
	/// @param	value -> {any}
	/// @return index -> {real}
	/// @tested false
	///
	for (var _i = 0, _len = array_length(_array); _i < _len; _i++) {
		if (_array[_i] == _value) {
			return _i;	
		}
	}
	return -1;
};
function array_reverse(_array) {
	/// @func   array_reverse(array)
	/// @param  array -> {array}
	/// @desc   reverse the order of entries in an array.
	/// @return array -> {array}
	/// @tested false
	///
	var _reversed = [];
	for (var _i = array_length(_array) - 1; _i >= 0; _i--) {
		array_push(_reversed, _array[_i]);
	}
	_array = _reversed;
	return _array;
};	
function array_contains(_array, _entry) {
	/// @func   array_contains(array, entry)
	/// @param  array -> {array}
	/// @param  entry -> {any}
	/// @desc   check if an entry exists within a given array.
	/// @return contains -> {bool}
	/// @tested false
	///
	for (var _i = 0, _len = array_length(_array); _i < _len; _i++) {
		if (_array[_i] == _entry) {
			return true;	
		}
	}
	return false;
};
function array_operate_on(_array, _use_entry_as_context, _callback, _data) {
	/// @func	array_operate_on(array, use_entry_as_context, callback, data*)
	/// @param	array				  -> {array} 
	/// @param	use_entry_as_context? -> {bool}
	/// @param	callback			  -> {function}
	/// @param	callback_data		  -> {struct}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (_use_entry_as_context) {
		for (var _i = 0, _len = array_length(_array); _i < _len; _i++) {
			with (_array[_i]) {
				if (_data == undefined) {
					 _callback();
				}
				else _callback(_data);
			}
		}		
	}
	else {
		for (var _i = 0, _len = array_length(_array); _i < _len; _i++) {
			_callback(_array[_i]);
		}		
	}
};
function for_array(_array, _cb, _cb_data) {
	/// @func	for_array(array, callback, cb_data)
	/// @param	array	 -> {array}
	/// @param	callback -> {function}
	/// @param	cb_data	 -> {any}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	for (var _i = 0, _n = array_length(_array); _i < _n; _i++) {
		_cb(_array[_i], _cb_data);
	}
};

#endregion
#region ds_lists ///////////

function ds_list_index_in_bounds(_ds_list, _index) {
	/// @func   ds_list_index_in_bounds(ds_list, index)
	/// @param  ds_list -> {ds_list}
	/// @param  index	-> {real}
	/// @desc   check if a given index is in bounds of a given list.
	/// @return in_bounds -> {bool}
	/// @tested false
	///
	return (_index >= 0 && _index < ds_list_size(_ds_list));	
};
function ds_list_pop(_ds_list) {
	/// @func   ds_list_pop(ds_list)
	/// @param  ds_list -> {ds_list}
	/// @desc   remove and return the first entry of a ds_list.
	/// @return value   -> {real}
	/// @tested false
	///
	if (ds_list_size(_ds_list) <= 0) return undefined;
	var _val = _ds_list[| 0];
	ds_list_delete(_ds_list, 0);
	return _val;
};
function ds_list_peek(_ds_list) {
	/// @func   ds_list_peek(ds_list)
	/// @param  ds_list -> {ds_list}
	/// @desc   return the first entry stored in a ds_list.
	/// @return entry -> {any}
	/// @tested false
	///
	if (ds_list_size(_ds_list) <= 0) return undefined;
	var _val = _ds_list[| 0];	
	return _val;
};
function ds_list_find_delete(_ds_list, _value) {
	/// @func   ds_list_find_delete(ds_list, value)
	/// @param  ds_list -> {ds_list}
	/// @param  value   -> {any}
	/// @desc   search a ds_list for a value, and remove it.
	/// @return did_delete? -> {bool}
	/// @tested false
	///
	var _pos = ds_list_find_index(_ds_list, _value);
	if (_pos != -1) {
		ds_list_delete(_ds_list, _pos);
		return true;
	}
	return false;
};
function ds_list_add_unique(_ds_list, _value) {
	/// @func   ds_list_add_unique(ds_list, value)
	/// @param  ds_list -> {ds_list}
	/// @param	value   -> {any}
	/// @desc   try to add a value, 
	/// @return did_add? -> {bool}
	/// @tested false
	///
	var _pos = ds_list_find_index(_ds_list, _value);
	if (_pos == -1) {
		ds_list_add(_ds_list, _value);	
		return true;
	}
	return false;
};
function ds_list_add_struct_unique_key(_ds_list, _struct, _key) {
	/// @func   ds_list_add_struct_unique_key(ds_list, struct, key)
	/// @param  ds_list	-> {ds_list}
	/// @param  struct	-> {struct}
	/// @param  key		-> {real/string}
	/// @desc   ...
	/// @return NA
	/// @tested false
	///
	var _value = variable_struct_get(_struct, _key);
	var _found = false;
	for (var _i = 0, _len = ds_list_size(_ds_list); _i < _len; _i++) {
		if (variable_struct_get(_ds_list[| _i], _key) == _value) {
			_found = true;
			break;
		}
	}
	if (!_found) ds_list_add(_ds_list, _struct);	
};
function ds_list_count_entry(_ds_list, _value) {
	/// @func   ds_list_count_entry(ds_list, value)
	/// @param  ds_list -> {ds_list}
	/// @param  value   -> {any}
	/// @desc   return a total number of entries that appear in a given list.
	/// @return count -> {real}
	/// @tested false
	///
	var _count  = 0;
	for (var _i = 0, _len = ds_list_size(_ds_list); _i < _len; _i++) {
		if (_ds_list[| _i] == _value) {
			_count++;	
		}
	} 
	return _count;
};
function ds_list_count_not_entry(_ds_list, _value) {
	/// @func   ds_list_count_not_entry(ds_list, value)
	/// @param  ds_list -> {ds_list}
	/// @param  value   -> {real}
	/// @desc   return the number of entries in a list that are not equal to the given value.
	/// @return count -> {real}
	/// @tested false
	///
	var _count  = 0;
	for (var _i = 0, _len = ds_list_size(_ds_list); _i < _len; _i++) {
		if (_ds_list[| _i] != _value) _count++;	
	}
	return _count;
};

#endregion
#region ds_grids ///////////

function ds_grid_index_in_bounds(_ds_grid, _i, _j) {
	/// @func   ds_grid_index_in_bounds(ds_grid, i, j)
	/// @param  ds_grid -> {ds_grid}
	/// @param  i		-> {real}
	/// @param  j		-> {real}
	/// @desc   check if a given i,j coordinate position is inside the bounds of a ds_grid.
	/// @return in_bounds -> {bool}
	/// @tested false
	///
	return (
			_i >= 0 && _i < ds_grid_width(_id) 
		&&	_j >= 0 && _j < ds_grid_height(_id)
	);
};

#endregion
#region structs ////////////

function struct_has(_struct, _var_name) {
	/// @func	struct_has(struct, var_name)
	/// @param	struct		-> {struct}
	/// @param	var_name	-> {string}
	/// @desc	...
	/// @return var_exists? -> {bool}
	/// @tested false
	///
	return variable_struct_exists(_struct, _var_name);
}
function structs_have_same_names(_struct_1, _struct_2) {
	/// @func	structs_have_same_names(struct_1, struct_2)
	/// @param	{struct}  struct_1
	/// @param	{struct}  struct_2
	/// @return {boolean} same_names?
	///
	var _struct_1_vars	 = variable_struct_get_names(_struct_1);
	var _struct_2_vars	 = variable_struct_get_names(_struct_2);
	var _n_struct_2_vars = array_length(_struct_2_vars);
	
	for (var _i = 0, _len = array_length(_struct_1_vars); _i < _len; _i++) {
		var _struct_1_var = _struct_1_vars[_i];	
		
		var _found_match =  false;
		for (var _j = 0; _j < _n_struct_2_vars; _j++) {
			var _struct_2_var  = _struct_2_vars[_j];
			if (_struct_2_var == _struct_1_var) {
				_found_match = true;
				break;
			}
		}
		if (!_found_match) return false;
	}
	return true;	
};
function struct_get_random_weighted(_data) {
	/// @func   struct_get_random_weighted(data_array)
	/// @param  data -> {data}
	/// @desc   data is an array of structs, where "chance" is a defined value indicating the weight.
	/// @return value -> {real}
	/// @tested false
	///
	var _total_chance = 0;
	for (var _i = 0, _len = array_length(_data); _i < _len; _i++) {
		_total_chance += _data[_i].chance;
	}
	var _rand = random(_total_chance);
	var _total_chance = 0;
	
	for (var _i = 0, _len = array_length(_data); _i < _len; _i++) {
		_total_chance += _data[_i].chance;
		if (_total_chance > _rand) {
			return _data[_i];
			break;
		}
	}
	return _data[irandom(array_length(_data) - 1)];
};

#endregion
#region buffers ////////////

function struct_to_buffer_encoded_compressed(_struct) {
	/// @func   struct_to_buffer_encoded_compressed(struct)
	/// @param  {struct} struct
	/// @return {buffer} buffer_encoded_compressed
	///
	var _json_string    = json_stringify(_struct);
	var _encoded_string = base64_encode(_json_string);
	var _buffer_size    = string_length(_encoded_string);
	var _buffer		    = buffer_create(_buffer_size, buffer_fixed, 1);
	buffer_write(_buffer, buffer_text, _encoded_string);

	/// Compress Buffer
	var _buffer_compressed = buffer_compress(_buffer, 0, _buffer_size);

	/// Cleanup
	buffer_delete(_buffer);
	
	return _buffer_compressed;
};
function struct_save_to_buffer(_struct, _filename) {
	/// @func   struct_save_to_buffer(struct, filename)
	/// @param  {struct} struct
	/// @param  {string} filename
	/// @return NA
	///
	var _buffer_compressed = struct_to_buffer_encoded_compressed(_struct);
	var _compressed_size   = buffer_get_size(_buffer_compressed);
	buffer_save(_buffer_compressed, _filename);

	/// Cleanup
	buffer_delete(_buffer_compressed);
};
function struct_load_from_buffer(_filename) {
	/// @func  struct_load_from_buffer(filename)
	/// @param filename
	///
	if (!file_exists(_filename)) {
		throw("filename: " + string(_filename) + " does not exist!");	
	}
	var _buffer_compressed = buffer_load(_filename);

	/// Decompress Buffer
	var _buffer_encoded = buffer_decompress(_buffer_compressed);
	var _string_encoded = buffer_read(_buffer_encoded, buffer_text);

	/// Decode Buffer
	var _buffer_decoded = buffer_base64_decode(_string_encoded);
	var _data_string	= buffer_read(_buffer_decoded, buffer_text);
	var _data_struct	= json_parse(_data_string);

	/// Cleanup
	buffer_delete(_buffer_decoded);
	buffer_delete(_buffer_compressed);
	buffer_delete(_buffer_encoded);
	
	return _data_struct;
};
function buffer_compressed_encoded_to_struct(_buffer, _destroy_buffer = true) {
	/// @func   buffer_compressed_encoded_to_struct(buffer, destroy_buffer?*)
	/// @param  {buffer} buffer
	/// @param  {bool}   destroy_buffer=true
	/// @return {struct} struct
	///
	/// Decompress Buffer
	var _buffer_encoded = buffer_decompress(_buffer);
	var _string_encoded = buffer_read(_buffer_encoded, buffer_text);

	/// Decode Buffer
	var _buffer_decoded = buffer_base64_decode(_string_encoded);
	var _data_string	= buffer_read(_buffer_decoded, buffer_text);
	var _data_struct	= json_parse(_data_string);

	/// Cleanup
	buffer_delete(_buffer_decoded);
	buffer_delete(_buffer_encoded);
	if (_destroy_buffer) {
		buffer_delete(_buffer);	
	}
	return _data_struct;
};

#endregion
#region objects ////////////

function events_user() {
	/// @func	events_user(numb1, ..., numbN)
	/// @param	{real} numb1
	/// @param	{real} ...
	/// @param	{real} numbN
	/// @return NA
	///
	for (var _i = 0; _i < argument_count; _i++) {
		event_user(argument[_i]);	
	}
};
function animation_ended(_sprite_index = sprite_index, _image_index = image_index, _image_speed = image_speed, _image_number = image_number) {
	/// @func   animation_ended(sprite_index*, image_index*, image_speed*, image_number*)
	/// @param	sprite_index -> {sprite_index}
	/// @param	image_index	 -> {real}
	/// @param	image_speed	 -> {real}
	/// @param	image_number -> {real}
	/// @desc   check to see if the current animation has ended.
	/// @return animation_ended -> {bool}
	/// @tested false
	///
	return (_image_index + _image_speed * sprite_get_speed(_sprite_index) / (sprite_get_speed_type(_sprite_index) == spritespeed_framespergameframe ? 1 : game_get_speed(gamespeed_fps)) >= _image_number);	
};

#endregion
#region instances //////////

function instance_nth_nearest(_x, _y, _obj, _n, _priority) {
	/// @func   instance_nth_nearest(x, y, obj, n, priority_list)
	/// @param  x	-> {real}
	/// @param  y	-> {real}
	/// @param  obj -> {object}
	/// @param  n	-> {real}
	/// @param  priority_list -> {ds_priority}
	/// @desc   find the nth instance nearest a given point. this utilized a ds_priority.
	/// @return instance -> {instance}
	/// @tested false
	///
	var _count	 = min(max(1, _n), instance_number(_obj));
	var _nearest = undefined;
	ds_priority_clear(_priority);
	with (_obj) ds_priority_add(_priority, self.id, distance_to_point(_x, _y)); 
	repeat (_count) _nearest = ds_priority_delete_min(_priority); 
	return _nearest;
};

#endregion
#region paths //////////////

function path_sprite_index_to_image_index(_path_index) {
	/// @func   path_sprite_index_to_image_index(path_index)
	/// @param  path_index -> {real}
	/// @desc   used with directional moving cursor sprite to get the proper index based off dir
	/// @return image_index -> {real}
	/// @tested false
	///
	if (player.entity_selected == undefined) return 8;
	if (_path_index == undefined) return 7;
	if (_path_index == 0) return 7;
	
	var _path_cells	= player.entity_selected.get_path_cells();
	var _n_cells	= array_length(_path_cells);
	var _cell		= _path_cells[_path_index];
	
	var _cell_next	= (_path_index + 1 < _n_cells) 
		? _path_cells[_path_index + 1
		] : undefined;
		
	var _cell_prev	= (_path_index - 1 >= 0) 
		? _path_cells[_path_index - 1] 
		: get_cell(player.entity_selected.i, player.entity_selected.j);
		
	if (_cell_next == undefined) return 0;
	
	var _dir_prev = board.get_cells_dir_relative(_cell_prev, _cell);
	var _dir_next = board.get_cells_dir_relative(_cell, _cell_next);
	
	if (_dir_prev == DIR.UP	   && _dir_next == DIR.UP)	  return 1;
	if (_dir_prev == DIR.DOWN  && _dir_next == DIR.DOWN)  return 1;
	if (_dir_prev == DIR.RIGHT && _dir_next == DIR.RIGHT) return 2;
	if (_dir_prev == DIR.LEFT  && _dir_next == DIR.LEFT)  return 2;
	if (_dir_prev == DIR.RIGHT && _dir_next == DIR.DOWN)  return 3;
	if (_dir_prev == DIR.UP	   && _dir_next == DIR.LEFT)  return 3;
	if (_dir_prev == DIR.UP	   && _dir_next == DIR.RIGHT) return 4;
	if (_dir_prev == DIR.LEFT  && _dir_next == DIR.DOWN)  return 4;
	if (_dir_prev == DIR.LEFT  && _dir_next == DIR.UP)	  return 5;
	if (_dir_prev == DIR.DOWN  && _dir_next == DIR.RIGHT) return 5;
	if (_dir_prev == DIR.DOWN  && _dir_next == DIR.LEFT)  return 6;
	if (_dir_prev == DIR.RIGHT && _dir_next == DIR.UP)	  return 6;
	return 7;
};
function path_end_all(_instance = self) {	 	
	/// @func   path_end_all(instance*)
	/// @param  {struct} instance=self
	/// @return NA
	///
	with (_instance) {
		path_end();
		path_clear_points(path);
		path_position = 0;
	}
};
function path_set_smooth(_path, _smooth) {
	/// @func   path_set_smooth(path, smooth)
	/// @param  path   -> {path}
	/// @param  smooth -> {bool}
	/// @desc   container function for better wording on path_set_kind()
	/// @return NA
	/// @tested false
	///
	path_set_kind(_path, _smooth);	
};
function path_start_default(_move_speed) {
	/// @func   path_start_default(move_speed)
	/// @param  move_speed -> {real}
	/// @desc   shorthand container function for path_start(...).
	/// @return NA
	/// @tested false
	///
	path_start(path, _move_speed, path_action_stop, false);	
};
function path_empty(_path) {
	/// @func	path_empty(path)
	/// @param	{path_index} path
	/// @return {boolean} is_empty?
	///
	return path_get_number(_path) == 0;
};

#endregion
#region collisions /////////

function collision_rectangle_bbox(_object, _precise, _notme, _padding = 0) {	 
	/// @func   collision_rectangle_bbox(object, precise?, notme?, padding*<0>)
	/// @param  object   -> {object}
	/// @param  precise  -> {bool}
	/// @param  notme    -> {bool}
	/// @param  padding  -> {real} | optional<0>
	/// @desc   containerized function for default collision_rectangle check based off bbox.
	/// @return instance -> {instance}
	/// @tested false
	///
	return collision_rectangle(
		bbox_left  - _padding, bbox_top	   - _padding, 
		bbox_right + _padding, bbox_bottom + _padding, 
		_object, _precise, _notme
	);
};
function collision_rectangle_list_bbox(_object, _precise, _notme, _list, _ordered, _padding = 0) {
	/// @func   collision_rectangle_list_bbox(object, precise?, notme?, list, ordered?, padding*<0>)
	/// @param  object   -> {object}
	/// @param  precise  -> {bool}
	/// @param  notme    -> {bool}
	/// @param  list     -> {ds_list}
	/// @param  ordered  -> {bool}
	/// @param  padding  -> {real} | optional<0>
	/// @desc   containerized function for default collision_rectangle_list check based off bbox.
	/// @return instance -> {instance}
	/// @tested false
	///
	return collision_rectangle_list(
		bbox_left  - _padding, bbox_top	   - _padding, 
		bbox_right + _padding, bbox_bottom + _padding, 
		_object, 
		_precise, 
		_notme, 
		_list, 
		_ordered
	);
};

#endregion
#region resource tree //////

function resource_tree_get_objects() {
	/// @func	resource_tree_get_objects()
	/// @return {array} object_indexes
	///
	var _objects = [];
	for (var _object = 0; _object < 1000000; _object++) {
		if (!object_exists(_object)) {
			return _objects;	
		}
		array_push(_objects, _object);
	};
	return _objects;
};
function resource_tree_get_object_parents() {
	/// @func	resource_tree_get_object_parents()
	/// @return {array} object_indexes
	///
	var _parents = [];
	var _unique  = {};	// used so that duplicates are not stored
	
	for (var _object = 0; _object < 1000000; _object++) {
		if (!object_exists(_object)) {
			return _parents;	
		}
		var _parent  = object_get_parent(_object);
		if (_parent != -1 && _parent != -100) {
			if (_unique[$ object_get_name(_parent)] == undefined) {
				_unique[$ object_get_name(_parent)] = _parent;
				array_push(_parents, _parent);		
			}
		}
	};
	return _parents;
};	

#endregion
#region sprites ////////////

function sprite_get_true_width(_sprite_index) {
	/// @func   sprite_get_true_width(sprite_index)
	/// @param  sprite_index -> {sprite}
	/// @desc   get the sprites width based off of the sprites baked bounding boxes.
	/// @return width		 -> {real}
	/// @tested false
	///
	return (sprite_get_bbox_right(_sprite_index) - sprite_get_bbox_left(_sprite_index));	
};
function sprite_get_true_height(_sprite_index) {	 
	/// @func   sprite_get_true_height(sprite_index)
	/// @param  sprite_index -> {sprite}
	/// @desc   get the sprites height based off of the sprites baked bounding boxes.
	/// @return width -> {real}
	///
	return (sprite_get_bbox_bottom(_sprite_index) - sprite_get_bbox_top(_sprite_index));	
};
function sprite_stretch(_xscale = 1, _yscale = _xscale) {
	/// @func   sprite_stretch(image_<xy>scale, image_<y>scale*)
	/// @param  image_xscale
	/// @param  image_yscale
	/// @desc   apply a slight offset to the sprite x & yscale.
	/// @return NA
	/// @tested false
	///
	if (sign(image_xscale) == -1) {
		_xscale = -abs(_xscale);	
	}
	image_xscale = _xscale;
	image_yscale = abs(_yscale);
};
function sprite_stretch_step() {
	/// @func   sprite_stretch_step()
	/// @desc   place in object's step event whenever using sprite_stretch() function.
	/// @return NA
	/// @tested false
	///
	image_xscale = lerp(image_xscale, xscale_base * facing, 0.3);
	image_yscale = lerp(image_yscale, yscale_base, 0.3);
};
function sprite_stretch_reset() {
	/// @func   sprite_stretch_reset()
	/// @desc   reset the sprites image_xscale and image_yscale back to their base value.
	/// @return NA
	/// @tested false
	///
	image_xscale = xscale_base * facing;
	image_yscale = yscale_base;
};
function sprite_update(_sprite_array, _dir, _face) {
	/// @func	sprite_update(sprite_array, dir, face)
	/// @param	sprite_array -> {array}
	/// @param	dir 		 -> {dir_enum}
	/// @param	face		 -> {face_enum}
	/// @desc	...
	/// @return sprite_index -> {real}
	/// @tested false
	///
	var _sprite;
	switch (_face) {
		case FACE.FRONT: {
			_sprite = _sprite_array[0];
		}
		case FACE.BACK: {
			_sprite = _sprite_array[1];
		}
	}
	sprite_index = _sprite;
	image_xscale = scale * _face;
	image_yscale = abs(image_yscale);
	return _sprite;
};

#endregion
#region draw ///////////////
	
function draw_sprite_alt(_spr = sprite_index, _subimg = image_index, _x = x, _y = y, _xscale = image_xscale, _yscale = image_yscale, _ang = image_angle, _c = image_blend, _a = image_alpha) {
	/// @func	draw_sprite_alt(sprite*, subimg*, x*, y*, xscale*, yscale*, angle*, color*, alpha*)
	/// @param	sprite_index -> {sprite_index}
	/// @param	image_index	 -> {image_index}
	/// @param	x			 -> {real}
	/// @param	y			 -> {real}
	/// @param	xscale		 -> {real}
	/// @param	yscale		 -> {real}
	/// @param	angle		 -> {real}
	/// @param	color		 -> {color}
	/// @param	alpha		 -> {real}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	draw_sprite_ext(_spr, _subimg, _x, _y, _xscale, _yscale, _ang, _c, _a);		
};
function draw_rectangle_alt(_x, _y, _width, _height, _rot, _col, _alpha) {
	/// @func   draw_rectangle_alt(x, y, width, height, rot, col, alpha)
	/// @param  x	   -> {real} 
	/// @param  y	   -> {real} 
	/// @param  width  -> {real} 
	/// @param  height -> {real} 
	/// @param  rot	   -> {real} 
	/// @param  color  -> {color} 
	/// @param  alpha  -> {real}
	/// @desc   draw a rectangle using a 1 pixel sprite: spr_white, this does not introduce a batch break.
	/// @return NA
	/// @tested false
	///
	draw_sprite_ext(__spr_pixel_white, 0, _x, _y, _width, _height, _rot, _col, _alpha);	
};
function draw_rectangle_width_color(_x1, _y1, _x2, _y2, _width, _color) {	 
	/// @func   draw_rectangle_width_color(x1, y1, x2, y2, width, color)
	/// @param  x1	  -> {real}
	/// @param  y1	  -> {real}
	/// @param  x2	  -> {real}
	/// @param  y2	  -> {real}
	/// @param  width -> {real}
	/// @param  color -> {color}
	/// @desc   a function designed to extend GMs draw_rectangle_color. This is a pretty low
	///			perfomance solution though.
	/// @return NA
	/// @tested false
	///
	draw_set_color(_color);
	draw_line_width(_x1, _y1, _x2, _y1, _width);
	draw_line_width(_x2, _y1, _x2, _y2, _width);
	draw_line_width(_x1, _y2, _x2, _y2, _width);
	draw_line_width(_x1, _y1, _x1, _y2, _width);
	draw_set_color(c_white);
};
function draw_circle_curve(_x, _y, _radius, _precision, _angle_start, _angle_end, _thickness, _outline, _alpha = undefined) {
	/// @func   draw_circle_curve(x, y, radius, precision, angle_start, angle_end, thickness, outline?, alpha*)
	/// @desc   extended functionality to allow more advanced circle drawing options.
	/// @param  x			-> {real}
	/// @param  y			-> {real}
	/// @param  radius		-> {real}
	/// @param  precision	-> {real}
	/// @param  angle_start	-> {angle}
	/// @param  angle_end	-> {angle}
	/// @param  thickness	-> {real}
	/// @param  outline		-> {bool}
	/// @param  alpha		-> {real}
	/// @return NA
	///
	static _precision_min = 3;
	_precision = max(_precision_min, _precision);
	
	var _angle_iter	   = _angle_end / _precision;
	var _len_perimeter = _radius + (_thickness * 0.5);
	var _len_middle	   = _radius - (_thickness * 0.5);
	var _angle		   = _angle_start + _angle_end;
	var _dist_perimeter, _dist_middle;
	
	if (_alpha != undefined) {
		draw_set_alpha(_alpha);
	}
	
	if (_outline) {
		draw_primitive_begin(pr_trianglestrip);
		draw_vertex(_x + lengthdir_x(_len_middle, _angle_start), _y + lengthdir_y(_len_middle, _angle_start));

		for (var i = 1; i <= _precision; i += 1) {
			_dist_perimeter = _angle_start    + _angle_iter * i;
			_dist_middle	= _dist_perimeter - _angle_iter;
			draw_vertex(_x + lengthdir_x(_len_perimeter, _dist_middle),		_y + lengthdir_y(_len_perimeter, _dist_middle));
			draw_vertex(_x + lengthdir_x(_len_middle,	 _dist_perimeter),	_y + lengthdir_y(_len_middle,	 _dist_perimeter));
		}
		draw_vertex(_x + lengthdir_x(_len_perimeter, _angle), _y + lengthdir_y(_len_perimeter, _angle));
		draw_vertex(_x + lengthdir_x(_len_middle, _angle), _y + lengthdir_y(_len_middle, _angle));
	}
	else {
		draw_primitive_begin(pr_trianglefan);
		draw_vertex(_x, _y);

		for (i = 1; i <= _precision; i += 1) {
			_dist_perimeter = _angle_start	  + _angle_iter * i;
			_dist_middle	= _dist_perimeter - _angle_iter;
			draw_vertex(_x + lengthdir_x(_len_perimeter, _dist_middle), _y + lengthdir_y(_len_perimeter, _dist_middle));
		}
		draw_vertex(_x + lengthdir_x(_len_perimeter, _angle), _y + lengthdir_y(_len_perimeter, _angle));
	}	
	draw_primitive_end();
	
	if (_alpha != undefined) {
		draw_set_alpha(1.0);
	}
};

#endregion
#region color //////////////

function colors_merge(_color1, _color2, _amount) {
	/// @func	colors_merge(color1, color2, amount)
	/// @param	{color} color1
	/// @param	{color} color2
	/// @param	{real}  amount
	/// @return {color} color_merged
	///
	return merge_color(_color1, _color2, _amount);	
};
function colors_pulse(_color1, _color2, _duration, _offset = 0) {
	/// @func	colors_pulse(color1, color2, duration, offset*)   
	/// @param  {color} color1	
	/// @param  {color} color2	
	/// @param  {real}  duration
	/// @param	{real}  offset=0
	/// @return {color} color	
	///
	return merge_color(_color1, _color2, wave(0, 1, _duration, _offset));
};

#endregion
#region strings ////////////

function log(_format) {
	/// @func	log(_format, params, ...)
	/// @desc	Logs to console using string format and arguments (allows 19 different arguments)
	/// @param	{string} format The string format.
	/// @param	{*...} params The values to append
	/// @return NA
	/// @tested false
	/// @usage
	/*
	log("{0} this is my {1}", "Hello", "World");
	log("Print numbers: {0} and strings '{1}'", 124, "World");
	log("Arrays {0} and structs {1}", [1, 2, 3], { hello: "world" });
	*/
	if (!LOGGING) return;
	///
	var _params = array_create(argument_count);
	for (var i = 0; i < argument_count; i++) {
		_params[i] = argument[i];
	}
	var _output = script_execute_ext(string_build, _params);
	show_debug_message("[" + string(current_time) + "]: " + _output);
};
function string_build(_format) {
	/// @func	string_build(_format, params, ...)
	/// @desc	Builds a string using string format and arguments (allows 19 different arguments)
	/// @param	{string} format The string format.
	/// @param	{*...} params The values to append
	/// @return	output -> {string}
	/// @tested false
	///
	static _paramIDs = ["{0}",	"{1}",	"{2}",	"{3}",	"{4}",	"{5}",	"{6}",	"{7}",	"{8}",	"{9}",
						"{10}", "{11}", "{12}", "{13}", "{14}", "{15}", "{16}", "{17}", "{18}", "{19}"];
						
	var _output = _format, _count = argument_count - 1;
	repeat (_count) {
		var _argument = argument[_count];
		var _argumentString = is_string(_argument) ? _argument : string(_argument);
		_output = string_replace_all(_output, _paramIDs[--_count], _argumentString);
	}
	return _output;
};
function string_contains(_string, _sub) {	 
	/// @func   string_contains(string, substring)
	/// @param  string	  -> {string} 
	/// @param  substring -> {string} 
	/// @desc   check if a string contains the 
	/// @return contains  -> {bool}
	/// @tested false
	///
	return (string_pos(_sub, _string) != 0);
};
function string_key() {
	/// @func	string_key(var1*, ..., varn*)
	/// @param	var* -> {any}
	/// @return key  -> {string}
	/// @tested false
	/// 
	var _string = "";
	for (var _i = 0; _i < argument_count; _i++) {
		_string += string(argument[_i]);
		if (_i < argument_count - 1) {
			_string += "_";
		}
	};
	return _string;
};
function string_parse_into_struct(_string, _substrings, _delineator) {
	/// @func	string_parse_into_struct(string, substrings, delineator)
	/// @param	{string} string
	/// @param	{array}	 substrings
	/// @param	{string} delineator
	///
	var _char;
	var _data  = {};
	var _value = "";
	var _index = 0;
		
	for (var _i = 1, _len = string_length(_string) + 1; _i <= _len; _i++) {
		_char = string_char_at(_string, _i);
			
		if (_char == _delineator || _i == _len) {
			_data[$ _substrings[_index]] = _value;
			_value = "";
			_index++;
		}
		else {
			_value += _char;
		}
	}
	return _data;		
};

#endregion
#region surfaces ///////////

function surface_ensure(_surface, _width, _height) {
	/// @func   surface_ensure(surface, width, height)
	/// @param  surface	-> {surface}
	/// @param  width	-> {real}
	/// @param  height	-> {real}
	/// @desc   containerized functionality to handle ensuring a surface exists before drawing to it
	/// @return surface -> {surface}
	/// @tested false
	///
	if (_surface == undefined || !surface_exists(_surface)) {
		_surface = surface_create(_width, _height);	
	}
	return _surface;
};
function surface_catch(_surf, _w, _h, _cb = function() {}, _cb_data) {
	/// @func	surface_catch(surface, width, height, callback, callback_data)
	/// @param	surface		  -> {surface}
	/// @param	width		  -> {real}
	/// @param	height		  -> {real}
	/// @param	callback	  -> {function}
	/// @param	callback_data -> {any}
	/// @desc	...
	/// @return surface	-> {surface}
	/// @tested false
	///
	if (!surface_exists(_surf)) {
		_surf = surface_create(_w, _h);
		_cb(_surf, _cb_data);
	}	
	return _surf;
};
	
#endregion
#region maths //////////////

function percent(_percent) {
	/// @func   percent(percent)
	/// @param  percent -> {real}
	/// @desc   check if a given percentage rolls true.
	/// @return rolled_true -> {bool}
	/// @tested false
	///
	return (random(100) < _percent);
};
function avg() {
	/// @func   avg(element*, ...*)
	/// @param  element_1 -> {real}
	/// @param  element_n -> {real}
	/// @desc   given n elements, compute the average value of them.
	/// @return avg -> {real}
	/// @tested false
	///
	var _n   = argument_count;
	var _avg = 0;
	
	for (var _i = 0; _i < _n; _i++) {
		_avg += argument[_i];
	}
	return (_avg / _n);
};
function wrap(_val, _min, _max) {
	/// @func   wrap(val, min, max)
	/// @param  val -> {real}
	/// @param  min -> {real}
	/// @param  max -> {real}
	/// @desc   given a value, return it's wrapped value confined to given min & max.
	/// @return val -> {real}
	/// @tested false
	///
	return ((_val > _max) ? _min : (_val < _min ? _max : _val));
};
function plot_line(_i1, _j1, _i2, _j2) {
	/// @func   plot_line(i1, j1, i2, j2)
	/// @param  i1	   -> {real}
	/// @param  j1	   -> {real}
	/// @param  i2	   -> {real}
	/// @param  j2	   -> {real}
	/// @desc   using Bresenham's Line Algorithm (https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm)
	///			get the grid coordinates that fall within that plotted line.
	/// @return coords -> {array}
	/// @tested false
	///
	var _di  = abs(_i2 - _i1);
	var _si  = _i1 < _i2 ? 1 : -1;
	var _dj  = -abs(_j2 - _j1);
	var _sj  = _j1 < _j2 ? 1 : -1;
	var _err = _di + _dj;
	var _coords = [];

	while (true) {
		array_push(_coords, { i: _i1, j: _j1 });
		if (_i1 == _i2 && _j1 == _j2) break;
		
		var _e2  = _err * 2;
		if (_e2 >= _dj) {
			_err += _dj;
			_i1  += _si;
		}
		if (_e2 <= _di) {
			_err += _di;
			_j1  += _sj;
		}
	}
	return _coords;
};
function ilerp(_min, _max, _value) {
	/// @func	ilerp(min, max, value)
	/// @param	min   -> {real}
	/// @param	max   -> {real}
	/// @param	value -> {real}
	/// @desc	pass a value in that exists between min and max, and get a mapped value between 0 - 1.
	/// @return t -> {real}
	/// @tested false
	///
	return (_value - _min) / (_max - _min);
};
function remap(_input_min, _input_max, _output_min, _output_max, _value) {
	/// @func	remap(input_min, input_max, output_min, output_max, value)
	/// @param	input_min  -> {real}
	/// @param	input_max  -> {real}
	/// @param	output_min -> {real}
	/// @param	output_max -> {real}
	/// @param	value	   -> {real}
	/// @desc	...
	/// @return value -> {real}
	/// @tested false
	/// 
	var _t = ilerp(_input_min, _input_max, _value);
	return lerp(_output_min, _output_max, _t);
};
function rotate_around(_rot, _amount, _max) {
	/// @func	rotate_around(rot, amount, max)
	/// @param	rot    -> {angle}
	/// @param	amount -> {angle}
	/// @param	max    -> {angle}
	/// @desc	...
	/// @return rot -> {angle}
	/// @tested false
	///
	var _target = _rot + _amount;
	while (_target < 0) {
		_target += 360;
	}
	return _target % _max;
};
function bresenham_line(_i1, _j1, _i2, _j2, _cb, _cb_data) {
	/// @func	bresenham_line()
	/// @param	i1			  -> {int}
	/// @param	j1			  -> {int}
	/// @param	i2			  -> {int}
	/// @param	j2			  -> {int}
	/// @param	callback	  -> {func}
	/// @param	callback_data -> {any}
	/// @desc	...
	/// @return NA
	/// @tested false
	///
    var _dist_x		= _i2 - _i1; 
	var _dist_y		= _j2 - _j1; 
    var _step_x		= sign(_dist_x);
    var _step_y		= sign(_dist_y);
    _dist_x			= abs(_dist_x);
    _dist_y			= abs(_dist_y);
    var _dist		= max(_dist_x, _dist_y);
    var _remainder	= _dist / 2;
	
    if (_dist_x > _dist_y) {
        for (var _i = 0; _i <= _dist; _i++) {
            _cb(_i1, _j1, _cb_data);
            
			_i1 += _step_x;
            _remainder += _dist_y;
			
            if (_remainder >= _dist_x) {
                _j1 += _step_y;
                _remainder -= _dist_x;
            }
        }
    }
    else for (var _i = 0; _i <= _dist; _i++) {
        _cb(_i1, _j1, _cb_data);
		
        _j1 += _step_y;
        _remainder += _dist_x;
		
        if (_remainder >= _dist_y) {
            _i1 += _step_x;
            _remainder -= _dist_y;
        }
    }
};
function wave(_from, _to, _duration, _offset) { 
	/// @func   wave(from, to, duration, offset)
	/// @param  from	 -> {real}
	/// @param  to		 -> {real} 
	/// @param  duration -> {real} 
	/// @param  offset   -> {real}
	/// @desc   simulate sin wave motion between two points over a given duration.
	/// @return value -> {real}
	/// @tested false
	///
	var _a4 = (_to - _from) * 0.5;
	return _from + _a4 + sin((((current_time * 0.001) + _duration * _offset) / _duration) * (pi * 2)) * _a4;
};
function lerp_angle(_angle_from, _angle_to, _amount) {
	/// @func   lerp_angle(angle_from, angle_to, amount)
	/// @param  angle_from -> {real}
	/// @param  angle_to   -> {real}
	/// @param  amount	   -> {real}
	/// @desc   apply a simulated lerp effect to an angle, accounting for the 360->0 angle wrap.
	/// @return angle -> {real}
	/// @tested false
	///
    return _angle_from - angle_difference(_angle_from, _angle_to) * _amount;
};
function angle_perpendicular(_x1, _y1, _x2, _y2) {
	/// @func	angle_perpendicular(x1, y1, x2, y2)
	/// @param	{real} x1
	/// @param	{real} y1
	/// @param	{real} x2
	/// @param	{real} y2
	/// @return {angle} angle_perpendicular
	///
	var _dir	  = point_direction(_x1, _y1, _x2, _y2);
	var _perp_dir = (_dir + 90) % 360;
	//if (_perp_dir < _dir) {
	//	_perp_dir += 180;
	//}
	return _perp_dir;
}

#endregion
#region async //////////////

function async_get_id() {
	/// @func   async_get_id()
	/// @return {real} id
	///
	return async_load[? "id"];
};
function async_get_status() {
	/// @func   async_get_status()
	/// @return {real} status
	///
	return async_load[? "status"];
};
function async_status_success() {
	/// @func   async_status_success()
	/// @return {bool} success?
	///
	return async_get_status();
};
function async_status_fail() {
	/// @func   async_status_fail()
	/// @return {bool} fail?
	///
	return !async_get_status();
};

#endregion
#region others /////////////

function dist_thresh(_val1, _val2, _thresh, _abs = true) {
	/// @func	dist_thresh(val1, val2, thresh, abs?*<t>)
	/// @param	val1   -> {any}
	/// @param	val2   -> {any}
	/// @param	thresh -> {real}
	/// @param	abs?   -> {bool}*<t>
	/// @desc	...
	/// @return within_dist? -> {bool}
	/// @tested false
	///
	if (_abs) {
		return abs(_val1 - _val2) <= _thresh;
	}
	return (_val1 - _val2) <= _thresh;
};
function new_callback(_callback, _data = undefined) {
	/// @func	new_callback(callback, data*)
	/// @param	{method} callback
	/// @param	{any} data=undefined
	/// @return {struct} callback
	///
	return {
		callback: _callback,
		data: _data,
	};
};
function instance_get_name_dynamic(_instance) {
	/// @func	instance_get_name_dynamic(instance)
	/// @param	{struct/instance} instance
	/// @return {string} name
	///
	if (is_struct(_instance)) {
		var _struct = instanceof(_instance);	// will return constructor name or just "struct"
		
	}
	else {
		return object_get_name(_instance.object_index);
	}
};

#endregion
#region isometric //////////

function iso_ijk_to_x(_iso_width, _i, _j, _k) {
	/// @func   iso_ijk_to_x(iso_width, i, j, k)
	/// @parma	{real} iso_width
	/// @param  {real} i
	/// @param  {real} j
	/// @param	{real} k
	/// @return {real} x
	///
	return (_i - _j) * (_iso_width * 0.5);
};
function iso_ijk_to_y(_iso_height, _i, _j, _k) {
	/// @func   iso_ijk_to_y(iso_height, i, j, k)
	/// @param	{real} iso_height
	/// @param  {real} i
	/// @param  {real} j
	/// @param	{real} k
	/// @return {real} y
	///
	var _y = (_i + _j) * (_iso_height * 0.5);
	var _z = _k * (_iso_height * 1.0);
	return _y - _z;
};
function iso_xy_to_i(_iso_width, _iso_height, _x, _y) {
	/// @func   iso_xy_to_i(iso_width, iso_height, x, y)
	/// @desc   convert given world coordinates to board coordinates.
	/// @param	{real} iso_width
	/// @param	{real} iso_height
	/// @param  {real} x
	/// @param  {real} y
	/// @return {real} i
	///
	return floor(((_x / (_iso_width * 0.5) + (_y / (_iso_height * 0.5))) * 0.5) + 0.5);
};
function iso_xy_to_j(_iso_width, _iso_height, _x, _y) {
	/// @func   iso_xy_to_j(iso_width, iso_height, x, y)
	/// @desc   convert given world coordinates to board coordinates.
	/// @param	{real} iso_width
	/// @param	{real} iso_height
	/// @param  {real} x
	/// @param  {real} y
	/// @return {real} j
	///
	return floor(((_y / (_iso_height * 0.5) - (_x / (_iso_width  * 0.5))) * 0.5) + 0.5);
};

#endregion
#region method /////////////

function method_get_name_dynamic(_method) {
	/// @func	method_get_name_dynamic(method)
	/// @param	{method} method
	/// @return {string} name
	///
	return string(ptr(_method));
};
function method_inherit(_method_parent = undefined, _method_child = undefined, _callback = undefined) {
	/// @func	method_inherit(method_parent*, method_child*, callback*)
	/// @desc	rather than needing to setup complex method inheritance through initialization of extra
	///			methods, this function serves as an encapsulation to do so with one-line execution.
	/// @param	{method} method_parent=undefined
	/// @param	{method} method_child=undefined
	/// @param	{method} callback=undefined
	/// @return {method} method
	/// @author GlebTsereteli & _gentoo_
	///
	var _inherit_depth = 1;
	
	#region Method Child ///////////
	
	var _method_child_owner = self;
	if (_method_child != undefined) {
		_method_child  = method(_method_child_owner, _method_child);
	}
	
	#endregion
	#region Method Parent //////////
	
	var _method_parent_owner = self;
	if (_method_parent != undefined) {
		_method_parent_owner = method_get_self(_method_parent); 
		if (is_struct(_method_parent_owner)) {
			_inherit_depth = _method_parent_owner.inherit_depth + 1;
		}
		_method_parent = method(_method_parent_owner, _method_parent);
	}
	
	#endregion
	#region Method Callbacks ///////
	
	var _callbacks = [];
	if (is_struct(_method_parent_owner)) {
		_callbacks = _method_parent_owner.callbacks;
	}
	if (_callback != undefined) {
		_callback  = method(method_get_self(_callback), _callback);
	}
	array_push(_callbacks, _callback); // push even if undefined, so that len matches inherit depth
	
	#endregion
	
	/// Stash Local Var References Through Temp Struct Binding
	var _bridge = {
		inherit_depth: _inherit_depth,
        method_parent: _method_parent,
        method_child:  _method_child,
		callbacks:	   _callbacks,
    };
    return method(_bridge, function() {
		if (method_parent != undefined) method_parent();
        if (method_child  != undefined) method_child();
		
		/// Execute Callbacks If At End Of Chain
		var _n_callbacks = array_length(callbacks);
		if (inherit_depth == _n_callbacks) {
			for (var _i = 0; _i < _n_callbacks; _i++) {
				var _callback  = callbacks[_i];
				if (_callback != undefined) {
					_callback();
				}
			}
		}
    });
};

#endregion
