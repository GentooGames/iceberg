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

/// ADD EVENTABLE IMPLEMENTATION TO COMPONENTS

function Component(_config = {}) : Class(_config) constructor {
	/// @func	Component(config*)
	/// @param	{struct}    config={}
	/// @return {Component} self
	///
	__initialized =  false;
	__active	  = _config[$ "active"] ?? true;
	
	#region Core ///////////////
	
	static setup    = function() {	/// @OVERRIDE
		/// @func	setup()
		/// @return {Component} self
		///
		if (!is_initialized()) {
			__initialized = true;
		}
		return self;
	}; 
	static teardown = function() {	/// @OVERRIDE
		/// @func	teardown()
		/// @return {Component} self
		///
		if (is_initialized()) {
			__initialized = false;
		}
		return self;
	}; 
	static rebuild  = function() {	/// @OVERRIDE
		/// @func	rebuild()
		/// @return {Component} self
		///
		if (is_initialized()) {
			teardown();
			setup();
		}
		return self;
	};
	static update   = function() {	/// @OVERRIDE
		/// @func	update()
		/// @return {Component} self
		///
		if (is_initialized() && is_active()) {
			// ...
		}
		return self;
	};	
	static render   = function() {	/// @OVERRIDE
		/// @func	render()
		/// @return {Component} self
		///
		if (is_initialized() && is_active()) {
			// ...
		}
		return self;
	};	
	
	#endregion
	#region Actions ////////////
	
	static activate	  = function() {
		/// @func	activate()
		/// @return {Component} self
		///
		__active = true;
		return self;
	};
	static deactivate = function() {
		/// @func	deactivate()
		/// @return {Component} self
		///
		__active = false;
		return self;
	};
		
	#endregion
	#region Checkers ///////////
	
	static is_initialized = function() {
		/// @func	is_initialized()
		/// @return {bool} initialized?
		///
		return __initialized;
	};
	static is_active	  = function() {
		/// @func	is_active()
		/// @return {bool} active?
		///
		return __active;
	};
		
	#endregion
};
	
#region Component Manager //////////

