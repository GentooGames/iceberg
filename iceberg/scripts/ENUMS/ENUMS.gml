function ___enums() {
	/// @func ___enums()
	///
	enum DIR	{ 
		NONE  = -4,
		LEFT  = -1, 
		RIGHT =  1, 
		UP, 
		DOWN,
		UP_RIGHT,
		UP_LEFT,
		DOWN_LEFT,
		DOWN_RIGHT,
	};
	enum FACE	{ 
		NONE  = -4,
		BACK  = -1,
		FRONT =  1, 
	};
	enum ANCHOR	{ 
		NONE	 = -4,
		TOP_LEFT =  0, 
		TOP_CENTER, 
		TOP_RIGHT, 
		CENTER_LEFT, 
		CENTER, 
		CENTER_RIGHT, 
		BOTTOM_LEFT, 
		BOTTOM_CENTER, 
		BOTTOM_RIGHT, 
	};
	enum PATH	{
		NONE	 = -4,
		STRAIGHT =  0,
		SMOOTH	 =  1,
	};
}

function dir_to_string(_dir) {
	/// @func   dir_to_string(dir)
	/// @param  {DIR}	 dir
	/// @return {string} dir
	///
	switch (_dir) {
		case DIR.RIGHT:		 return "RIGHT";	
		case DIR.UP_RIGHT:	 return "UP_RIGHT";	
		case DIR.UP:		 return "UP";	
		case DIR.UP_LEFT:	 return "UP_LEFT";	
		case DIR.LEFT:		 return "LEFT";	
		case DIR.DOWN_LEFT:	 return "DOWN_LEFT";	
		case DIR.DOWN:		 return "DOWN";	
		case DIR.DOWN_RIGHT: return "DOWN_RIGHT";	
		case DIR.NONE:		 return "NONE";
		default:			 return "NONE";
	};
	return "NONE";
};
function dir_to_angle(_dir) {
	/// @func   dir_to_angle(dir)
	/// @param  {DIR}	dir
	/// @return {angle} dir
	///
	switch (_dir) {
		case DIR.RIGHT:		 return 0;
		case DIR.UP_RIGHT:	 return 45;
		case DIR.UP:		 return 90;
		case DIR.UP_LEFT:	 return 135;
		case DIR.LEFT:		 return 180;
		case DIR.DOWN_LEFT:	 return 225;
		case DIR.DOWN:		 return 270;
		case DIR.DOWN_RIGHT: return 315;
		default:			 return undefined;
	};
	return undefined;
};
function dir_string_to_dir(_dir) {
	/// @func	dir_string_to_dir(dir)
	/// @param	{string} dir
	/// @return {DIR}    dir
	///
	switch (_dir) {
		case "RIGHT":	   return DIR.RIGHT;	 
		case "UP_RIGHT":   return DIR.UP_RIGHT;
		case "UP":		   return DIR.UP; 
		case "UP_LEFT":	   return DIR.UP_LEFT;
		case "LEFT":	   return DIR.LEFT;	
		case "DOWN_LEFT":  return DIR.DOWN_LEFT;
		case "DOWN":	   return DIR.DOWN;	
		case "DOWN_RIGHT": return DIR.DOWN_RIGHT;
		case "NONE":	   return DIR.NONE;
		default:		   return DIR.NONE;
	};
	return DIR.NONE;
};
function dir_string_to_angle(_dir) {
	/// @func	dir_string_to_angle(dir)
	/// @param	{string} dir
	/// @return {angle}  angle
	///
	_dir = dir_string_to_dir(_dir);
	return dir_to_angle(_dir);
};
function angle_to_dir(_angle) {
	/// @func	angle_to_dir(angle)
	/// @param	{angle} angle
	/// @return {DIR}   dir
	///
	switch (round((_angle mod 360) / 45)) {
		case 0:  return DIR.RIGHT;
		case 1:  return DIR.UP_RIGHT;
		case 2:  return DIR.UP;
		case 3:  return DIR.UP_LEFT;
		case 4:  return DIR.LEFT;
		case 5:  return DIR.DOWN_LEFT;
		case 6:  return DIR.DOWN;
		case 7:  return DIR.DOWN_RIGHT;
		case 8:  return DIR.RIGHT;
		default: return DIR.NONE;
	};
	return DIR.NONE;
};
function angle_to_dir_string(_angle) {
	/// @func	angle_to_dir_string(angle)
	/// @param	{angle}  angle
	/// @return {string} dir
	///
	var _dir = angle_to_dir(_angle);
	return  dir_to_string(_dir);
};
function face_to_string(_face) {
	/// @func	face_to_string(face)
	/// @param	{FACE}   face
	/// @return {string} face
	///
	switch (_face) {
		case FACE.FRONT: return "FRONT";	
		case FACE.BACK:  return "BACK";	
		case FACE.NONE:	 return "NONE";	
		default:		 return "NONE";	
	};
	return "NONE";	
};
function face_string_to_face(_face) {
	/// @func	face_string_to_face(face)
	/// @param	{string} face
	/// @return {FACE}   face
	///
	switch (_face) {
		case "FRONT": return FACE.FRONT;
		case "BACK":  return FACE.BACK;
		case "NONE":  return FACE.NONE;
		default:	  return FACE.NONE;
	};
	return FACE.NONE;
};
function anchor_to_string(_anchor) {
	/// @func	anchor_to_string(anchor)
	/// @param	{ANCHOR} anchor
	/// @return {string} anchor
	///
	switch (_anchor) {
		case ANCHOR.TOP_LEFT:	   return "TOP_LEFT";
		case ANCHOR.TOP_CENTER:	   return "TOP_CENTER";
		case ANCHOR.TOP_RIGHT:	   return "TOP_RIGHT";
		case ANCHOR.CENTER_LEFT:   return "CENTER_LEFT";
		case ANCHOR.CENTER:		   return "CENTER";
		case ANCHOR.CENTER_RIGHT:  return "CENTER_RIGHT";
		case ANCHOR.BOTTOM_LEFT:   return "BOTTOM_LEFT";
		case ANCHOR.BOTTOM_CENTER: return "BOTTOM_CENTER";
		case ANCHOR.BOTTOM_RIGHT:  return "BOTTOM_RIGHT"; 
		case ANCHOR.NONE:		   return "NONE";
		default:				   return "NONE";
	};
	return "NONE";
};
function anchor_string_to_anchor(_anchor) {
	/// @func	anchor_string_to_anchor(anchor)
	/// @param	{string} anchor
	/// @return {anchor} anchor
	///
	switch (_anchor) {
		case "TOP_LEFT":	  return ANCHOR.TOP_LEFT;
		case "TOP_CENTER":	  return ANCHOR.TOP_CENTER;
		case "TOP_RIGHT":	  return ANCHOR.TOP_RIGHT;
		case "CENTER_LEFT":	  return ANCHOR.CENTER_LEFT;
		case "CENTER":		  return ANCHOR.CENTER;
		case "CENTER_RIGHT":  return ANCHOR.CENTER_RIGHT;
		case "BOTTOM_LEFT":   return ANCHOR.BOTTOM_LEFT;
		case "BOTTOM_CENTER": return ANCHOR.BOTTOM_CENTER;
		case "BOTTOM_RIGHT":  return ANCHOR.BOTTOM_RIGHT;
		case "NONE":		  return ANCHOR.NONE;
		default:			  return ANCHOR.NONE;
	};
	return ANCHOR.NONE;
};
function path_to_string(_path) {
	/// @func	path_to_string(path)
	/// @param	{PATH}   path
	/// @return {string} path
	///
	switch (_path) {
		case PATH.STRAIGHT: return "STRAIGHT";	
		case PATH.SMOOTH:	return "SMOOTH";	
		case PATH.NONE:		return "NONE";	
		default:			return "NONE";
	};
	return "NONE";
};
function path_string_to_path(_path) {
	/// @func	path_string_to_path(path)
	/// @param	{string} path
	/// @return {PATH}   path
	///
	switch (_path) {
		case "STRAIGHT": return PATH.STRAIGHT;
		case "SMOOTH":	 return PATH.SMOOTH;
		case "NONE":	 return PATH.NONE;
		default:		 return PATH.NONE;
	};
	return PATH.NONE;
};

