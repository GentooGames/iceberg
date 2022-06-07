/// @desc Save/Load Async

switch (state) {
	/// Loading
	case __SC_STATE.FILE_FIRST_LOAD:
	case __SC_STATE.LOADING:
		if (async_get_id() == load_async_id) {
			if (async_status_fail()) {
				load_from_disk_fail();	
				exit;
			}
			load_from_disk_success();	
			
			if (state == __SC_STATE.LOADING) {
				state  = __SC_STATE.IDLE;	
			}
		}
		break;
		
	/// Saving
	case __SC_STATE.FILE_INIT_EMPTY:
	case __SC_STATE.SAVING:
		if (async_get_id() == save_async_id) {
			if (async_status_fail()) {
				save_to_disk_fail();	
				exit;
			}
			save_to_disk_success();	
			
			if (state == __SC_STATE.SAVING) {
				state  = __SC_STATE.IDLE;	
			}
		}
		break;	
}

