/// @desc Methods
event_inherited();

#region Saving

save_room			  = function() {
	/// @func save_room()
	///
	if (__SC_LOG) {
		show_debug_message("saving room");
	}
	var _save_object, _save_id, _save_data;
	var _room_data = { save_ids: [], };
	
	for (var _i = 0, _len = array_length(save_objects); _i < _len; _i++) {
		_save_object =  save_objects[_i];
		_save_id	 = _save_object.get_save_id();
		_save_data	 = _save_object.get_save_data();

		array_push(_room_data.save_ids, _save_id);
		_room_data[$ _save_id] = _save_data;
	}
	save_to_save_data("room_data", room_get_name(room), json_stringify(_room_data));
};
save_game			  = function(_save_slot = save_slot, _save_data = save_data, _on_success = undefined, _on_fail = undefined) {
	/// @func  save_game(save_slot*, save_data*, on_success*, on_fail*)
	/// @param {real}	  save_slot*=save_slot
	/// @param {struct}	  save_data*=save_data
	/// @param {Callback} on_success*=undefined
	/// @param {Callback} on_fail*=undefined
	///
	if (__SC_LOG) {
		show_debug_message("saving game");
	}
	save_room();
	save_to_disk(_save_slot, _save_data, _on_success, _on_fail);
	state = __SC_STATE.SAVING;
}
save_to_save_data	  = function() {
	/// @func save_to_save_data(struct_1_name, ..., struct_n_name, key, value)
	///
	var _i = 0;
	var _key, _child, _struct = save_data;
	while (_i < argument_count - 2) {
		_key = argument[_i];
		if (!variable_struct_exists(_struct, _key)) {
			_child			= {};
			_struct[$ _key] = _child;	
		}
		else {
			_child = _struct[$ _key];	
		}
		_struct = _child;
		_i++;
	}
	_key = argument[argument_count - 2];
	_struct[$ _key] = argument[argument_count - 1];
};
save_to_disk		  = function(_save_slot, _save_data, _on_success, _on_fail) {
	/// @func  save_to_disk(save_slot, save_data, on_success, on_fail)
	/// @param {real}	  save_slot
	/// @param {struct}	  save_data
	/// @param {Callback} on_success
	/// @param {Callback} on_fail
	///
	/*
		buffer_async_group_begin("...")
		async_id_1 = buffer_save_async(...)
		async_id_2 = buffer_save_async(...)
		...
		async_id_n = buffer_save_async(...)
		buffer_async_group_end()
	*/
	if (__SC_LOG) {
		show_debug_message("saving to disk");	
	}
	var _filename	 =  get_filename(_save_slot);
	var _buffer		 =  struct_to_buffer_encoded_compressed(_save_data);
	var _buffer_size =  buffer_get_size(_buffer);
	save_async_id	 =  buffer_save_async(_buffer, _filename, 0, _buffer_size);
	save_on_success  = _on_success;
	save_on_fail	 = _on_fail;
};
save_to_disk_success  = function() {
	/// @func save_to_disk_success()
	///	
	if (__SC_LOG) {
		show_debug_message("save to disk succeeded.");
	}
	if (save_on_success != undefined) {
		save_on_success();	
	}
	save_to_disk_complete();
};
save_to_disk_fail	  = function() {
	/// @func save_to_disk_fail()
	///
	if (__SC_LOG) {
		show_debug_message("save to disk failed.");
	}
	if (save_on_fail != undefined) {
		save_on_fail();	
	}
	save_to_disk_complete();
};
save_to_disk_complete = function() {
	/// @func  save_to_disk_complete()
	///
	save_async_id	= undefined;
	save_on_success = undefined;
	save_on_fail	= undefined;
};

#endregion
#region Loading

