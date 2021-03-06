///////////////////////////////////////////////////////////
// .---- .---. .   . .---. .---. .   . .---- .   . ----- //
// |     |   | | V | r---J |   | | \ | r--   | \ |   |   //
// L---- L---J |   | |     L---J |   V L---- |   V   |   //
///////////////////////////////////////////////////////////
//	Components											 //								
//	--- components are class objects designed to contain //
//		encapsulated and reusable game logic and/or		 //
//		game functionality.								 //
//	--- components can be instantiated alone or can be 	 //
//		tied into a greater ComponentSystem(). These 	 //
//		systems are designed to organize and provide 	 //
//		structure to a series of components owned and 	 //
//		shared by the same instance.					 //
//	--- components that are instantiated alone (and not	 //
//		through a component system) will automatically 	 //
//		instantiate a hidden component system that 		 //
//		belongs to that same owner. this hidden system 	 //
//		allows for consistency and normalization on how  //
//		we access these components.						 //
///////////////////////////////////////////////////////////
#macro __COMPONENT_SYSTEM_VAR_NAME "__component_system"	 //
// this var will be accessible to all objects that 		 //
// instantiate a Component() instance. invoking the code:// 
// "<instance>.components" will give you access to a 	 //
// component system that holds the component. this means //
// that we can always expect "object.components" to 	 //
// return a component system that will allow us to access// 
// other component instances associated to that object,  //
// and other component system functionality consistently //
// and always.											 //
///////////////////////////////////////////////////////////

#region - Component : /////////////////////////////////////

function Component(_config = {}) : Class(_config) constructor {
	/// @func	Component(config*)
	/// @param	{struct}    config={}
	/// @return {Component} self
	///
	/// Static /////////////
	static __CLASS	   = Component;
	static __IS_SYSTEM = false; 
	
	/// Properties /////////
	__config	  = _config;
	__initialized =  false;
	__active	  =  true;
	__system	  =  undefined;	// ComponentSystem() association
	__auto_insert =  true;		// auto insert into implied ComponentSystem()?
	
	#region Setup //////////
	
	static __setup_component  = function() {
		/// @func	__setup_component()
		/// @return {Component} self
		///
		if (!is_initialized()) {
			log("<Component()> {0}.setup()", instanceof(self));
			__setup_properties();
			__setup_system();
			__initialized = true;
		}
		return self;
	}; 
	static __setup_properties = function() {
		/// @func	__setup_properties()
		/// @return {Component} self
		///
		if (__config[$ "active"]	  != undefined) __active	  = __config[$ "active"];
		if (__config[$ "auto_insert"] != undefined) __auto_insert = __config[$ "auto_insert"];
		
		return self;
	};
	static __setup_system	  = function() {
		/// @func	__setup_system()
		/// @return {Component} self
		///
		if (!__IS_SYSTEM) {
			/// is __owners_system_setup()
			if (!variable_struct_exists(__owner, __COMPONENT_SYSTEM_VAR_NAME)) {
				__owner[$ __COMPONENT_SYSTEM_VAR_NAME] = undefined;
				__owner[$ __COMPONENT_SYSTEM_VAR_NAME] = new ComponentSystem({ owner: __owner }).setup();	
			}
			
			/// __get_owners_system()
			__system = __owner[$ __COMPONENT_SYSTEM_VAR_NAME];
			
			/// Add Component Self To ComponentSystem
			if (__auto_insert && has_system()) {
				get_system().add(self);
			}
		}
		else {
			__owner[$ __COMPONENT_SYSTEM_VAR_NAME] = self;
		}	
		return self;
	};
	static   setup			  = __setup_component;
	
	#endregion
	#region Teardown ///////
	
	static __teardown_component = function() {
		/// @func	__teardown_component()
		/// @return {Component} self
		///
		if (is_initialized()) {
			log("<Component()> {0}.teardown()", instanceof(self));
			__teardown_system();
			__initialized = false;
		}
		return self;
	}; 
	static __teardown_system	= function() {
		/// @func	__teardown_system()
		/// @return {Component} self
		///
		if (has_system()) {
			get_system().remove(get_class());
			__system = undefined;
		}
		return self;
	};
	static   teardown			= __teardown_component;
	
	#endregion
	#region Rebuild ////////
	
	static __rebuild_component  = function(_config = undefined) {
		/// @func	__rebuild_component(config*)
		/// @param	{struct}	config=undefined
		/// @return {Component} self
		///
		if (is_initialized()) {
			teardown();
		  __rebuild_properties(_config);
			setup();
		}
		return self;
	}; 
	static __rebuild_properties = function(_config = undefined) {
		/// @func	__rebuild_properties(config*)
		/// @param	{struct}	config=undefined
		/// @return {Component} self
		///
		if (_config != undefined) {
			__config = _config;	
		}
		return self;
	};
	static   rebuild			= __rebuild_component;
	
	#endregion
	#region Update /////////
	
	static __update_component = function() {
		/// @func	__update_component()
		/// @return {Component} self
		///
		if (is_initialized() && is_active()) {
			// ...
		}
		return self;
	};	
	static   update			  = __update_component;
	
	#endregion
	#region Render /////////
	
	static __render_component = function() {
		/// @func	__render_component()
		/// @return {Component} self
		///
		if (is_initialized() && is_active()) {
			// ...
		}
		return self;
	};	
	static   render			  = __render_component;
	
	#endregion
	////////////////////////
	#region Properties /////
		
	static get_class	  = function() {
		/// @func	get_class()
		/// @return {class} class
		///
		return __CLASS;
	};
	static get_system	  = function() {
		/// @func	get_system()
		/// @return {Component} system
		///
		return __system;
	};
	static set_system	  = function(_system) {
		/// @func	set_system(system)
		/// @param	{Component} system
		/// @return {Component} self
		///
		__system = _system;
		return self;
	};
	static has_system	  = function() {
		/// @func	has_system()
		/// @return {bool} has_system?
		///
		return __system != undefined;
	};
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
	static remove	  = function() {
		/// @func	remove()
		/// @return	{Component} self
		/// @desc	removes self from the ComponentSystem(), if __system is not undefined.
		///
		if (has_system()) {
			get_system().remove(get_class());
		}
		return self;
	};
};

