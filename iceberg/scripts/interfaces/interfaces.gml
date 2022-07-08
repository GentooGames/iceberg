//////////////////////////////////////////////////////////////////////////////
//	Interfaces																//
//		-	interfaces are abstract containers that define functionality, 	//
//			but interfaces DO NOT implement said functionality.				//
//		-	this allows an "object" to initialize multiple interfaces that 	//
//			modularly define functionality without creating a relational 	//
//			dependency.														//
//////////////////////////////////////////////////////////////////////////////

function ITriggerContainer(_owner = self) {
	/// @func	ITriggerContainer(owner*)
	/// @param	{struct} owner=self
	/// @return NA
	///
	with (_owner) {
		__ITriggers = {
			__active:   true,
			__names:    [],
			__count:    0,
			__triggers: {},
		};
	
		static add_trigger	    = method(self, function(_trigger_name, _trigger_method) {
			/// @func	add_trigger(trigger_name, trigger_method)
			/// @param	{string} trigger_name
			/// @param	{method} trigger_method
			/// @return {Action} self
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
		});
		static destroy_trigger  = method(self, function(_trigger_name) {
			/// @func	destroy_trigger(trigger_name)
			/// @param	{string} trigger_name
			/// @return {Action} self
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
		});
		static destroy_triggers = method(self, function() {
			/// @func	destroy_triggers()
			/// @return {Action} self
			///
			__ITriggers = {
				__names:	[],
				__count:	0,
				__triggers: {},
			};
			return self;
		});
		static update_triggers	= method(self, function() {
			/// @func	update_triggers()
			/// @return {Action} self
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
		});
	
		#region Getters ////////////
		
		static get_triggers_active = method(self, function() {
			/// @func	get_triggers_active()
			/// @return {boolean} are_active?
			///
			return __ITriggers.__active;
		});
		static get_trigger		   = method(self, function(_trigger_name) {
			/// @func	get_trigger(trigger_name)
			/// @param	{string} trigger_name
			/// @return {Trigger} trigger
			///
			return __ITriggers.__triggers[$ _trigger_name];
		});
		static get_trigger_active  = method(self, function(_trigger_name) {
			/// @func	get_trigger_active(trigger_name)
			/// @param	{string}  trigger_name
			/// @return {boolean} active?
			///
			if (has_trigger(_trigger_name)) {
				return get_trigger(_trigger_name).get_active();
			}
			return false;
		});
		static get_trigger_method  = method(self, function(_trigger_name) {
			/// @func	get_trigger_method(trigger_name)
			/// @param	{string} trigger_name
			/// @return {method} method
			///
			if (has_trigger(_trigger_name)) {
				return get_trigger(_trigger_name).get_method();
			}
			return undefined;
		});
		static get_trigger_data	   = method(self, function(_trigger_name) {
			/// @func	get_trigger_data(trigger_name)
			/// @param	{string} trigger_name
			/// @return {method} method
			///
			if (has_trigger(_trigger_name)) {
				return get_trigger(_trigger_name).get_data();
			}
			return undefined;
		});
		
		#endregion
		#region Setters	////////////
		
		static set_triggers_active = method(self, function(_active) {
			/// @func	set_triggers_active(active?)
			/// @param	{boolean} active?
			/// @return {Action} self
			///
			__ITriggers.__active = _active;
			return self;
		});
		static set_trigger_active  = method(self, function(_trigger_name, _active) {
			/// @func	set_trigger_active(trigger_name, active?)
			/// @param	{string}  trigger_name
			/// @param	{boolean} active?
			/// @return {Action} self
			///
			if (has_trigger(_trigger_name)) {
				get_trigger(_trigger_name).set_active(_active);
			}
			return self;
		});
		static set_trigger_method  = method(self, function(_trigger_name, _trigger_method) {
			/// @func	set_trigger_active(trigger_name, trigger_method)
			/// @param	{string} trigger_name
			/// @param	{method} method
			/// @return {Action} self
			///
			if (has_trigger(_trigger_name)) {
				get_trigger(_trigger_name).set_method(_trigger_method);
			}
			return self;
		});
		static set_trigger_data	   = method(self, function(_trigger_name, _trigger_data) {
			/// @func	set_trigger_data(trigger_name, trigger_data)
			/// @param	{string} trigger_name
			/// @param	{method} method
			/// @return {Action} self
			///
			if (has_trigger(_trigger_name)) {
				get_trigger(_trigger_name).set_data(_trigger_data);
			}
			return self;
		});
		
		#endregion
		#region Checkers ///////////
		
		static has_trigger = method(self, function(_trigger_name) {
			/// @func	has_trigger(trigger_name)
			/// @param	{string}  trigger_name
			/// @return {boolean} has_trigger?
			///
			return get_trigger(_trigger_name) != undefined;
		});
			
		#endregion
	}
};

