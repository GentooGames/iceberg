/// @desc Load Room

if (__SC_LOG) show_debug_message("room_start: " + string(room_get_name(room)));
if (__SC_LOAD_ON_FIRST_ROOM || room != __SC_FIRST_ROOM_INDEX) {
	load_room();	
}