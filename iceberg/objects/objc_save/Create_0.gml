/// @desc objc_save
global._save = self;
#macro SAVE global._save
/////////////////////////////
// .---- .---. .   . .---- //
// L---. r---j  \ /  r--   //
// ----J |   |   V   L---- //
/////////////////////////////
event_inherited();
events_user(CALLBACKS, EVENTS, METHODS);

/*	ToDo
	- setup buffer_save_async_groups() that spit out save data to multiple files inside of a defined group folder
	- test that customly defined save_ids are getting handled on_load properly
	- setup macros with associated build configs, so that console exporting can be handled dynamically with the specific file pathing edge cases present in consoles
	- handle failed load files and repeated load attempts
	- SaveObject and serializer auto binding handling?
	- Serialize & Deserialize 
		- arrays, structs, constructors, ds_lists, ds_maps, ds_queues, buffers
	- remove callbacks? INTEGRATE PUBSUB
	- does SaveObject need to be a constructor?
*/
#macro __SC_CONTROLLER				SAVE
#macro __SC_SAVE_FILE_GROUP			"default"
#macro __SC_SAVE_FILE_PREFIX		"save_data"
#macro __SC_SAVE_FILE_TYPE			".buf"
#macro __SC_SAVE_FILE_WIPE_ON_START false
#macro __SC_SAVE_ID_DELINEATOR		"|"
#macro __SC_SAVE_ID_SUBSTRINGS		["name","x","y","depth","layer"]
#macro __SC_SAVE_SLOT_DEFAULT		 0
#macro __SC_FIRST_ROOM_INDEX		_rm_init	// first room index to reference
#macro __SC_LOAD_ON_FIRST_ROOM		false		// if the first room is used as an init room, 
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

setup	 = method_inherit(setup,	function() {
	/// @func	setup()
	/// @return {struct} self
	///
	if (!initialized) {
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
		#region Events /////////
	
		TRANSITION.get_component(Eventable)
			.listen("hold_started", function(_data) {
				save_game(,, function() {
					TRANSITION.end_transition();
				});
			});
	
		#endregion
		
		save_file_begin_validation(room_goto_next);
	}
	return self;
});
teardown = method_inherit(teardown, function() {
	/// @func	teardown()
	/// @return {struct} self
	///
	if (initialized) {
		/// ...
	}
	return self;
});
rebuild  = method_inherit(rebuild,	function() {
	/// @func	rebuild()
	/// @return {struct} self
	///
	if (initialized) {
		/// ...
	}
	return self;
});
update	 = method_inherit(update,	function() {
	/// @func	update()
	/// @return {struct} self
	///
	if (initialized) {
		/// ...
	}
	return self;
});
render	 = method_inherit(render,	function() {
	/// @func	render()
	/// @return {struct} self
	///
	if (initialized) {
		/// ...
	}
	return self;
});

/*
test_number		= 100;
test_name		= "Gentoo";
test_serializer = new Serializer(
	self,
	[
		"test_number",
		"test_name",
		/// new SerializerType("buffer_name", VAR_TYPE.BUFFER)
	]
);