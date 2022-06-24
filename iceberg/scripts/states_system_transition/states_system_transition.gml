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
			event_publish("enter_started");
			
			effect = new effect_in()
				.event_subscribe("enter_completed", function() {
					fsm.change(STATE_SYSTEM_TRANSITION_CHANGE);	
				})
				.set_callback_on_leave_method(method(effect, function() {
					log("effect cleanup -- frome on_leave callback");	/// <-- this does not need to be here anymore, but it should be hitting. why not?
					//cleanup();
				}))
				.enter()
		},
		step:  function() {
			effect.update();
		},
		leave: function() {
			event_publish("enter_completed");
		},
	};
};
function state_system_transition_change() {
	/// @func	state_system_transition_change()
	/// @return {struct} state_data
	///
	return {
		enter: function() {
			event_publish("change_started");
			
			room_goto(room_target);	// <-- move to state.leave?
			fsm.change(STATE_SYSTEM_TRANSITION_HOLD);
		},
		step:  function() {
			effect.update();
		},
		leave: function() {
			event_publish("change_completed");
		},
	};
};
function state_system_transition_hold() {
	/// @func	state_system_transition_hold()
	/// @return {struct} state_data
	///
	return {
		enter: function() {
			event_publish("hold_started");
			
			effect.event_subscribe("hold_completed", function() {
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
			event_publish("hold_completed");
			effect.cleanup();
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
			event_publish("exit_started");
			
			effect = new effect_out()
				.event_subscribe("enter_completed", function() {
					fsm.change(STATE_SYSTEM_TRANSITION_IDLE);	
				})
				.reverse()
				.enter()
		},
		step:  function() {
			effect.update();
		},
		leave: function() {
			event_publish("exit_completed");
			effect.cleanup();
			effect_out = undefined;
		},
	};
};





