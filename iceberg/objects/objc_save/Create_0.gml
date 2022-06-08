/// @desc objc_save
global._save = id;
#macro SAVE global._save
/////////////////////////////
// .---- .---. .   . .---- //
// L---. r---j  \ /  r--   //
// ----J |   |   V   L---- //
/////////////////////////////
event_inherited();
event_user(METHODS);
event_user(EVENTS);
event_id = "save";

/*	ToDo
	- setup buffer_save_async_groups() that spit out save data to multiple files inside of a defined group folder
	- test that customly defined save_ids are getting handled on_load properly
	- setup macros with associated build configs, so that console exporting can be handled dynamically with the specific file pathing edge cases present in consoles
	- handle failed load files and repeated load attempts
	- SaveObject and serializer auto binding handling?
	- Serialize & Deserialize 
		- arrays, structs, constructors, ds_lists, ds_maps, ds_queues, buffers
	- (LATER) futher decoupling by implenting the "Builder" design pattern:
		- pass in array of vars into an interpreter script 
		- script checks each typeof(var) 
		- instantiates new class for var based off of var-type
		- each var-type data class contains isolated serialization "algorithm"
		- Serializer() then just invokes data_class.serialize()
		- this allows us to remove out lookup_read and lookup_write and replace
			with a more encapsulated implementation
		- also allows us to methodically handle edge cases and error throwing through an implicit
			type checker, etc.
*/
#macro __SC_CONTROLLER			SAVE
#macro __SC_SAVE_FILE_GROUP		"default"
#macro __SC_SAVE_FILE_PREFIX	"save_data"
#macro __SC_SAVE_FILE_TYPE		".buf"
#macro __SC_SAVE_ID_DELINEATOR	"|"
#macro __SC_SAVE_ID_SUBSTRINGS	["name","x","y","depth","layer"]
#macro __SC_SAVE_SLOT_DEFAULT	 0
#macro __SC_FIRST_ROOM_INDEX	_rm_init	// first room index to reference
#macro __SC_LOAD_ON_FIRST_ROOM	false		// if the first room is used as an init room, 
											// loading data in this room may not be wanted
enum __SC_STATE {
	BEGIN_VALIDATION,
	FILE_CHECK_EXISTS,
	FILE_INIT_EMPTY,
	FILE_FIRST_LOAD,
	FILE_CHECK_UP_TO_DATE,
	IDLE,
	LOADING,
	SAVING,
}

setup_save	  = function() {
	/// @func	setup_save()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (initialized) exit;
	#region ----------------
	
	setup_controller();
	
	#endregion
	#region States /////////
	
	state = -1;
	
	#endregion
	#region Save File //////

	save_slot			= __SC_SAVE_SLOT_DEFAULT;
	save_on_file_ready	= undefined;
	
	#endregion
	#region Saving /////////

	save_objects	= [];
	save_data		= data_new_empty();	// struct containing save data that will be written to disk
	save_async_id	= undefined;		// async return value used to validate in async event
	save_on_success	= undefined;		// on_success callback
	save_on_fail	= undefined;		// on_fail callback
	
	#endregion
	#region Loading ////////

	load_data		= data_new_empty();	// data loaded from disk. structured the same as save_data
	load_async_id	= undefined;		// async return value used to validate in async event
	load_on_success = undefined;		// on_success callback
	load_on_fail	= undefined;		// on_fail callback
	load_buffer		= buffer_create(1, buffer_grow, 1);
	
	#endregion
	save_file_begin_validation(room_goto_next);
};
teardown_save = function() {
	/// @func	teardown_save()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	teardown_controller();
	
	#endregion
};
rebuild_save  = function() {
	/// @func	rebuild_save()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	teardown_save();
	setup_save();
};
update_save   = function() {
	/// @func	update_save()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	update_controller();
	
	#endregion
};
render_save   = function() {
	/// @func	render_save()
	/// @desc	...
	/// @return NA
	/// @tested false
	///
	if (!initialized) exit;
	#region ----------------
	
	render_controller();
	
	#endregion
};

#region @OVERRIDE

setup	 = function() {
	/// @func	setup()
	/// @return NA
	/// @tested false
	///
	setup_save();
};
teardown = function() {
	/// @func	teardown()
	/// @return NA
	/// @tested false
	///
	teardown_save();
};
rebuild  = function() {
	/// @func	rebuild()
	/// @return NA
	/// @tested false
	///
	rebuild_save();
};
update	 = function() {
	/// @func	update()
	/// @return NA
	/// @tested false
	///
	update_save();
};
render	 = function() {
	/// @func	render()
	/// @return NA
	/// @tested false
	///
	render_save();
};

#endregion