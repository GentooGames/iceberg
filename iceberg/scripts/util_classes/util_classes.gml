/// Insert Ascii Art Here***

#region General ////////////

function Class(_config = {}) constructor {
	/// @func	Class(config*)
	/// @param	{struct} config={}
	/// @return {Class}  self
	///
	__config = _config;
	__owner	 = _config[$ "owner"] ?? other;
	__name	 = _config[$ "name" ] ?? __get_name_unique();

	#region Private ////////
	
	static __get_name_unique = function() {	
		/// @func	__get_name_unique()
		/// @return {string} name
		///
		return instanceof(self) + "_" + string(ptr(self));
	};
	
	#endregion
	#region Getters ////////
	
	static get_owner = function() {
		/// @func	get_owner()
		/// @return {struct} owner
		///
		return __owner;
	};
	static get_name	 = function() {
		/// @func	get_name()
		/// @return {string} name
		///
		return __name;
	};
	
	#endregion
	#region Setters ////////
	
	static set_owner = function(_owner) {
		/// @func	set_owner(owner)
		/// @param	{struct} owner
		/// @return {Class}	 self
		///
		__owner = _owner;
		return self;
	};
	static set_name	 = function(_name) {
		/// @func	set_name(name)
		/// @param	{string} name
		/// @return {Class}  self
		///
		__name = _name;
		return self;
	};
	
	#endregion
	
	/// ANY CHANGES MADE TO CONFIG STRUCT SHOULD BE UPDATED IN CODE_SNIPPET
};
function Method(_config = {}) : Class(_config) constructor {
	/// @func	Method(config*)
	/// @param	{struct} config={}
	/// @return {Method} self
	///	
	__method = _config[$ "method"] ?? undefined;
	__data	 = _config[$ "data"  ] ?? undefined;
	
	#region Getters ////////
	
	static get_method = function() {
		/// @func	get_method()
		/// @return {method} method
		///
		return __method;
	};
	static get_data   = function() {
		/// @func	get_data()
		/// @return {any} data
		///
		return __data;
	};

	#endregion
	
	static execute = function() {
		/// @func	execute()
		/// @return {any} return
		///
		return __method(__data);
	};
};

#endregion
#region Collections ////////

