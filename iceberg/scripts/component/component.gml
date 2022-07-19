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

#macro __COMPONENT_SYSTEM_VAR_NAME "__component_system"

function Component(_config = {}) : Class(_config) constructor {
	/// @func	Component(config*)
	/// @param	{struct}    config={}
	/// @return {Component} self
	///
	__config	  = _config;
	__initialized =  false;
	__active	  =  true;
	__system	  =  undefined;
	
	#region Private ////////
	
	static __get_owners_system		= function() {
		/// @func	__get_owners_system()
		/// @return {component} system
		///
		return __owner[$ __COMPONENT_SYSTEM_VAR_NAME];
	};
	static __is_owners_system_setup	= function() {
		/// @func	__is_owners_system_setup()
		/// @return {bool} owner_has_system?
		///
		return variable_struct_exists(__owner, __COMPONENT_SYSTEM_VAR_NAME);
	};
	
	#endregion
	#region Core ///////////
	
	static __setup_component    = function() {
		/// @func	__setup_component()
		/// @return {Component} self
		///
		if (!is_initialized()) {
			#region Props //////
			
			if (__config[$ "active"] != undefined) __active = __config[$ "active"];
			if (__config[$ "system"] != undefined) __system = __config[$ "system"];
			
			#endregion
			#region System /////
			
			/// Initialize Dynamic ComponentSystem() Var
			if (__system == undefined) {
				if (!__is_owners_system_setup()) {
					component_system_setup(__owner);
				}
				__system = __get_owners_system(); // may still be undefined
			}
			
			/// Add Self Component To ComponentSystem
			if (has_system()) {
				get_system().add_component(self);
			}
			
			#endregion
			__initialized = true;
		}
		return self;
	}; 
	static __teardown_component = function() {
		/// @func	__teardown_component()
		/// @return {Component} self
		///
		if (is_initialized()) {
			#region System /////
			
			if (__system != undefined) {
				__system.remove_component(__name);
				
				/// Destroy Dynamic ComponentSystem() Var If Empty
				if (__system.is_empty()) {
					component_system_teardown();
				}
				__system.teardown();	
				__system = undefined;
			}
			
			#endregion
			__initialized = false;
		}
		return self;
	}; 
	static __rebuild_component  = function(_config = undefined) {
		/// @func	__rebuild_component(config*)
		/// @param	{struct}	config=undefined
		/// @return {Component} self
		///
		if (is_initialized()) {
			teardown();
			#region Props //////
			
			if (_config != undefined) {
				__config = _config;	
			}
			
			#endregion
			setup();
		}
		return self;
	}; 
	static __update_component   = function() {
		/// @func	__update_component()
		/// @return {Component} self
		///
		if (is_initialized() && is_active()) {
			// ...
		}
		return self;
	};	
	static __render_component   = function() {
		/// @func	__render_component()
		/// @return {Component} self
		///
		if (is_initialized() && is_active()) {
			// ...
		}
		return self;
	};	
		
	static setup	= __setup_component;	/// @OVERRIDE
	static teardown	= __teardown_component;	/// @OVERRIDE
	static update	= __update_component;	/// @OVERRIDE
	static render	= __render_component;	/// @OVERRIDE
	
	#endregion
	#region Getters ////////
	
	static get_system = function() {
		/// @func	get_system()
		/// @return {Component} system
		///
		return __system;
	};
	
	#endregion
	#region Setters ////////
	
	static set_system = function(_system) {
		/// @func	set_system(system)
		/// @param	{Component} system
		/// @return {Component} self
		///
		__system = _system;
		return self;
	};
	
	#endregion
	#region Checkers ///////
	
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
	static has_system	  = function() {
		/// @func	has_system()
		/// @return {bool} has_system?
		///
		return get_system() != undefined;
	};
		
	#endregion
	
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
};
	
#region Component System ///////////