#endregion
#region - Component System : //////////////////////////////

function ComponentSystem(_config = {}) : Component(_config) constructor {
	/// @func	ComponentSystem(config*)
	/// @param	{struct}		  config
	/// @return {ComponentSystem} self
	///
	/// Static /////////////
	static __CLASS	   = ComponentSystem;
	static __IS_SYSTEM = true;
	
	/// Properties /////////
	__components = undefined;
	
	#region Setup //////////
	
	static __setup_component_system = function() {
		/// @func	__setup_comp_system()
		/// @return	{Component} self
		///
		if (!is_initialized()) {
			__setup_component();
			__setup_components();
		}
		return self;
	};
	static __setup_components		= function() {
		/// @func	__setup_components()
		/// @return {ComponentSystem} self
		///
		__components = new Set();
		return self;
	};
	static   setup					= __setup_component_system;
	
	#endregion
	#region Teardown ///////
	
	static __teardown_component_system	= function() {
		/// @func	__teardown_component_system()
		/// @return	{Component} self
		///
		if (is_initialized()) {
			__teardown_components();
			__teardown_component();
		}
		return self;
	};
	static __teardown_components		= function() {
		/// @func	__teardown_components()
		/// @return {ComponentSystem} self
		///
		var _components = __components.get_items_as_array();
		for (var _i = 0, _len = array_length(_components); _i < _len; _i++) {
			_components[_i].teardown();
		}
		__components = undefined;
		return self;
	};
	static   teardown					= __teardown_component_system;
	
	#endregion
	////////////////////////
	#region Components /////
	
	static get		= function(_component_class) {
		///	@func	get(component_class)
		/// @param	{class}		component_class
		/// @return {Component} component
		///
		var _class_name = script_get_name(_component_class);
		return __components.get_item(_class_name);
	};
	static get_size = function() {
		/// @func	get_size()
		/// @return {real} size
		///
		return __components.get_size();
	};
	static has		= function(_component_class) {
		/// @func	has(component_class)
		/// @param	{class}   component_class
		/// @return {boolean} has_component?
		///
		var _class_name = script_get_name(_component_class);
		return __components.has_item(_class_name);
	};
	static is_empty = function() {
		/// @func	is_empty()
		/// @return {bool} is_empty?
		///
		return __components.is_empty();
	};
	
	static create = function(_component_class) {
		/// @func	create(component_class)
		/// @param	{class}		component_class
		/// @return {Component} self
		///
		var _component = new _component_class({ 
			owner:		 get_owner(),
			auto_insert: false,
		}).setup();
		add(_component);
		return _component;
	};
	static add	  = function(_component) {
		///	@func	add(component)
		/// @param	{Component}	component
		/// @return {Component} self
		///
		 _component.set_system(self);
		 
		 var _class_name = instanceof(_component);
		 if (__components.has_item(_class_name)) {
			 var _owner_name  = instanceof(get_owner());
			 if (_owner_name == "instance") {
				_owner_name   = object_get_name(get_owner().object_index);	 
			 }
			 log("<ComponentSystem()> WARNING : component of type {0} already exists in {1}'s system.", _class_name, _owner_name);
		 }
		__components.add_item(_class_name, _component);
		return self;
	};
	static remove = function(_component_class) {
		///	@func	remove(component_class)
		/// @param	{class}		component_class
		/// @return {Component} self
		///
		if (has(_component_class)) {
			__components.remove_item(script_get_name(_component_class));
		}
		return self;
	};
	static empty  = function() {
		///	@func	empty()
		/// @return {Component} self
		///
		__components.empty();
		return self;
	};
		
	#endregion
	
	__owner.new_component		= method(self, function(_component_class) {
		/// @func	new_component(component_class)
		/// @param	{class}		component_class
		/// @return {Component} self
		///
		return create(_component_class);
	});
	__owner.add_component		= method(self, function(_component) {
		/// @func	add_component(component)
		/// @param	{Component} component
		/// @return {Component} self
		///
		return add(_component);
	});
	__owner.has_component		= method(self, function(_component_class) {
		/// @func	has_component(component_class)
		/// @param	{class}	  component_class
		/// @return {boolean} has_component?
		///
		return has(_component_class);
	});
	__owner.get_component		= method(self, function(_component_class) {
		/// @func	get_component(component_class)
		/// @param	{class}		component_class
		/// @return {Component} component
		///
		return get(_component_class);
	});
	__owner.remove_component	= method(self, function(_component_class) {
		/// @func	remove_component(component_class)
		/// @param	{class}		component_class
		/// @return {Component} self
		///
		return remove(_component_class);
	});
	__owner.teardown_components = method(self, function() {
		/// @func	teardown_components()
		/// @return	{Component} self
		///
		self[$ __COMPONENT_SYSTEM_VAR_NAME] = undefined;
		return teardown();
	});
};
function component_system_setup() {
	/// @func	component_system_setup(component1, ..., componentN)
	/// @param	{Component}	component_1
	/// @param	{Component}	...
	/// @param	{Component}	component_n
	/// @return {Component} system
	///
	var _owner  = self;
	var _system = new ComponentSystem({ owner: _owner }).setup();
	_owner[$ __COMPONENT_SYSTEM_VAR_NAME] = _system;
	
	for (var _i = 0; _i < argument_count; _i++) {
		_system.create(argument[_i]);	
	}
	return _system;
};
function component_system_exists(_owner = self) {
	/// @func	component_system_exists(owner*)
	/// @param	{struct}  owner=self
	/// @return {boolean} exists?
	///
	return variable_struct_exists(_owner, __COMPONENT_SYSTEM_VAR_NAME);
};

#endregion
#region - Eventable : /////////////////////////////////////