function Collection(_config = {}) : Class(_config) constructor {
	/// @func	Collection(config*)
	/// @param	{struct}	 config={}
	/// @return {Collection} self
	///
	__array =	[];
	__items = __array;
	__size  =	0;
	
	static get_items = function() {			
		/// @func	get_items()
		/// @return {array} items
		///
		return __items;
	};
	static get_size  = function() {
		/// @func	get_size()
		/// @return {real} size
		///
		return __size;
	};
	static has_item  = function(_name) {
		/// @func	has_item(name)
		/// @param	{string}  name
		/// @return	{boolean} has_item?
		///
		if (is_empty()) {
			return false;	
		}
		return get_item(_name) != undefined;
	};	
	static is_empty  = function() {
		/// @func	is_empty()
		/// @return {bool} is_empty?
		///
		return get_size() == 0;
	};
	
	////////////////////////////////////////
	
	/// @LOCAL
	static __add_item_collection	= function(_item) {
		/// @func	__add_item_collection(item)
		/// @param	{any}		 item
		/// @return {Collection} self
		///
		array_push(__array, _item);
		__size++;
		return self;
	};
	static __remove_item_collection = function(_item) {
		/// @func	__remove_item_collection(item)
		/// @param	{any}		 item
		/// @return {Collection} self
		///
		var _index  = array_find_index(__array, _item);
		if (_index != -1) {
			array_delete(__array, _index, 1);
			__size--;	
		}
		return self;
	};
	static __empty_collection		= function() {
		/// @func	__empty_collection()
		/// @return {Collection} self
		///
		__array = [];
		__size  = 0;
		return self;
	};
	
	/// @OVERRIDE
	static get_item    = function(_item) {
		/// @func	get_item(item)
		/// @param	{any} item
		/// @return {any} item
		///
		return _item;
	};
	static add_item	   = function(_item) {
		/// @func	add_item(item)
		/// @param	{any}		 item
		/// @return {Collection} self
		///	
		__add_item_collection(_item);
		return self;
	};
	static remove_item = function(_item) {		
		/// @func	remove_item(item)
		/// @param	{any}		 item
		/// @return {Collection} self
		///
		if (!is_empty()) {
			__remove_item_collection(_item);
		}
		return self;
	};
	static empty	   = function() {			
		/// @func	empty()
		/// @return {Collection} self
		///
		if (!is_empty()) {
			__empty_collection();
		}
		return self;
	};
};
function Set(_config = {}) : Collection(_config) constructor {
	/// @func	Set(config*)
	/// @param	{struct} config={}
	/// @return {Set}	 self
	///
	__items = {};
	__names = [];	
	
	static get_names		  = function() {
		/// @func	get_names()
		/// @return {array} names
		///
		return __names;
	};
	static get_items_as_array = function() {
		/// @func	get_items_as_array()
		/// @return {array} items
		///
		return struct_to_array(__items, __names, __size);
	};
		
	////////////////////////////////////////
	
	/// @LOCAL
	static __add_item_set	 = function(_name, _item) {
		/// @func	__add_item_set(name, item)
		/// @param	{string} name
		/// @param	{any}    item
		/// @return {Set}    self
		///
		__items[$ _name] = _item;
		array_push(__names, _name);
		return self;
	};
	static __remove_item_set = function(_name) {
		/// @func	__remove_item_set(name)
		/// @param	{string} name
		/// @return {Set}    self
		///
		variable_struct_remove(__items, _name);
		array_find_delete(__names, _name);
		return self;
	};
	static __empty_set	     = function() {
		/// @func	__empty_set()
		/// @return {Set} self
		///
		__items = {};
		__names = [];
		return self;
	};
		
	/// @OVERRIDE
	static get_item	   = function(_name) {
		/// @func	get_item(name)
		/// @param	{string} name
		/// @return	{Set}    self
		///
		return __items[$ _name];
	};
	static add_item    = function(_name, _item) {
		/// @func	add_item(name, item)
		/// @param	{string} name
		/// @param	{any}	 item
		/// @return {Set}	 self
		///	
		if (!has_item(_name)) {
			__add_item_collection(_item);
			__add_item_set(_name, _item);
		}
		else {
			log("<{0}()> WARNING in add_item() item with name {1} already exists. item not added", instanceof(self), _name);
		}
		return self
	};
	static remove_item = function(_name) {
		/// @func	remove_item(name)
		/// @param	{string} name
		/// @return {Set}	 self
		///
		if (has_item(_name)) {
			__remove_item_collection(_name);
			__remove_item_set(_name);
		}
		else {
			log("<{0}()> WARNING in remove_item() item with name {1} does not exist.", instanceof(self), _name);
		}
		return self
	};
	static empty	   = function() {
		/// @func	empty()
		/// @return {Set} self
		///
		if (!is_empty()) {
			__empty_collection();
			__empty_set();
		}
		return self
	};
};
function Family(_config = {}) : Set(_config) constructor {
	/// @func	Family(config*)
	/// @param	{struct} config={}
	/// @return {Family} self
	///
	static get_sets		= get_items;
	static get_set		= get_item;
	static add_set		= add_item;
	static has_set		= has_item;
	static remove_set	= remove_item;
	
	static new_set		= function() {
		/// @func	new_set()
		/// @return {Collection} set
		/// 
		return new Collection();
		/// if this changes from a Collection(). make sure to update
		///	add_item(), remove_item(), and get_item() default return
		/// to account for an item_name param and type change
	};
	static empty_set	= function(_set_name) {
		/// @func	empty_set(set_name)
		/// @param	{string} set_name
		/// @return {Family} self
		///
		if (has_set(_set_name)) {
			get_set(_set_name).empty();
		}
		else {
			log("<{0}()> WARNING in empty_set() set with name {1} does not exist.", instanceof(self), _set_name);	
		}
		return self;
	};
	static get_items	= function(_set_name) {
		/// @func	get_items(set_name)
		/// @param	{string} set_name
		/// @return {array}  items
		///
		if (has_set(_set_name)) {
			return get_set(_set_name).get_items();
		}
		else {
			log("<{0}()> WARNING in get_items() set with name {1} does not exist.", instanceof(self), _set_name);		
		}
		return [];
	};
	static add_item	    = function(_set_name, _item) {	
		/// @func	add_item(set_name, item)
		/// @param	{string} set_name
		/// @param	{any}    item
		/// @return {Family} self
		///
		if (!has_set(_set_name)) {
			add_set(_set_name, new_set());
		}
		get_set(_set_name).add_item(_item);
		return self;
	};
	static remove_item  = function(_set_name, _item) {			
		/// @func	remove_item(set_name, item)
		/// @param	{string} set_name
		/// @param	{any}    item
		/// @return {Family} self
		///
		if (has_set(_set_name)) {
			var _set = get_set(_set_name);
			_set.remove_item(_item);	
			
			if (_set.is_empty()) {
				remove_set(_set_name);
			};
		}
		else {
			log("<{0}()> WARNING in remove_item() set with name {1} does not exist.", instanceof(self), _set_name);		
		}
		return self;
	};
};

#endregion
#region Triggers ///////////

