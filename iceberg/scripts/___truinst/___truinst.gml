global.___system_truInst = {
	
	active:				true,
	logging:			true,
	camera:				obj_camera,	// reference to camera object
	padding:			0,
	parent_objects:		object_indexes_get_parents(),
	deactivated:		[],
	deactivated_data:	[],
	temp_activated:		[],
	cache:				{},	// value = array	
	////////////////////////////
	setup:		  function() {},
	update:		  function() {
		/// @func update()
		///
		if (!is_culling()) return false;
		
		for (var _i = array_length(deactivated_data) - 1; _i >= 0; _i--) {
			var _data =  deactivated_data[_i];
			var _inst = _data.id;
			if (!is_offscreen(_inst)) {
				_inst.truInst_activate(_i);
			}
		}
		return true;
	},
	teardown:	  function() {},
	////////////////////////////
	clear_all:	  function(_destroy_instances = true) {
		/// @func	clear_all(destroy_instances?*)
		/// @param	{boolean} destroy_instances=true
		/// @return {boolean} did_clear_all?
		///
		for (var _i = 0, _len = array_length(deactivated); _i < _len; _i++) {
			var _deactivated = deactivated[_i];
			if (_destroy_instances) {
				instance_destroy_tru(_deactivated);
			}
			else {
				instance_activate_object(_deactivated);
			}
		}
		deactivated		 = [];
		deactivated_data = [];
		temp_activated	 = [];
		cache			 = {};
		return true;
	},
	clear_temp:   function() {
		/// @func	clear_temp()
		/// @return {boolean} did_clear_temp?
		///
		for (var _i = array_length(temp_activated) - 1; _i >= 0; _i--) {
			var _deactivated = temp_activated[_i];
			instance_deactivate_object(_deactivated);
			array_delete(temp_activated, _i, 1);
		}
		return true;
	},
	is_offscreen: function(_id = id) {
		/// @func	is_offscreen(id*)
		/// @param	{instance} id=id
		/// @return {boolean}  is_offscreen?
		///
		var _bbox = _id.truInst_get_bbox();
		return ((_bbox.bbox_left   > camera.get_right()  + padding)
			||	(_bbox.bbox_top    > camera.get_bottom() + padding)
			||	(_bbox.bbox_right  < camera.get_left()   - padding) 
			||	(_bbox.bbox_bottom < camera.get_top()	 - padding)
		);
	},
	is_culling:	  function() {
		/// @func	is_culling()
		/// @return {boolean} is_culling?
		///
		return active;
	},
};
#macro TRUINST global.___system_truInst

function instance_exists_culled() {};
function instance_destroy_culled() {};
function instance_find_culled() {};
function instance_number_culled() {};