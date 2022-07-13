/// Insert Ascii Art Here***
//////////////////////////////////////////////////////
//	Components										//								
//		--- components are class objects that 		//
//		|	containerize reusable functionality.    //	
//		--- components can be instantiated as stand //
//		|	alone objects, or be tied into a 		//
//		|	greater component system designed to 	//
//		|	organize and provide structure to a 	//
//		|	series of components.					//							
//		--- any form of generalized logic that can 	//
//		|	be shared across multiple objects 		//
//		|	(regardless of object inheritence) 		//
//		|	should be encapsulated into a component //
//////////////////////////////////////////////////////

function Component(_config = {}) : Class(_config) constructor {
	/// @func	Component(config*)
	/// @param	{struct}    config={}
	/// @return {Component} self
	///
	__initialized = false;
	
	static setup    = function() {		/// @OVERRIDE
		/// @func	setup()
		/// @return {Component} self
		///
		__initialized = true;
		return self;
	}; 
	static teardown = function() {		/// @OVERRIDE
		/// @func	teardown()
		/// @return {Component} self
		///
		__initialized = false;
		return self;
	}; 
	static update   = function() {};	/// @OVERRIDE
	static render   = function() {};	/// @OVERRIDE
	
	#region Actions ////////
	
	static actvate	  = function() {
		/// @func	actvate()
		/// @return {Component} self
		///
		return set_active(true);
	};
	static deactivate = function() {
		/// @func	deactivate()
		/// @return {Component} self
		///
		return set_active(false);
	};
	
	#endregion
};

#region Moveable ///////////////////

function Moveable() : Component() constructor {
	/// @func	Moveable()
	/// @return	{Moveable} self
	///
	__owner	   = other;
	__hspd	   = 0;
	__vspd	   = 0;
	__speed	   = 0;
	__accel	   = 1;
	__fric	   = 1;
	__movesets = new Stash();
	__moveset  = undefined;
	
	///__dir  = undefined;
	///__path = undefined;	// instantiated in setup()
	
	static setup_super	  = setup;
	static setup		  = function() {
		/// @func	setup()
		/// @return {Moveable} self
		///
		if (!__initialized) {
			setup_super();
			//__path = path_add();
			//path_set_kind(__path, 1);
			//path_set_closed(__path, false);
		}
		return self;
	};
	static teardown_super = teardown;
	static teardown		  = function() {
		/// @func	teardown()
		/// @return {Moveable} self
		///
		if (__initialized) {
			teardown_super();
			//path_delete(__path);
			//__path = undefined;
		}
		return self;
	};
	static update		  = function() {
		/// @func	update()
		/// @return {Moveable} self
		///
		//__update_hspd_vspd();
		//__update_xy();
		return self;
	};
		
	#region MoveSet

	static moveset_get		   = function(_name) {
		/// @func	moveset_get(name)
		/// @param	{string}  name
		/// @return {MoveSet} moveset
		///
		return __movesets.get(_name);
	};
	static moveset_set		   = function(_moveset) {
		/// @func	moveset_set(moveset)
		/// @param	{MoveSet}  moveset
		/// @return {Moveable} self
		///
		__moveset = _moveset;
		__moveset_update();
		return self;
	};
	static moveset_add		   = function(_name, _moveset) {
		/// @func	moveset_add(name, moveset)
		/// @param	{string}   name
		/// @param	{Moveset}  moveset
		/// @return {Moveable} self
		///
		__movesets.add(_name, _moveset);
		return self;
	};
	static moveset_new		   = function(_name, _data) {
		/// @func	moveset_new(name, data)
		/// @param	{string}   name
		/// @param	{struct}   data
		/// @return {Moveable} self
		///
		return moveset_add(_name, new MoveSet(_name, _data));
	};
	static moveset_exists	   = function(_name) {
		/// @func	moveset_exists(name)
		/// @param	{string}  name
		/// @return {boolean} exists?
		///
		return __movesets.exists(_name);
	};
	static moveset_clear	   = function() {
		/// @func	moveset_clear()
		/// @return {Moveable} self
		///
		return moveset_set(undefined);
	};
	static moveset_change	   = function(_name) {
		/// @func	moveset_change(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		if (moveset_exists(_name)) {
			moveset_set(moveset_get(_name));
		}
		return self;
	};
	static moveset_apply	   = function() {
		/// @func	moveset_apply()
		/// @return {Moveable} self
		///
		__speed = __moveset.__speed;
		__accel = __moveset.__accel;
		__fric  = __moveset.__fric;
		return self;
	};
	
	static moveset_add_trigger = function(_moveset_name, _trigger_name, _trigger) {};
		
	#endregion
};
function MoveableTopDown() : Moveable() constructor {
	/// @func	MoveableTopDown()
	/// @return {Moveable} self
	///
};
function MoveablePlatformer() : Moveable() constructor {
	/// @func	MoveablePlatformer()
	/// @return {Moveable} self
	///
};
function MoveSet(_name, _config) constructor {
	/// @func	MoveSet(name, config)
	/// @param	{string}  name
	/// @param	{struct}  config
	/// @return {MoveSet} self
	///
	__moveable	=  other;
	__name		= _name;
	__config	= _config;
	__speed		= _config[$ "speed"] ?? 0;
	__accel		= _config[$ "accel"] ?? 0;
	__fric		= _config[$ "fric" ] ?? 0;
	__mult		= _config[$ "mult" ] ?? 1;
	
	__triggers = {};
};