function ComponentManager(_config = {}) : Component(_config) constructor {
	/// @func	ComponentManager(config*)
	/// @param	{struct}		   config={}
	/// @return {ComponentManager} self
	///
	__components = new Container();
	
	static add_component = function() {};
	static get_component = function() {};
	static has_component = function() {};
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

function Eventable(_config = {}) : Component(_config) constructor {
	/// @func	Eventable(config*)
	/// @param	{struct}	config={}
	/// @return {Eventable} self
	///
	__broadcaster = undefined;	/// <-- instantiated in setup()
	__logging	  = DEBUGGING && 1;

	#region Private ////////
	
	static __setup	  = setup;
	static __teardown = teardown;
	
	#endregion
	#region Core ///////////
	
	static setup    = function() {
		/// @func	setup()
		/// @return {Eventable} self
		///
		if (!is_initialized()) {
			__setup();
			__broadcaster = new Publisher();
			register([
				"registered",
				"broadcasted",
				"listened",
				"listeners_cleared",
			]);
		}
		return self;
	};
	static teardown = function() {
		/// @func	teardown()
		/// @return {Eventable} self
		///
		if (is_initialized()) {
			__teardown();
			__broadcaster = undefined;
		}
		return self;
	};
	
	#endregion
	#region Actions ////////
	
	static register			= function(_events) {
		/// @func	register(events)
		/// @param	{array}		events
		/// @return	{Eventable} self
		///
		if (!is_array(_events)) {
				_events = [_events];	
			}
		for (var _i = 0, _len = array_length(_events); _i < _len; _i++) {
				get_broadcaster().register_channel(_events[_i]);
			}
		broadcast("registered", _events);
		return self;
	};
	static broadcast		= function(_event_name, _payload = undefined) {
		/// @func	 broadcast(event_name, payload*)
		/// @param	{string}	event_name
		/// @param	{any}		payload=undefined
		/// @return	{Eventable} self
		///
		/*	<data_struct>: {
				eventable: self,
				instance:  owner,
				payload:   <any>,
			}
		*/
		if (is_active()) {
			var _self  = self;
			var _owner = get_owner();
			var _data  = {
				eventable: _self,
				instance:  _owner,
				payload:   _payload,
			}
			get_broadcaster().publish(_event_name, _data);
			get_broadcaster().publish("broadcasted", _data);

			if (__logging) {
				log("<PUBLISHER> {0} \n\t event : {1} \n\t payload : {2}", instanceof(_owner), _event_name, _payload);
			}
		}
		return self;
	};
	static listen			= function(_event_name, _callback, _weak_reference = false) {
		/// @func	listen(event_name, callback, weak_reference?)
		/// @param	{string}	event_name
		/// @param	{method}	callback_method
		/// @param	{boolean}	weak_reference=false
		/// @return	{Eventable} self
		///
		get_broadcaster().subscribe(_event_name, _callback, _weak_reference);
		broadcast("listened", { 
			event_name: _event_name,
			callback:   _callback,
		});
		return self;
	};
	static clear_listeners	= function(_event_name) {
		/// @func	clear_listeners(event_name)
		/// @param	{string}	event_name
		/// @return	{Eventable} self
		///
		__publisher.clear_channel(_event_name);
		broadcast("listeners_cleared", _event_name);
		return self;
	};
	static enable_logging	= function() {
		/// @func	enable_logging()
		/// @return {Eventable} self
		///
		__logging = true;
		return self;
	};
	static disable_logging	= function() {
		/// @func	disable_logging()
		/// @return {Eventable} self
		///
		__logging = false;
		return self;
	};
	
	//static unsubscribe_subscriber = function(_subscriber, _force = false) {};
	
	#endregion
	#region Getters ////////
	
	static get_broadcaster = function() {
		/// @func	get_broadcaster()
		/// @return {Publisher} publisher
		///
		return __broadcaster;
	};
	
	#endregion
	#region Checkers ///////
	
	static is_registered = function(_event_name) {
		/// @func	is_registered(event_name)
		/// @param	{string}  event_name
		/// @return {boolean} is_registered?
		///
		return get_broadcaster().has_registered_channel(_event_name);
	};
		
	#endregion
};

#endregion
#region Moveable ///////////////////

function Moveable(_config = {}) : Component(_config) constructor {
	/// @func	Moveable(config*)
	/// @param	{struct}   config={}
	/// @return	{Moveable} self
	///
	__owner	  = other;
	__hspd	  = 0;
	__vspd	  = 0;
	__speed	  = _config[$ "speed"] ?? 0;
	__accel	  = _config[$ "accel"] ?? 0;
	__fric	  = _config[$ "fric" ] ?? 0;
	__mult	  = _config[$ "mult" ] ?? 0;
	__moveset = {
		__movesets:	undefined,	// collection 
		__default:	undefined,	// default
		__moveset:	undefined,	// current
	};
	__path	  = {
		__index:  undefined,
		__smooth: true,
		__closed: false,
	};
	
	#region Private ////////////
	
	#region Setup //////////////
	
	static __setup		   = setup;
	static __setup_moveset = function(_default_name = "__default__") {
		/// @func	__setup_moveset(default_name*)
		/// @param	{string}   default_name=__default__
		/// @return {Moveable} self
		///
		var _movesets = new Container({ name: "movesets" });
		var _moveset  = new MoveSet({ 
			name:  _default_name,
			speed: __speed,
			accel: __accel,
			fric:  __fric,
			mult:  __mult,
		});
		
		__moveset.__movesets = _movesets;
		__set_moveset_default(_moveset);
		__set_moveset_current(_moveset);
		  add_moveset(_default_name, _moveset);
		  apply_moveset();
		  
		return self;
	};
	static __setup_path    = function() {
		/// @func	__setup_path()
		/// @return {Moveable} self
		///
		with (__path) {
			__index = path_add();
			path_set_kind(__index, __smooth);
			path_set_closed(__index, __closed);
		}
		return self;
	};
	
	#endregion
	#region Teardown ///////////
	
	static __teardown		  = teardown;
	static __teardown_moveset = function() {
		/// @func	__teardown_moveset()
		/// @return {Moveable} self
		///
		__moveset.__movesets = undefined;
		__set_moveset_default(undefined);
		__set_moveset_current(undefined);
		
		return self;
	};
	static __teardown_path	  = function() {
		/// @func	__teardown_path()
		/// @return {Moveable} self
		///
		with (__path) {
			path_delete(__index);
			__index = undefined;
		}
		return self;
	};
	
	#endregion
	#region Update /////////////
	
	static __update = update;
	
	#endregion
	#region Getters ////////////
	
	static __get_moveset_current = function() {
		/// @func	__get_moveset_current()
		/// @return {MoveSet} moveset
		///
		with (__moveset) {
			return __moveset;
		}
	};
	static __get_moveset_default = function() {
		/// @func	__get_moveset_default()
		/// @return {MoveSet} moveset
		///
		with (__moveset) {
			return __default;
		}
	};
	
	#endregion
	#region Setters ////////////
	
	static __set_moveset_current = function(_moveset) {
		/// @func	__set_moveset_current(moveset)
		/// @param	{MoveSet}  moveset
		/// @return {Moveable} self
		///
		with (__moveset) {
			__moveset = _moveset;
		}
		return self;
	};
	static __set_moveset_default = function(_moveset) {
		/// @func	__set_moveset_default(moveset)
		/// @param	{MoveSet}  moveset
		/// @return {Moveable} self
		///
		with (__moveset) {
			__default = _moveset;
		}
		return self;
	};
	
	#endregion
	
	#endregion
	#region Core ///////////////
	
	static setup	= function() {
		/// @func	setup()
		/// @return {Moveable} self
		///
		if (!is_initialized()) {
			__setup();
			__setup_moveset();
			//__setup_path();
			
			/// ACTION & TRIGGER TESTING
			/// rework and move into setup()
			eventer = new Eventable().setup();	
			action_change_moveset = new Action({ 
				method: method(self, function(_moveset_name) {
					change_moveset("test");
				})
			});
		}
		return self;
	};
	static teardown	= function() {
		/// @func	teardown()
		/// @return {Moveable} self
		///
		if (is_initialized()) {
			__teardown();
			__teardown_moveset();
			//__teardown_path();
		}
		return self;
	};
	static update	= function() {
		/// @func	update()
		/// @return {Moveable} self
		///
		if (is_initialized() && is_active()) {
			__update();
			//__update_hspd_vspd();
			//__update_xy();
		}
		return self;
	};
	
	#endregion
	
	static get_moveset		   = function(_name) {
		/// @func	get_moveset(name)
		/// @param	{string}  name
		/// @return {MoveSet} moveset
		///
		with (__moveset) {
			return __movesets.get(_name);
		}
	};
	static set_moveset		   = function(_moveset) {
		/// @func	set_moveset(moveset)
		/// @param	{MoveSet}  moveset
		/// @return {Moveable} self
		///
		__set_moveset_current(_moveset);
		apply_moveset();
		return self;
	};
	static add_moveset		   = function(_name, _moveset) {
		/// @func	add_moveset(name, moveset)
		/// @param	{string}   name
		/// @param	{MoveSet}  moveset
		/// @return {Moveable} self
		///
		with (__moveset) {
			__movesets.add(_name, _moveset);
		}
		return self;
	};
	static new_moveset		   = function(_name, _data) {
		/// @func	new_moveset(name, data)
		/// @param	{string}   name
		/// @param	{struct}   data
		/// @return {Moveable} self
		///
		_data[$ "name"] = _name;	// append name onto data struct
		
		var _moveset = new MoveSet(_data);
		add_moveset(_name, _moveset);
		return self;
	};
	static has_moveset		   = function(_name) {
		/// @func	has_moveset(name)
		/// @param	{string}  name
		/// @return {boolean} exists?
		///
		with (__moveset) {
			return __movesets.exists(_name);
		}
	};
	static reset_moveset	   = function() {
		/// @func	reset_moveset()
		/// @return {Moveable} self
		///
		return set_moveset(__get_moveset_default());
	};
	static change_moveset	   = function(_name) {
		/// @func	change_moveset(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		if (has_moveset(_name)) {
			set_moveset(get_moveset(_name));
		}
		return self;
	};
	static apply_moveset	   = function(_moveset = __get_moveset_current()) {
		/// @func	apply_moveset(moveset*)
		/// @param	{MoveSet}  moveset=moveset_get_current
		/// @return {Moveable} self
		///
		__speed = _moveset.__speed;
		__accel = _moveset.__accel;
		__fric  = _moveset.__fric;
		__mult  = _moveset.__mult;
		return self;
	};
	static set_moveset_default = function(_data) {
		/// @func	set_moveset_default(data)
		/// @param	{struct}   data
		/// @return {Moveable} self
		///
		__get_moveset_default().set_data(_data);
		return self;
		
	};
	static add_moveset_trigger = function(_moveset_name, _trigger_method) {};
	
	/// WIRE EVENT TO TRIGGER PUBSUB TO TRIGGER MOVESET CHANGE
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

#endregion
#region Actionable /////////////////

function Actionable() : Component() constructor {
	/// @func	Actionable()
	/// @return {Component} self 
	///
	__fsm = undefined;
	
	#region Core ///////////////
	
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
	
	#endregion
	
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
	
	#region Private ////////
	
	static __setup	  = setup;
	static __teardown = teardown;
	
	#endregion
	#region Core ///////////
	
	static setup	= function() {
		/// @func	setup()
		/// @return {Collidable} self
		///
		if (!__initialized) {
			__setup();	
			__collisions = ds_list_create();
		}
		return self;
	};
	static teardown = function() {
		/// @func	teardown()
		/// @return {Collidable} self
		///
		if (__initialized) {
			__teardown();
			ds_list_destroy(__collisions);
			__collisions = undefined;
		}
		return self;
	};
		
	#endregion
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

