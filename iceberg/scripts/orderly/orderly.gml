//////////////////////////////////////////////
// .---. .---. .---\ .---- .---. .    .   . //
// |   | r---J |   | r--   r---J |      V   //
// L---J |  \  L---/ L---- |  \  L----  |   //
///////////////////////////////////////$(º)>//
#region docs, info & configs /////////////////

#region about ////////////////////////////////
/*
	written_by:__gentoo__________________
	version:_____0.1.0___________________
*/        
#endregion
#region change log ///////////////////////////

#region version 0.1.0
/*	
	Date: 03/22/2022
	1. Released first version.
*/
#endregion

#endregion
#region docs & help //////////////////////////
/*
	- built based off of the Command design pattern
		https://www.tutorialspoint.com/design_pattern/command_pattern.htm
		
	this will act very similarly to the classic command pattern implementation
	however, additional functionality will be added. functionality includes:
		- action queuing
		- pausing & resuming action execution
		- on_start, on_execute, & on_end triggers w/callbacks
		- delayed action execution
		- continuous action execution until an end condition is met
*/
#endregion
#region upcoming features ////////////////////
/*
	- action logging
	- action replaying
*/
#endregion
#region default config values ////////////////

#macro __AR_DEFAULT_START_PAUSED			false								// does the Runner() start paused?
#macro __AR_DEFAULT_END_CONDITION			undefined							// end_condition_function to check against to determine if the Action() is considered complete
#macro __AR_DEFAULT_END_CONDITION_DATA		undefined							// end_condition_data used to pass into the end_condition_function 
#macro __AR_DEFAULT_DELAY				   -1									// delay = frames_between_action_execution. set to -1 for no delay. 
#macro __AR_DEFAULT_DELAY_ON_FIRST_ACTION   false								// apply delay to the first Action() pushed into the Runner when empty?
#macro __AR_DEFAULT_DELAY_ON_ACTION_CHANGE  true								// apply delay between each Action() execution?
#macro __AR_DEFAULT_WAIT_FOR_DELAY_TO_END	true								// does the delay need to be done before considering the Action() as complete?
#macro __AR_DEFAULT_ITERATIONS_MAX		    1									// maximum number of times that an Action() can run. -1 = no max limit
#macro __AR_DEFAULT_END_ON_ITERATIONS_MAX	false								// should the Action() consider itself complete once it has iterated the max number of times?
#macro __AR_DEFAULT_END_BEHAVIOR		  __AR_ACTION_END.REMOVE_FROM_RUNNER	// toggle switch to determine how the Action() should be handled once complete. choose from enum __AR_ACTION_END
#macro __AR_DEFAULT_AUTO_BIND_TO_ACTOR		true								// should the functions passed into the Runner() automatically bind to the actor? set to false if you plan on doing your own binding using method()
#macro __AR_DEFAULT_USE_SCRIPT_EXECUTE_EXT	false								// use script_execute_ext() to process functions?
#macro __AR_DEFAULT_TRIGGER_ON_START_FUNC	undefined							// function to execute once an Action() has been started
#macro __AR_DEFAULT_TRIGGER_ON_START_DATA	undefined							// data to use for the function to execute once an Action() has been started
#macro __AR_DEFAULT_TRIGGER_ON_EXECUTE_FUNC	undefined							// function to execute once an Action() has been executed
#macro __AR_DEFAULT_TRIGGER_ON_EXECUTE_DATA	undefined							// data to use for the function to execute once an Action() has been executed
#macro __AR_DEFAULT_TRIGGER_ON_END_FUNC		undefined							// function to execute once an Action() has been completed
#macro __AR_DEFAULT_TRIGGER_ON_END_DATA		undefined							// data to use for the function to execute once an Action() has been executed

#endregion
#region enums ////////////////////////////////

enum __AR_ACTION_END {
	REMOVE_FROM_RUNNER,
}	

#endregion

#endregion