function ComponentSystem(_config = {}) : Component(_config) constructor {
	/// @func	ComponentSystem(config*)
	/// @param	{struct}		  config
	/// @return {ComponentSystem} self
	///
	__components = new Set();
	__categories = new Family();
	
	#region Core ///////////
	
	static __setup_component_system		= function() {
		/// @func	__setup_component_system()
		/// @return	{Component} self
		///
		if (!is_initialized()) {
			__setup_component();
		}
		return self;
	};
	static __teardown_component_system	= function() {
		/// @func	__teardown_component_system()
		/// @return	{Component} self
		///
		if (is_initialized()) {
			__teardown_component();
		}
		return self;
	};
	
	static setup	= __setup_component_system;
	static teardown = __teardown_component_system;
	
	#endregion
	
	static get_size = function() {
		/// @func	get_size()
		/// @return {real} size
		///
		return __components.get_size();
	};
	static is_empty = function() {
		/// @func	is_empty()
		/// @return {bool} is_empty?
		///
		return get_size() <= 0;
	};
	static empty	= function() {
		///	@func	empty()
		/// @return {Component} self
		///
		__components.empty();
		__categories.empty();
		return self;
	};
	
	/// Single Component
	static add_component	 = function(_component) {
		///	@func	add_component(component)
		/// @param	{Component}	component
		/// @return {Component} self
		///
		 _component.set_system(self);
		__components.add_item(_component.get_name(), _component);
		__categories.add_item(instanceof(_component), _component);
		return self;
	};
	static new_component	 = function(_component_name, _component_literal) {
		/// @func	new_component(component_name, component_literal)
		/// @param	{string}	component_name
		/// @param	{literal}	component_literal
		/// @return {Component} self
		///
		return add_component(new _component_literal({
			owner:  get_owner(),	
			name:  _component_name,
		}).setup());
	};
	static has_component	 = function(_component_name) {
		/// @func	has_component(component_name)
		/// @param	{string}  component_name
		/// @return {boolean} has_component?
		///
		return get_component(_component_name) != undefined;
	};
	static get_component	 = function(_component_name) {
		///	@func	get_component(component_name)
		/// @param	{string}	component_name
		/// @return {Component} component
		///
		return __components.get_item(_component_name);
	};
	static remove_component  = function(_component_name) {
		///	@func	remove_component(component_name)
		/// @param	{string}	component_name
		/// @return {Component} self
		///
		if (__components.has_item(_component_name)) {
			var _component = __components.get_item(_component_name);
			__components.remove_item(_component_name);
			__categories.remove_item(instanceof(_component), _component);
		}
		return self;
	};
	static act_on_component	 = function(_component_name, _method, _data = undefined) {
		/// @func	act_on_component(component_name, method, data*)
		/// @param	{string}	component_name
		/// @param	{method}	method
		/// @param	{any}		data=undefined
		/// @return {Component} self
		///
		if (has_component(_component_name)) {
			var _component = get_component(_component_name);
			with (_component) {
				_method(_data);	
			}
		}
		return self;
	};
	
	/// Components
	static has_components	 = function(_component_literal) {
		/// @func	has_components(component_literal)
		/// @param	{literal} component_literal
		/// @return {boolean} has_components?
		///
		var _category   = script_get_name(_component_literal);
		var _components = get_components(_category);
		return array_length(_components) > 0;
	};
	static get_components	 = function(_component_literal) {
		/// @func	get_components(component_literal)
		/// @param	{literal} component_literal
		/// @return {array}   components
		///
		var _category = script_get_name(_component_literal);
		return __categories.get_items(_category);
	};
	static act_on_components = function(_category_name, _method, _data = undefined) {
		/// @func	act_on_components(category_name, method, data*)
		/// @param	{string}	category_name
		/// @param	{method}	method
		/// @param	{any}		data=undefined
		/// @return {Component} self
		///
		if (has_components(_category_name)) {
			var _components = get_components(_category_name);
			for (var _i = 0, _len = array_length(_components); _i < _len; _i++) {
				var _component = _components[_i];
				with (_component) {
					_method(_data);	
				}
			}
		}
		return self;
	};
		
	/// since we cannot overload methods, and would love to have remove_component(component_instance)
	/// instead have components be able to remove themselves with .remove()
};
function component_system_setup(_owner = self) {
	/// @func	component_system_setup(owner*)
	/// @param	{struct}	owner=self
	/// @return {component} system
	///
	_owner[$ __COMPONENT_SYSTEM_VAR_NAME] = undefined;	// set to undefined in order to avoid recursive loop
	_owner[$ __COMPONENT_SYSTEM_VAR_NAME] = new ComponentSystem({ owner: _owner }).setup();	// <-----------'
	_owner[$ "component_system"]		  = method(_owner, function() {
		/// @func	component_system()
		/// @return {Component} system
		///
		return self[$ __COMPONENT_SYSTEM_VAR_NAME]; // <-- can use more explicit accessor should be
	});
	
	return _owner[$ __COMPONENT_SYSTEM_VAR_NAME];
};
function component_system_teardown(_owner = self) {
	/// @func	component_system_teardown(owner*)
	/// @param	{struct}	owner=self
	/// @return {component} system
	///
	_owner.component_system().teardown();
	_owner.variable_struct_remove(self, __COMPONENT_SYSTEM_VAR_NAME);
	_owner.variable_struct_remove(self, "component_system");
	return _owner;
};

