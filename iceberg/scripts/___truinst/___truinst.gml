function ___truInst() {
	/// @func ___truInst()
	///
	global.___system_truInst = {
		initialized: false,
		
		#region Core ///////
		
		setup:	  function(_active = true) {
			/// @func	setup(active?*)
			/// @param	{boolean} active=true
			/// @return {struct}  self
			///
			camera			= obj_camera;
			parent_objects  = resource_tree_get_object_parents();
			padding			= 0;
		
			if (TRUINST_APPLY_CULLING && !initialized) {
				active			 = _active;
				deactivated		 = [];
				deactivated_data = [];
				temp_activated	 = [];
				cache			 = {};	// holds arrays keyed by object_index
				initialized		 = true;
			}
			return self;
		},
		update:	  function() {
			/// @func	update()
			/// @return {struct} self
			///
			if (TRUINST_APPLY_CULLING && initialized) {
				for (var _i = array_length(deactivated_data) - 1; _i >= 0; _i--) {
					var _data =  deactivated_data[_i];
					var _inst = _data.id;
					if (!is_offscreen(_inst)) {
						_inst.truInst_activate(_i);
					}
				}
			}
			return self;
		},
		render:	  function() {
			/// @func	render()
			/// @return {struct} self
			///
			if (initialized) {};
			return self;
		},
		teardown: function() {
			/// @func	teardown()
			/// @return {struct} self
			///
			if (TRUINST_APPLY_CULLING && initialized) {
				active			 = false;
				deactivated		 = [];
				deactivated_data = [];
				temp_activated	 = [];
				cache			 = {};
				initialized		 = false;
			}
			return self;
		},
	
		#endregion
		#region Actions ////
		
		clear_all:  function(_destroy_instances = true) {
			/// @func	clear_all(destroy_instances?*)
			/// @param	{boolean} destroy_instances=true
			/// @return {struct}  self
			///
			if (TRUINST_APPLY_CULLING) {
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
			}
			return self;
		},
		clear_temp: function() {
			/// @func	clear_temp()
			/// @return {struct} self
			///
			if (TRUINST_APPLY_CULLING) {
				for (var _i = array_length(temp_activated) - 1; _i >= 0; _i--) {
					var _deactivated = temp_activated[_i];
					instance_deactivate_object(_deactivated);
					array_delete(temp_activated, _i, 1);
				}
			}
			return self;
		},
		
		#endregion
		#region Getters ////
		
		
		
		#endregion
		#region Setters ////
		
		
		
		#endregion
		#region Checkers ///
		
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
			
		#endregion
		#region __Private //
		
		
		
		#endregion
	};
	#region Macros /////////
	
	#macro TRUINST				 global.___system_truInst
	#macro TRUINST_APPLY_CULLING 1
	#macro TRUINST_LOGGING		 1
	
	#endregion
	TRUINST.setup(); /// <-- automatically invoke setup()
};
function instance_exists_tru(_id = id) {
		/// @func	instance_exists_tru(id*)
		/// @param	{instance} instance=id
		/// @return {boolean}  instance_exists?
		///
		if (!TRUINST_APPLY_CULLING) {
			return instance_exists(_id);
		}
		if (instance_exists(_id)) {
			return true;
		}
		/// Is : Object
		if (_id < 100000) {
			var _array = TRUINST.cache[$ _id];
	
			/// Not Culled
			if (_array == undefined) {
				return instance_exists(_id);
			}
			/// Is Culled
			else {
				/// Temp Reactivate All Instances Of object_index
				for (var _i = 0, _len = array_length(_array); _i < _len; _i++) {
					var _this_inst = _array[_i];	
					if (_this_inst.truInst_is_active() && !_this_inst.truInst_is_temp_activated()) {
						_this_inst.truInst_temp_activate();
					}
				}
				return array_length(_array) > 0;
			}
		}
		/// Is : Instance Id
		else {
			var _index  = array_find_index(TRUINST.deactivated, _id);
			if (_index != -1) {
				var _this_inst = TRUINST.deactivated[_index];
				if (_this_inst.truInst_is_active() && !_this_inst.truInst_is_temp_activated()) {
					_this_inst.truInst_temp_activate();
				}
				return true;
			}
		}
		return false;
	};
function instance_destroy_tru(_id = id) {
		/// @func	instance_destroy_tru(id*)
		/// @param	{instance} instance=id
		/// @return {boolean}  instance_destroyed?
		///
		/// Check If Instance Exists In Real World First
		if (instance_exists(_id)) {
			instance_destroy(_id);
			return true;
		}
		if (TRUINST_APPLY_CULLING) {
			/// Remove From Deactivated Lists & Destroy
			for (var _i = array_length(TRUINST.deactivated) - 1; _i >= 0; _i--) {
				var _instance = TRUINST.deactivated[_i];
				if (_instance == _id) {
					_instance.truInst_activate(_i); // reactivate instance before destroying
					instance_destroy(_id);	
					return true;
				}
			}
		}
		return false;
	};
function instance_find_tru(_object_index = object_index, _n) {
		/// @func	instance_find_tru(object_index*, n)
		/// @param	{instance} object_index=object_index
		/// @param	{real}	   n
		/// @return {instance} instance
		///
		if (!TRUINST_APPLY_CULLING) {
			return instance_find(_id, _n);
		}
		/// Non-Culled
		if (TRUINST.cache[$ _object_index] == undefined) {
			return instance_find(_id, _n);
		}
		/// Culled
		else {
			var _instance  = TRUINST.cache[$ _object_index];
			if (_instance == undefined) {
				return noone;	
			}
			else {
				/// Add To Temp Activated List
				if (_instance.truInst_is_active() && !_instance.truInst_is_temp_activated()) {
					_instance.truInst_temp_activate();
				}
				return _instance;
			}
		}
		return noone;
	};
function instance_number_tru(_object_index = object_index) {
		/// @func	instance_number_tru(object_index*)
		/// @param	{instance} object_index=object_index
		/// @return {real}	   instance_number
		///
		if (!TRUINST_APPLY_CULLING) {
			return instance_number(_object_index);
		}
		/// Non-Culled
		if (TRUINST.cache[$ _object_index] == undefined) {
			return instance_number(_object_index);
		}
		/// Culled
		else {
			return array_length(TRUINST.cache[$ _object_index]);
		}
		return -1;
	};