function Eventable(_config = {}) : Component(_config) constructor {
	/// @func	Eventable(config*)
	/// @param	{struct}	config={}
	/// @return {Eventable} self
	///
	/// Static /////////////
	static __CLASS = Eventable;
	static __log   = 0;
	
	/// Properties /////////
	__broadcaster = undefined;
	
	#region Setup //////////
	
	static __setup_eventable   = function() {
		/// @func	__setup_eventable()
		/// @return {Eventable} self
		///
		if (!is_initialized()) {
			__setup_component();
			__setup_broadcaster();
		}
		return self;
	};
	static __setup_broadcaster = function() {
		/// @func	__setup_broadcaster()
		/// @return {Eventable} self
		///
		__broadcaster = new Publisher();
		register(
			"registered",
			"broadcasted",
			"listened",
			"listeners_cleared",
		);
		return self;
	};
	static   setup			   = __setup_eventable;
	
	#endregion
	#region Teardown ///////
	
	static __teardown_eventable   = function() {
		/// @func	__teardown_eventable()
		/// @return {Eventable} self
		///
		if (is_initialized()) {
			__teardown_broadcaster();
			__teardown_component();
		}
		return self;
	};
	static __teardown_broadcaster = function() {
		/// @func	__teardown_broadcaster()
		/// @return {Eventable} self
		///
		__broadcaster = undefined;
		return self;
	};
	static   teardown			  = __teardown_eventable;
	
	#endregion
	////////////////////////
	#region Properties /////
	
	static get_broadcaster = function() {
		/// @func	get_broadcaster()
		/// @return {Publisher} publisher
		///
		return __broadcaster;
	};
	static has_broadcaster = function() {
		/// @func	has_broadcaster()
		/// @return {boolean} has_broadcaster?
		///
		return __broadcaster != undefined;
	};
	static is_registered   = function(_event_name) {
		/// @func	is_registered(event_name)
		/// @param	{string}  event_name
		/// @return {boolean} is_registered?
		///
		if (!has_broadcaster()) {
			return false;	
		}
		return get_broadcaster().has_registered_channel(_event_name);
	};
		
	#endregion
	
	static register			= function() {
		/// @func	register(event_1, ..., event_n)
		/// @param	{string}	event_1
		/// @param	{string}	...
		/// @param	{string}	event_n
		/// @return	{Eventable} self
		///
		/// Register ALL Channels First!!!
		for (var _i = 0; _i < argument_count; _i++) {
			get_broadcaster().register_channel(argument[_i]);
		}
		for (var _i = 0; _i < argument_count; _i++) {
			broadcast("registered", argument[_i]);
		}
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
			
			/// the event associated to the above broadcast may invoke Eventable().teardown(), which could __broadcaster to undefined
			if (has_broadcaster()) {
				get_broadcaster().publish("broadcasted", _data);
			}
			if (__log) {
				log("<Eventable()> instance: {0} | event: \"{1}\"", instanceof(_owner), _event_name);
				/// ^ logging payload can sometimes log a recursive struct, freezing the log and/or GameMaker
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
		get_broadcaster().clear_channel(_event_name);
		broadcast("listeners_cleared", _event_name);
		return self;
	};
	//static unsubscribe_subscriber = function(_subscriber, _force = false) {};
};

#endregion
#region - Moveable : //////////////////////////////////////

/*	ToDo:
	-	replace literal movement with vector implementation
		-	expose way to add new spring adjustments, including inverse spring adjusters
	-	test that move multiplier is limiting movement speed appropriately
	-	add moving platform support : way to define other Moveables to have hspd & vspd get values from
	-	has snap to implementation
	-	entities weight and impact on accel and iverse proportional impact on fric
	-	additional multipliers
	-	how to handle conflicting MoveSet/MoveSpeed triggers happening at the same time?
		-	if MoveSpeed run is bound to vk_enter, and crouch is bound to vk_control, what happens when both are pressed?
*/

function Moveable(_config = {}) : Component(_config) constructor {
	/// @func	Moveable(config*)
	/// @param	{struct}   config={}
	/// @return {Moveable} self
	///
	/// Static /////////////
	static __CLASS = Moveable;
	
	/// Properties /////////
	__props		= {
		__speed:	  1.0,
		__speed_mult: 1.0,
		__weight:	  1.0,
		__accel:	  0.0,
		__fric:		  0.0,
		__hspd:		  0.0,
		__vspd:		  0.0,
	};
	__movespeed = {
		__current:    undefined,
		__movespeeds: undefined,
		__default:    undefined,
	};
	__moveset	= {
		__current:	undefined,
		__movesets:	undefined,
		__default:  undefined,
	};
	__path		= {
		__index:  undefined,
		__smooth: true,
		__closed: false,
		__speed:  0.0,	// do NOT use path_speed, will not work with IOTA
	};
	
	#region Setup //////////
	
	static __setup_moveable	 = function() {
		/// @func	__setup_moveable()
		/// @return {Moveable} self
		///
		if (!is_initialized()) {
			__setup_component();
			__setup_props();
			__setup_movespeed();
			__setup_moveset();
			__setup_path();
		}
		return self;
	};
	static __setup_props	 = function() {
		/// @func	__setup_props()
		/// @return {Moveable} self
		///
		//if (__config[$ "path_index" ] != undefined) __path.__index  = __config.path_index;
		//if (__config[$ "path_smooth"] != undefined) __path.__smooth = __config.path_smooth;
		//if (__config[$ "path_closed"] != undefined) __path.__closed = __config.path_closed;
		return self;
	};
	static __setup_movespeed = function() {
		/// @func	__setup_movespeed()
		/// @return {Moveable} self
		///
		__movespeed.__movespeeds = new Set();
		__movespeed.__triggers	 = new Set();
		return self;
	};
	static __setup_moveset	 = function() {
		/// @func	__setup_moveset()
		/// @return {Moveable} self
		///
		__moveset.__movesets = new Set();
		__moveset.__triggers = new Set();
		return self;
	};
	static __setup_path		 = function() {
		/// @func	__setup_path()
		/// @return {Moveable} self
		///
		if (__path.__index == undefined) {	/// replace with has_path()
			__path.__index  = path_add();
		}
		path_set_kind(__path.__index, __path.__smooth);
		path_set_closed(__path.__index, __path.__closed);
		return self;
	};
	static   setup			 = __setup_moveable;
	
	#endregion
	#region Teardown ///////
	
	static __teardown_moveable	= function() {
		/// @func	__teardown_moveable()
		/// @return {Moveable} self
		///
		if (is_initialized()) {
			__teardown_path();
			__teardown_moveset();
			__teardown_movespeed();
			__teardown_component();
		}
		return self;
	};
	static __teardown_movespeed = function() {
		/// @func	__teardown_movespeed()
		/// @return {Moveable} self
		///
		__movespeed.__current    = undefined;
		__movespeed.__movespeeds = undefined;
		__movespeed.__triggers	 = undefined;
		return self;
	};
	static __teardown_moveset	= function() {
		/// @func	__teardown_moveset()
		/// @return {Moveable} self
		///
		__moveset.__current  = undefined;
		__moveset.__movesets = undefined;
		__moveset.__triggers = undefined;
		return self;
	};
	static __teardown_path		= function() {
		/// @func	__teardown_path()
		/// @return {Moveable} self
		///
		path_delete(__path.__index);
		__path.__index = undefined;
		return self;
	};
	static   teardown			= __teardown_moveable;
	
	#endregion
	#region Update /////////
	
	static __update_moveable  = function() {
		/// @func	__update_moveable()
		/// @return {Moveable} self
		///
		if (is_initialized() && is_active()) {
			__update_component();
			__update_moveset();
			__update_movespeed();
		}
		return self;
	};
	static __update_movespeed = function() {
		/// @func	__update_movespeed()
		/// @return {Moveable} self
		///
		var _target = undefined;
		
		/// Check For MoveSpeed Trigger Activations
		var _names  = __movespeed.__movespeeds.get_names();
		for (var _i = 0, _len = array_length(_names); _i < _len; _i++) {
			var _movespeed = get_movespeed(_names[_i]);
			if (_movespeed.check_trigger_activation()) {
				_target = _movespeed;
				break;	
			}
		}
		/// Default MoveSpeed
		if (_target == undefined) {
			_target  = get_movespeed_default();	
		}
		/// Set MoveSpeed If Not Current
		if (_target != undefined) {
			var _target_name = _target.get_name();
			if (!is_movespeed_current(_target_name)) {
				change_movespeed(_target_name);
			}
		}
		return self;
	};
	static __update_moveset   = function() {
		/// @func	__update_moveset()
		/// @return {Moveable} self
		///
		var _target = undefined;
		
		/// Check For MoveSet Trigger Activations
		var _names  = __moveset.__movesets.get_names();
		for (var _i = 0, _len = array_length(_names); _i < _len; _i++) {
			var _moveset = get_moveset(_names[_i]);
			if (_moveset.check_trigger_activation()) {
				_target = _moveset;
				break;	
			}
		}
		/// Default MoveSet
		if (_target == undefined) {
			_target  = get_moveset_default();	
		}
		/// Set MoveSet If Not Current
		if (_target != undefined) {
			var _target_name = _target.get_name();
			if (!is_moveset_current(_target_name)) {
				change_moveset(_target_name);
			}
		}
		return self;
	};
	static   update			  = __update_moveable;
	
	#endregion
	////////////////////////
	#region Properties /////
	
	static get_speed	  = function() {
		/// @func	get_speed()
		/// @return {real} speed
		///
		return __props.__speed * get_speed_mult();	
	};
	static get_speed_mult = function() {
		/// @func	get_speed_mult()
		/// @return {real} speed_mult
		///
		return __props.__speed_mult;	
	};
	static get_weight	  = function() {
		/// @func	get_weight()
		/// @return {real} weight
		///
		return __props.__weight;	
	};
	static get_accel	  = function() {
		/// @func	get_accel()
		/// @return {real} accel
		///
		//return __props.__accel / get_weight();
		return __props.__accel;
	};
	static get_fric		  = function() {
		/// @func	get_fric()
		/// @return {real} fric
		///
		//return __fric * get_weight();
		return __props.__fric;
	};
	static get_hspd		  = function() {
		/// @func	get_hspd()
		/// @return {real} hspd
		///
		return __props.__hspd;	
	};
	static get_vspd		  = function() {
		/// @func	get_vspd()
		/// @return {real} vspd
		///
		return __props.__vspd;	
	};
	
	static set_speed	  = function(_speed) {
		/// @func	set_speed(speed)
		/// @param	{real}	   speed
		/// @return {Moveable} self
		///
		__props.__speed = _speed;
		return self;
	};
	static set_speed_mult = function(_mult) {
		/// @func	set_speed_mult(mult)
		/// @param	{real}	   mult
		/// @return {Moveable} self
		///
		__props.__speed_mult = _mult;
		return self;
	};
	static set_weight	  = function(_weight) {
		/// @func	set_weight(weight)
		/// @param	{real}	   weight
		/// @return {Moveable} self
		///
		__props.__weight = _weight;
		return self;
	};
	static set_accel	  = function(_accel) {
		/// @func	set_accel(accel)
		/// @param	{real}	   accel
		/// @return {Moveable} self
		///
		__props.__accel = _accel;
		return self;
	};
	static set_fric		  = function(_fric) {
		/// @func	set_fric(fric)
		/// @param	{real}	   fric
		/// @return {Moveable} self
		///
		__props.__fric = _fric;
		return self;
	};
	static set_hspd		  = function(_hspd) {
		/// @func	set_hspd(hspd)
		/// @param	{real}	   hspd
		/// @return {Moveable} self
		///
		__props.__hspd = _hspd;
		return self;
	};
	static set_vspd		  = function(_vspd) {
		/// @func	set_vspd(vspd)
		/// @param	{real}	   vspd
		/// @return {Moveable} self
		///
		__props.__vspd = _vspd;
		return self;
	};
	
	#endregion
	#region MoveSpeed //////

	static __new_movespeed			   = function(_name) {
		/// @func	__new_movespeed(name)
		/// @param	{string}    name
		/// @return {MoveSpeed} movespeed
		///		
		var _movespeed = new MoveSpeed({ name: _name });
		__add_movespeed(_movespeed);
		return _movespeed;
	};
	static __add_movespeed			   = function(_movespeed) {
		/// @func   __add_movespeed(movespeed)
		/// @param  {MoveSpeed} movespeed
		/// @return {Moveable}  self
		///
		var _name = _movespeed.get_name();
		if (has_movespeed(_name)) {
			show_error("movespeed " + _name + " already exists. unable to add duplicate movespeed", true);
		}
		__movespeed.__movespeeds.add_item(_name, _movespeed);	
		return self;
	};
	static __apply_movespeed		   = function(_name = undefined) {
		/// @func	__apply_movespeed(name*)
		/// @param	{string}   name=undefined
		/// @return {Moveable} self
		///
		var _movespeed = get_movespeed(_name);
		set_speed(_movespeed.get_speed());
		return self;
	};
	
	static get_movespeed			   = function(_name = undefined) {
		/// @func	get_movespeed(name*)
		/// @param	{string}	name=undefined
		/// @return {MoveSpeed} movespeed
		///
		if (_name == undefined) {
			return get_movespeed_current();	
		}
		return __movespeed.__movespeeds.get_item(_name);
	};
	static get_movespeed_current	   = function() {
		/// @func	get_movespeed_current()
		/// @return {MoveSpeed} current
		///
		return __movespeed.__current;
	};
	static get_movespeed_default	   = function() {
		/// @func	get_movespeed_default()
		/// @return {MoveSpeed} default
		///
		return __movespeed.__default;
	};
	static get_movespeed_condition	   = function(_name) {
		/// @func	get_movespeed_condition(name)
		/// @param	{string}	name
		/// @return {MoveSpeed} movespeed
		///
		if (!has_movespeed(_name)) {
			return undefined;
		}
		return get_movespeed(_name).get_condition();
	};
	static set_movespeed			   = function(_name, _speed, _condition = undefined) {
		/// @func	set_movespeed(name, speed, condition*)
		/// @param	{string}   name
		/// @param	{real}     speed
		/// @param  {method}   condition=undefined
		/// @return {Moveable} self
		///
		var _movespeed = has_movespeed(_name)
			?   get_movespeed(_name)
			: __new_movespeed(_name);
		_movespeed.set_speed(_speed);
		
		if (_condition != undefined) {
			_movespeed.set_condition(_condition);	
		}
		return self;
	};
	static set_movespeed_default	   = function(_name) {
		/// @func	set_movespeed_default(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		if (!has_movespeed(_name)) {
			show_error("movespeed " + _name + " does not exist. cannot set as default.", true);	
		}
		__movespeed.__default = get_movespeed(_name);
		return self;
	};
	static set_movespeed_condition	   = function(_name, _condition) {
		/// @func   set_movespeed_condition(name, condition)
		/// @param  {string}   name
		/// @param  {method}   condition
		/// @return {Moveable} self 
		///
		if (!has_movespeed(_name)) {
			show_error("movespeed " + _name + " does not exist. cannot set condition.", true);	
		}
		get_movespeed(_name).set_condition(_condition);
		return self;
	};
	static is_movespeed_current		   = function(_name) {
		/// @func	is_movespeed_current(name)
		/// @param	{string}  name
		/// @return {boolean} is_current?
		///
		if (!has_movespeed_current()) {
			return false;	
		}
		return get_movespeed_current().get_name() == _name;
	};
	static is_movespeed_default		   = function(_name = undefined) {
		/// @func	is_movespeed_default(name*)
		/// @param	{string}  name=undefined
		/// @return {boolean} is_default?
		///
		if (!has_movespeed_default()) {
			return false;	
		}
		if (_name == undefined) {
			_name  = get_movespeed_current().get_name();	
		}
		return get_movespeed_default().get_name() == _name;
	};
	static has_movespeed			   = function(_name = undefined) {
		/// @func	has_movespeed(name*)
		/// @param	{string } name=undefined
		/// @return {boolean} has_movespeed?
		///
		return get_movespeed(_name) != undefined;
	};
	static has_movespeed_current	   = function() {
		/// @func	has_movespeed_current()
		/// @return {boolean} has_current?
		///
		return get_movespeed_current() != undefined;
	};
	static has_movespeed_default	   = function() {
		/// @func	has_movespeed_default()
		/// @return {boolean} has_default?
		///
		return get_movespeed_default() != undefined;
	};
	static has_movespeed_condition	   = function(_name) {
		/// @func	has_movespeed_condition(name)
		/// @param	{string}  name
		/// @return {boolean} has_moveset_condition?
		///
		if (!has_movespeed(_name)) {
			return false;	
		}
		return get_movespeed(_name).has_condition();
	};
	static has_movespeeds			   = function() {
		/// @func   has_movespeed()
		/// @return {bool} has_movespeeds?
		///	
		return !__movespeed.__movespeeds.is_empty();
	};
	static change_movespeed			   = function(_name) {
		/// @func	change_movespeed(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		if (!has_movespeed(_name)) {
			show_error("movespeed " + _name + " does not exist. unable to change movespeed", true);	
		}
		__movespeed.__current  = get_movespeed(_name);
		__apply_movespeed(_name);
		return self;
	};
	static change_movespeed_to_default = function() {
		/// @func	change_movespeed_to_default()
		/// @return {Moveable} self
		///
		if (!has_movespeed_default()) {
			show_error("movespeed default has not been set. cannot change movespeed.", true);	
		}
		change_movespeed(get_movespeed_default().get_name());
		return self;
	};
	static remove_movespeed			   = function(_name) {
		/// @func	remove_movespeed(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		__movespeed.__movespeeds.remove_item(_name);
		return self;
	};
	static remove_movespeed_current	   = function() {
		/// @func	remove_movespeed_current()
		/// @return {Moveable} self
		///
		__movespeed.__current = undefined;
		return self;
	};
	static remove_movespeed_default	   = function() {
		/// @func	remove_movespeed_default()
		/// @return {Moveable} self
		///
		__movespeed.__default = undefined;
		return self;
	};
	static remove_movespeed_condition  = function(_name) {
		/// @func	remove_movespeed_condition(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		if (!has_movespeed(_name)) {
			show_error("moveset " + _name + " does not exist. unable to remove condition", true);	
		}
		get_movespeed(_name).remove_condition();	
		return self;
	};
	
	#endregion
	#region MoveSet ////////
	
	static __new_moveset			 = function(_name) {
		/// @func	__new_moveset(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		var _moveset = new MoveSet({ name: _name });
		__add_moveset(_moveset);
		return _moveset;
	};
	static __add_moveset			 = function(_moveset) {
		/// @func   __add_moveset(moveset)
		/// @param  {MoveSet}  moveset
		/// @return {Moveable} self
		///
		var _name = _moveset.get_name();
		if (has_moveset(_name)) {
			show_error("moveset " + _name + " already exists. unable to add duplicate moveset", true);
		}
		__moveset.__movesets.add_item(_name, _moveset);	
		return self;
	};
	static __apply_moveset			 = function(_name = undefined) {
		/// @func	__apply_moveset(name*)
		/// @param	{string}   name=undefined
		/// @return	{Moveable} self
		///
		var _moveset = get_moveset(_name);
		set_speed_mult(_moveset.get_speed_mult());
		set_accel(_moveset.get_accel());
		set_fric(_moveset.get_fric());
		return self;
	};
	
	static get_moveset				 = function(_name = undefined) {
		/// @func	get_moveset(name*)
		/// @param	{string}  name=undefined
		/// @return {MoveSet} moveset
		///
		if (_name == undefined) {
			return get_moveset_current();	
		}
		return __moveset.__movesets.get_item(_name);
	};
	static get_moveset_current		 = function() {
		/// @func	get_moveset_current()
		/// @return {MoveSet} moveset
		///
		return __moveset.__current;
	};
	static get_moveset_default		 = function() {
		/// @func	get_moveset_default()
		/// @return {MoveSet} default
		///
		return __moveset.__default;
	};
	static get_moveset_condition	 = function(_name) {
		/// @func	get_moveset_condition(name)
		/// @param	{string} name
		/// @return {method} trigger_method
		///
		if (!has_moveset(_name)) {
			return undefined;
		}
		return get_moveset(_name).get_condition();
	};
	static set_moveset				 = function(_name, _data, _condition = undefined) {
		/// @func	set_moveset(name, speed)
		/// @param	{string}   name
		/// @param	{struct}   data
		/// @return {Moveable} self
		///
		var _moveset = has_moveset(_name)
			?   get_moveset(_name)
			: __new_moveset(_name);
		_moveset.set_data(_data);
		
		if (_condition != undefined) {
			_moveset.set_condition(_condition);
		}
		return self;
	};
	static set_moveset_default		 = function(_name) {
		/// @func	set_moveset_default(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		if (!has_moveset(_name)) {
			show_error("moveset " + _name + " does not exist, cannot set as default.", true);
		}
		__moveset.__default = get_moveset(_name);
		return self;
	};
	static set_moveset_condition	 = function(_name, _condition) {
		/// @func   set_moveset_condition(name, condition)
		/// @param  {string}   name
		/// @param  {method}   condition
		/// @return {Moveable} self 
		///
		if (!has_moveset(_name)) {
			show_error("moveset " + _name + " does not exist. cannot set condition.", true);	
		}
		get_moveset(_name).set_condition(_condition);
		return self;
	};
	static is_moveset_current		 = function(_name) {
		/// @func	is_moveset_current(name)
		/// @param	{string}  name
		/// @return {boolean} is_current?
		///
		if (!has_moveset_current()) {
			return false;	
		}
		return get_moveset_current().get_name() == _name;
	};
	static is_moveset_default		 = function(_name = undefined) {
		/// @func	is_moveset_default(name*)
		/// @param	{string}  name=undefined
		/// @return {boolean} is_default?
		///
		if (!has_moveset_default()) {
			return false;	
		}
		if (_name == undefined) {
			_name  = get_moveset_current().get_name();	
		}
		return get_moveset_default().get_name() == _name;
	};
	static has_moveset				 = function(_name = undefined) {
		/// @func	has_moveset(name*)
		/// @param	{string}  name=undefined
		/// @return {boolean} has_moveset?
		///
		return get_moveset(_name) != undefined;
	};
	static has_moveset_current		 = function() {
		/// @func	has_moveset_current()
		/// @return {boolean} has_moveset_current?
		///
		return get_moveset_current() != undefined;
	};
	static has_moveset_default		 = function() {
		/// @func	has_moveset_default()
		/// @return {boolean} has_moveset_default?
		///
		return get_moveset_default() != undefined;
	};
	static has_moveset_condition	 = function(_name) {
		/// @func	has_moveset_condition(name)
		/// @param	{string}  name
		/// @return {boolean} has_moveset_condition?
		///
		if (!has_moveset(_name)) {
			return false;	
		}
		return get_moveset(_name).has_condition();
	};
	static has_movesets				 = function() {
		/// @func   has_movesets()
		/// @return {bool} has_movesets?
		///	
		return !__moveset.__movesets.is_empty();
	};
	static change_moveset			 = function(_name) {
		/// @func	change_moveset(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		if (!has_moveset(_name)) {
			show_error("moveset " + _name + " does not exist. unable to change moveset", true);	
		}
		__moveset.__current  = get_moveset(_name);
		__apply_moveset(_name);
		return self;
	};
	static change_moveset_to_default = function() {
		/// @func	change_moveset_to_default(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		if (!has_moveset_default()) {
			show_error("moveset default has not been set. cannot change moveset.", true);	
		}
		change_moveset(get_moveset_default().get_name());
		return self;
	};
	static remove_moveset			 = function(_name) {
		/// @func	remove_moveset(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		__moveset.__movesets.remove_item(_name);
		return self;
	};
	static remove_moveset_current	 = function() {
		/// @func	remove_moveset_current()
		/// @return {Moveable} self
		///
		__moveset.__current = undefined;
		return self;
	};
	static remove_moveset_default	 = function() {
		/// @func	remove_moveset_default()
		/// @return {Moveable} self
		///
		__moveset.__default = undefined;
		return self;
	};
	static remove_moveset_condition  = function(_name) {
		/// @func	remove_moveset_condition(name)
		/// @param	{string}   name
		/// @return {Moveable} self
		///
		if (!has_moveset(_name)) {
			show_error("moveset " + _name + " does not exist. unable to remove condition", true);	
		}
		get_moveset(_name).remove_condition();	
		return self;
	};
	
	#endregion
	#region Path ///////////
	
	static get_path			= function() {};
	static get_path_speed	= function() {};
	static set_path_speed	= function(_speed) {};
	static set_path_smooth	= function(_smooth) {};
	static set_path_closed	= function(_closed) {};
	static is_path_smooth	= function() {};
	static is_path_cloased	= function() {};
	
	#endregion
	#region Movement ///////
	
	
	#endregion
};
function MoveableTopDown(_config = {}) : Moveable(_config) constructor {
	/// @func	MoveableTopDown(config*)
	/// @param	{struct}		  config={}
	/// @return {MoveableTopDown} self
	///
	/// Static /////////////
	static __CLASS = MoveableTopDown;
	
	#region Update /////////
	
	static __update_moveable_td = function() {
		/// @func	__update_moveable_td()
		/// @return {MoveableTopDown} self
		///
		if (is_initialized() && is_active()) {
			__update_moveable();
			__update_movement();
		}
		return self;
	};
	static __update_movement	= function() {
		/// @func	__update_movement()
		/// @return {Moveable} self
		///
		apply_movement();
		return self;
	};
	static   update				= __update_moveable_td;
	
	#endregion
	////////////////////////
	
	static apply_movement = function() {
		/// @func	apply_movement()
		/// @return {MoveablePlatformer} self
		///
		var _input_h =  keyboard_check(ord("D")) - keyboard_check(ord("A"));
		var _input_v =  keyboard_check(ord("S")) - keyboard_check(ord("W"));
		var _speed_h =  get_hspd();
		var _speed_v =  get_vspd();
		var _speed   =  get_speed();
		var _max_h   = _speed * _input_h;
		var _max_v   = _speed * _input_v;
		var _min_h	 =  0;
		var _min_v	 =  0;
		
		/// Apply Acceleration
		_speed_h = approach(_speed_h, _max_h, get_accel());
		_speed_v = approach(_speed_v, _max_v, get_accel());
		
		/// Apply Friction
		if (_input_h == 0) _speed_h = approach(_speed_h, _min_h, get_fric());
		if (_input_v == 0) _speed_v = approach(_speed_v, _min_v, get_fric());
		
		/// Apply hspd & vspd
		set_hspd(_speed_h);
		set_vspd(_speed_v);
		
		/// Update x & y
		get_owner().x += get_hspd();
		get_owner().y += get_vspd();
		return self;
	};
	
};
function MoveablePlatformer(_config = {}) : Moveable(_config) constructor {
	/// @func	MoveablePlatformer(config*)
	/// @param	{struct} config={}
	/// @return {MoveablePlatformer} self
	///
	/// Static /////////////
	static __CLASS = MoveablePlatformer;
	
	#region Update /////////
	
	static __update_moveable_plat = function() {
		/// @func	__update_moveable_plat()
		/// @return {MoveableTopDown} self
		///
		if (is_initialized() && is_active()) {
			__update_moveable();
			__update_movement();
		}
		return self;
	};
	static __update_movement	  = function() {
		/// @func	__update_movement()
		/// @return {Moveable} self
		///
		apply_movement();
		return self;
	};
	static   update				  = __update_moveable_plat;
	
	#endregion
	////////////////////////
	
	static apply_movement = function() {
		/// @func	apply_movement()
		/// @return {MoveablePlatformer} self
		///
		return self;
	};
};
///////////////////////////////////////////////////////////
function MoveableUtil(_config = {}) : Class(_config) constructor {
	/// @func	MoveableUtil(config*)
	/// @param	{struct}	   config={}
	/// @return {MoveableUtil} self
	///
	__trigger = new Trigger({ name: get_name() });
	
	static get_trigger	 = function() {
		/// @func	get_trigger()
		/// @return {Trigger} trigger
		///
		return __trigger;
	};
	static get_condition = function() {
		/// @func	get_condition()
		/// @return {method} condition
		///
		if (!__trigger.has_condition()) {
			return undefined;
		}
		return __trigger.get_condition().get_method();
	};
	static set_condition = function(_method, _data = undefined) {
		/// @func	set_condition(method, data*)
		/// @param	{method}  method
		/// @param	{any}	  data=undefined
		/// @return {MoveSet} self
		///
		__trigger.set_condition(_method, _data);
		return self;
	};
	static has_condition = function() {
		/// @func	has_condition()
		/// @return {bool} has_condition?
		///
		return get_condition() != undefined;
	};
	
	static check_trigger_activation = function() {
		/// @func	check_trigger_activation()
		/// @return {boolean} trigger_activated?
		///
		return __trigger.check_activation();
	};
};
function MoveSpeed(_config = {}) : MoveableUtil(_config) constructor {
	/// @func	MoveSpeed(config*)
	/// @param	{struct}	config={}
	/// @return {MoveSpeed} self
	///
	/// Properties /////////
	__speed	= _config[$ "speed"] ?? 0.0;
	__trigger.set_action(method(get_owner(), function(_name) {
		change_movespeed(_name);
	}), get_name());
	
	static get_speed = function() {
		/// @func	get_speed()
		/// @return {real} speed
		///
		return __speed;
	};
	static set_speed = function(_speed) {
		/// @func	set_speed(speed)
		/// @param	{real}		speed
		/// @return {MoveSpeed} self
		///
		__speed = _speed;
		return self;
	};
};
function MoveSet(_config = {}) : MoveableUtil(_config) constructor {
	/// @func	MoveSet(config*)
	/// @param	{struct}  config={}
	/// @return {MoveSet} self
	///
	/// Properties /////////
	__speed_mult = _config[$ "speed_mult"] ?? 1.0;
	__accel		 = _config[$ "accel"	 ] ?? 0.0;
	__fric		 = _config[$ "fric"		 ] ?? 0.0;
	__trigger.set_action(method(get_owner(), function(_name) {
		change_moveset(_name);
	}), get_name());
	
	static get_speed_mult = function() {
		/// @func	get_speed_mult()
		/// @return {real} mult
		///
		return __speed_mult;
	};
	static get_accel	  = function() {
		/// @func	get_accel()
		/// @return {real} accel
		///
		return __accel;
	};
	static get_fric		  = function() {
		/// @func	get_fric()
		/// @return {real} fric
		///
		return __fric;
	};
	
	static set_data		  = function(_data) {
		/// @func	set_data(data)
		/// @param	{struct}  data
		/// @return {MoveSet} self
		///
		if (_data[$ "speed_mult"] != undefined) set_speed_mult(_data.speed_mult);
		if (_data[$ "accel"		] != undefined) set_accel(_data.accel);
		if (_data[$ "fric"		] != undefined) set_fric(_data.fric);
		return self;
	};
	static set_speed_mult = function(_mult) {
		/// @func	set_speed_mult(mult)
		/// @param	{real}	  mult
		/// @return {MoveSet} self
		///
		__speed_mult = _mult;
		return self;
	};
	static set_accel	  = function(_accel) {
		/// @func	set_accel(accel)
		/// @param	{real}	  accel
		/// @return {MoveSet} self
		///
		__accel = _accel;
		return self;
	};
	static set_fric		  = function(_fric) {
		/// @func	set_fric(fric)
		/// @param	{real}	  fric
		/// @return {MoveSet} self
		///
		__fric = _fric;
		return self;
	};
};