load_room				= function() {
	/// @func load_room()
	///
	if (__SC_LOG) {
		show_debug_message("loading room");	
	}
	var _room_name  = room_get_name(room);
	var _room_data  = load_data.room_data[$ _room_name];
	if (_room_data != undefined) {
		_room_data  = json_parse(_room_data);
				
		var _save_ids = _room_data.save_ids;
		for (var _i = 0, _len = array_length(_save_ids); _i < _len; _i++) {
			var _save_id		= _save_ids[_i];
			var _save_id_data	=  string_parse_into_struct(_save_id, __SC_SAVE_ID_SUBSTRINGS, __SC_SAVE_ID_DELINEATOR);
			var _instance_name	= _save_id_data.name;
			var _instance_x		=  real(_save_id_data.x);
			var _instance_y		=  real(_save_id_data.y);			
			var _instance_depth =  real(_save_id_data.depth);
			var _instance_layer = _save_id_data.layer;
			var _instance_index	=  asset_get_index(_instance_name);
			var _instance		=  collision_point(_instance_x, _instance_y, _instance_index, true, true);

			/// Spawn Dynamically Created Instance If Necessary
			if (_instance == noone) {
				/// Prioritize Creating Instance On Layer
				if (_instance_layer != "" && _instance_layer != "-1") {
					if (__SC_LOG) {
						show_debug_message("instance does not exist on room start, creating it dynamically on layer: " + _instance_layer);
					}
					_instance		=  instance_create_layer(_instance_x, _instance_y, _instance_layer, _instance_index);
					_instance.depth = _instance_depth;
				}
				else {
					if (__SC_LOG) {
						show_debug_message("instance does not exist on room start, creating it dynamically with depth: " + string(_instance_depth));
					}
					_instance = instance_create_depth(_instance_x, _instance_y, _instance_depth, _instance_index);	
				}
			}
			/// Invoke Load
			var _load_data = json_parse(_room_data[$ _save_id]);
			_instance.load(_load_data);	
		}
	}
};
load_game				= function(_save_slot = save_slot) {
	/// @func  load_game(save_slot*)
	/// @param {real} save_slot*=save_slot
	///
	if (__SC_LOG) {
		show_debug_message("loading game");
	}
	load_from_disk(_save_slot, room_restart);
	state = __SC_STATE.LOADING;
};
load_from_disk			= function(_save_slot, _on_success, _on_fail) {
	/// @func  load_from_disk(save_slot, on_success, on_fail)
	/// @param {real}	  save_slot
	/// @param {Callback} on_success
	/// @param {Callback} on_fail
	/// @desc	get load_data from disk
	///
	if (__SC_LOG) {
		show_debug_message("loading from disk");
	}
	var _filename	= get_filename(_save_slot);
	load_async_id	= buffer_load_async(load_buffer, _filename, 0, -1);
	load_on_success = _on_success;
	load_on_fail	= _on_fail;
};
load_from_disk_success  = function() {
	/// @func load_from_disk_success()
	///
	if (__SC_LOG) {
		show_debug_message("load from disk succeeded");
	}
	load_data = buffer_compressed_encoded_to_struct(load_buffer, false);
	
	if (load_on_success != undefined) {
		load_on_success();	
	}
	load_from_disk_complete();
};
load_from_disk_fail	    = function() {
	/// @func load_from_disk_fail()
	///
	if (__SC_LOG) {
		show_debug_message("load from disk failed");
	}
	if (load_on_fail != undefined) {
		load_on_fail();	
	}
	load_from_disk_complete();
};
load_from_disk_complete = function() {
	/// @func load_from_disk_complete()
	///
	//load_data		= undefined;	// keep these around for later reference, so that we dont have to invoke load() again to access
	load_async_id	= undefined;
	load_on_success = undefined;
	load_on_fail	= undefined;
	buffer_resize(load_buffer, 1);	// size down buffer so that buffer is not consuming excess space in RAM
};

#endregion
#region File System

get_filename				= function(_save_slot = save_slot) {
	/// @func  get_filename(save_slot*)
	/// @param save_slot*=save_slot
	///
	return __SC_SAVE_FILE_PREFIX + "_" + string(_save_slot) + __SC_SAVE_FILE_TYPE;
};
get_filename_group			= function(_save_slot = save_slot) {
	/// @func  get_filename_group(save_slot*)
	/// @param save_slot*=save_slot
	///
	return __SC_SAVE_FILE_GROUP + "/" + get_filename();
};
save_file_begin_validation	= function(_on_file_ready) {
	/// @func	save_file_begin_validation(on_file_ready*)
	/// @param	{method/function} on_file_ready=undefined
	/// 	
	state = __SC_STATE.BEGIN_VALIDATION;
	if (__SC_LOG) {
		show_debug_message("####################");
		show_debug_message("validating save file");
		show_debug_message("####################");
	}
	save_on_file_ready = _on_file_ready;
	save_file_check_exists();
};
save_file_check_exists		= function() {
	/// @func save_file_check_exists()
	///
	state = __SC_STATE.FILE_CHECK_EXISTS;
	if (__SC_LOG) {
		show_debug_message("checking if save file exists");
	}
	if (file_exists(get_filename_group())) {
		if (__SC_LOG) {
			show_debug_message("save file exists");
		}
		save_file_first_load();
	}
	else {
		if (__SC_LOG) {
			show_debug_message("save file does not exist");
		}
		save_file_init_empty();
	}
};
save_file_init_empty		= function() {
	/// @func save_file_init_empty()
	///
	state = __SC_STATE.FILE_INIT_EMPTY;
	if (__SC_LOG) {
		show_debug_message("initializing new empty save file");
	}
	save_to_disk(, data_new_empty(), save_file_first_load);
};	
save_file_first_load		= function() {
	/// @func save_file_first_load()
	///
	state = __SC_STATE.FILE_FIRST_LOAD;
	if (__SC_LOG) {
		show_debug_message("loading data from save file for the first time");
	}
	load_from_disk(, save_file_check_up_to_date);
};
save_file_is_up_to_date		= function() {
	/// @func save_file_is_up_to_date()
	///
	return structs_have_same_names(data_new_empty(), load_data);
};
save_file_check_up_to_date	= function() {
	/// @func save_file_check_up_to_date()
	///
	state = __SC_STATE.FILE_CHECK_UP_TO_DATE;
	if (__SC_LOG) {
		show_debug_message("checking if save file is up-to-date");
	}
	if (save_file_is_up_to_date()) {
		if (__SC_LOG) {
			show_debug_message("save file is up-to-date");
		}
		save_file_validated();
	}
	else {
		if (__SC_LOG) {
			show_debug_message("save file is out-of-date");
		}
		save_file_init_empty();
	}
};	
save_file_validated			= function() {
	/// @func save_file_validated()
	///
	state = __SC_STATE.IDLE;
	if (__SC_LOG) {
		show_debug_message("save file validated");
	}
	if (save_on_file_ready != undefined) {
		save_on_file_ready();	
	}
};

#endregion
#region Util 

stash_save_object	= function(_save_object = id) {
	/// @func  stash_save_object(save_object*)
	/// @param save_object=id
	///
	if (!array_contains(save_objects, _save_object)) {
		array_push(save_objects, _save_object);
	}
};
unstash_save_object	= function(_save_object = id) {
	/// @func  unstash_save_object(save_object*)
	/// @param save_object=id
	///
	array_find_delete(save_objects, _save_object);
};
data_new_empty		= function() {
	/// @func data_new_empty()
	///
	return {
		room_data: {},
	};
};

#endregion
