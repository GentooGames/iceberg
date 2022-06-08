/// @desc Load Room

log("room_start: " + string(room_get_name(room)));
if (__SC_LOAD_ON_FIRST_ROOM || room != __SC_FIRST_ROOM_INDEX) {
	load_room();	
}