#macro STATE_SYSTEM_TRANSITION_IDLE			 "state_system_transition_idle"
#macro STATE_SYSTEM_TRANSITION_TRANSITIONING "state_system_transition_transitioning"
#macro STATE_SYSTEM_TRANSITION_CHANGE		 "state_system_transition_change"
#macro STATE_SYSTEM_TRANSITION_HOLD			 "state_system_transition_hold"
#macro STATE_SYSTEM_TRANSITION_ENDING		 "state_system_transition_ending"

function state_system_transition_draw_default() {
	/// @func	state_system_transition_draw_default()
	/// @return NA
	///
	if (effect != undefined) {
		effect.render();	
	}
};
function state_system_transition_idle() {
	/// @func	state_system_transition_idle()
	/// @return {struct} state_data
	///
	return {
		enter: function() {},
		step:  function() {},
		leave: function() {},
	};
};
function state_system_transition_transitioning() {
	/// @func	state_system_transition_transitioning()
	/// @return {struct} state_data
	///
	return {
		enter: function() {
			get_component(Eventable)
				.broadcast("enter_started");
				
			effect = new effect_in().setup();
			effect.get_component(Eventable)
				.listen("enter_completed", function(_data) {
					fsm.change(STATE_SYSTEM_TRANSITION_CHANGE);	
				});
			effect.enter()
		},
		step:  function() {
			effect.update();
		},
		leave: function() {
			get_component(Eventable)
				.broadcast("enter_completed");
		},
	};
};
function state_system_transition_change() {
	/// @func	state_system_transition_change()
	/// @return {struct} state_data
	///
	return {
		enter: function() {
			get_component(Eventable)
				.broadcast("change_started");
			
			/// Move To state.leave?
			var _event_name = (room_target == room)
				? "room_restarted"
				: "room_changed";
			room_goto(room_target);		
			
			get_component(Eventable)
				.broadcast(_event_name, room_target);	
			
			fsm.change(STATE_SYSTEM_TRANSITION_HOLD);
		},
		step:  function() {
			effect.update();
		},
		leave: function() {
			get_component(Eventable)
				.broadcast("change_completed");
		},
	};
};
function state_system_transition_hold() {
	/// @func	state_system_transition_hold()
	/// @return {struct} state_data
	///
	return {
		enter: function() {
			get_component(Eventable)
				.broadcast("hold_started");
				
			effect.get_component(Eventable)
				.listen("hold_completed", function(_data) {
					room_to_release = true;
					if (end_transition_is_ready()) {
						end_transition();
					}
				});
				
			room_holding = true;
		},
		step:  function() {
			effect.update();
		},
		leave: function() {
			get_component(Eventable)
				.broadcast("hold_completed");
				
			effect.teardown();
			effect_in = undefined;
		},
	};
};
function state_system_transition_ending() {
	/// @func	state_system_transition_ending()
	/// @return {struct} state_data
	///
	return {
		enter: function() {
			get_component(Eventable)
				.broadcast("exit_started");
				
			effect = new effect_out().setup();
			effect.get_component(Eventable)
				.listen("enter_completed", function(_data) {
					fsm.change(STATE_SYSTEM_TRANSITION_IDLE);	
				});
			effect.reverse();
			effect.enter();
		},
		step:  function() {
			effect.update();
		},
		leave: function() {
			get_component(Eventable)
				.broadcast("exit_completed");
				
			effect.teardown();
			effect_out = undefined;
			effect	   = undefined;
		},
	};
};