#endregion
#region Eventable //////////////////

function Eventable(_config = {}) : Component(_config) constructor {
	/// @func	Eventable(config*)
	/// @param	{struct}	config={}
	/// @return {Eventable} self
	///
	__broadcaster = undefined;		/// <-- instantiated in setup()
	__logging	  = DEBUGGING && 1;

	#region Core ///////////
	
	static __setup_eventable    = function() {
		/// @func	__setup_eventable()
		/// @return {Eventable} self
		///
		if (!is_initialized()) {
			__setup_component();
			#region Broadcaster
			
			__broadcaster = new Publisher();
			register([
				"registered",
				"broadcasted",
				"listened",
				"listeners_cleared",
			]);
			
			#endregion
		}
		return self;
	};
	static __teardown_eventable = function() {
		/// @func	__teardown_eventable()
		/// @return {Eventable} self
		///
		if (is_initialized()) {
			#region Broadcaster
			
			__broadcaster = undefined;
			
			#endregion
			__teardown_component();
		}
		return self;
	};
		
	static setup	= __setup_eventable;
	static teardown = __teardown_eventable;
	
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
	__speed	  = 0;
	__accel	  = 0;
	__fric	  = 0;
	__mult	  = 0;
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
	
	//action_change_moveset = new Action({ 
	//	method: method(self, function(_moveset_name) {
	//		change_moveset("test");
	//	})
	//});
	//static add_moveset_trigger = function(_moveset_name, _trigger_method) {};

	#region Core ///////////////
	
	static __setup_moveable	   = function() {
		/// @func	__setup_moveable()
		/// @return {Moveable} self
		///
		if (!is_initialized()) {
			__setup_component();
			#region Props //////
			
			if (__config[$ "speed"] != undefined) __speed = __config.speed;
			if (__config[$ "accel"] != undefined) __accel = __config.accel;
			if (__config[$ "fric" ] != undefined) __fric  = __config.fric;
			if (__config[$ "mult" ] != undefined) __mult  = __config.mult;
			
			#endregion
			#region Eventer //// 
			
			eventer = new Eventable().setup();	
			
			#endregion
			#region Moveset ////
			
			__moveset.__movesets = new Set();
			set_moveset_default(new MoveSet({ 
				name:  "__default__",
				speed: __speed,
				accel: __accel,
				fric:  __fric,
				mult:  __mult,
			}));
			add_moveset("__default__", get_moveset_default());
			set_moveset(get_moveset_default());
			
			#endregion
			#region Path ///////
			
			with (__path) {
				__index = path_add();
				path_set_kind(__index, __smooth);
				path_set_closed(__index, __closed);
			}
			
			#endregion
		}
		return self;
	};
	static __teardown_moveable = function() {
		/// @func	__teardown_moveable()
		/// @return {Moveable} self
		///
		if (is_initialized()) {
			#region Path ///////
			
			with (__path) {
				path_delete(__index);
				__index = undefined;
			}
			
			#endregion
			#region Moveset ////
			
			__moveset.__movesets = undefined;
			set_moveset_default(undefined);	/// should this be resetting back to default moveset instead? should config be considered here?
			set_moveset(undefined, false);	/// should this be resetting back to default moveset instead? should config be considered here?
			
			#endregion
			#region Eventer ////
			
			eventer.teardown();
			eventer = undefined;
			
			#endregion
			__teardown_component();
		}
		return self;
	};
	static __update_moveable   = function() {
		/// @func	__update_moveable()
		/// @return {Moveable} self
		///
		if (is_initialized() && is_active()) {
			__update_component();
		}
		return self;
	};
	
	static setup	= __setup_moveable;
	static teardown = __teardown_moveable;
	static update	= __update_moveable;
	
	#endregion
	#region Getters ////////////
	
	static get_moveset		   = function(_name) {
		/// @func	get_moveset(name)
		/// @param	{string}  name
		/// @return {MoveSet} moveset
		///
		with (__moveset) {
			return __movesets.get_item(_name);
		}
	};
	static get_moveset_current = function() {
		/// @func	get_moveset_current()
		/// @return {MoveSet} moveset
		///
		with (__moveset) {
			return __moveset;
		}
	};
	static get_moveset_default = function() {
		/// @func	get_moveset_default()
		/// @return {MoveSet} moveset
		///
		with (__moveset) {
			return __default;
		}
	};
		
	#endregion
	#region Setters ////////////
	
	static set_moveset				= function(_moveset, _apply = true) {
		/// @func	set_moveset(moveset, apply?*)
		/// @param	{MoveSet}  moveset
		/// @param	{boolean}  apply=true
		/// @return {Moveable} self
		///
		__moveset.__moveset = _moveset;
		if (_apply) {
			apply_moveset(_moveset);
		}
		return self;
	};
	static set_moveset_default		= function(_moveset) {
		/// @func	set_moveset_default(moveset)
		/// @param	{MoveSet}  moveset
		/// @return {Moveable} self
		///
		with (__moveset) {
			__default = _moveset;
		}
		return self;
	};
	static set_moveset_default_data = function(_data) {		// condense this with moveset_apply?
		/// @func	set_moveset_default_data(data)
		/// @param	{struct}   data
		/// @return {Moveable} self
		///
		get_moveset_default().set_data(_data);
		return self;
	};
		
	#endregion
	#region Checkers ///////////
	
	static has_moveset = function(_name) {
		/// @func	has_moveset(name)
		/// @param	{string}  name
		/// @return {boolean} exists?
		///
		with (__moveset) {
			return __movesets.has_item(_name);
		}
	};
	
	#endregion
	
	static add_moveset	  = function(_name, _moveset) {
		/// @func	add_moveset(name, moveset)
		/// @param	{string}   name
		/// @param	{MoveSet}  moveset
		/// @return {Moveable} self
		///
		with (__moveset) {
			__movesets.add_item(_name, _moveset);
		}
		return self;
	};
	static new_moveset	  = function(_name, _data) {
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
	static reset_moveset  = function() {
		/// @func	reset_moveset()
		/// @return {Moveable} self
		///
		return set_moveset(get_moveset_default());
	};
	static change_moveset = function(_name) {
		/// @func	change_moveset(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		if (has_moveset(_name)) {
			set_moveset(get_moveset(_name));
		}
		return self;
	};
	static apply_moveset  = function(_moveset = __get_moveset_current()) {
		/// @func	apply_moveset(moveset*)
		/// @param	{MoveSet}  moveset=moveset_get_current
		/// @return {Moveable} self
		///
		__speed = _moveset.__speed;
		__accel = _moveset.__accel;
		__fric  = _moveset.__fric;
		__mult  = _moveset.__mult;
		set_moveset(_moveset, false);
		return self;
	};
	
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
function MoveSet(_config = {}) : Class(_config) constructor {
	/// @func	MoveSet(config*)
	/// @param	{struct}  config={}
	/// @return {MoveSet} self
	///
	__moveable	= other;
	__owner		= __moveable.get_owner();
	__config	= _config;
	__speed		= _config[$ "speed"] ?? 0;
	__accel		= _config[$ "accel"] ?? 0;
	__fric		= _config[$ "fric" ] ?? 0;
	__mult		= _config[$ "mult" ] ?? 1;
	
	#region Setters ////////
	
	static set_data = function(_data) {
		/// @func	set_data(data)
		/// @param	{struct}  data
		/// @return {MoveSet} self
		///
		if (_data[$ "speed"] != undefined) __speed = _data.speed;
		if (_data[$ "accel"] != undefined) __accel = _data.accel;
		if (_data[$ "fric" ] != undefined) __fric  = _data.fric;
		if (_data[$ "mult" ] != undefined) __mult  = _data.mult;
		
		return self;
	};
		
	#endregion
};

#endregion
#region Actionable /////////////////

/// DECOUPLE RENDERING FROM ACTIONABLE AND PUT INTO RENDERABLE()?

function Actionable() : Component() constructor {
	/// @func	Actionable()
	/// @return {Component} self 
	///
	__fsm = undefined;
	
	#region Private ////////
	
	static __get_state_empty = function() {
		/// @func	__get_state_empty()
		/// @return {struct} state
		///
		return {
			enter: function() {},
			step:  function() {},
			leave: function() {},
			draw:  function() {},
		};
	};
	
	#endregion
	#region Core ///////////
	
	static setup_actionable	   = function() {
		/// @func	setup_actionable()
		/// @return {Actionable} self
		///
		if (!is_initialized()) {
			__setup_component();
			#region fsm ////
			
			__fsm = new SnowState("__empty__", false);
			__fsm.add("__empty__", __get_state_empty());
			
			#endregion
		}
		return self;
	};
	static teardown_actionable = function() {
		/// @func	teardown_actionable()
		/// @return {Actionable} self
		///
		if (is_initialized()) {
			#region fsm ////
			
			__fsm = undefined;
			
			#endregion
			__teardown_component();
		}
		return self;
	};
	static update_actionable   = function() {
		/// @func	update_actionable()
		/// @return {Actionable} self
		///
		if (is_initialized() && is_active()) {
			__update_component();
			#region fsm ////
			
			__fsm.step();
			
			#endregion
		}
		return self;
	};
	static render_actionable   = function() {
		/// @func	render_actionable()
		/// @return {Actionable} self
		///
		if (is_initialized() && is_active()) {
			__render_component();
			#region fsm ////
			
			__fsm.draw();
			
			#endregion
		}
		return self;
	};
		
	static setup	= setup_actionable;
	static teardown = teardown_actionable;
	static update	= update_actionable;
	static render	= render_actionable;
	
	#endregion
	#region Getters ////////
	
	static get_states		  = function() {
		/// @func	state_get_states()
		/// @return {Actionable} self
		///
		return __fsm.get_states();
	};
	static get_state_current  = function() {
		/// @func	state_get_current()
		/// @return {Actionable} self
		///
		return __fsm.get_current_state();
	};
	static get_state_previous = function() {
		/// @func	state_get_previous()
		/// @return {Actionable} self
		///
		return __fsm.get_previous_state();
	};
	static get_state_time	  = function(_us = true) {
		/// @func	state_get_time(us*)
		/// @param	{boolean}	 us?=true
		/// @return {Actionable} self
		///
		return __fsm.get_time(_us);
	};
	
	#endregion
	#region Setters ////////
	
	static set_state_time = function(_time, _us = true) {
		/// @func	actionable_state_set_time(time, us*)
		/// @param	{milliseconds} time
		/// @param	{boolean}	   us?=true
		/// @return {Actionable}   self
		///
		__fsm.set_time(_time, _us);
		return self;
	};
	
	#endregion
	#region Checkers ///////
	
	static is_state	 = function(_state_name) {
		/// @func	state_is(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		return __fsm.state_is(_state_name);
	};
	static has_state = function(_state_name) {
		/// @func	state_exists(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		return __fsm.state_exists(_state_name);
	};
	
	#endregion
	
	static add_state	= function(_state_name, _state_struct) {
		/// @func	state_add(state_name, state_struct)
		/// @param	{string}	 state_name
		/// @param	{struct}	 state_struct
		/// @return {Actionable} self
		///
		__fsm.add(_state_name, _state_struct);
		return self;
	};
	static change_state	= function(_state_name) {
		/// @func	state_change(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		__fsm.change(_state_name);
		return self;
	};
};

#endregion
////////////////////////////////////
#region Scriptable /////////////////

function Scriptable() : Component() constructor {
	/// @func	Scriptable()
	/// @return {Component} self
	///
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

/// ADD EVENTABLE IMPLEMENTATION TO COMPONENTS