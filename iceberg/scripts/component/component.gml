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
	__active	  = _config[$ "active"] ?? true;
	__owner		  = _config[$ "owner" ] ?? other;
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
	static get_active = function() {
		/// @func	get_active()
		/// @return {boolean} active?
		///
		return __active;
	};
	static get_owner  = function() {
		/// @func	get_owner()
		/// @return {instance/struct} owner
		///
		return __owner;
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
	static set_active = function(_active) {
		/// @func	set_active(active?)
		/// @param	{boolean}	active?
		/// @return {Component} self
		///
		__active = _active;
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
	
//////////////////////////////////////////////////////
//	Interfaces										//					
//		--- ... 									//
//////////////////////////////////////////////////////

function Interfaces() : Component() constructor {
	/// @func	Interfaces()
	/// @return {Interfaces} self
	///
	__interfaces = new Stash();
};
function Interface(_component, _owner = _component.get_owner()) constructor {
	/// @func	Interface(component, owner*)
	/// @param	{Component} component
	/// @param	{struct}	owner=component.get_owner()
	/// @return {Interface} self
	///
	__component = _component;
	__owner		= _owner;
	
	static get_component = function() {
		/// @func	get_component()
		/// @return {Component} component
		///
		return __component;
	};
	static get_owner	 = function() {
		/// @func	get_owner()
		/// @return {struct} owner
		///
		return __owner;
	};		
	
	/// Init Stash To Hold Component Instances
	var _component_name = string_lower(instanceof(_component));
	var _stash_var_name = "__stash_" + _component_name;
	if (!variable_struct_exists(__owner, _stash_var_name)) {
		variable_struct_set(__owner, _stash_var_name, undefined);
		__owner[$ _stash_var_name] = new Stash();
		
		var _bridge	= {
			stash: _owner[$ _stash_var_name],
		};
		
		/// __stash_moveable_get = function() {};
		variable_struct_set(__owner, _component_name + "_add", method(_bridge, function(_name, _value) {
			return stash.add(_name, _value);
		}));
	}
};





