#endregion
#region - Actionable : ////////////////////////////////////

/// DECOUPLE RENDERING FROM ACTIONABLE AND PUT INTO RENDERABLE()?

function Actionable() : Component() constructor {
	/// @func	Actionable()
	/// @return {Actionable} self
	///
	/// Static /////////////
	static __CLASS = Actionable;
	
	/// Properties /////////
	__fsm = undefined;
	
	#region Setup //////////
	
	static __setup_actionable = function() {
		/// @func	__setup_actionable()
		/// @return {Actionable} self
		///
		if (!is_initialized()) {
			__setup_component();
			__setup_fsm();
		}
		return self;
	};
	static __setup_fsm		  = function() {
		/// @func	__setup_fsm()
		/// @return {Actionable} self
		///
		__fsm = new SnowState("__empty__", false);
		__fsm.add("__empty__", __get_state_empty());
		return self;
	};
	static   setup			  = __setup_actionable;
	
	#endregion
	#region Teardown ///////
	
	static __teardown_actionable = function() {
		/// @func	__teardown_actionable()
		/// @return {Actionable} self
		///
		if (is_initialized()) {
			__teardown_fsm();
			__teardown_component();
		}
		return self;
	};
	static __teardown_fsm		 = function() {
		/// @func	__teardown_fsm()
		/// @return {Actionable} self
		///
		__fsm = undefined;
		return self;
	};
	static   teardown			 = __teardown_actionable;
	
	#endregion
	#region Update /////////
	
	static __update_actionable  = function() {
		/// @func	__update_actionable()
		/// @return {Actionable} self
		///
		if (is_initialized() && is_active()) {
			__update_component();
			__update_fsm();
		}
		return self;
	};
	static __update_fsm			= function() {
		/// @func	__update_fsm()	
		/// @return {Actionable} self
		///
		__fsm.step();
		return self;
	};
	static   update				= __update_actionable;
	
	#endregion
	#region Render /////////
	
	static __render_actionable  = function() {
		/// @func	__render_actionable()
		/// @return {Actionable} self
		///
		if (is_initialized() && is_active()) {
			__render_component();
			__render_fsm();
		}
		return self;
	};
	static __render_fsm			= function() {
		/// @func	__render_fsm()	
		/// @return {Actionable} self
		///
		__fsm.draw();
		return self;
	};
	static   render				= __render_actionable;
	
	#endregion
	////////////////////////
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
	static set_state_time	  = function(_time, _us = true) {
		/// @func	actionable_state_set_time(time, us*)
		/// @param	{milliseconds} time
		/// @param	{boolean}	   us?=true
		/// @return {Actionable}   self
		///
		__fsm.set_time(_time, _us);
		return self;
	};
	static is_state			  = function(_state_name) {
		/// @func	state_is(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		return __fsm.state_is(_state_name);
	};
	static has_state		  = function(_state_name) {
		/// @func	state_exists(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		return __fsm.state_exists(_state_name);
	};
	static add_state		  = function(_state_name, _state_struct) {
		/// @func	state_add(state_name, state_struct)
		/// @param	{string}	 state_name
		/// @param	{struct}	 state_struct
		/// @return {Actionable} self
		///
		__fsm.add(_state_name, _state_struct);
		return self;
	};
	static change_state		  = function(_state_name) {
		/// @func	state_change(state_name)
		/// @param	{string}	 state_name
		/// @return {Actionable} self
		///
		__fsm.change(_state_name);
		return self;
	};
};

