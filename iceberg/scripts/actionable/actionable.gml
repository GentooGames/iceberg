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
	
	//IIntegral();
};