function Orderly()  constructor {
	/// @func	Orderly() 
	/// @return {Orderly} self
	///
	owner = other;
	this  = {
		action:    undefined,
		actions:   [],
		n_actions: 0,
		config:	   {
			default_end_condition:			__AR_DEFAULT_END_CONDITION,
			default_end_condition_data:		__AR_DEFAULT_END_CONDITION_DATA,
			default_delay:					__AR_DEFAULT_DELAY,
			default_delay_on_first_action:	__AR_DEFAULT_DELAY_ON_FIRST_ACTION,
			default_delay_on_action_change:	__AR_DEFAULT_DELAY_ON_ACTION_CHANGE,
			default_wait_for_delay_to_end:	__AR_DEFAULT_WAIT_FOR_DELAY_TO_END,
			default_iterations_max:			__AR_DEFAULT_ITERATIONS_MAX,
			default_end_on_iterations_max:	__AR_DEFAULT_END_ON_ITERATIONS_MAX,
			default_end_behavior:			__AR_DEFAULT_END_BEHAVIOR,
			default_auto_bind_to_actor:		__AR_DEFAULT_AUTO_BIND_TO_ACTOR,
			default_use_script_execute_ext: __AR_DEFAULT_USE_SCRIPT_EXECUTE_EXT,
			default_on_start:	{
				func: __AR_DEFAULT_TRIGGER_ON_START_FUNC,
				data: __AR_DEFAULT_TRIGGER_ON_START_DATA,
			},
			default_on_execute: {
				func: __AR_DEFAULT_TRIGGER_ON_EXECUTE_FUNC,
				data: __AR_DEFAULT_TRIGGER_ON_EXECUTE_DATA,
			},
			default_on_end:		{
				func: __AR_DEFAULT_TRIGGER_ON_END_FUNC,
				data: __AR_DEFAULT_TRIGGER_ON_END_DATA,
			},
		},
		control:   {
			paused:		   __AR_DEFAULT_START_PAUSED,
			delayed_first: false,
		},
	};
	/// Core ///////////////////////////////////////////
	static step					   = function() {
		/// @func	step()
		/// @desc	tick ran every frame. 
		/// @return NA
		///
		if (!can_execute()) exit;
		/////////////////////////
		if (has_action()) {
			with (get_action()) {
				if (can_execute()) {
					execute();
				}
				else wait();	
			}
		}	
		else {
			// If No Action Set, Reset delayed_first Flag
			if (!this.config.default_delay_on_first_action) {
				this.control.delayed_first = false;
			}
			set_action(pop());
		}
	};
	static push					   = function(_action) {
		/// @func	push()
		/// @param	{Action} action
		/// @desc	add a new action into the stack.
		/// @return {Orderly} self
		///
		array_push(this.actions, _action);
		this.n_actions++;
		return self;
	};
	static pop					   = function() {
		/// @func	pop()
		/// @desc	get the next action from the stack
		/// @return {Orderly} action
		///
		if (get_size() <= 0) {
			return undefined;
		}
		var _action = this.actions[0];
		array_delete(this.actions, 0, 1);
		this.n_actions--;
		
		/// Skip Any Action Flagged For Removal
		if (_action != undefined && _action.this.control.to_remove) {
			_action  = pop(); // recursive 
		}		
		return _action;
	};
	static pause				   = function() {
		/// @func	pause()
		/// @desc	indefinately pause action execution. can be resumed using
		///			resume() method in the Orderly() class.
		/// @return {Orderly} self
		///
		this.control.paused = true;
		return self;
	};
	static resume				   = function() {
		/// @func	resume()
		/// @desc	resume action execution if previously paused. can be paused using
		///			pause() method in the Orderly() class.
		/// @return {Orderly} self
		///
		this.control.paused = false;
		return self;
	};
	static reset				   = function() {
		/// @func	reset()
		/// @desc	clear out the entire Orderly() & reset
		///			back to its starting state.
		/// @return {Orderly} self
		///
		this.action					= undefined;
		this.actions				= [];
		this.tagged					= {};
		this.n_actions				= 0;
		this.control.paused			= __AR_DEFAULT_START_PAUSED;
		this.control.delayed_first	= false;
		return self;
	};
	static new_action			   = function(_config, _add_to_queue = true) {
		/// @func	new_action({actor, func, data}, add_to_queue?<t>)
		/// @param	{struct} config		 
		/// @param	{bool}	 add_to_queue?
		/// @desc	use this method to create a new instance of OrderlyAction()
		///			and automatically add it into the stack.
		/// @return {OrderlyAction} action
		///
		var _action = new OrderlyAction(_config);
		if (_add_to_queue) {
			add_action(_action);
		}
		return _action;
	};
	static add_action			   = function(_action) {
		/// @func	add_action(action)	
		/// @param	{OrderlyAction} action
		/// @desc	...
		/// @return {Orderly} self
		///
		push(_action);
		return self;
	};
	static clear_action			   = function() {
		/// @func	clear_action()
		/// @desc	set the current action executing to undefined.
		/// @return {OrderlyAction} self
		///
		set_action(undefined);
		return self;
	};
	static remove_action		   = function(_action, _clear_active = true) {
		/// @func	remove_action(action, clear_active?*<t>)
		/// @param	{OrderlyAction} action		 
		/// @param	{bool}			clear_active?
		/// @desc	remove a given action from the stack.
		/// @return {Orderly} self
		///
		for (var _i = get_size() - 1; _i >= 0; _i--) {
			var _this_action = this.actions[_i];
			if (_this_action == _action) {
				array_delete(this.actions, _i, 1);
				this.n_actions--;
			}
		}
		if (_clear_active) {
			if (this.action == _action) {
				clear_action();	
			}
		}
		return self;
	};
	static remove_actor			   = function(_actor,  _clear_active = true) {
		/// @func	remove_actor(actor, clear_active?*<t>)	
		/// @param	{struct}  actor		 
		/// @param	{bool}    clear_active?
		/// @return {Orderly} self
		///
		for (var _i = get_size() - 1; _i >= 0; _i--) {
			var _this_action = this.actions[_i];
			if (_this_action.get_actor() == _actor) {
				array_delete(this.actions, _i, 1);
				this.n_actions--;
			}
		}
		if (_clear_active) {
			if (get_actor() != undefined) {
				if (get_action() != undefined && (get_action()).get_actor() == _actor) {
					clear_action();	
				}
			}
		}
		return self;
	};
	static flag_action_for_removal = function(_action) {
		/// @func	flag_action_for_removal(action)
		/// @param	{OrderlyAction} action
		/// @return {Orderly}		self
		///
		_action.flag_for_removal();
		return self;
	};
	static flag_actor_for_removal  = function(_actor) {
		/// @func	flag_actor_for_removal(actor)
		/// @param	{struct}  actor
		/// @return {Orderly} self
		///
		for (var _i = 0, _len = get_size(); _i < _len; _i++) {
			if (this.actions[_i].get_actor() == _actor) {
				this.actions[_i].flag_for_removal();	
			}
		}
		return self;
	};
	
	/// Checkers ///////////////////////////////////////
	static can_execute = function() {
		/// @func	can_execute()
		/// @desc	is the Orderly() currently able to execute actions?
		/// @return {bool} can_execute?
		///
		return (
			!this.control.paused
		);
	};
	static has_action  = function() {
		/// @func	has_action()
		/// @desc	check if the current action executing is undefined
		/// @return {bool} has_action?
		///
		return get_action() != undefined;	
	};	
	static is_empty	   = function() {
		/// @func	is_empty()
		/// @desc	check if the stack currently has any actions waiting
		/// @return {bool} is_empty?
		///
		return get_size() <= 0;	
	};
	static is_paused   = function() {
		/// @func	is_paused()
		/// @desc	...
		/// @return {bool} is_paused?
		///
		return this.control.paused;
	};
	static is_running  = function() {
		/// @func	is_running()	
		/// @desc	...
		/// @return {bool} is_running?
		///
		return (has_action()
			&&	!is_paused()
		);
	};
		
	/// Getters ////////////////////////////////////////
	static get_owner  = function() {
		/// @func	get_owner()
		/// @desc	return the assigned owner to the Orderly()
		/// @return {struct} owner
		///
		return owner;
	};
	static get_size	  = function() {
		/// @func	get_size()
		/// @desc	return the number of actions in the stack.
		/// @return {real} size
		///
		return this.n_actions;		
	};
	static get_action = function() {
		/// @func	get_action()
		/// @desc	get the action currently executing. may return undefined
		/// @return {Orderly} action
		///
		return this.action;		
	};
	static get_actor  = function() {
		/// @func	get_actor()
		/// @desc	return the defined actor for the given action executing
		///			if no action executing, return undefined
		/// @return {struct} actor
		///
		return (
			has_action() 
				? (get_action()).get_actor() 
				:  undefined
		);
	};
	
	/// Setters ////////////////////////////////////////
	static set_action						  = function(_action) {
		/// @func	set_action(action)
		/// @param	{OrderlyAction} action
		/// @desc	set the action currently executing. this will NOT invoke any
		///			necessary teardown proceedures involved with naturally removing an 
		///			action from the stack when it completes by itself.
		/// @return {Orderly} self
		///
		this.action  = _action;
		if (_action != undefined) {
			_action._prep();	
		}
		return self;
	};
	static set_default_end_condition		  = function(_actor = get_owner(), _func, _data) {
		/// @func	set_default_end_condition(actor*, func, data)
		/// @param	{struct}   actor
		/// @param	{function} func 
		/// @param	{any} data 
		/// @return {Orderly} self
		///
		this.config.default_end_condition	   = _func;
		this.config.default_end_condition_data = _data;
		if (this.config.default_auto_bind_to_actor) {
			this.config.default_end_condition = method(_actor, _func);	
		}
		return self;
	};
	static set_default_delay				  = function(_delay) {
		/// @func	set_default_delay(delay)
		/// @param	{real} delay
		/// @desc	...
		/// @return {Orderly}  self
		///
		this.config.default_delay = _delay;
		return self;
	};
	static set_default_delay_on_first_action  = function(_delay_on_first_action) {
		/// @func	set_default_delay_on_first_action(delay_on_first_action?)
		/// @param	{bool} delay_on_first_action?
		/// @desc	...
		/// @return {Orderly} self
		///
		this.config.default_delay_on_first_action = _delay_on_first_action;
		return self;
	};
	static set_default_delay_on_action_change = function(_delay_on_action_change) {
		/// @func	set_default_delay_on_action_change(delay_on_action_change?)
		/// @param	{bool} delay_on_action_change?
		/// @desc	...
		/// @return {Orderly} self
		///
		this.config.default_delay_on_action_change = _delay_on_action_change;
		return self;
	};
	static set_default_wait_for_delay_to_end  = function(_wait_for_delay_to_end) {
		/// @func	set_default_wait_for_delay(wait_for_delay_to_end?)
		/// @param	wait_for_delay_to_end? {bool}
		/// @desc	...
		/// @return {Orderly} self
		///
		this.config.default_wait_for_delay_to_end = _wait_for_delay_to_end;
		return self;
	};
	static set_default_max_iterations		  = function(_iterations) {
		/// @func	set_default_max_iterations(iterations)
		/// @param	{real} iterations
		/// @desc	...
		/// @return {Orderly} self
		///
		this.config.default_iterations_max = _iterations;
		return self;
	};
	static set_default_end_on_max_iterations  = function(_end_on_max) {
		/// @func	set_default_end_on_max_iterations(end_on_max?)
		/// @param	{bool} end_on_max?
		/// @desc	...
		/// @return {Orderly} self
		///
		this.config.default_end_on_iterations_max = _end_on_max;
		return self;
	};
	static set_default_end_behavior			  = function(_action_end_enum) {
		/// @func	set_default_end_behavior(action_end_enum)
		/// @param	{enum} action_end_enum
		/// @desc	...
		/// @return {Orderly} self
		///
		this.config.default_end_behavior = _action_end_enum;
		return self;
	};
	static set_default_repeat_action		  = function(_repeat_action) {
		/// @func	set_default_repeat_action(repeat_action?)
		/// @param	{bool} repeat_action?
		/// @desc	...
		/// @return {Orderly} self
		/// 
		this.config.default_repeat_action = _repeat_action;
		return self;
	};
	static set_default_auto_bind_to_actor	  = function(_auto_bind_methods) {
		/// @func	set_default_auto_bind_to_actor(auto_bind_methods?)
		/// @param	{bool} auto_bind_methods?
		/// @desc	...
		/// @return {Orderly} self
		///
		this.config.default_auto_bind_to_actor = _auto_bind_methods;
		return self;
	};
	static set_default_use_script_execute_ext = function(_use_script_execute_ext) {
		/// @func	set_default_use_script_execute_ext(use_script_execute_ext?)
		/// @param	{bool} use_script_execute_ext?
		/// @desc	...
		/// @return {Orderly} self
		///
		this.config.use_script_execute_ext = _use_script_execute_ext;
		return self;
	};
	static set_default_on_start				  = function(_actor = get_owner(), _func, _data) {
		/// @func	set_default_on_start(actor*, func, data)
		/// @param	{struct}   actor
		/// @param	{function} func
		/// @param	{any}	   data
		/// @return {Orderly}  self
		///
		this.config.default_on_start_func = _func;
		this.config.default_on_start_data = _data;
		if (this.config.default_auto_bind_to_actor) {
			this.config.default_on_start_func = method(_actor, _func);	
		}
		return self;
	};
	static set_default_on_execute			  = function(_actor = get_owner(), _func, _data) {
		/// @func	set_default_on_execute(actor*, func, data)
		/// @param	{struct}   actor
		/// @param	{function} func
		/// @param	{any}	   data
		/// @return {Orderly}  self
		///
		this.config.default_on_execute_func = _func;
		this.config.default_on_execute_data = _data;
		if (this.config.default_auto_bind_to_actor) {
			this.config.default_on_execute_func = method(_actor, _func);	
		}
		return self;
	};
	static set_default_on_end				  = function(_actor = get_owner(), _func, _data) {
		/// @func	set_default_on_end(actor*, func, data)
		/// @param	{struct}   actor
		/// @param	{function} func
		/// @param	{any}	   data
		/// @return {Orderly}  self
		///
		this.config.default_on_end_func = _func;
		this.config.default_on_end_data = _data;
		if (this.config.default_auto_bind_to_actor) {
			this.config.default_on_end_func = method(_actor, _func);	
		}
		return self;
	};
};
function OrderlyAction(_config) constructor {
	/// @func	OrderlyAction({actor, func, data})
	/// @param	{struct} config
	/// @desc	...
	/// @return {OrderlyAction} self
	///
	runner = other;
	this   = {
		actor:   _config[$ "actor"] ?? runner.get_owner(),
		func:	 _config.func,
		data:	 _config[$ "data" ] ?? undefined,
		config:	 {
			end_condition:			runner.this.config.default_end_condition,
			end_condition_data:		runner.this.config.default_end_condition_data,
			delay:					runner.this.config.default_delay,
			delay_on_first_action:	runner.this.config.default_delay_on_first_action,
			delay_on_action_change: runner.this.config.default_delay_on_action_change,
			wait_for_delay_to_end:	runner.this.config.default_wait_for_delay_to_end,
			iterations_max:			runner.this.config.default_iterations_max,
			end_behavior:			runner.this.config.default_end_behavior,
			end_on_iterations_max:	runner.this.config.default_end_on_iterations_max,
			auto_bind_to_actor:		runner.this.config.default_auto_bind_to_actor,
			use_script_execute_ext: runner.this.config.default_use_script_execute_ext,
			on_start:	{
				func: runner.this.config.default_on_start.func,
				data: runner.this.config.default_on_start.data,
			},
			on_execute: {
				func: runner.this.config.default_on_execute.func,
				data: runner.this.config.default_on_execute.data,
			},
			on_end:		{
				func: runner.this.config.default_on_end.func,
				data: runner.this.config.default_on_end.data,
			},
		},
		control: {
			iterations:	0,
			did_start:	false,
			delay:	   -1, 
			did_delay:  false,
			to_remove:  false,
		},	
	};
	#region Setup
	
	var _actor = get_actor();
	if (this.config.auto_bind_to_actor && _actor != undefined) {
		this.func = method(_actor, this.func);
		///
		if (this.config.end_condition	!= undefined) this.config.end_condition	  = method(_actor, this.config.end_condition);
		if (this.config.on_start.func	!= undefined) this.config.on_start.func	  = method(_actor, this.config.on_start.func);
		if (this.config.on_execute.func != undefined) this.config.on_execute.func = method(_actor, this.config.on_execute.func);
		if (this.config.on_end.func		!= undefined) this.config.on_end.func	  = method(_actor, this.config.on_end.func);
	}
	
	#endregion
	#region _
	
	static _prep					 = function() {
		/// @func	_prep()
		/// @desc	...
		/// @return NA
		///
		/// Set Delay Timer
		if (	(this.config.delay_on_first_action  && !runner.this.control.delayed_first)
			||	(runner.this.control.delayed_first  && this.config.delay_on_action_change)) 
		{
			this.control.delay = this.config.delay;
			runner.this.control.delayed_first = true;
		}
	};
	static _execute					 = function() {
		/// @func	_execute()
		/// @desc	...
		/// @return NA
		///
		if (this.config.use_script_execute_ext) {
			if (this.data != undefined) {
				if (is_array(this.data)) {
					 script_execute_ext(this.func, this.data);
				}
				else this.func(this.data);
			}
			else this.func();
		}
		else this.func(this.data);
		////////////////////////////////////////////
		this.control.iterations++;
		this.control.delay				  = this.config.delay;
		this.control.did_delay			  = false;
		runner.this.control.delayed_first = true; 
	};
	static _delay					 = function() {
		/// @func	_delay()
		/// @desc	...
		/// @return NA
		///
		if (this.control.delay > 0) {
			this.control.delay--;
		}
		else if (this.control.delay == 0) {
			this.control.did_delay = true;	
			this.control.delay	   = -1;
		}
	};
	static _end						 = function() {
		/// @func	_end()
		/// @desc	this action now considered complete, and will be 
		///			removed from the ActionRunner() stack.
		/// @return NA
		///
		_on_end_trigger();
		_on_end_behavior();
	};
		
	static _check_for_end			 = function() {
		/// @func	_check_for_end()
		/// @desc	...
		/// @return NA
		///
		if (_can_end()) {
			_end();
		}
	};
	static _can_end					 = function() {
		/// @func	_can_end()
		/// @desc	check if this action can be considered "complete" 
		///			so that it can be removed from the ActionRunner() stack.
		/// @return NA
		///
		return (  this.control.did_start
			&&	(!this.config.wait_for_delay_to_end || !is_delayed())
			&&  (_end_iterations_satisfied()		|| _end_condition_satisfied())
		);	
	};
	static _end_iterations_satisfied = function() {
		/// @func	_end_iterations_satisfied()
		/// @desc	...
		/// @return NA
		///
		return (this.config.end_on_iterations_max 
			&&	this.control.iterations >= this.config.iterations_max
		);
	};
	static _end_condition_satisfied  = function() {
		/// @func	_end_condition_satisfied()
		/// @desc	...
		/// @return NA
		///
		return (this.config.end_condition != undefined 
			&&	this.config.end_condition(this.config.end_condition_data)
		);
	};
		
	static _on_start_trigger		 = function() {
		/// @func	_on_start_trigger()
		/// @desc	check if on_start() should execute, and execute it.
		/// @return NA
		///
		if (!this.control.did_start) {
			if (this.config.on_start.func != undefined) {
				if (this.config.use_script_execute_ext) {
					if (this.config.on_start.data != undefined) {
						if (is_array(this.config.on_start.data)) {
							script_execute_ext(this.config.on_start.func, this.config.on_start.data);	
						}
						else this.config.on_start.func(this.config.on_start.data);
					}
					else this.config.on_start.func();
				}
				else this.config.on_start.func(this.config.on_start.data);	
			}
			this.control.did_start = true;	
		}
	};
	static _on_execute_trigger		 = function() {
		/// @func	_on_execute_trigger()
		/// @desc	check if on_execute() should execute, and execute it.
		/// @return NA
		///
		if (this.config.on_execute.func != undefined) {
			if (this.config.use_script_execute_ext) {
				if (this.config.on_execute.data != undefined) {
					if (is_array(this.config.on_execute.data)) {
						script_execute_ext(this.config.on_execute.func, this.config.on_execute.data);	
					}
					else this.config.on_execute.func(this.config.on_execute.data);
				}
				else this.config.on_execute.func();
			}
			else this.config.on_execute.func(this.config.on_execute.data);	
		}
	};
	static _on_end_trigger			 = function() {
		/// @func	_on_end_trigger()
		/// @desc	...
		/// @return NA
		///
		if (this.config.on_end.func != undefined) {
			if (this.config.use_script_execute_ext) {
				if (this.config.on_end.data != undefined) {
					if (is_array(this.config.on_end.data)) {
						script_execute_ext(this.config.on_end.func, this.config.on_end.data);	
					}
					else this.config.on_end.func(this.config.on_end.data);
				}
				else this.config.on_end.func();
			}
			else this.config.on_end.func(this.config.on_end.data);	
		}
	};
	static _on_end_behavior			 = function() {
		/// @func	_on_end_behavior()
		/// @desc	...
		/// @return NA
		///
		switch (this.config.end_behavior) {
			case __AR_ACTION_END.REMOVE_FROM_RUNNER:	
			default: 
				runner.clear_action();
				break;
		};
	};
	
	#endregion
	
	/// Core ///////////////////////////////////////////
	static execute			= function() {
		/// @func	execute()
		/// @desc	execute the action. then check to see if the action
		///			is complete. If complete, run on_end()
		/// @return NA
		///
		_on_start_trigger();
		_execute();
		_on_execute_trigger();
		_check_for_end();
	};
	static wait				= function() {
		/// @func	wait()
		/// @desc	...
		/// @return NA
		///
		_delay();
		_check_for_end();
	};
	static flag_for_removal	= function() {
		/// @func	flag_for_removal()
		/// @desc	...
		/// @return {OrderlyAction} self
		///
		this.control.to_remove = true;
		return self;
	};
		
	/// Getters ////////////////////////////////////////
	static get_actor = function() {
		/// @func	get_actor()
		/// @desc	return the actor/context
		/// @return {struct} actor
		///
		return this.actor;
	};
	
	/// Setters ////////////////////////////////////////
	static set_method				  = function(_actor = get_actor(), _func = this.func, _data = this.data) {
		/// @func	set_method(actor*, func, data)
		/// @param	{struct}		actor
		/// @param	{function}		func  
		/// @param	{any}			data  
		/// @return {OrderlyAction} self
		///
		this.func = _func;
		if (this.config.auto_bind_to_actor) {
			this.func = method(_actor, _func);	
		}
		this.data = _data;
		return self;
	};
	static set_actor				  = function(_actor) {
		/// @func	set_actor(actor)
		/// @param	{struct}		actor
		/// @return {OrderlyAction} self
		///
		this.actor = _actor;
		return self;
	};
	static set_end_condition		  = function(_func, _data) {
		/// @func	set_end_condition(func, data)
		/// @param	{function} func
		/// @param	{any} data
		/// @desc	...
		/// @return {OrderlyAction} self
		///
		this.config.end_condition	   = _func;
		this.config.end_condition_data = _data;
		
		var _actor = get_actor();
		if (this.config.auto_bind_to_actor && _actor != undefined) {
			this.config.end_condition = method(_actor, _func);	
		}
		return self;
	};
	static set_delay				  = function(_delay) {
		/// @func	set_delay(delay)
		/// @param	{real} delay
		/// @desc	...
		/// @return {OrderlyAction} self
		///
		this.control.delay = _delay;
		return self;
	};
	static set_max_iterations		  = function(_iters) {
		/// @func	set_max_iterations(iters)
		/// @param	{real} iters
		/// @desc	the max number of times that the action can execute.
		/// @return {OrderlyAction} self
		///
		this.config.iterations_max = _iters;
		return self;
	};
	static set_end_on_max_iterations  = function(_end) {
		/// @func	set_end_on_max_iterations(end?)
		/// @param	{bool} end?
		/// @desc	if this is true, when the max number of iterations has been exceeded,
		///			the action will complete itself.
		/// @return {OrderlyAction} self
		///
		this.config.end_on_iterations_max = _end;
		return self;
	};
	static set_end_behavior			  = function(_action_end_enum) {
		///	@func	set_end_behavior(action_end_enum)
		/// @param	{enum} action_end_enum
		/// @desc	...
		/// @return {OrderlyAction} self
		///
		this.config.end_behavior = _action_end_enum;
		return self;
	};
	static set_auto_bind_to_actor	  = function(_auto_bind_methods) {
		/// @func	set_auto_bind_to_actor(auto_bind_methods?)
		/// @param	{bool} auto_bind_methods?
		/// @desc	...
		/// @return {OrderlyAction} self
		/// 
		this.config.auto_bind_to_actor = _auto_bind_methods;
		return self;
	};
	static set_use_script_execute_ext = function(_use_script_execute_ext) {
		/// @func	set_use_script_execute_ext(use_script_execute_ext?)
		/// @param	{bool} use_script_execute_ext?
		/// @desc	...
		/// @return {OrderlyAction} self
		/// 
		this.config.use_script_execute_ext = _use_script_execute_ext;
		return self;
	};
	static set_on_start				  = function(_func, _data) {
		/// @func	set_on_start(func, data)
		/// @param	{function} func
		/// @param	{any} data
		/// @desc	function to execute once the action has started.
		/// @return {OrderlyAction} self
		///
		this.config.on_start.func = _func;
		this.config.on_start.data = _data;
		
		var _actor = get_actor();
		if (this.config.auto_bind_to_actor && _actor != undefined) {
			this.config.on_start.func = method(_actor, _func);	
		}
		return self;
	};
	static set_on_execute			  = function(_func, _data) {
		/// @func	set_on_execute(func, data)
		/// @param	{function} func
		/// @param	{any} data
		/// @desc	function to execute once the action has executed. (may execute multiple times).
		/// @return {OrderlyAction} self
		///
		this.config.on_execute.func = _func;
		this.config.on_execute.data = _data;
		
		var _actor = get_actor();
		if (this.config.auto_bind_to_actor && _actor != undefined) {
			this.config.on_execute.func = method(_actor, _func);	
		}
		return self;
	};
	static set_on_end				  = function(_func, _data) {
		/// @func	set_on_end(func, data)
		/// @param	{function} func
		/// @param	{any} data
		/// @desc	function to execute once the action has completed.
		/// @return {OrderlyAction} self
		///
		this.config.on_end.func = _func;
		this.config.on_end.data = _data;
		
		var _actor = get_actor();
		if (this.config.auto_bind_to_actor && _actor != undefined) {
			this.config.on_end.func = method(_actor, _func);	
		}
		return self;
	};
	static set_config				  = function(_config) {
		/// @func	set_config(config)
		/// @param	{struct}config
		/// @desc	...
		/// @return {OrderlyAction} self
		///
		this.config = _config;
		return self;
	};
		
	/// Checkers ///////////////////////////////////////
	static is_delayed	= function() {
		/// @func	is_delayed()
		/// @desc	...
		/// @return {bool} is_delayed
		///
		return (this.control.delay != -1 && !this.control.did_delay);
	};
	static can_iterate	= function() {
		/// @func	can_iterate()
		/// @desc	...
		/// @return {bool} can_iterate?
		///
		return (((this.config.iterations_max == undefined || this.config.iterations_max <= 0)
			||	 (this.control.iterations < this.config.iterations_max))
		);
	};
	static can_execute	= function() {
		/// @func	can_execute()
		/// @desc	check if the current action is able to be executed from the ActionRunner()
		///			actions where can_execute() == false can still be manually invoked through action.execute()
		/// @return {bool} can_execute?
		///
		return (!is_delayed() 
			&&	 can_iterate()
		);
	};
};
