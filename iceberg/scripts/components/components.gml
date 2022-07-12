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

function Component(_config = {}) constructor {
	/// @func	Component(config*)
	/// @param	{struct}    config={}
	/// @return {Component} self
	///
	__initialized =  false;
	__config	  = _config;
	__owner		  = _config[$ "owner" ] ?? other;
	__active	  = _config[$ "active"] ?? true;
	__name		  = _config[$ "name"  ] ?? __get_name_unique();
	
	#region Private ////////
	
	static __update_data	 = function() {
		/// @func	__update_data()
		/// @return {Component} self
		///
		if (__config[$ "active"] != undefined) set_active(__config.active);
		if (__config[$ "owner "] != undefined) set_owner (__config.owner );
		if (__config[$ "name  "] != undefined) set_name  (__config.name  );
		
		return self;
	};
	static __get_name_unique = function() {
		/// @func	__get_name_unique()
		/// @return {string} name
		///
		return instanceof(self) + "_" + string(ptr(self));
	};
	
	#endregion
	
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
	#region Getters ////////
	
	static get_config = function() {
		/// @func	get_config()
		/// @return {struct} config
		///
		return __config;
	};
	static get_owner  = function() {
		/// @func	get_owner()
		/// @return {struct} owner
		///
		return __owner;
	};
	static get_active = function() {
		/// @func	get_active()
		/// @return {boolean} active?
		///
		return __active;
	};
	static get_name   = function() {
		/// @func	get_name()
		/// @return {string} name
		///
		return __name;
	};
		
	#endregion
	#region Setters	////////
	
	static set_config = function(_config) {
		/// @func	set_config(config)
		/// @param	{struct}	config
		/// @return {Component} self
		///
		__config = _config;
		__update_data();
		return self;
	};
	static set_owner  = function(_owner) {
		/// @func	set_owner(owner)
		/// @param	{instance/struct} owner
		/// @return {Component}	  self
		///
		__owner = _owner;
		return self;
	};
	static set_active = function(_active) {
		/// @func	set_active(active?)
		/// @param	{boolean}	active?
		/// @return {Component} self
		///
		__active = _active;
		return self;
	};
	static set_name   = function(_name) {
		/// @func	set_name(name)
		/// @param	{string}	name
		/// @return {Component} self
		///
		__name = _name;
		return self;
	};
		
	#endregion
};
function Components() : Component() constructor {
	/// @func	Components()
	/// @return {Coop} self
	///
	__interfaces = new Interfaces();
};
	


function Interfaces() : Component() constructor {
	/// @func	Interfaces()
	/// @return {Interfaces} self
	///
	__interfaces = new Stash();
};


#region Moveable ///////////////////

#region Moveable

