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

/*
function unit_create_instance(_x, _y) {
	/// @func unit_create_instance()
	///
	var _unit = instance_create_depth(_x, _y, 0, obj_unit);
	_unit.event_publish("created",, true);
	return _unit;
};

with (objc_battle) {
	PUBLISHER.subscribe("unit_created", function(_data) {
		array_push(units, _data.id);	
	});
}
obj_unit.event_subscribe("created", function() {});
PUBLISHER.subscribe("unit_created", function() {});