#endregion
#region - Collidable : ////////////////////////////////////

function Collidable() : Component() constructor {
	/// @func	Collidable()
	/// @return {Collidable} self
	///
	/// Static /////////////
	static __CLASS = Collidable;
	
	/// Properties /////////
	__owner		 = other;
	__collisions = undefined;
	
	#region Setup //////////
	
	static __setup_collidable = function() {
		/// @func	__setup_collidable()
		/// @return {Collidable} self
		///
		if (!is_initialized()) {
			__setup_component();	
			__setup_collisions();
		}
		return self;
	};
	static __setup_collisions = function() {
		/// @func	__setup_collisions()
		/// @return {Collidable} self
		///
		__collisions = ds_list_create();
		return self
	};
	static   setup			  = __setup_collidable;
	
	#endregion
	#region Teardown ///////
	
	static __teardown_collidable = function() {
		/// @func	__teardown_collidable()
		/// @return {Collidable} self
		///
		if (is_initialized()) {
			__teardown_collisions();
			__teardown_component();
		}
		return self;
	};
	static __teardown_collisions = function() {
		/// @func	__teardown_collisions()
		/// @return {Collidable} self
		///
		ds_list_destroy(__collisions);
		__collisions = undefined;
		return self;
	};
	static   teardown			 = __teardown_collidable;
	
	#endregion
};

#endregion
#region - Saveable : //////////////////////////////////////

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
#region - Cullable : //////////////////////////////////////

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
				log("<Cullable()>: object {0} activated.", _inst);
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
				log("<Cullable()>: object {0} deactivated.", self.id);
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
				log("<Cullable()>: object {0} destroyed.", self.id);	
			}
			return __truInst_instance;
		});
		
		__truInst_setup(_active); /// <-- automatically invoke setup
	}
	return _truInst_instance;
};

#endregion
#region - Scriptable : ////////////////////////////////////

function Scriptable() : Component() constructor {
	/// @func	Scriptable()
	/// @return {Component} self
	///
};

#endregion