#endregion
#region Actionable /////////////////

function Actionable() : Component() constructor {
	/// @func	Actionable()
	/// @return {Component}	self 
	///
	__fsm = undefined;
	
	static update = function() {
		/// @func	update()
		/// @return {Actionable} self
		///
		if (__fsm != undefined) {
			__fsm.step();
		}
		return self;
	};
	static render = function() {
		/// @func	render()
		/// @return {Actionable} self
		///
		if (__fsm != undefined) {
			__fsm.draw();	
		}
		return self;
	};
	
	/// States
	static actionable_state_add			 = function(_state_name, _state_struct) {
		/// @func	actionable_state_add(state_name, state_struct)
		/// @param	{string}	 state_name
		/// @param	{struct}	 state_struct
		/// @return {Actionable} self
		///
		if (__fsm == undefined) {
			__fsm  = new SnowState(_state_name, false);
		}
		__fsm.add(_state_name, _state_struct);
		return self;
	};
	static actionable_state_change		 = function(_state_name) {
		/// @func	actionable_state_change(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		__fsm.change(_state_name);
		return self;
	};
	static actionable_state_is			 = function(_state_name) {
		/// @func	actionable_state_is(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		return __fsm.state_is(_state_name);
	};
	static actionable_state_exists		 = function(_state_name) {
		/// @func	actionable_state_exists(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		return __fsm.state_exists(_state_name);
	};
	static actionable_state_get_states	 = function() {
		/// @func	actionable_state_get_states()
		/// @return {Actionable} self
		///
		return __fsm.get_states();
	};
	static actionable_state_get_current  = function() {
		/// @func	actionable_state_get_current()
		/// @return {Actionable} self
		///
		return __fsm.get_current_state();
	};
	static actionable_state_get_previous = function() {
		/// @func	actionable_state_get_previous()
		/// @return {Actionable} self
		///
		return __fsm.get_previous_state();
	};
	static actionable_state_get_time	 = function(_us = true) {
		/// @func	actionable_state_get_time(us*)
		/// @param	{boolean}	 us?=true
		/// @return {Actionable} self
		///
		return __fsm.get_time(_us);
	};
	static actionable_state_set_time	 = function(_time, _us = true) {
		/// @func	actionable_state_set_time(time, us*)
		/// @param	{milliseconds} time
		/// @param	{boolean}	   us?=true
		/// @return {Actionable}   self
		///
		__fsm.set_time(_time, _us);
		return self;
	};
	static state_add					 = actionable_state_add;
	static state_change					 = actionable_state_change;
	static state_is						 = actionable_state_is;
	static state_exists					 = actionable_state_exists;
	static state_get_states				 = actionable_state_get_states;
	static state_get_current			 = actionable_state_get_current;
	static state_get_previous			 = actionable_state_get_previous;
	static state_get_time				 = actionable_state_get_time;
	static state_set_time				 = actionable_state_set_time;
};

#endregion
#region Collidable /////////////////

function Collidable() : Component() constructor {
	/// @func	Collidable()
	/// @return {Component} self
	///
	__owner		 = other;
	__collisions = undefined;
	
	static setup_super	  = setup;
	static setup		  = function() {
		/// @func	setup()
		/// @return {Collidable} self
		///
		if (!__initialized) {
			setup_super();	
			
			__collisions = ds_list_create();
		}
		return self;
	};
	static teardown_super = teardown;
	static teardown		  = function() {
		/// @func	teardown()
		/// @return {Collidable} self
		///
		if (__initialized) {
			teardown_super();
			
			ds_list_destroy(__collisions);
			__collisions = undefined;
		}
		return self;
	};
};

#endregion
#region Scriptable /////////////////

function Scriptable() : Component() constructor {
	/// @func	Scriptable()
	/// @return {Component} self
	///
};

#endregion
#region Eventable //////////////////

