/////////////////////////////
// .---. .---. .---. .---. //
// |     |   | |   | r---J //
// L---' L---J L---J |     //
//////////////////////$(º)>//

coop = new Coop();
fsm1 = coop.add_component(SnowState, "__TestStateStart1");
fsm2 = coop.add_component(SnowState, "__TestStateStart2");
coop.add_component(truInst_setup);

coop.get_component(truInst_setup);	// function 
coop.get_component(SnowState);		// construct	
coop.get_component(fsm1);			// var

function Coop() constructor {
	/// @func Coop()
	///
	__owner				= other;
	__components_struct = {};
	__components_array  = [];
	
	#region Schema Example /////
	/*
		__components: {
			<instance_name>: {
				type: "constructor",
				name: instanceof(<instance_name>),
				instances_struct: {
					"instance_01_ptr": instance_01,	
					"instance_02_ptr": instance_02,
				},
				instances_array: [
					instance_01, 
					instance_02,
				],
			},
			<script_name>: {
				type:	  "function",
				name:	  <script_name>,
				instances_struct: {
					<script_name>: <script_name>,	// only ever 1 instance allowedm this is to just 
													// normalize schema structure between the two types.
				},
				instances_array: [
					<script_name>
				],
			},
		},
	*/
	#endregion
	#region __Private //////////
	
	static __add_component_constructor = function(_constructor, _params = undefined) {
		/// @func __add_component_constructor(constructor, params*)
		/// @param	{instanceof} constructor
		/// @param	{any}		 params=undefined
		/// @return {instanceof} return new constructor(params)
		///
		var _component_name = instanceof(_constructor);
		return __add_component(_component_name, __CooponentConstructor, _params);
	};
	static __add_component_function	   = function(_function, _params = undefined) {
		/// @func __add_component_function(function, params*)
		/// @param	{function}	function
		/// @param	{any}		params=undefined
		/// @return {any}		return function(params)
		///
		var _component_name = script_get_name(_function);
		return __add_component(_component_name, __CooponentFunction, _params);
	};
	static __add_component			   = function(_component_name, _component_instanceof, _component_source, _component_params = undefined) {
		/// @func __add_component(component_name, component_instanceof, component_source, component_params*)
		/// @param	{string}				component_name
		/// @param	{instanceof}			component_intanceof
		/// @param	{function/constructor}	component_source
		/// @param	{any}					component_params=undefined
		/// @return {instanceof/any}		return component(component_params)
		///
		var _component = __components_struct[$ _component_name];
		
		/// Create New Component & Stash-It
		if (_component == undefined) {
			_component  = __new_component(_component_name, _component_instanceof, _component_source, _component_params);
		}
		return _component.instantiate();
	};
	static __new_component			   = function(_component_name, _component_instanceof, _component_source, _component_params = undefined) {
		/// @func __new_component(component_name, component_instanceof, component_source, component_params*)
		/// @param	{string}			  component_name
		/// @param	{instanceof}		  component_intanceof
		/// @param	{function/instanceof} component_source
		/// @param	{any}				  component_params=undefined
		/// @return {Cooponent}			  new_component
		///
		var _component = new _component_instanceof({
			component:	_component_source,
			params:		_component_params,
			name:		_component_name,
		});
		__components[$ _component_name] = _component;
		return _component;
	};
	static __get_component_constructor = function(_constructor) {
		/// @func	__get_component_constructor(constructor)
		/// @param	{intanceof} constructor
		/// @return {array}		instances
		///
		var _component_name = instanceof(_constructor);
		return __get_component(_component_name);
	};
	static __get_component_function	   = function(_function) {
		/// @func	__get_component_function(function)
		/// @param	{function} function
		/// @return {array}	   instances
		///
		var _component_name = script_get_name(_function);
		return __get_component(_component_name);
	};
	static __get_component			   = function(_component_name) {
		/// @func	__get_component(component_name)
		/// @param	{string} component_name
		/// @return {array}	 instances
		///
		var _component  = __components_struct[$ _component_name];
		if (_component == undefined) {
			return undefined;	
		}
		return _component.get();
	};
		
	#endregion
	
	static add_component = function(_component, _params = undefined) {
		/// @func add_component(component, params*)
		/// @param	{instanceof/function} component
		/// @param	{any}				  params=undefined
		/// @return {instanceof/any}	  component.instantiate()
		///
		/// Constructor
		if (instanceof(_component) != undefined) {
			return __add_component_constructor(_component, _params);
		}
		/// Function
		if (script_exists(_component)) {
			return __add_component_function(_component, _params);
		}
		return undefined;
	};
	static get_component = function(_component) {
		/// @func	get_component(component)
		/// @param	{function/instanceof} component
		/// @return {array}				  instances
		///
		/// Constructor Component
		if (instanceof(_component) != undefined) {
			return __get_component_constructor(_component);	
		}
		/// Function Component
		if (script_exists(_component)) {
			return __get_component_function(_component);
		}
		return undefined;
	};
	static has_component = function(_component) {
		/// @func	has_component(component)
		/// @return {boolean} has_component?
		///
		return get_component(_component) != undefined;
	};
};
////////////////////////////////////////
function __Cooponent(_config) constructor {
	/// @func	__Cooponent(config)
	/// @param	{struct}	config
	/// @return {Cooponent} self
	///
	__active	= true;
	__component = _config.component;
	__params	= _config[$ "params"] ?? undefined;
	__name		= _config[$ "name"  ] ?? "";
	
	__instances_struct = {};
	__instances_array  = [];
	
	static add_instance = function(_instance_name, _instance) {
		/// @func	add_instance(instance_name, instance)
		/// @param	{string}	instance_name
		/// @param	{any}		instance
		/// @return {Cooponent} self
		///
		if (!variable_struct_exists(__instances_struct, _instance_name)) {
			__instances_struct[$ _instance_name] = _instance;
			array_push(__instances_array, _instance);
		}
		return self;
	};
	static get			= function() {
		/// @func	get()
		/// @return {array} instances_array
		///
		return __instances_array;
	};
};
function __CooponentConstructor(_config) : __Cooponent(_config) constructor {
	/// @func	__CooponentConstructor(config)
	/// @param	{struct}	config
	/// @return {Cooponent} self
	///
	__type = "constructor";
	
	static instantiate  = function() {
		/// @func	instantiate()
		/// @return {instanceof} instance
		///
		var _instance = new __component(__params);
		add_instance(string(ptr(_instance)), _instance);
		return _instance;
	};
};
function __CooponentFunction(_config) : __Cooponent(_config) constructor {
	/// @func	__CooponentFunction(config)
	/// @param	{struct}	config
	/// @return {Cooponent} self
	///
	__type = "function";
	
	static instantiate  = function() {
		/// @func	instantiate()
		/// @return {any} function_return
		///
		add_instance(__name, __name);
		return __component(__params);
	};
};	


















