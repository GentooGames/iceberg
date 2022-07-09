function camera_create_instance(_x = 0, _y = 0) {
	/// @func	camera_create_instance(x*, y*)
	/// @param	{real}	   x=0
	/// @param	{real}	   y=0
	/// @return {instance} camera
	///
	var _camera = instance_create_depth(_x, _y, 0, obj_camera);
	/// _camera.setup();
	return _camera;
};