function Trigger(_config = {}) : Class(_config) constructor {
	/// @func	Trigger(config*)
	/// @param	{struct}  config={}
	/// @return {Trigger} self
	/// @desc	a Trigger() contains ONE condition and ONE action.
	///			if the condition is validated, then the action will
	///			will be executed. the data associated to the condition
	///			validation and action execution is broadcasted over the
	///			Eventable broadcast event, so that other objects can 
	///			listen to it and parse the relevant data appropriately.
	///
	__condition = undefined;
	__action	= undefined;
	
	/// Establish Ability To Broadcast Events
	component_system_setup(Eventable);
	__eventable = get_component(Eventable)
		.register("trigger_validated", "action_executed")
		.listen  ("trigger_validated",  method(self, execute))
	
	#region Getters	////////
	
	static get_condition = function() {
		/// @func	get_condition()
		/// @return {Method} condition
		///
		if (__condition == undefined) {
			return undefined;	
		}
		return __condition.get_method();
	};
	static get_action	 = function() {
		/// @func	get_action()
		/// @return {Method} action
		///
		if (__action == undefined) {
			return undefined;	
		}
		return __action.get_method();
	};
	
	#endregion
	#region Setters ////////
	
	static set_condition = function(_method, _data = undefined) {
		/// @func	set_condition(method, data*)
		/// @param	{method} method
		/// @param	{any}	 data=undefined
		/// @return {struct} self
		///
		__condition = new Method({
			method: _method,
			data:   _data,
		});
		return self;
	};
	static set_action	 = function(_method, _data = undefined) {
		/// @func	set_action(method, data*)
		/// @param	{method} method
		/// @param	{any}	 data=undefined
		/// @return {struct} self
		///
		__action = new Method({
			method: _method,
			data:   _data,
		});
		return self;
	};
	
	#endregion
	#region Checkers ///////
	
	static has_condition = function() {
		/// @func   has_condition()
		/// @return {boolean} has_condition?
		///
		return get_condition() != undefined;
	};
	static has_action	 = function() {
		/// @func   has_action()
		/// @return {boolean} has_action?
		///
		return get_action() != undefined;
	};
	
	#endregion
	
	static remove_condition = function() {
		/// @func	remove_condition()
		/// @return {Trigger} self
		///
		__condition = undefined;
		return self;
	};
	static remove_action	= function(_name) {
		/// @func	remove_action(name, method)
		/// @param	{string}  name
		/// @return {Trigger} self
		///
		__action = undefined;
		return self;
	};
	static check_activation = function() {
		/// @func	check_activation()
		/// @return {boolean} activated?
		///
		if (has_condition()) {
			if (__condition.execute()) {
				__eventable.broadcast("trigger_validated", { 
					trigger:    self, 
					condition: __condition,
				});
				return true;	
			}
		}
		return false;
	};
	static execute			= function(_data) {
		/// @func	execute(data)
		/// @param	{struct} data
		/// @return {struct} self
		///
		/// execute() gets run from the Pub/Sub. if this returns a 
		/// true boolean, with the current implementation, then the 
		/// Subscriber will automatically be removed from Pub/Sub
		///
		if (has_action()) {
			var _result = __action.execute();
			__eventable.broadcast("action_executed", { 
				trigger:    self, 
				condition: _data.payload.condition,
				action:	   __action,
				result:    _result,
			});
		}
		return self;
	};
};
function TriggerExt(_config = {}) : Class(_config) constructor {
	/// @func	TriggerExt(config*)
	/// @param	{struct}  config={}
	/// @return {Trigger} self
	/// @desc	a TriggerExt() can contain ANY number of conditions, and 
	///			ANY number of actions. Both "conditions" and "actions" are 
	///			encapsulated in a Method() class. if any one of the 
	///			conditions is validated, then all of the actions will be 
	///			executed. the data associated to the condition validation
	///			and action execution is broadcasted over the Eventable
	///			broadcast event, so that other objects can listen to it
	///			and parse the relevant data appropriately.
	///
	__conditions = new Set();
	__actions	 = new Set();
	
	/// Establish Ability To Broadcast Events
	component_system_setup(Eventable);
	__eventable = get_component(Eventable)
		.register("trigger_validated", "action_executed")
		.listen  ("trigger_validated",  method(self, execute))
	
	#region Private ////////
	
	static __add_condition	= function(_condition) {
		/// @func   __add_condition(condition)
		/// @param  {Method}  condition
		/// @return {Trigger} self
		///
		__conditions.add_item(_condition.get_name(), _condition);
		return self;
	};
	static __add_action		= function(_action) {
		/// @func   __add_action(action)
		/// @param  {Method}  action
		/// @return {Trigger} self
		///
		__actions.add_item(_action.get_name(), _action);
		return self;
	};
	
	#endregion
	#region Getters	////////
	
	static get_condition	= function(_name) {
		/// @func	get_condition(name)
		/// @param	{string} name
		/// @return {Method} condition
		///
		if (!__conditions.has_item(_name)) {
			return undefined;
		}
		return __conditions.get_item(_name).get_method();
	};
	static get_conditions	= function() {
		/// @func   get_conditions()
		/// @return {array} methods
		///
		if (!has_conditions()) {
			return [];	
		}
		var _items   = __conditions.get_items();
		var _names   = __conditions.get_names();
		var _count	 = __conditions.get_size();
		var _methods = array_create(_count);
		
		for (var _i = 0; _i < _count; _i++) {
			var _item = _items[$ _names[_i]];
			_methods[_i] = _item.get_method();	
		}
		return _methods;
	};
	static get_action		= function(_name) {
		/// @func	get_action(name)
		/// @param	{string} name
		/// @return {Method} action
		///
		if (!__actions.has_item(_name)) {
			return undefined;
		}
		return __actions.get_item(_name).get_method();
	};
	static get_actions		= function() {
		/// @func   get_actions()
		/// @return {array} methods
		///
		if (!has_actions()) {
			return [];	
		}
		var _items   = __actions.get_items();
		var _names   = __actions.get_names();
		var _count	 = __actions.get_size();
		var _methods = array_create(_count);
		
		for (var _i = 0; _i < _count; _i++) {
			var _item = _items[$ _names[_i]];
			_methods[_i] = _item.get_method();	
		}
		return _methods;
	};
	
	#endregion
	#region Checkers ///////
	
	static has_condition  = function(_name) {
		/// @func   has_condition(name)
		/// @param  {string } name
		/// @return {boolean} has_condition?
		///
		return __conditions.has_item(_name);
	};
	static has_conditions = function() {
		/// @func   has_conditions()
		/// @return {bool} has_conditions?
		///	
		return !__conditions.is_empty();
	};
	static has_action	  = function(_name) {
		/// @func   has_action(name)
		/// @param  {string } name
		/// @return {boolean} has_action?
		///
		return __actions.has_item(_name);
	};
	static has_actions	  = function() {
		/// @func   has_actions()
		/// @return {bool} has_actions?
		///	
		return !__actions.is_empty();
	};
	
	#endregion
	
	static new_condition	= function(_name, _method, _data = undefined) {
		/// @func	new_condition(name, method, data*)
		/// @param	{string}  name
		/// @param	{method}  method
		/// @param	{any}	  data=undefined
		/// @return {Trigger} self
		///
		return __add_condition(new Method({
			name:   _name,
			method: _method,
			data:   _data,
		}));
	};
	static new_action		= function(_name, _method, _data = undefined) {
		/// @func	new_action(name, method, data*)
		/// @param	{srting}  name
		/// @param	{method}  method
		/// @param	{any}	  data=undefined
		/// @return {Trigger} self
		///
		return __add_action(new Method({
			name:   _name,
			method: _method,
			data:   _data,
		}));
	};
	static remove_condition = function(_name) {
		/// @func	remove_condition(name)
		/// @param	{string}  name
		/// @return {Trigger} self
		///
		__conditions.remove_item(_name);
		return self;
	};
	static remove_action	= function(_name) {
		/// @func	remove_action(name)
		/// @param	{string}  name
		/// @return {Trigger} self
		///
		__actions.remove_item(_name);
		return self;
	};
	static clear_conditions = function() {
		/// @func	clear_conditions()
		/// @return {Trigger} self
		///
		__conditions.empty();
		return self;
	};
	static clear_actions	= function() {
		/// @func	clear_actions()
		/// @return {Trigger} self
		///
		__actions.empty();
		return self;
	};
	static check_activation = function() {
		/// @func	check_activation()
		/// @return {boolean} activated?
		///
		if (!__conditions.is_empty()) {
			var _names = __conditions.get_names();
			var _count = __conditions.get_size();
			for (var _i = 0; _i < _count; _i++) {
				var _condition = __conditions.get_item(_names[_i]);
				if (_condition.execute()) {
					__eventable.broadcast("trigger_validated", { 
						trigger:    self, 
						condition: _condition,
					});
					return true;	
				}
			}
		}
		return false;
	};
	static execute			= function(_data) {
		/// @func	execute(data)
		/// @param	{struct} data
		/// @return {struct} self
		///
		/// execute() gets run from the Pub/Sub. if this returns a 
		/// true boolean, with the current implementation, then the 
		/// Subscriber will automatically be removed from Pub/Sub
		///
		if (!__actions.is_empty()) {
			var _action_names = __actions.get_names();
			var _actions	  = __actions.get_items();
			var _n_actions	  = __actions.get_size();
			for (var _i = 0; _i < _n_actions; _i++) {
				var _action_name = _action_names[_i];
				var _action		 = _actions[$ _action_name];
				var _result		 = _action.execute();
				__eventable.broadcast("action_executed", { 
					trigger:    self, 
					condition: _data.payload.condition,
					action:	   _action,
					result:    _result,
				});
			}
		}
		return self;
	};
};

#endregion