#region Components /////

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
	__movesets = {
		__sets:	   {},
		__names:   [],
		__current: {
			__set:  undefined,
			__name: undefined,
		},
	};
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
	
	#region MoveSet - Private
	
	static __moveset_update_values	  = function(_moveset = __moveset_get_current()) {
		/// @func	__moveset_update_values(moveset*)
		/// @param	{MoveableMoveset} moveset = moveset_current
		/// @return {Actionable}	  self
		///
		__speed = _moveset.__speed;
		__accel = _moveset.__accel;
		__fric  = _moveset.__fric;
		return self;
	};
	static __moveset_get_current_name = function() {
		/// @func	__moveset_get_current_name()
		///	@return {string} name
		///
		return __movesets.__current.__name;
	};
	static __moveset_get_current	  = function() {
		/// @func	__moveset_get_current()
		/// @return {struct} move_set
		///
		return __movesets.__current.__set;
	};
	static __moveset_get			  = function(_moveset_name) {
		///	@func	__moveset_get(moveset_name)
		/// @param	{string} moveset_name
		/// @return {struct} moveset
		///
		return __movesets.__sets[$ _moveset_name];
	};
	static __moveset_set_current	  = function(_moveset_name) {
		/// @func	__moveset_set_current(moveset_name)
		/// @param	{string}	 moveset_name
		/// @return {Actionable} self
		///
		if (__moveset_exists(_moveset_name)) {
			__movesets.__current.__name = _moveset_name;
			__movesets.__current.__set  = __moveset_get(_moveset_name);
			__moveset_update_values();
		}
		return self;
	};
	static __moveset_exists			  = function(_moveset_name) {
		/// @func	__moveset_exists(moveset_name)
		/// @param	{string}  moveset_name
		/// @return {boolean} exists?
		///
		return __moveset_get(_moveset_name) != undefined;
	};
	static __moveset_add			  = function(_moveset_name, _moveset) {
		/// @func	__moveset_add(moveset_name, moveset)
		/// @param	{string}   moveset_name
		/// @param	{MoveSet}  moveset
		/// @return {Moveable} self
		///
		__movesets.__sets[$ _moveset_name] = _moveset;
		array_push(__movesets.__names, _moveset_name);
		return self;
	};
	static __moveset_remove			  = function(_moveset_name) {
		/// @func	__moveset_remove(moveset_name)
		/// @param	{string}   moveset_name
		/// @return {Moveable} self
		///
		if (__moveset_exists(_moveset_name)) {
			variable_struct_remove(__movesets.__sets, _moveset_name);
			
			/// array_find_delete()
			for (var _i = array_length(__movesets.__names) - 1; _i >= 0; _i--) {
				if (__movesets.__names[_i] == _moveset_name) {
					array_delete(__movesets.__names, _i, 1);
					break;
				}
			}
		}
		return self;
	};
	
	#endregion
	
	static moveset_new		   = function(_moveset_name, _moveset_data) {
		/// @func	moveset_new(moveset_name, moveset_data)
		/// @param	{string}   moveset_name
		/// @param	{struct}   moveset_data
		/// @return {Moveable} self
		///
		var _moveset = new MoveableMoveSet(_moveset_name, _moveset_data);
		__moveset_add(_moveset_name, _moveset);
		return self;
	};
	static moveset_exists	   = function(_moveset_name) {
		/// @func	moveset_exists(moveset_name)
		/// @param	{string}  moveset_name
		/// @return {boolean} moveset_exists?
		///
		return __moveset_exists(_moveset_name);
	};
	static moveset_change	   = function(_moveset_name) {
		/// @func	moveset_change(moveset_name)
		/// @param	{string}   moveset_name
		/// @return {Moveable} self
		///
		if (__moveset_exists(_moveset_name)) {
			var _moveset = __moveset_get(_moveset_name);
			__moveset_set_current(_moveset);
		}
		return self;
	};
	static moveset_add_trigger = function(_moveset_name, _trigger_name, _trigger) {
		/// @func	moveset_add_trigger(moveset_name, trigger_name, trigger)
		/// @param	...
		/// @return {Moveable} self
		///
		
	};
		
	#endregion
};
function MoveableTopDown() : Moveable() constructor {
	/// @func	MoveableTopDown()
	/// @return {Component} self
	///
	
};

#endregion
#region Interfaces /////

function IMoveable(_moveable, _owner = _moveable.get_owner()) : Interface(_moveable, _owner) constructor {
	/// @func	IMoveable(moveable, owner*)
	/// @param	{Moveable}  moveable
	/// @param	{struct}	owner=moveable.get_owner()
	/// @return {IMoveable} self
	///
	__owner.moveset_new = method(__component, __component.moveset_new);
};
	
#endregion
#region Util ///////////

function MoveableMoveSet(_name, _config) constructor {
	/// @func	MoveableMoveSet(name, config)
	/// @param	{string}		  name
	/// @param	{struct}		  config
	/// @return {MoveableMoveSet} self
	///
	__moveable	=  other;
	__name		= _name;
	__config	= _config;
	__speed		= _config[$ "speed"] ?? 0;
	__accel		= _config[$ "accel"] ?? 0;
	__fric		= _config[$ "fric" ] ?? 0;
	__mult		= _config[$ "mult" ] ?? 1;
};

#endregion

#endregion

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