function EventObject(_name = "") {
	/// @func	EventObject(name*)
	/// @param	{string} name=""
	/// @return	{struct} event_instance
	///
	__event_instance  =  self;
	__event_publisher =  new Publisher();
	__event_name	  = _name;

	event_setup				= method(__event_instance, function() {
		/// @func	event_setup()
		/// @return	{struct} event_instance
		///
		return __event_instance;
	});
	event_update			= method(__event_instance, function() {
		/// @func	event_update()
		/// @return	{struct} event_instance
		///
		return __event_instance;
	});
	event_teardown			= method(__event_instance, function() {
		/// @func	event_teardown()
		/// @return	{struct} event_instance
		///
		return __event_instance;
	});
	////////////////////////////////////////////////////
	event_get_instance		= method(__event_instance, function() {
		/// @func	event_get_instance()
		/// @return	{struct} event_instance
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
		/// @param	{array}	 event_array
		/// @parma	{bool}	 push_to_global=false
		/// @return	{struct} event_instance
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
		/// @param	{string} event_name
		/// @param	{any}	 payload=undefined
		/// @param	{bool}	 push_to_global=false
		/// @return	{struct} event_instance
		///
		/*	<data_struct>: {
				id:		 self,
				payload: any,
			}
		*/
		var _publisher   = event_get_publisher();
		var _data_struct = {
			self:	  event_get_instance(),
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
		/// @param	{string}  event_name
		/// @param	{method}  callback_method
		/// @param	{boolean} weak_reference=false
		/// @return	{struct}  event_instance
		///
		var _publisher = event_get_publisher();
		_publisher.subscribe(_event_name, _callback, _weak_reference);
		return __event_instance;
	});
	event_unsubscribe		= method(__event_instance, function(_event_name, _force = false) {
		/// @func	event_unsubscribe(event_name, force?*)
		/// @param	{string}  event_name
		/// @parma	{boolean} force=false
		/// @return	{struct}  event_instance
		///
		var _publisher = event_get_publisher();
		_publisher.unsubscribe(_event_name, _force);
		return __event_instance;
	});
	event_clear_subscribers = method(__event_instance, function(_event_name) {
		/// @func	event_clear_subscribers(event_name)
		/// @param	{string} event_name
		/// @return	{struct} event_instance
		///
		var _publisher = event_get_publisher();
		_publisher.clear_channel(_event_name);
		return __event_instance;
	});	
	////////////////////////////////////////////////////
	event_setup(); /// <-- automatically invoke setup
	
	return __event_instance;
};

#endregion
#region Saveable ///////////////////

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

#endregion
#region Cullable ///////////////////

function truInst_setup(_truInst_instance = self, _active = true) {
	
	
	/// REPLACE INSTANCE ID WITH APPROPRAITE SELF
	
	
	/// @func	truInst_setup(truInst_instance*, active?*)	
	/// @param	{struct}  truInst_instance=other
	/// @param	{boolean} active=true
	/// @return {struct}  truInst_instance
	///
	with (_truInst_instance) {		
		__truInst_instance = _truInst_instance;
		__truInst_active   = _active;
	
		#region Private ////////
		
		__truInst_setup	   = method(__truInst_instance, function(_active = true) {
			///	@func	__truInst_setup(active?*)
			/// @param	{boolean} active=true
			/// @return {struct}  truInst_instance
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
		__truInst_update   = method(__truInst_instance, function(_destroy_if_offscreen = false) {
			/// @func	__truInst_update(destroy_if_offscreen*)
			/// @param	{boolean} destroy_if_offscreen=false
			/// @return {struct}  truInst_instance
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
		__truInst_teardown = method(__truInst_instance, function() {
			/// @func	__truInst_teardown()
			/// @return {struct} truInst_instance
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
		
		#endregion
		
		truInst_update			  = method(__truInst_instance, function(_destroy_if_offscreen = false) {
			/// @func	truInst_update(destroy_if_offscreen*)
			/// @param	{boolean} destroy_if_offscreen=false
			/// @return {struct}  truInst_instance
			///
			return __truInst_update(_destroy_if_offscreen);
		});
		truInst_teardown		  = method(__truInst_instance, function() {
			/// @func	truInst_teardown()
			/// @return {struct} truInst_instance
			///	
			return __truInst_teardown();
		});
		truInst_get_instance	  = method(__truInst_instance, function() {
			/// @func	truInst_get_instance()
			/// @return {struct} truInst_instance
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
			/// @param	{real}	 list_index
			/// @return {struct} truInst_instance
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
			/// @return {struct} truInst_instance
			///
			instance_activate_object(id);
			array_push(TRUINST.temp_activated, id);
			return __truInst_instance;
		});
		truInst_deactivate		  = method(__truInst_instance, function() {
			/// @func	truInst_deactivate()
			/// @return {struct} truInst_instance
			///
			if (TRUINST_APPLY_CULLING) {
				array_push(TRUINST.deactivated, id);
				array_push(TRUINST.deactivated_data, { id: id, bbox: truInst_get_bbox() });	
				if (TRUINST_LOGGING) { show_debug_message("<TRUINST>: object " + string(self.id) + " deactivated."); }
			}
			instance_deactivate_object(id);
			__truInst_active = false;
			return __truInst_instance;
		});
		truInst_destroy			  = method(__truInst_instance, function() {
			/// @func	truInst_destroy()
			/// @return {struct} truInst_instance
			///
			instance_destroy();	// replace with instance.destroy()?
			
			if (TRUINST_APPLY_CULLING) {
				if (TRUINST_LOGGING) { show_debug_message("<TRUINST>: object " + string(self.id) + " destroyed."); }	
			}
			return __truInst_instance;
		});
		
		__truInst_setup(_active); /// <-- automatically invoke setup
	}
	return _truInst_instance;
};

#endregion
