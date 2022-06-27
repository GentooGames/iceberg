function camera_create_instance(_x = 0, _y = 0) {
	/// @func	camera_create_instance(x*, y*)
	/// @param	x -> {real}
	/// @param	y -> {real}
	/// @desc	create an instance of obj_camera and invoke .setup()
	/// @return NA
	/// @tested false
	///
	var _camera = instance_create_layer(_x, _y, "Controllers", obj_camera);
	/// _camera.setup();
	return _camera;
};
