function SaveObject(_save_id = undefined, _save_vars, _on_init = undefined) constructor {
	/// @func  SaveObject(save_id*, save_vars, on_init*)
	/// @param {string}   save_id=undefined
	/// @param {array}	  save_vars
	/// @param {Callback} on_init=undefined
	///
	__save_object_owner		= other;
	__save_object_save_id	= _save_id ?? __save_object_generate_id();
	__save_object_callbacks = {
		on_init: _on_init,
		on_load:  undefined,
	};
		
	#region Initialize Serializer
	
	__save_object_serializer = new Serializer(__save_object_owner, _save_vars)
		.add_lookup("state", 
			function(_id) {			// write translation
				return script_get_name(_id.state);
			},
			function(_asset_name) { // read  translation
				return asset_get_index(_asset_name);	
			}
		)	
		
	#endregion
		
	/// Private Class Methods
	static __save_object_generate_id   = function() {
		static _delineator = __SC_SAVE_ID_DELINEATOR;
		with (__save_object_owner) {
			return (object_get_name(object_index) + _delineator
				+	string(x) + _delineator
				+	string(y) + _delineator
				+	string(depth) + _delineator
				+	string(layer_get_name(layer))
			);
		}
	};
	static __save_object_parse_id	   = function() {
		return string_parse_into_struct(
			__save_object_save_id,
			__SC_SAVE_ID_SUBSTRINGS,
			__SC_SAVE_ID_DELINEATOR,
		);
	};
	static __save_object_on_init	   = function() {
		if (__save_object_callbacks.on_init != undefined) {
			__save_object_callbacks.on_init();
		}
	};
	static __save_object_load		   = function(_load_data) {
		/// Search For Load Data Ourselves
		if (_load_data == undefined) {
			var _room_name	= room_get_name(room);
			var _room_data  = __SC_CONTROLLER.load_data.room_data[$ _room_name];
			var _save_id    = __save_object_get_save_id();
				_load_data  = _room_data[$ _save_id];
				
			if (_load_data == undefined) {
				log("ERROR loading for instance " 
					+ object_get_name(__save_object_owner.object_index) 
					+ ", unable to find associated load_data for save_id: " 
					+ string(__save_object_save_id)
					+ ", in the given room: "
					+ _room_name
				);
				exit;
			}
		}
		/// Cast Data To String If Necessary
		if (!is_string(_load_data)) {
			_load_data = json_stringify(_load_data);	
		}
		return __save_object_serializer.deserialize(_load_data);
	};
	static __save_object_get_save_id   = function() {
		return __save_object_save_id;
	};
	static __save_object_get_save_data = function() {
		return __save_object_serializer.serialize();
	};
	
	/// Public Class Methods
	static load		   = function(_load_data) {
		/// @func	load(load_data*)
		/// @param  {struct}	 load_data
		/// @return {SaveObject} self
		/// 
		return __save_object_load(_load_data);
	};
	static set_on_load = function(_on_load) {
		/// @func	set_on_load(on_load)
		/// @param	{method/function} on_load
		/// @return {SaveObject}	  self
		///
		__save_object_callbacks.on_load = _on_load;
		
		/// Bind on_load To Execute On Serializer.deserialize()
		__save_object_serializer.set_on_deserialize(
			method(__save_object_owner, _on_load)
		);
		return self;
	}
		
	/// Instance Methods
	__save_object_owner.load		  = method(self, function(_load_data) {
		return __save_object_load(_load_data);
	});
	__save_object_owner.get_save_id   = method(self, function() {
		return __save_object_get_save_id();
	});
	__save_object_owner.get_save_data = method(self, function() {
		return __save_object_get_save_data();
	});
	
	__save_object_on_init();
};
function EventObject(_event_instance, _name = "") {
	/// @func	EventObject(instance, name*)
	/// @param	{struct/instance} event_instance
	/// @param	{string}		  name=""
	/// @return	{struct/instance} event_instance
	///
	with (_event_instance) {
		__event_instance  = _event_instance;
		__event_publisher =  new Publisher();
		__event_name	  = _name;

		event_setup				= method(__event_instance, function() {
			/// @func	event_setup()
			/// @return	{struct/instance} event_instance
			///
			return __event_instance;
		});
		event_update			= method(__event_instance, function() {
			/// @func	event_update()
			/// @return	{struct/instance} event_instance
			///
			return __event_instance;
		});
		event_teardown			= method(__event_instance, function() {
			/// @func	event_teardown()
			/// @return	{struct/instance} event_instance
			///
			return __event_instance;
		});
		////////////////////////////////////////////////////
		event_get_instance		= method(__event_instance, function() {
			/// @func	event_get_instance()
			/// @return	{struct/instance} event_instance
			///
			return __event_instance;
		});
		event_get_publisher		= method(__event_instance, function() {
			/// @func	event_get_publisher()
			/// @return {Publisher} event_publisher
			///
			return __event_publisher;
		});
		event_get_context_name	= method(__event_instance, function() {
			/// @func	event_get_context_name()
			/// @return {string} event_name
			///
			return __event_name;
		});
		event_register			= method(__event_instance, function(_event_array, _push_to_global = false) {
			/// @func	event_register(event_array, push_to_global?)
			/// @param	{array}			  event_array
			/// @parma	{bool}			  push_to_global=false
			/// @return	{struct/instance} event_instance
			///
			/// Cast And Normalize Argument To Array
			if (!is_array(_event_array)) {
				_event_array = [_event_array];	
			}
			/// Register Each Channel
			var _publisher = event_get_publisher();
			for (var _i = 0, _len = array_length(_event_array); _i < _len; _i++) {
				_publisher.register_channel(_event_array[_i]);
			}
			/// Send To Global?
			if (_push_to_global) {
				PUBLISHER.register(_event_array, false);
			}
			return __event_instance;
		});
		event_registered		= method(__event_instance, function(_event_name) {
			/// @func	event_registered(event_name)
			/// @param	{string}  event_name
			/// @return {boolean} event_is_registered?
			///
			var _publisher = event_get_publisher();
			return _publisher.has_registered_channel(_event_name);
		});
		event_publish			= method(__event_instance, function(_event_name, _payload = undefined, _push_to_global = false) {
			/// @func	 event_publish(event_name, payload*, push_to_global?*)
			/// @param	{string}		  event_name
			/// @param	{any}			  payload=undefined
			/// @param	{bool}			  push_to_global=false
			/// @return	{struct/instance} event_instance
			///
			/*	<data_struct>: {
					id:		 self,
					payload: any,
				}
			*/
			var _publisher   = event_get_publisher();
			var _data_struct = {
				id:		  event_get_instance(),
				payload: _payload,
			}
			_publisher.publish(_event_name, _data_struct);
			
			if (_push_to_global) {
				PUBLISHER.publish(get_event_context_name() + "_" + _event_name, _data_struct, false);
			}
			return __event_instance;
		});
		event_subscribe			= method(__event_instance, function(_event_name, _callback, _weak_reference = false) {
			/// @func	event_subscribe(event_name, callback, weak_reference?)
			/// @param	{string}		  event_name
			/// @param	{method}		  callback_method
			/// @param	{boolean}		  weak_reference=false
			/// @return	{struct/instance} event_instance
			///
			var _publisher = event_get_publisher();
			_publisher.subscribe(_event_name, _callback, _weak_reference);
			return __event_instance;
		});
		event_unsubscribe		= method(__event_instance, function(_event_name, _force = false) {
			/// @func	event_unsubscribe(event_name, force?*)
			/// @param	{string}		  event_name
			/// @parma	{boolean}		  force=false
			/// @return	{struct/instance} event_instance
			///
			var _publisher = event_get_publisher();
			_publisher.unsubscribe(_event_name, _force);
			return __event_instance;
		});
		event_clear_subscribers = method(__event_instance, function(_event_name) {
			/// @func	event_clear_subscribers(event_name)
			/// @param	{string}		  event_name
			/// @return	{struct/instance} event_instance
			///
			var _publisher = event_get_publisher();
			_publisher.clear_channel(_event_name);
			return __event_instance;
		});	
		////////////////////////////////////////////////////
		event_setup(); /// <-- automatically invoke setup
	}
	return __event_instance;
};
function TruInstObject(_truInst_instance, _active = true) {
	/// @func	TruInstObject(truInst_instance, active?*)	
	/// @param	{struct/instance} truInst_instance
	/// @param	{boolean}		  active=true
	/// @return {struct/instance} truInst_instance
	///
	with (_truInst_instance) {		
		__truInst_instance = _truInst_instance;
		__truInst_active   = _active;
		
		truInst_setup	 = method(__truInst_instance, function(_active = true) {
			///	@func	truInst_setup(active?*)
			/// @param	{boolean}		  active=true
			/// @return {struct/instance} truInst_instance
			///
			if (TRUINST_APPLY_CULLING) {
				/// Add Instance To Cached Array
				if (TRUINST.cache[$ object_index] == undefined) {
					TRUINST.cache[$ object_index]  = [];
				}
				array_push(TRUINST.cache[$ object_index], id);
	
				/// Check If Also Needing To Add Instance To Parent's Cached Array
				for (var _i = 0, _len = array_length(TRUINST.parent_objects); _i < _len; _i++) {
					var _parent = TRUINST.parent_objects[_i];
					if (object_is_ancestor(object_index, _parent)) {	
						if (TRUINST.cache[$ _parent] == undefined) {
							TRUINST.cache[$ _parent]  = [];
						}
						array_push(TRUINST.cache[$ _parent], id);
					}
				}
			}
			__truInst_active = _active;
			
			return __truInst_instance;
		});
		truInst_update	 = method(__truInst_instance, function(_destroy_if_offscreen = false) {
			/// @func	truInst_update(destroy_if_offscreen*)
			/// @param	{boolean}		  destroy_if_offscreen=false
			/// @return {struct/instance} truInst_instance
			///
			if (TRUINST_APPLY_CULLING && truInst_is_active() && truInst_is_offscreen()) {
				if (_destroy_if_offscreen) {
					truInst_destroy();
					return id;
				}
				truInst_deactivate();
			}
			return __truInst_instance;
		});
		truInst_teardown = method(__truInst_instance, function() {
			/// @func	truInst_teardown()
			/// @return {struct/instance} truInst_instance
			///	
			if (TRUINST_APPLY_CULLING) {
				/// Remove Instance From Cached Array
				var _array  = TRUINST.cache[$ object_index];
				if (_array != undefined) {
					array_find_delete(_array, id);
				}
				/// Check If Also Needing To Remove Instance From Parent's Cached Array
				for (var _i = array_length(TRUINST.parent_objects) - 1; _i >= 0; _i--) {
					var _parent = TRUINST.parent_objects[_i];
					if (object_is_ancestor(object_index, _parent)) {
						array_find_delete(TRUINST.cache[$ _parent], id);
					}
				}
				/// Remove From Deactivated List
				var _index  = array_find_index(TRUINST.deactivated, id);
				if (_index != -1) {
					array_delete(TRUINST.deactivated,	   _index, 1);
					array_delete(TRUINST.deactivated_data, _index, 1);
				}
				/// Remove From Temp Activated List If Exists There
				var _index  = array_find_index(TRUINST.temp_activated, id);
				if (_index != -1) {
					array_delete(TRUINST.temp_activated, _index, 1);
				}
			}
			return __truInst_instance;
		});
		////////////////////////////////////////////////
		truInst_get_instance	  = method(__truInst_instance, function() {
			/// @func	truInst_get_instance()
			/// @return {struct/instance} truInst_instance
			///
			return __truInst_instance;
		});
		truInst_get_bbox		  = method(__truInst_instance, function() {
			/// @func	truInst_get_bbox()
			/// @return {struct} bbox_data
			///
			return {
				bbox_left:   x - sprite_xoffset,
				bbox_top:    y - sprite_yoffset,
				bbox_right:  x - sprite_xoffset + sprite_width,
				bbox_bottom: y - sprite_yoffset + sprite_height,
			};
		});
		truInst_get_active		  = method(__truInst_instance, function() {
			/// @func	truInst_get_active()
			/// @return {boolean} truInst_active
			///
			return __truInst_active;
		});
		truInst_is_active		  = method(__truInst_instance, function() {
			/// @func	truInst_is_active()
			/// @return {boolean} is_active?
			///
			return truInst_get_active();
		});
		truInst_is_offscreen	  = method(__truInst_instance, function() {
			/// @func	truInst_is_offscreen()
			/// @return {boolean} is_offscreen?
			///
			return TRUINST.is_offscreen(id);
		});
		truInst_is_temp_activated = method(__truInst_instance, function() {
			/// @func	truInst_is_temp_activated(index)
			/// @return {boolean} is_temp_activated?
			///
			if (TRUINST_APPLY_CULLING) {
				return (array_find_index(TRUINST.temp_activated, id) != -1);
			}
			return false;
		});
		truInst_activate		  = method(__truInst_instance, function(_index) {
			/// @func	truInst_activate(index)
			/// @param	{real}			  list_index
			/// @return {struct/instance} truInst_instance
			///
			if (TRUINST_APPLY_CULLING) {
				array_delete(TRUINST.deactivated,	     _index, 1);
				array_delete(TRUINST.deactivated_data,   _index, 1);
				array_find_delete(TRUINST.temp_activated, id);
				if (TRUINST_LOGGING) { show_debug_message("<TRUINST>: object " + string(_inst) + " activated."); }
			}
			instance_activate_object(id);
			__truInst_active = true;
			return __truInst_instance;
		});
		truInst_temp_activate	  = method(__truInst_instance, function() {
			/// @func	truInst_temp_activate()
			/// @return {struct/instance} truInst_instance
			///
			instance_activate_object(id);
			array_push(TRUINST.temp_activated, id);
			return __truInst_instance;
		});
		truInst_deactivate		  = method(__truInst_instance, function() {
			/// @func	truInst_deactivate()
			/// @return {struct/instance} truInst_instance
			///
			if (TRUINST_APPLY_CULLING) {
				array_push(TRUINST.deactivated, id);
				array_push(TRUINST.deactivated_data, { id: id, bbox: truInst_get_bbox() });	
				if (TRUINST_LOGGING) { show_debug_message("<TRUINST>: object " + string(id) + " deactivated."); }
			}
			instance_deactivate_object(id);
			__truInst_active = false;
			return __truInst_instance;
		});
		truInst_destroy			  = method(__truInst_instance, function() {
			/// @func	truInst_destroy()
			/// @return {struct/instance} truInst_instance
			///
			instance_destroy();	// replace with instance.destroy()?
			
			if (TRUINST_APPLY_CULLING) {
				if (TRUINST_LOGGING) { show_debug_message("<TRUINST>: object " + string(id) + " destroyed."); }	
			}
			return __truInst_instance;
		});
		////////////////////////////////////////////////
		truInst_setup(_active); /// <-- automatically invoke setup
	}
	return __truInst_instance;
};