function Triggers() constructor {
	/// @func	Triggers()
	/// @return {Triggers} self
	///
	__triggers = new Stash("triggers");
	__actions  = new Stash("actions");
	
	__owner		= other;
	__triggers  = {
		__active:   true,
		__names:    [],
		__count:    0,
		__triggers: {},
	};
	
	static add_trigger	    = function(_trigger_name, _trigger_method) {
		/// @func	add_trigger(trigger_name, trigger_method)
		/// @param	{string}   trigger_name
		/// @param	{method}   trigger_method
		/// @return {Triggers} self
		///
		if (!has_trigger(_trigger_name)) {
			var _action = self;
			with (__ITriggers) {
				__triggers[$ _trigger_name] = new Trigger({
					owner:  _action,
					name:	_trigger_name,
					method: _trigger_method,
				});
				array_push(__names, _trigger_name);
				__count++;
			}
			/// Register Trigger PubSub Event
			var _component = get_owner();
			_component.event_register( "trigger_executed_" + _trigger_name);
			_component.event_subscribe("trigger_executed_" + _trigger_name, method(self, execute));
		}
		return self;
	};
	static destroy_trigger  = function(_trigger_name) {
		/// @func	destroy_trigger(trigger_name)
		/// @param	{string}   trigger_name
		/// @return {Triggers} self
		///
		if (has_trigger(_trigger_name)) {
			with (__ITriggers) {
				variable_struct_remove(__triggers, _trigger_name);
			
				/// array_find_delete();
				for (var _i = array_length(__names) - 1; _i >= 0; _i--) {
					if (__names[_i] == _trigger_name) {
						array_delete(__names, _i, 1);
						break;
					}
				}
				__count--;
			}
		}
		return self;
	};
	static destroy_triggers = function() {
		/// @func	destroy_triggers()
		/// @return {Triggers} self
		///
		__ITriggers = {
			__names:	[],
			__count:	0,
			__triggers: {},
		};
		return self;
	};
	static update_triggers	= function() {
		/// @func	update_triggers()
		/// @return {Triggers} self
		///
		with (__ITriggers) {
			if (__active) {
				for (var _i = 0; _i < __count; _i++) {
					var _name	 = __names[_i];
					var _trigger = __triggers[$ _name];
					if (_trigger.get_active()) {
						_trigger.execute();
					}
				}
			}
		}
		return self;
	};
	
	#region Getters ////////////
		
	static get_triggers_active = function() {
		/// @func	get_triggers_active()
		/// @return {boolean} are_active?
		///
		return __ITriggers.__active;
	};
	static get_trigger		   = function(_trigger_name) {
		/// @func	get_trigger(trigger_name)
		/// @param	{string} trigger_name
		/// @return {Trigger} trigger
		///
		return __ITriggers.__triggers[$ _trigger_name];
	};
	static get_trigger_active  = function(_trigger_name) {
		/// @func	get_trigger_active(trigger_name)
		/// @param	{string}  trigger_name
		/// @return {boolean} active?
		///
		if (has_trigger(_trigger_name)) {
			return (get_trigger(_trigger_name)).get_active();
		}
		return false;
	};
	static get_trigger_method  = function(_trigger_name) {
		/// @func	get_trigger_method(trigger_name)
		/// @param	{string} trigger_name
		/// @return {method} method
		///
		if (has_trigger(_trigger_name)) {
			return (get_trigger(_trigger_name)).get_method();
		}
		return undefined;
	};
	static get_trigger_data	   = function(_trigger_name) {
		/// @func	get_trigger_data(trigger_name)
		/// @param	{string} trigger_name
		/// @return {method} method
		///
		if (has_trigger(_trigger_name)) {
			return (get_trigger(_trigger_name)).get_data();
		}
		return undefined;
	};
		
	#endregion
	#region Setters	////////////
		
	static set_triggers_active = function(_active) {
		/// @func	set_triggers_active(active?)
		/// @param	{boolean}  active?
		/// @return {Triggers} self
		///
		__ITriggers.__active = _active;
		return self;
	};
	static set_trigger_active  = function(_trigger_name, _active) {
		/// @func	set_trigger_active(trigger_name, active?)
		/// @param	{string}   trigger_name
		/// @param	{boolean}  active?
		/// @return {Triggers} self
		///
		if (has_trigger(_trigger_name)) {
			(get_trigger(_trigger_name)).set_active(_active);
		}
		return self;
	};
	static set_trigger_method  = function(_trigger_name, _trigger_method) {
		/// @func	set_trigger_active(trigger_name, trigger_method)
		/// @param	{string}   trigger_name
		/// @param	{method}   method
		/// @return {Triggers} self
		///
		if (has_trigger(_trigger_name)) {
			(get_trigger(_trigger_name)).set_method(_trigger_method);
		}
		return self;
	};
	static set_trigger_data	   = function(_trigger_name, _trigger_data) {
		/// @func	set_trigger_data(trigger_name, trigger_data)
		/// @param	{string}   trigger_name
		/// @param	{method}   method
		/// @return {Triggers} self
		///
		if (has_trigger(_trigger_name)) {
			(get_trigger(_trigger_name)).set_data(_trigger_data);
		}
		return self;
	};
		
	#endregion
	#region Checkers ///////////
		
	static has_trigger = function(_trigger_name) {
		/// @func	has_trigger(trigger_name)
		/// @param	{string}  trigger_name
		/// @return {boolean} has_trigger?
		///
		return get_trigger(_trigger_name) != undefined;
	};
			
	#endregion
	
	
};

