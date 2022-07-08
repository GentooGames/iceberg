/////////////////////////////////////
// .---. r---. .   . .---. .   . . //
// |  -. r--   | \ |   |   |   | | //
// L---J L---J |   V   |   L---J | //
//////////////////////////////$(º)>//
#region docs, info & configs ////////

#region about ///////////////////////
/*
	written_by:_______gentoo________
	version:__________0.2.1_________
	last_updated:___06/22/2022______
*/
#endregion
#region change log //////////////////

#region version 0.2.*

#region version 0.2.2
/*
	Date: 06/22/2022
		QOL:
			x.	renamed auto_bind_methods to auto_bind_methods_to_self for more explicit naming intention
			x.	a Publisher instance is now required, and no longer optional
*/
#endregion
#region version 0.2.1 (released)
/*
	Date: 06/22/2022
		Feature Additions:			
			x.	abstracted actions and triggers. previously, a few set contexts existed in which the action/triggers were defined.
				these included for example: "hover_action_add()" "hover_trigger_add()"; however, this functionality does not need
				to be context sensitive and specific to the hover action. instead, we can generalize a simple action/trigger binding
				that can be defined however desired.
			x.	ability to have triggers send data to the corresponding action, through the method: action_send_payload(). as a result
				actions can now take a data parameter, and if action_send_payload() is invoked inside of the trigger method, then the
				action will have that value passed in as its parameter.
			x.	added events with PubSub support. see events methods.
			x.	new methods for interacting with previously defined configs:
					x.	config_set_value(config_name, value_name, value);
					x.	config_get_value(config_name, value_name);
					x.	config_remove_value(config_name, value_name);
		QOL:
			x.	refactored and restuctured actions, triggers, and states
			x.	abstracted actions, triggers, and states into new GentuiUtilMethod() classes, so that each of these objects are 
				encapsulated in a way that is easier to manage/interact with.
*/
#endregion
#region version 0.2.0 (released)
/*
	Date: 06/15/2022
		Bug Fixes:
			x.	fixed bug where state_execute_on_enter was executing on_exit, and state_execute_on_exit was executing on_enter
		
		Feature Additions:
			x.	added "active" flag for entire component that can now be toggled to enable/disable update() and render() entirely
			x.	added custom configurations that can be used for quick style toggling  
			x.	state machine will now check for configs with matching names if no config_override or config_binding is established. 
				this can be disabled by setting state_on_change_sync_config to false.
		
		QOL:
			x.	added method descriptions for Ui() base component class
			x.	reformatted state_set_current() & config_set_current() to match more appropriate levels of abstraction, especially
				when compared to it's corollary methods state_change() & config_change(), such that the two different methods are 
				operating on not-so-similar functionalities.
			x.	no-longer need to override properties_update() as properties will now automatically update if a getter/setter method
				exists with the proper naming convention.
					<property_name> : set_<property_name>() get_<property_name>
					e.g. :	text = property_add(...);	// this will now automatically update if the following methods have been declared
							set_text();
							get_text();
							
							interpolation = property_add(...);
							set_interpolation();
							get_interpolation();
							
			x. set use_gui_space default to true
			
		Property/Method Name Changes:
			x.	renamed step() method to update() method to remove implied context sensitivity
			x.	renamed draw() method to render() method to remove implied context sensitivity
			x.	renamed set_execute_on_enter() methods to set_state_execute_on_enter()
			x.	renamed set_execute_on_exit() methods to set_state_execute_on_exit()
			x.	renamed hover_*() methods to hover_execute_*() 
					- let's normalize the "leave" keyword, and use "exit" instead, and will use this for all similarly named methods
			x.	renamed hover_leave_add_*() methods to hover_exit_add_*()
			x.	renamed click_*() methods to click_execute_*()
			x.	renamed set_propegate_*() methods to set_pin_propegate_*()
			x.	renamed propegate_*() to propagate_*() fixing spelling error
			x.	renamed auto_bind to auto_bind_methods_to_self
			x.	renamed pin_propagate_pos to pin_propagate_pos_to_child
			x.	renamed pin_propagate_scale	to pin_propagate_scale_to_child
			x.	renamed pin_propagate_alpha	to pin_propagate_alpha_to_child
		
		Pull Requests:
			x.	merged in fryman's pull request updating return values for state_execute_* methods
*/
#endregion

#endregion
#region version 0.1.*

#region version 0.1.1 (released)
/*	
	Date: 05/26/2022
	1. components now propagate their alpha values down to pinned children components
	2. global config macros to toggle property propegation
	3. components now implement local property instantiations of the following global default macros:
		- execute_on_enter
		- execute_on_exit
		- propagate_pos_to_child
		- propagate_scale_to_child
		- propagate_alpha_to_child
	4. created public getter and setter methods to interact with new local propeties listed in 3.
	5. draw_rectangle_width_color removed from global scope and integrated into base Ui() component.
*/
#endregion
#region version 0.1.0 (released)
/*	
	Date: 05/24/2022
	1. FINISHED FIRST ITERATION! WOO!
*/
#endregion

#endregion

#endregion
#region docs & help /////////////////

#region definitions

#endregion

#endregion
#region bugs ////////////////////////
/*
	
*/
#endregion
#region upcoming features ///////////
/*		
	- integrate custom actions and triggers into pubsub. should broadcast events, at least the triggers
	- consider removeing action callbacks entirely? in favor of pubsub?
	- NEW COMPONENT: added UiCircle() implementing draw_circle_curve() functionality
	- NEW COMPONENT: added UiArc() implementing draw_circle_curve() functionality
	- NEW COMPONENT: added UiTextbox() 
	- add sprite support to panels
	- add dithering effects to components
	- add support for UI components to render contents to a surface
		- only update surface contents when necessary, and bake children surfaces onto parent
	- setup component angle support
		- propagate parent angle to children components
		- have mouse click detection and interactions respond to different angles
	- replace properties with FluidProperty(); however, do not create a dependency to that system, instead, re-implement the basic functionality 
		- this will allow our new values to have lerp and spring motion
		- setup configs so that they can lerp to their newly assigned property values
	- ability to have parent components implement child components' update() and render() methods automatically
		- additionally, setup corresponding depth system for custom depth sorting if automatic updates and renders are used
	- improve performance with draw_rectangle_alt, draw_line_alt utilizing one pixel sprite
		- dynamically generate one pixel sprite using surface, sprite_save, etc
	- docs & help
*/
#endregion
#region default config values ///////

#macro __GENTUI_DEFAULT_CONFIG_NAME_START	  "__start__"
#macro __GENTUI_DEFAULT_CONFIG_NAME_DEFAULT   "__default__"
#macro __GENTUI_DEFAULT_UPDATE_TRIGGER_NAME   "__default__"
#macro __GENTUI_DEFAULT_UPDATE_TRIGGER_METHOD function() { return true; }
#macro __GENTUI_DEFAULT_RENDER_TRIGGER_NAME   "__default__"
#macro __GENTUI_DEFAULT_RENDER_TRIGGER_METHOD function() { return true; }

#macro __GENTUI_PUBLISHER	Publisher	// <-- this system utilizes a PubSub design pattern. you can replace
										// the existing implementation with a custom implementation by first
										// changing this class reference, and then updating the Events methods.
										// if you decide to intended publisher, make sure to have the following
										// asset included in your project: https://xdstudios.itch.io/xpublisher

#endregion

#endregion
#region Gentui Util Classes /////////

function GentuiState(_config) constructor {
	/// @func	GentuiState(config)
	/// @param	{struct} conig
	/// @return {GentuiState} self
	///
	__owner	   = _config[$ "owner"	 ] ?? other;
	__active   = _config[$ "active"  ] ?? true;
	__name	   = _config[$ "name"    ] ?? undefined;
	__on_enter = _config[$ "on_enter"] ?? undefined;
	__on_loop  = _config[$ "on_loop" ] ?? undefined;
	__on_exit  = _config[$ "on_exit" ] ?? undefined;
	__config   = _config[$ "config"  ] ?? undefined;	// string pointer to associated config
	
	/// Core ///////////////////////////////////
	static update			= function() {
		/// @func	update()
		/// @return {GentuiState} self
		///
		return execute_on_loop();
	};	
	static execute_on_enter = function() {
		/// @func	execute_on_enter()
		/// @return {any} on_enter_return
		///
		if (has_on_enter()) {
			return __on_enter();
		}
		return undefined;
	};
	static execute_on_loop  = function() {
		/// @func	execute_on_loop()
		/// @return {any} execute_on_loop
		///
		if (has_on_loop()) {
			return __on_loop();
		}
		return undefined;
	};
	static execute_on_exit  = function() {
		/// @func	execute_on_exit()
		/// @return {any} on_exit_return
		///
		if (has_on_exit()) {
			return __on_exit();
		}
		return undefined;
	};
	
	/// Getters ////////////////////////////////
	static get_active      = function() {
		/// @func	get_active()
		/// @return {boolean} active?
		///
		return __active;
	};
	static get_name		   = function() {
		/// @func	get_name()
		/// @return {string} name
		///
		return __name;
	};
	static get_on_enter	   = function() {
		/// @func	get_on_enter()
		/// @return {method} on_enter
		///
		return __on_enter;
	};
	static get_on_loop	   = function() {
		/// @func	get_on_loop()
		/// @return {method} on_loop
		///
		return __on_loop;
	};
	static get_on_exit	   = function() {
		/// @func	get_on_exit()
		/// @return {method} on_exit
		///
		return __on_exit;
	};
	static get_config_bind = function() {
		/// @func	get_config_bind()
		/// @return {string} config_name
		///
		return __config;
	};
	
	/// Setters ////////////////////////////////
	static set_active	   = function(_active) {
		/// @func	set_active(active)
		/// @param	{boolean} active?
		/// @return {GentuiState} self
		///
		__active = _active;
		return self;
	};
	static set_name		   = function(_name) {
		/// @func	set_name(name)
		/// @param	{string} name
		/// @return {GentuiState} self
		///
		__name = _name;
		return self;
	};
	static set_on_enter	   = function(_on_enter) {
		/// @func	set_on_enter(on_enter)
		/// @param	{method}	  on_enter
		/// @return {GentuiState} self
		///
		__on_enter = _on_enter;
		return self;
	};
	static set_on_loop	   = function(_on_loop) {
		/// @func	set_on_enter(on_loop)
		/// @param	{method}	  on_loop
		/// @return {GentuiState} self
		///
		__on_loop = _on_loop;
		return self;
	};
	static set_on_exit	   = function(_on_exit) {
		/// @func	set_on_enter(on_exit)
		/// @param	{method}	  on_exit
		/// @return {GentuiState} self
		///
		__on_exit = _on_exit;
		return self;
	};
	static set_config_bind = function(_config_name) {
		/// @func	set_config_bind(config_name)
		/// @param	{string} config_name
		/// @return	{GentuiState} self
		///
		__config = _config_name;
		return self;
	};
		
	/// Checkers ///////////////////////////////
	static has_on_enter	= function() {
		/// @func	has_on_enter()
		/// @return	{boolean} has_on_enter?
		///
		return get_on_enter() != undefined;
	};
	static has_on_loop  = function() {
		/// @func	has_on_loop()
		/// @return	{boolean} has_on_loop?
		///
		return get_on_loop() != undefined;
	};
	static has_on_exit  = function() {
		/// @func	has_on_exit()
		/// @return	{boolean} has_on_exit?
		///
		return get_on_exit() != undefined;
	};
};

#endregion

function Ui(_config_name = __GENTUI_DEFAULT_CONFIG_NAME_START, _config = {}) constructor {
	/// @func  Ui(config_name*, config*)
	/// @desc  this is the base ui component, containing all core features and functionality that is inherited and implemented
	///		   by all other ui components. an instance of this class will have no visual representation, but can still be utilized
	///		   for creating more "abstract" data containers. see UiLine().add_point() for an example, where a "point" is created
	///		   by instantiating a new Ui() class instance, and passing in x & y values for later reference.
	/// @use   generally this class will be implemented through inheritance of the other Ui components; however, if you wish to implement
	///		   an explicit instance of this class, you can do so using the following: 
	///		   var _abstractUiPointContainer = new Ui({x : _x, y: _y});		/// creates an abstract component containing coordinate points
	/// @param {real}	x*
	/// @param {real}	y*
	/// @param {color}	color*
	/// @param {real}	alpha*
	/// @param {real}	angle*
	/// @param {real}	scale*
	/// @param {real}	xscale*
	/// @param {real}	yscale*
	/// @param {real}	width*
	/// @param {real}	height*
	/// @param {bool}	visible*
	/// @param {real}	thickness*
	/// @param {real}	input_device*
	/// @param {bool}	use_gui_space*
	/// @param {bool}	state_execute_on_enter*
	/// @param {bool}	state_execute_on_exit*
	/// @param {bool}	propagate_position_to_child*
	/// @param {bool}	propagate_scale_to_child*
	/// @param {bool}	propagate_alpha_to_child*
	///
	__owner = other;
	__this  = {			/// <-- change default starting values here
		__default: {	/// <-- change default starting values here
			active:							true,
			x:								0,
			y:								0,
			color:							c_white,
			alpha:							1.0,
			angle:							0,
			scale:							1,
			xscale:							1,
			yscale:							1,
			width:							0,
			height:							0,
			visible:					    true,
			thickness:						1,
			input_device:				    0,
			use_gui_space:					true,
			auto_bind_methods_to_self:				true,
			state_execute_on_enter:			true,
			state_execute_on_exit:			true,
			state_on_change_sync_config:	true,
			pin_propagate_pos_to_child:		true,
			pin_propagate_scale_to_child:	true,
			pin_propagate_alpha_to_child:	false,	
		},
		__actions: {
			__active: true,
			__update: {
				__active:  true,
				__count:   0,
				__names:   [],
				__actions: {},
			},
			__render: {
				__active:  true,
				__count:   0,
				__names:   [],
				__actions: {},
			},
			__custom: {
				__active:  true,
				__count:   0,
				__names:   [],
				__actions: {},
			},
		},
		__states:  {
			__active:  true,
			__count:   0,
			__names:   [],
			__current: {
				__state: undefined,
				__name:  "",
			},	
			__states:  {},
		},
		__config:  {
			__current:		undefined,	/// current config struct pointer
			__configs:		{},			/// all stored configs keyed out by config_name
			__properties:	{},			/// stored properties for dynamic updating
			__name:			"",			/// current config name
			__name_start:	__GENTUI_DEFAULT_CONFIG_NAME_START,
			__name_default:	__GENTUI_DEFAULT_CONFIG_NAME_DEFAULT,
		},
		__pin:	   {
			__pins:	  [],
			__size:	  0,
			__parent: undefined,
			__xoff:	  0,
			__yoff:	  0,
		},
	};	
	__config_init(_config_name, _config);
	
	#region Core ///////////////////////////
	
	static update	  = function() {
		/// @func	update()
		/// @desc	tick update for the component class. call this in a step event, or
		///			wherever the code for this component class should be updated.
		/// @return	{Ui} self
		///
		if (get_active()) {
			states_update();
			actions_update_update();
			actions_custom_update();
		}
		return self;
	};
	static render	  = function() {
		/// @func	render()
		/// @desc	tick update for the component class rendering. call this in a draw 
		///			event, or wherever the code for this component class should be rendered.
		/// @return	{Ui} self
		///
		if (get_active()) {
			actions_render_update();
		}
		return self;
	};	
	static show		  = function() {
		/// @func	show()
		/// @desc	toggle the visibility of component to visible
		/// @return {Ui} self
		///
		set_visible(true);
		event_publish("show_toggled");
		return self;
	};
	static hide		  = function() {
		/// @func	hide()
		/// @desc	toggle the visibility of component to hidden
		/// @return {Ui} self
		///
		set_visible(false);
		event_publish("hide_toggled");
		return self;
	};
	static activate   = function() {
		/// @func	activate()
		/// @desc	set active to true
		/// @return {Ui} self
		///
		set_active(true);
		event_publish("activated");
		return self;
	};
	static deactivate = function() {
		/// @func	deactivate()
		/// @desc	set active to false
		/// @return {Ui} self
		///
		set_active(false);
		event_publish("deactivated");
		return self;
	};
	
	#endregion
	#region Getters & Setters //////////////
	
	#region Getters //////////////////////// 
	
	static get_owner						= function() {
		/// @func	get_owner()
		/// @return {instance/struct} owner
		///
		return __owner;
	};
	static get_active						= function() {
		/// @func	get_active()
		/// @return {instance/struct} owner
		///
		return __active;
	};
	static get_x							= function() {
		/// @func	get_x()
		/// @return {real} x
		///
		with (__this.__pin) {
			if (__parent != undefined && other.__pin_propagate_pos_to_child) {
				return __parent.get_x() - (__xoff * __parent.get_xscale());	// apply parent scale to position offset
			}
		}
		return __x;	
	};
	static get_y							= function() {
		/// @func	get_y()
		/// @return {real} y
		///
		with (__this.__pin) {
			if (__parent != undefined && other.__pin_propagate_pos_to_child) {
				return __parent.get_y() - (__yoff * __parent.get_yscale());	// apply parent scale to position offset
			}
		}
		return __y;	
	};
	static get_width						= function() {	/// @OVERRIDE
		/// @func	get_width()
		/// @return {real} width
		///
		return __width * get_xscale();
	};
	static get_height						= function() {	/// @OVERRIDE
		/// @func	get_height()
		/// @return {real} height
		///
		return __height * get_yscale();
	};
	static get_right						= function() {	/// @OVERRIDE
		/// @func	get_right()
		/// @return {x} right
		///
		return get_x() + get_width();
	};
	static get_left							= function() {	/// @OVERRIDE
		/// @func	get_left()
		/// @return {x} left
		///
		return get_x();
	};
	static get_top							= function() {	/// @OVERRIDE
		/// @func	get_top()
		/// @return {y} top
		///
		return get_y();
	};
	static get_bottom						= function() {	/// @OVERRIDE
		/// @func	get_bottom()
		/// @return {y} bottom
		///
		return get_y() + get_height();
	};
	static get_center_x						= function() {	/// @OVERRIDE
		/// @func	get_center_x()
		/// @return {x} center
		///
		return get_x() + (get_width() * 0.5);
	};
	static get_center_y						= function() {	/// @OVERRIDE
		/// @func	get_center_y()
		/// @return {y} center
		///
		return get_y() + (get_height() * 0.5);
	};
	static get_color						= function() {
		/// @func	get_color()
		/// @return {real} color
		///
		return __color;
	};
	static get_alpha						= function() {
		/// @func	get_alpha()
		/// @return {real} alpha
		///
		var _parent_alpha = 1;
		if (__this.__pin.__parent != undefined && __pin_propagate_alpha_to_child) {
			_parent_alpha = __this.__pin.__parent.get_alpha();
		}
		return __alpha * _parent_alpha;
	};
	static get_angle						= function() {
		/// @func	get_angle()
		/// @return {real} angle
		///
		return __angle;
	};
	static get_xscale						= function() {
		/// @func	get_xscale()
		/// @return {real} xscale
		///
		return __xscale * get_scale();
	};
	static get_yscale						= function() {
		/// @func	get_yscale()
		/// @return {real} yscale
		///
		return __yscale * get_scale();
	};
	static get_scale						= function() {
		/// @func	get_scale()
		/// @return {real} scale
		///
		var _parent_scale = 1;
		if (__this.__pin.__parent != undefined && __pin_propagate_scale_to_child) {
			_parent_scale = __this.__pin.__parent.get_scale();
		}
		return __scale * _parent_scale;
	};
	static get_visible						= function() {
		/// @func	get_visible()
		/// @return {boolean} visible
		///
		return __visible;
	};
	static get_thickness					= function() {
		/// @func	get_thickness()
		/// @return {real} thickness
		///
		return __thickness * get_scale();
	};
	static get_input_device					= function() {
		/// @func	get_input_device()
		/// @desc	input device registered for use with device_mouse_x_...
		/// @return {real} input_device
		///
		return __input_device;
	};
	static get_use_gui_space				= function() {
		/// @func	get_use_gui_space()
		/// @desc	if toggled to true, component will be rendered on gui_space and look for mouse interactions
		///			with coordinates based off of the gui_space positioning
		/// @return {bool} use_gui_space?
		///
		return __use_gui_space;
	};
	static get_mouse_xy						= function() {
		/// @func	get_mouse_xy()
		/// @return {struct} mouse_xy
		///
		var _input_device = get_input_device();
		if (get_use_gui_space()) {
			return {
				x: device_mouse_x_to_gui(_input_device),
				y: device_mouse_y_to_gui(_input_device),
			};
		}
		else {
			return {
				x: device_mouse_x(_input_device),
				y: device_mouse_y(_input_device),
			};
		}
	};
	static get_state_execute_on_enter		= function() {
		/// @func	get_state_execute_on_enter()
		/// @return {boolean} state_execute_on_enter?
		///
		return __state_execute_on_enter;
	};
	static get_state_execute_on_exit		= function() {
		/// @func	get_execute_on_exit()
		/// @return {boolean} state_execute_on_exit?
		///
		return __state_execute_on_exit;
	};
	static get_pin_propagate_pos_to_child	= function() {
		/// @func	get_pin_propagate_pos_to_child()
		/// @desc	if propagate_pos toggled to true, the position properties will be sent down to
		///			pinned children and used for their sub-positioning, so that elements stick together
		/// @return {boolean} propagate_position_to_child?
		///
		return __pin_propagate_pos_to_child;
	};
	static get_pin_propagate_scale_to_child	= function() {
		/// @func	get_pin_propagate_scale_to_child()
		/// @desc	if propagate_scale toggled to true, the scale properties will be sent down to pinned
		///			children and used for their scaling and positioning, so that elements stick/scale together
		/// @return {boolean} propagate_scale_to_child?
		///
		return __pin_propagate_scale_to_child;
	};
	static get_pin_propagate_alpha_to_child	= function() {
		/// @func	get_pin_propagate_alpha_to_child()
		/// @desc	if propagate_alpha toggled to true, the alpha properties will be sent down to pinned
		///			children and used for their alpha, so that elements blend/fade together
		/// @return {boolean} propagate_alpha_to_child?
		///
		return __pin_propagate_alpha_to_child;
	};
		
	#endregion
	#region Setters ////////////////////////
		
	static set_owner						= function(_owner) {
		/// @func	set_owner(owner)
		/// @param	{instance/struct} owner
		/// @return {Ui} self
		///
		__owner = _owner;
		return self;
	};
	static set_active						= function(_active) {
		/// @func	set_active(active)
		/// @param	{boolean} active
		/// @return {Ui} self
		///
		__active = _active;
		return self;
	};
	static set_x							= function(_x) {
		/// @func	set_x(x)
		/// @param	{real} x
		/// @return {Ui} self
		///
		__x = _x;
		return self;
	};
	static set_y							= function(_y) {
		/// @func	set_y(y)
		/// @param	{real} y
		/// @return {Ui} self
		///
		__y = _y;
		return self;
	};
	static set_pos							= function(_x, _y) {
		/// @func	set_pos(x, y)
		/// @param	{real} x
		/// @param	{real} y
		/// @return {Ui} self
		///
		set_x(_x);
		set_y(_y);
		return self;
	};
	static set_width						= function(_width) {
		/// @func	set_width(width)
		/// @param	{real} width
		/// @return {Ui} self
		///
		__width = _width;
		return self;
	};
	static set_height						= function(_height) {
		/// @func	set_height(height)
		/// @param	{real} height
		/// @return {Ui} self
		///
		__height = _height;
		return self;
	};
	static set_color						= function(_color) {
		/// @func	set_color(color)
		/// @param	{color} color
		/// @return {Ui} self
		///
		__color = _color;
		return self;
	};
	static set_alpha						= function(_alpha) {
		/// @func	set_alpha(alpha)
		/// @param	{real} alpha
		/// @return {Ui} self
		///
		__alpha = _alpha;
		return self;
	};
	static set_angle						= function(_angle) {
		/// @func	set_angle(angle)
		/// @param	{real} angle
		/// @return {Ui} self
		///
		__angle = _angle;
		return self;
	};
	static set_xscale						= function(_xscale) {
		/// @func	set_xscale(xscale)
		/// @param	{real} xscale
		/// @return {Ui} self
		///
		__xscale = _xscale;
		return self;
	};
	static set_yscale						= function(_yscale) {
		/// @func	set_yscale(yscale)
		/// @param	{real} yscale
		/// @return {Ui} self
		///
		__yscale = _yscale;
		return self;
	};
	static set_scale						= function(_scale) {
		/// @func	set_scale(scale)
		/// @param	{real} scale
		/// @return {Ui} self
		///
		__scale = _scale;
		return self;
	};
	static set_visible						= function(_visible) {
		/// @func	set_visible(visible)
		/// @param	{boolean} visible?
		/// @return {Ui} self
		///
		__visible = _visible;
		return self;
	};
	static set_thickness					= function(_thickness) {
		/// @func	set_thickness(thickness)
		/// @param	{real} thickness
		/// @return {Ui} self
		///
		__thickness = _thickness;
		return self;
	};
	static set_input_device					= function(_device) {
		/// @func	set_input_device(interact_action)
		/// @param	{real}		   device
		/// @return {UiInteractor} self
		///
		__input_device = _device;
		return self;
	};
	static set_use_gui_space				= function(_use_gui_space) {
		/// @func	set_use_gui_space(use_gui_space?)
		/// @param	{boolean}	   use_gui_space?
		/// @return {UiInteractor} self
		///
		__use_gui_space = _use_gui_space;
		return self;
	};
	static set_state_execute_on_enter		= function(_state_execute_on_enter) {
		/// @func	set_state_execute_on_enter(state_execute_on_enter?)
		/// @desc	whether or not the defined on_enter state function should execute whenever
		///			transitioning into a new state.
		/// @param	{boolean}	   state_execute_on_enter?
		/// @return {UiInteractor} self
		///
		__state_execute_on_enter = _state_execute_on_enter;
		return self;
	};
	static set_state_execute_on_exit		= function(_state_execute_on_exit) {
		/// @func	set_state_execute_on_exit(state_execute_on_exit?)
		/// @desc	whether or not the defined on_exit state function should execute whenever
		///			transitioning out of the current state.
		/// @param	{boolean}	   state_execute_on_exit?
		/// @return {UiInteractor} self
		///
		__state_execute_on_exit = _state_execute_on_exit;
		return self;
	};
	static set_pin_propagate_pos_to_child	= function(_pin_propagate_pos_to_child) {
		/// @func	set_pin_propagate_pos_to_child(pin_propagate_pos_to_child?)
		/// @param	{boolean}	   pin_propagate_pos_to_child?
		/// @return {UiInteractor} self
		///
		__pin_propagate_pos_to_child = _pin_propagate_pos_to_child;
		return self;
	};
	static set_pin_propagate_scale_to_child	= function(_pin_propagate_scale_to_child) {
		/// @func	set_pin_propagate_scale(pin_propagate_scale_to_child?)
		/// @param	{boolean}	   pin_propagate_scale_to_child?
		/// @return {UiInteractor} self
		///
		__pin_propagate_scale_to_child = _pin_propagate_scale_to_child;
		return self;
	};
	static set_pin_propagate_alpha_to_child	= function(_pin_propagate_alpha_to_child) {
		/// @func	set_pin_propagate_alpha(pin_propagate_alpha_to_child?)
		/// @param	{boolean}	   pin_propagate_alpha_to_child?
		/// @return {UiInteractor} self
		///
		__pin_propagate_alpha_to_child = _pin_propagate_alpha_to_child;
		return self;
	};
			
	#endregion
	#region Defaults ///////////////////////
	
	static default_set = function(_property_name, _property_default_value) {
		/// @func	default_set(property_name, property_default_value)
		/// @param	{string} property_name
		/// @param	{any}	 property_default_value
		/// @return {Ui}	 self
		///
		__this.__default[$ _property_name] = _property_default_value;
		return self;
	};
	static default_get = function(_property_name) {
		/// @func	default_get(property_name)
		/// @param	{string} property_name
		/// @return {any}	 property_default_value
		///
		return __this.__default[$ _property_name];
	};
		
	static default_get_auto_bind_methods_to_self		   = function() {
		/// @func	default_get_auto_bind_methods_to_self()
		/// @return {boolean} auto_bind_methods_to_self?
		///
		return default_get("auto_bind_methods_to_self");
	};
	static default_get_state_on_change_sync_config = function() {
		/// @func	default_get_state_on_change_sync_config()
		/// @return {boolean} sync_config_on_state_change?
		///
		return default_get("state_on_change_sync_config");
	};
	
	#endregion
	
	#endregion
	#region Actions ////////////////////////
	
	#region Action Method Abstractions /////
	
	/// Action: Core
	static __actions_update	= function(_action_context) {
		/// @func	__actions_update(action_context)
		/// @param	{struct} action_context
		/// @return {Ui} self
		///
		with (_action_context) {
			if (__active) {
				for (var _i = 0; _i < __count; _i++) {
					var _name   = __names[_i];
					var _action	= __actions[$ _name];
					_action.update();
				}
			}
		}
		return self;
	};
	static __action_add		= function(_action_context, _action_name, _action_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	__action_add(action_context, action_name, action_method, bind_to_self?*)
		/// @param	{struct}  action_context
		/// @param	{string}  action_name 
		/// @param	{method}  action_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		if (_bind_to_self) {
			_action_method = method(self, _action_method);	
		}
			
		var _component = self;
		with (_action_context) {
			__actions[$ _action_name] = new Action({
				owner:  _component,
				name:   _action_name,
				method: _action_method,
			});
			array_push(__names, _action_name);
			__count++;
		}
		return self;
	};
	static __action_get		= function(_action_context, _action_name) {
		/// @func	__action_get(action_name)
		/// @param	{struct}  action_context
		/// @param	{string} action_name
		/// @return {Action} action
		///
		with (_action_context) {
			return __actions[$ _action_name];
		}
	};
	static __action_exists	= function(_action_context, _action_name) {
		/// @func	__action_exists(action_context, action_name)
		/// @param	{struct}  action_context
		/// @param	{string}  action_name
		/// @return {boolean} action_exists?
		/// 
		return __action_get(_action_context, _action_name) != undefined;
	};
	static __action_destroy	= function(_action_context, _action_name) {
		/// @func	__action_destroy(action_context, action_name)
		/// @param	{struct} action_context
		/// @param	{string} action_name
		/// @return {Ui} self
		///
		if (__action_exists(_action_context, _action_name)) {
			with (_action_context) {
				variable_struct_remove(__actions, _action_name);
				
				/// array_find_delete();
				for (var _i = array_length(__names) - 1; _i >= 0; _i--) {
					if (__names[_i] == _action_name) {
						array_delete(__names, _i, 1);
						break;
					}
				}
				__count--;
			}
		}
		return self;
	};
	
	/// Action: Getters & Setters
	static __action_get_active = function(_action_context, _action_name) {	
		/// @func	__action_get_active(action_name)
		/// @param	{struct} action_context
		/// @return {string} action_name
		///
		if (__action_exists(_action_context, _action_name)) {
			return __action_get(_action_context, _action_name).get_active();
		}
		return false;
	};
	static __action_get_method = function(_action_context, _action_name) {
		/// @func	__action_get_method(action_name)
		/// @param	{struct} action_context
		/// @param	{string} action_name
		/// @return {UiAction} action
		/// 
		if (__action_exists(_action_context, _action_name)) {
			return __action_get(_action_context, _action_name).get_method();
		}
		return undefined;
	};
	static __action_set_active = function(_action_context, _action_name, _active) {
		/// @func	__action_set_active(action_name, active)
		/// @param	{struct} action_context
		/// @param	{string}  action_name
		/// @param	{boolean} active?
		/// @return {Ui} self
		///
		if (__action_exists(_action_context, _action_name)) {
			__action_get(_action_context, _action_name).set_active(_active);
		}
		return self;
	};
	static __action_set_name   = function(_action_context, _action_name, _new_name) {
		/// @func	__action_set_name(action_name, new_name)
		/// @param	{struct} action_context
		/// @param	{string} action_name
		/// @param	{string} new_name
		/// @return {Ui} self
		/// 
		if (__action_exists(_action_context, _action_name)) {
			__action_get(_action_context, _action_name).set_name(_new_name);
		}
		return self;
	};
	static __action_set_method = function(_action_context, _action_name, _action_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	__action_set_method(action_name, action_method, bind_to_self?*)
		/// @param	{struct}  action_context
		/// @param	{string}  action_name 
		/// @param	{method}  action_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		if (__action_exists(_action_context, _action_name)) {
			if (_bind_to_self) {
				_action_method = method(self, _action_method);	
			}
			__action_get(_action_context, _action_name).set_method(_action_method);
		}
		return self;
	}
	
	/// Action Triggers
	static __action_add_trigger		 = function(_action_context, _action_name, _trigger_name, _trigger_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	__action_add_trigger(action_name, trigger_name, trigger_method, bind_to_self?*)
		/// @param	{struct}  action_context
		/// @param	{string}  action_name
		/// @param	{string}  trigger_name
		/// @param	{method}  trigger_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		if (__action_exists(_action_context, _action_name)) {
			if (_bind_to_self) {
				_trigger_method = method(self, _trigger_method);
			}
			__action_get(_action_context, _action_name).add_trigger(_trigger_name, _trigger_method);
		}
		return self;
	};
	static __action_get_trigger		 = function(_action_context, _action_name, _trigger_name) {
		/// @func	__action_get_trigger(action_name, trigger_name)
		/// @param	{struct} action_context
		/// @param	{string} action_name
		/// @param	{string} trigger_name
		/// @return {Trigger} trigger
		///
		if (__action_exists(_action_context, _action_name)) {
			return __action_get(_action_context, _action_name).get_trigger(_trigger_name);
		}
		return undefined;
	};
	static __action_has_trigger		 = function(_action_context, _action_name, _trigger_name) {
		/// @func	__action_has_trigger(action_name, trigger_name)
		/// @param	{struct}  action_context
		/// @param	{string}  action_name
		/// @param	{string}  trigger_name
		/// @return {boolean} trigger_exists?
		///
		if (__action_exists(_action_context, _action_name)) {
			return __action_get(_action_context, _action_name).has_trigger(_trigger_name);	
		}
		return false;
	};
	static __action_destroy_trigger	 = function(_action_context, _action_name, _trigger_name) {
		/// @func	__action_destroy_trigger(action_name, trigger_name)
		/// @param	{struct} action_context
		/// @param	{string} action_name
		/// @param	{string} trigger_name
		/// @return {Ui} self
		///
		if (__action_exists(_action_context, _action_name)) {
			__action_get(_action_context, _action_name).destroy_trigger(_trigger_name);
		}
		return self;
	};
	static __action_destroy_triggers = function(_action_context, _action_name) {
		/// @func	__action_destroy_triggers(action_name)
		/// @param	{struct} action_context
		/// @param	{string} action_name
		/// @return {Ui} self
		///
		if (__action_exists(_action_context, _action_name)) {
			__action_get(_action_context, _action_name).destroy_triggers();
		}
		return self;
		
	};
	
	/// Action Triggers: Getters & Setters
	static __action_get_trigger_method  = function(_action_context, _action_name, _trigger_name) {
		/// @func	__action_get_trigger_method(action_name, trigger_name)
		/// @param	{struct}   action_context
		/// @param	{string}   action_name
		/// @param	{string}   trigger_name
		/// @return {UiAction} action_trigger
		///
		if (__action_exists(_action_context, _action_name)) {
			return __action_get(_action_context, _action_name).get_trigger_method(_trigger_name);	
		}
		return undefined;
	};
	static __action_get_trigger_data	= function(_action_context, _action_name, _trigger_name) {
		/// @func	__action_get_trigger_data(action_context, action_name, trigger_name)
		/// @param	{struct}  action_context
		/// @param	{string}  action_name
		/// @param	{string}  trigger_name
		/// @return {boolean} triggers_active?
		///
		if (__action_exists(_action_context, _action_name)) {
			return __action_get(_action_context, _action_name).get_trigger_data(_trigger_name);
		}
		return false;
	};
	static __action_get_trigger_active  = function(_action_context, _action_name, _trigger_name) {
		/// @func	__action_get_trigger_active(action_name, trigger_name)
		/// @param	{struct}  action_context
		/// @param	{string}  action_name
		/// @param	{method}  trigger_name
		/// @return {boolean} active
		///
		if (__action_exists(_action_context, _action_name)) {
			return __action_get(_action_context, _action_name).get_active(_trigger_name);
		}
		return false;
	};
	static __action_get_triggers_active = function(_action_context, _action_name) {
		/// @func	__action_get_triggers_active(action_context, action_name)
		/// @param	{struct}  action_context
		/// @param	{string}  action_name
		/// @return {boolean} triggers_active?
		///
		if (__action_exists(_action_context, _action_name)) {
			return __action_get(_action_context, _action_name).get_triggers_active();
		}
		return false;
	};
	
	static __action_set_trigger_method  = function(_action_context, _action_name, _trigger_name, _trigger_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	__action_set_trigger_method(action_name, trigger_name, trigger_method, bind_to_self?*)
		/// @param	{struct}  action_context
		/// @param	{string}  action_name
		/// @param	{string}  trigger_name
		/// @param	{method}  trigger_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		if (__action_exists(_action_context, _action_name)) {
			if (_bind_to_self) {
				_trigger_method = method(self, _trigger_method);	
			}
			__action_get(_action_context, _action_name).set_trigger_method(_trigger_name, _trigger_method);
		}
		return self;
	};
	static __action_set_trigger_data	= function(_action_context, _action_name, _trigger_name, _trigger_data) {
		/// @func	__action_set_trigger_data(action_context, action_name, trigger_name, trigger_data) 
		/// @param	{struct} action_context
		/// @param	{string} action_name
		/// @param	{string} trigger_name
		/// @param	{any}	 trigger_data
		/// @return {Ui}	 self
		///
		if (__action_exists(_action_context, _action_name)) {
			__action_get(_action_context, _action_name).set_trigger_data(_trigger_name, _trigger_data);
		}
		return self;
	};
	static __action_set_trigger_active  = function(_action_context, _action_name, _trigger_name, _active) {
		/// @func	__action_set_trigger_active(action_name, trigger_name, active)
		/// @param	{struct}  action_context
		/// @param	{string}  action_name
		/// @param	{string}  trigger_name
		/// @param	{boolean} active
		/// @return	{Ui}	  self
		///
		if (__action_exists(_action_context, _action_name)) {
			__action_get(_action_context, _action_name).set_trigger_active(_trigger_name, _active);
		}
		return self;
	};
	static __action_set_triggers_active = function(_action_context, _action_name, _active) {
		/// @func	__action_set_triggers_active(action_context, action_name, active)
		/// @param	{struct}  action_context
		/// @param	{string}  action_name
		/// @param	{boolean} active?
		/// @return {Ui} self
		///
		if (__action_exists(_action_context, _action_name)) {
			__action_get(_action_context, _action_name).set_triggers_active(_active);
		}
		return self;
	};
	
	#endregion
	#region Custom Actions /////////////////
	
	static actions_custom_update = function() {
		/// @func	actions_custom_update()
		/// @return {Ui} self
		///
		return __actions_update(__this.__actions.__custom);
	};
	
	/// Actions Custom: Core
	static action_add	  = function(_action_name, _action_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	action_add(action_name, action_method, bind_to_self?*)
		/// @param	{string}  action_name 
		/// @param	{method}  action_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		return __action_add(__this.__actions.__custom, _action_name, _action_method, _bind_to_self);
	};
	static action_add_ext = function() {}; /// be able to define n trigger bindings?
	static action_get	  = function(_action_name) {
		/// @func	action_get(action_name)
		/// @param	{string} action_name
		/// @return {Action} action
		///
		return __action_get(__this.__actions.__custom, _action_name);
	};
	static action_exists  = function(_action_name) {
		/// @func	action_exists(action_name)
		/// @param	{string}  action_name
		/// @return {boolean} action_exists?
		/// 
		return __action_exists(__this.__actions.__custom, _action_name);
	};
	static action_destroy = function(_action_name) {
		/// @func	action_destroy(action_name)
		/// @param	{string} action_name
		/// @return {Ui} self
		///
		return __action_destroy(__this.__actions.__custom, _action_name);
	};
	
	/// Actions Custom: Getters & Setters
	static action_get_active = function(_action_name) {
		/// @func	action_get_active(action_name)
		/// @param	{string}  action_name
		/// @return {boolean} active?
		///
		return __action_get_active(__this.__actions.__custom, _action_name);
	};
	static action_get_method = function(_action_name) {
		/// @func	action_get_method(action_name)
		/// @param	{string} action_name
		/// @return {method} method
		///
		return __action_get_method(__this.__actions.__custom, _action_name);
	};
	static action_set_active = function(_action_name, _active) {
		/// @func	action_set_active(action_name, active?)
		/// @param	{string}  action_name
		/// @param  {boolean} active?
		/// @return {Ui} self
		///
		return __action_set_active(__this.__actions.__custom, _action_name, _active);
	};
	static action_set_name	 = function(_action_name, _new_name) {
		/// @func	action_set_name(action_name, new_name)
		/// @param	{string} action_name
		/// @param  {string} new_name
		/// @return {Ui} self
		///
		return __action_set_name(__this.__actions.__custom, _action_name, _new_name);
	};
	static action_set_method = function(_action_name, _action_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	action_set_method(action_name, action_method, bind_to_self?*)
		/// @param	{string}  action_name
		/// @param  {method}  action_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		return __action_set_method(__this.__actions.__custom, _action_name, _action_method, _bind_to_self);
	};
		
	/// Action Custom: Triggers Core
	static action_add_trigger	   = function(_action_name, _trigger_name, _trigger_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	action_add_trigger(action_name, trigger_name, trigger_method, bind_to_self?*)
		/// @param	{string}  action_name
		/// @param	{string}  trigger_name
		/// @param	{method}  trigger_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		return __action_add_trigger(__this.__actions.__custom, _action_name, _trigger_name, _trigger_method, _bind_to_self);
	};
	static action_get_trigger	   = function(_action_name, _trigger_name) {
		/// @func	action_get_trigger(action_name, trigger_name)
		/// @param	{string} action_name
		/// @param	{string} trigger_name
		/// @return {Trigger} trigger
		///
		return __action_get_trigger(__this.__actions.__custom, _action_name, _trigger_name);
	};
	static action_has_trigger	   = function(_action_name, _trigger_name) {
		/// @func	action_has_trigger(action_name, trigger_name)
		/// @param	{string}  action_name
		/// @param	{string}  trigger_name
		/// @return {boolean} trigger_exists?
		///
		return __action_has_trigger(__this.__actions.__custom, _trigger_name);
	};
	static action_destroy_trigger  = function(_action_name, _trigger_name) {
		/// @func	action_destroy_trigger(action_name, trigger_name)
		/// @param	{string} action_name
		/// @param	{string} trigger_name
		/// @return {Ui} self
		///
		return __action_destroy_trigger(__this.__actions.__custom, _action_name, _trigger_name);
	};
	static action_destroy_triggers = function(_action_name) {
		/// @func	action_destroy_triggers(action_name)
		/// @param	{string} action_name
		/// @return {Ui} self
		///
		return __action_destroy_triggers(__this.__actions.__custom, _action_name);
	};
	
	/// Action Custom: Triggers Getters & Setters
	static action_get_trigger_method  = function(_action_name, _trigger_name) {
		/// @func	action_get_trigger_method(action_name, trigger_name)
		/// @param	{string}   action_name
		/// @param	{string}   trigger_name
		/// @return {UiAction} action_trigger
		///
		return __action_get_trigger_method(__this.__actions.__custom, _action_name, _trigger_name);
	};
	static action_get_trigger_data	  = function(_action_name, _trigger_name) {
		/// @func	action_get_trigger_data(action_name, trigger_name)
		/// @param	{string}   action_name
		/// @param	{string}   trigger_name
		/// @return {UiAction} action_trigger
		///
		return __action_get_trigger_data(__this.__actions.__custom, _action_name, _trigger_name);
	};
	static action_get_trigger_active  = function(_action_name, _trigger_name) {
		/// @func	action_get_trigger_active(action_name, trigger_name)
		/// @param	{string}  action_name
		/// @param	{method}  trigger_name
		/// @return {boolean} active
		///
		return __action_get_trigger_active(__this.__actions.__custom, _action_name, _trigger_name);
	};
	static action_get_triggers_active = function(_action_name) {
		/// @func	action_get_triggers_active(action_name)
		/// @param	{string}  action_name
		/// @return {boolean} triggers_active?
		///
		return __action_get_triggers_active(__this.__actions.__custom);
	};
	
	static action_set_trigger_method  = function(_action_name, _trigger_name, _trigger_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	action_set_trigger_method(action_name, trigger_name, trigger_method, bind_to_self?*)
		/// @param	{string}  action_name
		/// @param	{string}  trigger_name
		/// @param	{method}  trigger_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		return __action_set_trigger_method(__this.__actions.__custom, _action_name, _trigger_name, _trigger_method, _bind_to_self);
	};
	static action_set_trigger_data	  = function(_action_name, _trigger_name, _trigger_data) {
		/// @func	action_set_trigger_data(action_name, trigger_name, trigger_data) 
		/// @param	{string} action_name
		/// @param	{string} trigger_name
		/// @param	{any}	 trigger_data
		/// @return {Ui}	 self
		///
		return __action_set_trigger_data(__this.__actions.__custom, _action_name, _trigger_name, _trigger_data);
	};
	static action_set_trigger_active  = function(_action_name, _trigger_name, _active) {
		/// @func	action_set_trigger_active(action_name, trigger_name, active)
		/// @param	{string}  action_name
		/// @param	{string}  trigger_name
		/// @param	{boolean} active
		/// @return	{Ui}	  self
		///
		return __action_set_trigger_active(__this.__actions.__custom, _action_name, _trigger_name, _active);
	};
	static action_set_triggers_active = function(_action_name, _active) {
		/// @func	action_get_triggers_active(action_name, active)
		/// @param	{string}  action_name
		/// @param	{boolean} active?
		/// @return {boolean} triggers_active?
		///
		return __action_set_triggers_active(__this.__actions.__custom, _action_name, _active);
	};
	
	/// Action Custom: Triggers Util
	static action_set_trigger_result  = function(_result, _data) {
		/// @func	action_set_trigger_result(result, data)
		///
		other.set_data(_data);
		return _result;
	};
			
	#endregion
	#region Update Actions /////////////////
	
	static actions_update_update = function() {
		/// @func	actions_update_update()
		/// @return {Ui} self
		///
		return __actions_update(__this.__actions.__update);
	};
	
	/// Actions Update: Core
	static action_update_add	 = function(_action_name, _action_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	action_update_add(action_name, action_method, bind_to_self?*)
		/// @param	{string}  action_name 
		/// @param	{method}  action_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		__action_add(__this.__actions.__update, _action_name, _action_method, _bind_to_self);
		__action_add_trigger(__this.__actions.__update, _action_name, __GENTUI_DEFAULT_UPDATE_TRIGGER_NAME, __GENTUI_DEFAULT_UPDATE_TRIGGER_METHOD, true);
		return self;
	};
	static action_update_get	 = function(_action_name) {
		/// @func	action_update_get(action_name)
		/// @param	{string} action_name
		/// @return {Action} action
		///
		return __action_get(__this.__actions.__update);
	};
	static action_update_exists  = function(_action_name) {
		/// @func	action_update_exists(action_name)
		/// @param	{string}  action_name
		/// @return {boolean} action_exists?
		/// 
		return __action_exists(__this.__actions.__update, _action_name);
	};
	static action_update_destroy = function(_action_name) {
		/// @func	action_update_destroy(action_name)
		/// @param	{string} action_name
		/// @return {Ui} self
		///
		return __action_destroy(__this.__actions.__update, _action_name);
	};
	
	/// Actions Update: Getters & Setters
	static action_update_get_active	= function(_action_name) {
		/// @func	action_update_get_active(action_name)
		/// @param	{string}  action_name
		/// @return {boolean} active?
		///
		return __action_get_active(__this.__actions.__update, _action_name);
	};
	static action_update_get_method = function(_action_name) {
		/// @func	action_update_get_method(action_name)
		/// @param	{string} action_name
		/// @return {method} method
		///
		return __action_get_method(__this.__actions.__update, _action_name);
	};
	
	static action_update_set_active	= function(_action_name, _active) {
		/// @func	action_update_set_active(action_name, active?)
		/// @param	{string}  action_name
		/// @param  {boolean} active?
		/// @return {Ui} self
		///
		return __action_set_active(__this.__actions.__update, _action_name, _active);
	};
	static action_update_set_name	= function(_action_name, _new_name) {
		/// @func	action_update_set_name(action_name, new_name)
		/// @param	{string} action_name
		/// @param  {string} new_name
		/// @return {Ui} self
		///
		return __action_set_name(__this.__actions.__update, _action_name, _new_name);
	};
	static action_update_set_method	= function(_action_name, _action_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	action_update_set_method(action_name, action_method, bind_to_self?*)
		/// @param	{string}  action_name
		/// @param  {method}  action_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		return __action_set_method(__this.__actions.__update, _action_name, _action_method, _bind_to_self);
	};
	
	#endregion
	#region Render Actions /////////////////
	
	static actions_render_update = function() {
		/// @func	actions_render_update()
		/// @return {Ui} self
		///
		return __actions_update(__this.__actions.__render);
	};
	
	/// Actions Render: Core
	static action_render_add	 = function(_action_name, _action_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	action_render_add(action_name, action_method, bind_to_self?*)
		/// @param	{string}  action_name 
		/// @param	{method}  action_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		__action_add(__this.__actions.__render, _action_name, _action_method, _bind_to_self);
		__action_add_trigger(__this.__actions.__render, _action_name, __GENTUI_DEFAULT_RENDER_TRIGGER_NAME, __GENTUI_DEFAULT_RENDER_TRIGGER_METHOD, true);
		return self;
	};
	static action_render_get	 = function(_action_name) {
		/// @func	action_render_get(action_name)
		/// @param	{string} action_name
		/// @return {Action} action
		///
		return __action_get(__this.__actions.__render);
	};
	static action_render_exists  = function(_action_name) {
		/// @func	action_render_exists(action_name)
		/// @param	{string}  action_name
		/// @return {boolean} action_exists?
		/// 
		return __action_exists(__this.__actions.__render, _action_name);
	};
	static action_render_destroy = function(_action_name) {
		/// @func	action_render_destroy(action_name)
		/// @param	{string} action_name
		/// @return {Ui} self
		///
		return __action_destroy(__this.__actions.__render, _action_name);
	};
	
	/// Actions Render: Getters & Setters
	static action_render_get_active = function(_action_name) {
		/// @func	action_render_get_active(action_name)
		/// @param	{string}  action_name
		/// @return {boolean} active?
		///
		return __action_get_active(__this.__actions.__render, _action_name);
	};
	static action_render_get_method	= function(_action_name) {
		/// @func	action_render_get_method(action_name)
		/// @param	{string} action_name
		/// @return {method} method
		///
		return __action_get_method(__this.__actions.__render, _action_name);
	};
	
	static action_render_set_active = function(_action_name, _active) {
		/// @func	action_render_set_active(action_name, active?)
		/// @param	{string}  action_name
		/// @param  {boolean} active?
		/// @return {Ui} self
		///
		return __action_set_active(__this.__actions.__render, _action_name, _active);
	};
	static action_render_set_name	= function(_action_name, _new_name) {
		/// @func	action_render_set_name(action_name, new_name)
		/// @param	{string} action_name
		/// @param  {string} new_name
		/// @return {Ui} self
		///
		return __action_set_name(__this.__actions.__render, _action_name, _new_name);
	};
	static action_render_set_method	= function(_action_name, _action_method, _bind_to_self = default_get_auto_bind_methods_to_self()) {
		/// @func	action_render_set_method(action_name, action_method, bind_to_self?*)
		/// @param	{string}  action_name
		/// @param  {method}  action_method
		/// @param	{boolean} bind_to_self?*
		/// @return {Ui} self
		///
		return __action_set_method(__this.__actions.__render, _action_name, _action_method, _bind_to_self);
	};
		
	#endregion
	
	static actions_get_active = function(_active) {
		/// @func	actions_get_active(active)
		/// @return {boolean} active?
		///
		return __this.__actions.__active;
	};
	static actions_set_active = function(_active) {
		/// @func	actions_set_active(active)
		/// @param	{boolean} active?
		/// @return {Ui} self
		///
		__this.__actions.__active = _active;
		return self;
	};
	
	#endregion
	#region State Machine //////////////////

	/// Core ///////////////////////////////
	static states_update	= function() {
		/// @func	states_update()
		/// @return {Ui} self
		///
		if (state_has_current()) {
			state_get_current().update();	
		}
		return self;
	};
	static state_add		= function(_state_name, _state_method, _auto_bind_method = default_get_auto_bind_methods_to_self()) {
		/// @func	state_add(state_name, state_method, auto_bind_methods_to_self?*)
		/// @desc	add a new state_method bound to a given state_name
		/// @param	{string}		  state_name
		/// @param	{method/function} state_method
		/// @param	{boolean}		  auto_bind_methods_to_self?*
		/// @return	{Ui}			  self
		///
		return state_add_ext(_state_name,, _state_method,,, _auto_bind_method);
	};
	static state_add_ext	= function(_state_name, _on_enter_method = undefined, _on_loop_method, _on_exit_method = undefined, _config_name = undefined, _auto_bind_method = default_get_auto_bind_methods_to_self()) {
		/// @func	state_add_ext(state_name, on_enter_method*, on_loop_method, on_exit_method*, config_name*, auto_bind_methods_to_self?*)
		/// @desc	add a new state_method bound to a given state_name
		/// @param	{string}		  state_name
		/// @param	{method/function} on_enter=undefined
		/// @param	{method/function} on_loop
		/// @param	{method/function} on_exit=undefined
		/// @param	{struct}		  config_name=undefined
		/// @param	{boolean}		  auto_bind_methods_to_self?*
		/// @return	{Ui}			  self
		///
		if (_auto_bind_method) {
			if (_on_enter_method != undefined) _on_enter_method = method(self, _on_enter_method);	
			if (_on_loop_method  != undefined) _on_loop_method  = method(self, _on_loop_method);	
			if (_on_exit_method  != undefined) _on_exit_method  = method(self, _on_exit_method);	
		}
		with (__this.__states) {
			__states[$ _state_name] = new GentuiState({
				name:     _state_name,
				on_enter: _on_enter_method,
				on_loop:  _on_loop_method,
				on_exit:  _on_exit_method,
				config:   _config_name,
			});
			array_push(__names, _state_name);
			__count++;
		}
		return self;
	};
	static state_change		= function(_state_name) {
		/// @func	state_change(state_name)
		/// @desc	do state transition if a state exists with the given name.
		/// @param	{string} state_name
		/// @return {Ui}	 self
		///
		return state_change_ext(_state_name);
	};
	static state_change_ext	= function(_state_name, _config = undefined, _sync_config_to_state = default_get_state_on_change_sync_config()) {
		/// @func	state_change_ext(state_name, config*, sync_config_to_state*)
		/// @desc	do state transition if a state exists with the given name.
		/// @param	{string}  state_name
		/// @param	{string}  config=undefined
		/// @param	{boolean} sync_config_to_state?
		/// @return {Ui}	  self
		///
		if (state_exists(_state_name)) {
			state_set_current(_state_name, _config, _sync_config_to_state);
			event_publish("state_changed", _state_name);
		}
		return self;
	};
	
	/// Getters ////////////////////////////
	static state_get			  = function(_state_name) {
		/// @func	state_get(state_name)
		/// @desc	return the method associated to the given state name that would be executed during a state update.
		/// @param	{string}		  state_name
		/// @return {method/function} state
		///
		return __this.__states.__states[$ _state_name];
	};
	static state_get_current	  = function() {
		/// @func	state_get_current()
		/// @desc	get the currently executing state method
		/// @return {method/function} state
		///
		return __this.__states.__current.__state;
	};
	static state_get_current_name = function() {
		/// @func	state_get_current_name()
		/// @desc	get the name of the currently executing state method.
		/// @return {string} name
		///
		return __this.__states.__current.__name;
	};
	static state_get_active		  = function(_state_name) {
		/// @func	state_get_active(state_name)
		/// @param	{string}  state_name
		/// @return {boolean} active?
		///
		if (state_exists(_state_name)) {
			state_get(_state_name).get_active();
		}
		return false;
	};
	static state_get_on_enter	  = function(_state_name) {
		/// @func	state_get_on_enter(state_name)
		/// @param	{string} state_name
		/// @return {method} on_enter
		///
		if (state_exists(_state_name)) {
			state_get(_state_name).get_on_enter();
		}
		return false;
	};
	static state_get_on_loop	  = function(_state_name) {
		/// @func	state_get_on_loop(state_name)
		/// @param	{string} state_name
		/// @return {method} on_loop
		///
		if (state_exists(_state_name)) {
			state_get(_state_name).get_on_loop();
		}
		return false;
	};
	static state_get_on_exit	  = function(_state_name) {
		/// @func	state_get_on_exit(state_name)
		/// @param	{string} state_name
		/// @return {method} on_exit
		///
		if (state_exists(_state_name)) {
			state_get(_state_name).get_on_exit();
		}
		return false;
	};
	static state_get_config_bind  = function(_state_name) {
		/// @func	state_get_config_bind(state_name)
		/// @param	{string} state_name
		/// @return {string} config_name
		///
		if (state_exists(_state_name)) {
			state_get(_state_name).get_config_bind();
		}
		return false;
	};
	
	/// Setters ////////////////////////////
	static state_set_current	 = function(_state_name, _config_override = undefined, _state_on_change_sync_config = default_get_state_on_change_sync_config()) {
		/// @func	state_set_current(state_name, state_method, config_override*, state_on_change_sync_config?*)	
		/// @desc	set the current state method to that of the passed state_name's method
		/// @param	{string}  state_name
		/// @param	{string}  config_override=undefined
		/// @param	{boolean} state_on_change_sync_config=default
		/// @return	{Ui}	  self
		///
		if (state_exists(_state_name)) {
			/// Run Previous State Exit
			if (state_exists(state_get_current_name())) {
				state_execute_on_exit(state_get_current_name());
			}
			
			/// Update Current State
			__this.__states.__current.__state =  state_get(_state_name);
			__this.__states.__current.__name  = _state_name;
			#region Sync Config ////////////////////////////////////////
			
			var _config = undefined;
			
			/// Check For Config Override
			if (_config_override != undefined && config_exists(_config_override)) {
				_config = _config_override;
			}
			/// Check For Config Binding
			if (_config == undefined) {
				var _config_bind  = state_get(_state_name).get_config_bind();
				if (_config_bind != undefined && config_exists(_config_bind)) {
					_config = _config_bind;
				}
			}
			/// Check For Config w/Same State Name
			if (_config == undefined && _state_on_change_sync_config) {
				if (config_exists(_state_name)) {
					_config = _state_name;	
				}
			}
			/// Assign Config If Set
			if (_config != undefined) {
				config_change(_config);	
			}
			
			#endregion
			
			/// Run New State Enter
			state_execute_on_enter(_state_name);
		}
		return self;
	};
	static state_set_name		 = function(_state_name, _new_name) {
		/// @func	state_set_name(state_name, new_name)
		/// @param	{string} state_name
		/// @param	{string} new_name
		/// @return {Ui} self
		///
		if (state_exists(_state_name)) {
			state_get(_state_name).set_name(_new_name);
		}
		return self;
	};
	static state_set_active		 = function(_state_name, _active) {
		/// @func	state_set_active(state_name, active?)
		/// @param	{string}  state_name
		/// @param	{boolean} active?
		/// @return {Ui} self
		///
		if (state_exists(_state_name)) {
			state_get(_state_name).set_active(_active);
		}
		return self;
	};
	static state_set_on_enter	 = function(_state_name, _on_enter_method, _auto_bind_method = default_get_auto_bind_methods_to_self()) {
		/// @func	state_set_on_enter(state_name, on_enter_method, auto_bind_methods_to_self?*)
		/// @desc	add a new state_on_enter method bound to a given state_name
		/// @param	{string}		  state_name
		/// @param	{method/function} on_enter_method
		/// @param	{boolean}		  auto_bind_methods_to_self?*
		/// @return	{Ui}			  self
		///
		if (state_exists(_state_name)) {
			if (_auto_bind_method) {
				_on_enter_method = method(self, _on_enter_method);	
			}
			state_get(_state_name).set_on_enter(_on_enter_method);
		}
		return self;
	};
	static state_set_on_loop	 = function(_state_name, _on_loop_method, _auto_bind_method = default_get_auto_bind_methods_to_self()) {
		/// @func	state_set_on_enter(state_name, on_loop_method, auto_bind_methods_to_self?*)
		/// @desc	add a new state_on_enter method bound to a given state_name
		/// @param	{string}		  state_name
		/// @param	{method/function} on_loop_method
		/// @param	{boolean}		  auto_bind_methods_to_self?*
		/// @return	{Ui}			  self
		///
		if (state_exists(_state_name)) {
			if (_auto_bind_method) {
				_on_loop_method = method(self, _on_loop_method);	
			}
			state_get(_state_name).set_on_loop(_on_loop_method);
		}
		return self;
	};
	static state_set_on_exit	 = function(_state_name, _on_exit_method, _auto_bind_method = default_get_auto_bind_methods_to_self()) {
		/// @func	state_set_on_enter(state_name, on_exit_method, auto_bind_methods_to_self?*)
		/// @desc	add a new state_on_enter method bound to a given state_name
		/// @param	{string}		  state_name
		/// @param	{method/function} on_exit_method
		/// @param	{boolean}		  auto_bind_methods_to_self?*
		/// @return	{Ui}			  self
		///
		if (state_exists(_state_name)) {
			if (_auto_bind_method) {
				_on_exit_method = method(self, _on_exit_method);	
			}
			state_get(_state_name).set_on_exit(_on_exit_method);
		}
		return self;
	};
	static state_set_config_bind = function(_state_name, _config_name) {
		/// @func	state_set_config_bind(state_name, config_name)
		/// @desc	establish a relationship between a state and a config, so that the config is
		///			automatically updated and applied upon state transition.
		/// @param	{string} state_name
		/// @param	{string} config_name
		/// @return {Ui} self
		///
		if (state_exists(_state_name)) {
			state_get(_state_name).set_config_bind(_config_name);
		}
		return self;
	};
	
	/// Checkers ///////////////////////////
	static state_exists		 = function(_state_name) {
		/// @func	state_exists(state_name)
		/// @desc	return if the given state_name has been registered as a state_method.
		/// @param	{string}  state_name
		/// @return {boolean} state_exists?
		///
		return state_get(_state_name) != undefined;
	};
	static state_is			 = function(_state_name) {
		/// @func	state_is(state_name)
		/// @desc	check if the current state_is the same as that of the passed in state_name
		/// @param	{string}  state_name 
		/// @return {boolean} state_is?
		///
		return state_get_current_name() == _state_name;
	};
	static state_has_current = function() {
		/// @func	state_has_current()
		/// @return {boolean} has_current?
		///
		return state_get_current() != undefined;
	};
	
	/// Other //////////////////////////////
	static state_execute_on_enter = function(_state_name) {
		/// @func	state_execute_on_enter(state_name)
		/// @param	{string} state_name
		/// @return {Ui} self
		///
		if (state_exists(_state_name)) {
			state_get(_state_name).execute_on_enter();
		}
		return self;
	};
	static state_execute_on_loop  = function(_state_name) {
		/// @func	state_execute_on_loop(state_name)
		/// @param	{string} state_name
		/// @return {Ui} self
		///
		if (state_exists(_state_name)) {
			state_get(_state_name).execute_on_loop();
		}
		return self;
	};
	static state_execute_on_exit  = function(_state_name) {
		/// @func	state_execute_on_exit(state_name)
		/// @param	{string} state_name
		/// @return {Ui} self
		///
		if (state_exists(_state_name)) {
			state_get(_state_name).execute_on_exit();
		}
		return self;
	};
	
	#endregion
	#region Pins ///////////////////////////
	
	static pin_components = function() {
		/// @func	pin_components(component1, ..., componentN)	
		/// @desc	pin x number of passed in components to this self component. pinned components 
		///			will propagate position, scale, and alpha to children components if the associated
		///			flag toggles are set to true.
		/// @param	{Ui} components
		/// @return {Ui} component
		///
		for (var _i = 0; _i < argument_count; _i++) {
			var _component = argument[_i];
			array_push(__this.__pin.__pins, _component);
			__this.__pin.__size++;
			_component.pin_set_parent(self);	
		}
		return self;
	};
	static pin_set_parent = function(_parent) {
		/// @func	pin_set_parent(parent)
		/// @param  {Ui} parent
		/// @return {Ui} self
		///
		__this.__pin.__xoff   = _parent.get_x() - get_x();
		__this.__pin.__yoff   = _parent.get_y() - get_y();
		__this.__pin.__parent = _parent;
		event_publish("pin_parent_assigned", _parent);
		return self;
	};
		
	#endregion
	#region Configs & Properties ///////////
	
	/// Configs ////////////////////////////////////////////////////////////////
	static config_add				 = function(_config_name, _config_struct) {
		/// @func	config_add(config_name, config)
		/// @param	{string} config_name
		/// @param	{struct} config_struct
		/// @return {Ui} self
		///
		__this.__config.__configs[$ _config_name] = _config_struct;	
		return self;
	};
	static config_get				 = function(_config_name) {
		/// @func	config_get(config_name)
		/// @desc	return the config associated to the given config_name
		/// @param	{string} config_name
		/// @return {struct} config_struct
		///
		return __this.__config.__configs[$ _config_name];
	};
	static config_get_current		 = function() {
		/// @func	config_get_current()
		/// @desc	get the currently assigned config
		/// @return {struct} config
		///
		return __this.__config.__current;
	};
	static config_get_current_name	 = function() {
		/// @func	config_get_current_name()
		/// @desc	get the name of the currently assigned config
		/// @return {string} name
		///
		return __this.__config.__name;
	};
	static config_set_current		 = function(_config_name, _config_struct) {
		/// @func	config_set_current(config_name, config_struct)	
		/// @desc	set the current configuration and update values
		/// @param	{string} config_name
		/// @param	{struct} config_struct
		/// @return	{Ui}	 self
		///
		__this.__config.__name	  = _config_name;
		__this.__config.__current = _config_struct;
		__properties_update(_config_struct);
		return self;
	};
	static config_get_start			 = function() {
		/// @func	config_get_start()
		/// @return {struct} config_start
		///
		return config_get(config_get_start_name());
	};
	static config_get_start_name	 = function() {
		/// @func	config_get_start_name()
		/// @return {string} start_name
		///
		return __this.__config.__name_start;
	};
	static config_get_default		 = function() {
		///	@func	config_get_default()
		/// @return {struct} config_default
		/// 
		return config_get(config_get_default_name());
	};
	static config_get_default_name	 = function() {
		/// @func	config_get_default_name()
		/// @return {string} default_name
		///
		return __this.__config.__name_default;
	};
	static config_exists			 = function(_config_name) {
		/// @func	config_exists(config_name) 
		/// @param	{string}  config_name
		/// @return {boolean} config_exists?
		///
		return variable_struct_exists(__this.__config.__configs, _config_name);
	};
	static config_change			 = function(_config_name) {
		/// @func	config_change(config_name)
		/// @desc	do config transition
		/// @param	{string} config_name
		/// @return {Ui}	 self
		///
		if (config_exists(_config_name)) {
			config_set_current(_config_name, config_get(_config_name));
			event_publish("config_changed", _config_name);
		}
		return self;
	};
	static config_is				 = function(_config_name) {
		/// @func	config_is(state_name)
		/// @desc	check if the current config_is the same as that of the passed in config_name
		/// @param	{string}  config_name
		/// @return {boolean} config_is?
		///
		return _config_name == config_get_current_name();
	};
	static config_apply_state		 = function (_state_name, _check_for_state_config = default_get_state_on_change_sync_config()) {
		/// @func	config_apply_state(state_name, check_for_state_config?*)
		/// @desc	apply the config bound to a given state. if no binding exists, default 
		///			check for an existing config with the same state name.
		/// @param	{string}  state_name
		/// @param	{boolean} check_for_state_config?
		/// @return {Ui} self
		///
		/// Check For State Bound Config First
		var _config_name = __this.__state.__configs[$ _state_name];
		if (config_exists(_config_name)) {
			config_change(_config_name);
			return self;
		}
		/// Check For Matching State Config
		if (_check_for_state_config && config_exists(_state_name)) {
			config_change(_state_name);	
		}
		return self;
	};
	static config_restore_to_start	 = function(_restore_all_properties = true) {
		/// @func	config_restore_to_start(restore_all_properties?*)
		/// @param	{bool} restore_all_properties=true
		/// @return {Ui} self
		///
		if (_restore_all_properties) {
			__properties_update(config_get_default());	// wipe all values to default first
		}
		return config_change(config_get_start_name());
	};
	static config_restore_to_default = function() {
		/// @func	config_restore_to_default()
		/// @return {Ui} self
		///
		return config_change(config_get_default_name());
	};
	static config_set_value			 = function(_config_name, _value_name, _value) {
		/// @func	config_set_value(config_name, value_name, value) 
		/// @param	{string} config_name
		/// @param	{string} value_name
		/// @param	{any}	 value
		/// @return {Ui}	 self
		///
		if (config_exists(_config_name)) {
			variable_struct_set(config_get(_config_name), _value_name, _value);
		}
		return self;
	};
	static config_get_value			 = function(_config_name, _value_name) {
		/// @func	config_get_value(config_name, value_name)
		/// @param	{string} config_name
		/// @param	{string} value_name
		/// @return {any}	 value
		///
		if (config_exists(_config_name)) {
			return variable_struct_get(config_get(_config_name), _value_name);
		}
		return undefined;
	};
	static config_remove_value		 = function(_config_name, _value_name) {
		/// @func	config_remove_value(config_name, value_name) 
		/// @param	{string} config_name
		/// @param	{string} value_name
		/// @return {Ui}	 self
		///
		if (config_exists(_config_name)) {
			variable_struct_remove(config_get(_config_name), _value_name);
		}
		return self;
	};
	
	static __config_init			 = function(_config_start_name, _config_struct) {
		/// @func	__config_init(config_start_name, config_struct*)
		/// @param	{string} config_start_name
		/// @param	{struct} config_struct=config_get_default()
		///	@return NA
		///
		var _config_default = __config_init_default();
		
		/// If Not Config Struct Was Passed, Use Default Config
		if (_config_struct == undefined || _config_struct == {}) {
			_config_struct  = _config_default;
		}
		__config_init_start(_config_start_name, _config_struct);
		__config_init_complete(_config_default, _config_start_name, _config_struct);
	};
	static __config_init_default	 = function() {
		/// @func	__config_init_default()
		/// @return {struct} config_default_struct
		///
		var _config_default = __this.__default;
		config_add(config_get_default_name(), _config_default);
		return _config_default;
	};
	static __config_init_start		 = function(_config_start_name, _config_start_struct) {
		/// @func	__config_init_start(config_start_name, config_start_struct)
		/// @param	{string} config_start_name
		/// @param	{struct} config_start_struct
		/// @return {struct} config_start_struct
		///
		__this.__config.__name_start = _config_start_name;
		config_add(_config_start_name, _config_start_struct);
		return _config_start_struct;
	};
	static __config_init_complete	 = function(_config_default_struct, _config_start_name, _config_start_struct) {
		/// @func	__config_init_complete(config_default_struct, config_start_name, config_start_struct)
		/// @param	{struct} config_default_struct
		/// @param	{string} config_start_name
		/// @param	{struct} config_start_struct
		/// @return NA
		///
		__config_stash_properties(_config_default_struct);
		__config_stash_properties(_config_start_struct);
		
		/// Invoke Default So That All Properties Are At Least Set Once
		__properties_update(_config_default_struct);
		config_set_current(_config_start_name, _config_start_struct);	/// <-- will automatically update properties to start_struct
	};
	static __config_stash_properties = function(_config_struct) {
		/// @func	__config_stash_properties(config_struct)
		/// @param	{struct} config_struct
		/// @return NA
		///
		var _property_names = variable_struct_get_names(_config_struct);
		for (var _i = 0, _len = array_length(_property_names); _i < _len; _i++) {
			var _property_name    = _property_names[_i];
			var _property_value   = _config_struct[$ _property_name];
			var _property_default =  default_get(_property_name);
			if (_property_default == undefined) {
				_property_default = _property_value;	
			}
			__property_add(_config_struct, _property_name, _property_default, false);
		}
	};
		
	/// Properties /////////////////////////////////////////////////////////////
	static set_properties	   = function(_properties_struct) {
		/// @func	set_properties(properties_struct)
		/// @desc	ui components are designed to be modular and lightweight, as a result, this method can be used
		///			to declare and instantiate additional properties that should be associated with this component.
		///			this also prevents the initially passed in config struct, from being bloated and having to account
		///			for all possible passed in values, as we can instead, pass in added values after-the-fact using this 
		///			method.
		/// @param  {struct} properties
		/// @return {Ui}	 self
		///
		var _names  = variable_struct_get_names(_properties_struct);
		var _count  = array_length(_names);
		var _name, _value;
		
		/// Set Properties
		for (var _i = 0; _i < _count; _i++) {
			_name  = _names[_i];
			_value = _properties_struct[$ _name];
			variable_struct_set(self, _name, _value);
		}
		return self;
	};
	static __property_add	   = function(_config_in, _property_name, _default_value, _add_to_start_config = true) {
		/// @func	__property_add(config_in, property_name, default_value, add_to_start_config?*)
		/// @desc	any property added using this method needs to have a correlated setter() method with the 
		///			proper naming convention. as a result, this method should only be used to initialize
		///			static properties.
		/// @param	{struct}  config_in
		/// @param	{string}  property_name
		/// @param	{any}	  default_value
		/// @param	{boolean} add_to_start_config=true
		/// @return {any}	  value
		///
		/// CANNOT BE USED IF A PREVIOUSLY DEFINED SETTER METHOD DOES NOT EXIST
		///
		/// Get Property Value
		var _value = _default_value;
		if (_config_in !=  undefined) {
			_value = _config_in[$ _property_name] ?? _default_value;
		}
		/// Add Property To Start Struct?
		if (_add_to_start_config) {
			config_get_start()[$ _property_name] = _value;
		}
		/// Store Property Setter() For Dynamic Updates In __properties_update()
		__this.__config.__properties[$ _property_name] = {
			setter: variable_struct_get(self, "set_" + _property_name),	
		};
		/// Store Default Property
		default_set(_property_name, _default_value);
		
		return _value;
	};
	static __properties_update = function(_config = config_get_current()) {
		/// @func	__properties_update(config*)
		/// @desc	given a config struct, iterate through each value, and use the previously defined
		///			associated setter() method to set the current value into self: the Ui component.
		/// @param	{struct} config=config_get_current()
		/// @return {Ui} self
		///
		/// CANNOT BE USED IF A PREVIOUSLY DEFINED SETTER METHOD DOES NOT EXIST
		///
		var _property_names = variable_struct_get_names(_config); 
		for (var _i = 0, _len = array_length(_property_names); _i < _len; _i++) {
			
			var _property_name   = _property_names[_i];
			var _property_value  = _config[$ _property_name];
			var _property_setter =  undefined;
			
			/// If Setter Method Exists, Use Setter Method
			if (variable_struct_exists(__this.__config.__properties, _property_name)) {
				_property_setter = __this.__config.__properties[$ _property_name].setter;
				if (_property_setter != undefined) {
					_property_setter(_property_value);
				}
			}
			/// Manually Assign Value
			//if (_property_setter == undefined) {
			//	variable_struct_set(self, "__" + _property_name, _property_value);
			//}
		}	
		return self;
	};
	
	#endregion
	#region Interactions ///////////////////
	
	static mouse_touching = function() {
		/// @func	mouse_touching()
		/// @desc	return if the mouse is currently touching the component.
		/// @return {boolean} mouse_touching?
		///
		var _mxy = get_mouse_xy();
		return (
			_mxy.x >= get_left() && _mxy.x <= get_right() &&
			_mxy.y >= get_top()  && _mxy.y <= get_bottom()
		);
	};
	
	#endregion
	#region Util Functions /////////////////
	
	static __draw_rectangle_width_color = function(_x1, _y1, _x2, _y2, _width, _color) {	
		/// @func   __draw_rectangle_width_color(x1, y1, x2, y2, width, color)
		/// @desc   a function designed to extend GMs draw_rectangle_color. This is a pretty low
		///			perfomance solution though.
		/// @param  {real}	x1	 
		/// @param  {real}	y1	 
		/// @param  {real}	x2	 
		/// @param  {real}	y2	 
		/// @param  {real}	width
		/// @param  {color}	color
		/// @return NA
		///
		draw_set_color(_color);
		draw_line_width(_x1, _y1, _x2, _y1, _width);
		draw_line_width(_x2, _y1, _x2, _y2, _width);
		draw_line_width(_x1, _y2, _x2, _y2, _width);
		draw_line_width(_x1, _y1, _x1, _y2, _width);
		draw_set_color(c_white);
	};
	
	#endregion
	#region Events /////////////////////////
	
	EventObject(self, "gentui");
	event_register([
		"activated", 
		"deactivated",
		"show_toggled",
		"hide_toggled",
		"state_changed",
		"config_changed",
		"pin_parent_assigned",
		"action_executed",
		"trigger_triggered",
	]);
	
	#endregion
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function UiPanel  (_config_name = __GENTUI_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_config_name, _config) constructor {
	/// @func  UiPanel(config) : Ui(config)
	/// @param {bool} outline*
	///
	__outline = __property_add(_config, "outline", false);
	
	#region Core ///////////////////
	
	static render = function() {
		/// @func	render()
		/// @return {UiPanel} self
		///
		var _width     = get_width();
		var _height    = get_height();
		var _alpha     = get_alpha();
		var _outline   = get_outline();
		var _thickness = get_thickness();
		
		/// @TODO: replace with draw_rectangle_alt()
		if (_width > 0 && _height > 0 && _alpha > 0) {
			var _x = get_x();
			var _y = get_y();
			var _c = get_color();
			
			if (!_outline) {
				draw_set_alpha(_alpha);
				draw_rectangle_color(
					_x, 
					_y, 
					_x + _width,
					_y + _height,
					_c, _c, _c, _c,
					_outline,
				);
				draw_set_alpha(1.0);
			}
			else {
				__draw_rectangle_width_color(
					_x, 
					_y, 
					_x + _width, 
					_y + _height,
					_thickness,
					_c,
				);
			}
		}
		return self;
	};
	
	#endregion
	#region Getters & Setters //////
	
	/// Getters
	static get_outline = function() {
		/// @func	get_outline()
		/// @return {real} outline
		///
		return __outline;
	};
		
	/// Setters
	static set_outline = function(_outline) {
		/// @func	set_outline(outline)
		/// @param	{real} outline
		/// @return {Ui} self
		///
		__outline = _outline;
		return self;
	};
		
	#endregion
	
	action_render_add("render_main", render, true);
};
function UiLabel  (_config_name = __GENTUI_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_config_name, _config) constructor {
	/// @func  UiLabel(config) : Ui(config)
	/// @param {string}	  text*
	/// @param {bool}	  wrap*
	/// @param {real}	  wrap_width*
	/// @param {real}	  line_space*
	/// @param {constant} halign*
	/// @param {constant} valign*
	///
	__text		 = __property_add(_config, "text",		  "");
	__wrap_apply = __property_add(_config, "wrap_apply",  false);
	__wrap_width = __property_add(_config, "wrap_width", -1);
	__line_space = __property_add(_config, "line_space", -1);
	__halign	 = __property_add(_config, "halign",	  fa_left);
	__valign	 = __property_add(_config, "valign",	  fa_top);
		
	#region Core ///////////////////
	
	static render = function() {
		/// @func	render()
		/// @return {UiLabel} self
		///
		if (has_text()) {
			draw_set_halign(get_halign());
			draw_set_valign(get_valign());
			
			var _color = get_color();
			
			if (get_wrap_apply() && get_wrap_width() != -1) {
				draw_text_ext_transformed_color(
					get_x(),
					get_y(),
					get_text(),
					get_line_space(), 
					get_wrap_width(),
					get_xscale(),
					get_yscale(),
					get_angle(), 
					_color, _color, _color, _color,
					get_alpha()
				);
			}
			else {
				draw_text_transformed_color(
					get_x(),
					get_y(),
					get_text(),
					get_xscale(),
					get_yscale(),
					get_angle(),
					_color, _color, _color, _color,
					get_alpha()
				);
			}
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
		}
		return self;
	};
	
	#endregion
	#region Getters & Setters //////
		
	/// Getters
	static get_text		  = function() {
		/// @func	get_text()
		/// @return {string} text
		///
		return __text;
	};
	static get_wrap_apply = function() {
		/// @func	get_wrap_apply()
		/// @return {bool} wrap_apply?
		///
		return __wrap_apply;
	};
	static get_wrap_width = function() {
		/// @func	get_wrap_width()
		/// @return {real} wrap_width
		///
		return __wrap_width;
	};
	static get_line_space = function() {
		/// @func	get_line_space()
		/// @return {real} line_space
		///
		return __line_space;
	};
	static get_halign	  = function() {
		/// @func	get_halign()
		/// @return {constant} horizontal alignment
		///
		return __halign;
	};
	static get_valign	  = function() {
		/// @func	get_valign()
		/// @return {constant} vertical alignment
		///
		return __valign;
	};
	static get_width	  = function() {	/// @OVERRIDE
		/// @func	get_width()
		/// @return {real} width
		///
		return string_width(get_text()) * get_xscale();
	};
	static get_height	  = function() {	/// @OVERRIDE
		/// @func	get_height()
		/// @return {real} height
		///
		return string_height(get_text()) * get_yscale();
	};
	static get_left		  = function() {	/// @OVERRIDE
		/// @func	get_left()
		/// @return {real} x_pos
		///
		switch (get_halign()) {
			case fa_left:	return get_x();
			case fa_center: return get_x() - get_width() * 0.5;
			case fa_right:	return get_x() + get_width();
		};
	};
	static get_right	  = function() {	/// @OVERRIDE
		/// @func	get_right()
		/// @return {real} x_pos
		///
		return get_left() + get_width();
	};
	static get_top		  = function() {	/// @OVERRIDE
		///	@func	get_top()
		/// @return {real} y_pos
		///
		switch (get_valign()) {
			case fa_top:	return get_y();
			case fa_middle: return get_y() - get_height() * 0.5;
			case fa_bottom: return get_y() - get_height();
		};
	};
	static get_bottom	  = function() {	/// @OVERRIDE
		///	@func	get_bottom()
		/// @return {real} y_pos
		///
		return get_top() + get_height();
	};
	static get_center_x	  = function() {	/// @OVERRIDE
		/// @func	get_center_x()
		/// @return {real} x_pos
		///
		return get_left() + get_width() * 0.5;
	};
	static get_center_y	  = function() {	/// @OVERRIDE
		/// @func	get_center_y()
		/// @return {real} y_pos
		///
		return get_top() + get_height() * 0.5;
	};

	/// Setters
	static set_text		  = function(_text) {
		/// @func	set_text(text)
		/// @param	{string} text
		/// @return {Ui} self
		///
		__text = _text;
		return self;
	};
	static set_wrap_apply = function(_wrap_apply) {
		/// @func	set_wrap_apply(wrap_apply?)
		/// @param	{bool} wrap_apply?
		/// @return {Ui} self
		///
		__wrap_apply = _wrap_apply;
		return self;
	};
	static set_wrap_width = function(_wrap_width) {
		/// @func	set_wrap_width(wrap_width)
		/// @param	{real} wrap_width
		/// @return {Ui} self
		///
		__wrap_width = _wrap_width;
		return self;
	};
	static set_line_space = function(_line_space) {
		/// @func	set_line_space(line_space)
		/// @param	{real} line_space
		/// @return {Ui} self
		///
		__line_space = _line_space;
		return self;
	};
	static set_halign	  = function(_halign) {
		/// @func	set_halign(halign)
		/// @param	{constant} halign
		/// @return {Ui} self
		///
		__halign = _halign;
		return self;
	};
	static set_valign	  = function(_valign) {
		/// @func	set_valign(valign)
		/// @param	{constant} valign
		/// @return {Ui} self
		///
		__valign = _valign;
		return self;
	};
		
	/// Checkers
	static has_text = function() {
		/// @func	has_text()
		/// @return {boolean} has_text?
		///
		var _text = get_text();
		return _text != "" && _text != undefined;
	};
	
	#endregion
	
	action_render_add("render_main", render, true);
};
function UiSprite (_config_name = __GENTUI_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_config_name, _config) constructor {
	/// @func  UiSprite(config) : Ui(config)
	/// @param {sprite_index} sprite*
	/// @param {real} image*
	/// @param {real} speed*
	///
	if (!variable_struct_exists(_config, "sprite")) {
		throw("***error in UiSprite*** sprite not defined.");	
	}
		
	__sprite = __property_add(_config, "sprite", undefined);
	__image  = __property_add(_config, "image",  0);
	__speed  = __property_add(_config, "speed",  1);

	#region Core ///////////////////
	
	static update = function() {
		/// @func	update()
		/// @return {UiSprite} self
		///
		if (get_speed() > 0) {
			set_image(get_image() + get_speed());
		}
		return self;
	};
	static render = function() {
		/// @func	render()
		/// @return {UiSprite} self
		///
		draw_sprite_ext(
			get_sprite(), 
			get_image(), 
			get_x(),
			get_y(),
			get_xscale(),
			get_yscale(),
			get_angle(), 
			get_color(), 
			get_alpha()
		);
		return self;
	};
	
	#endregion
	#region Getters & Setters //////
	
	/// Getters
	static get_sprite	= function() {
		/// @func	get_sprite()
		/// @return {real} sprite_index
		///
		return __sprite;
	};
	static get_index	= function() {
		/// @func	get_index()
		/// @return {real} sprite_index
		///
		return get_sprite();
	};
	static get_image	= function() {
		/// @func	get_image()
		/// @return {real} image_index
		///
		return __image;	
	};
	static get_frame	= function() {
		/// @func	get_frame()
		/// @return {real} image_index
		///
		return get_image();	
	};
	static get_speed	= function() {
		/// @func	get_speed()
		/// @return {real} image_speed
		///
		return __speed;	
	};
	static get_xoffset	= function() {
		/// @func	get_xoffset()
		/// @return {real} x_offset
		///
		return sprite_get_xoffset(get_sprite()) * get_xscale();
	};
	static get_yoffset	= function() {
		/// @func	get_yoffset()
		/// @return {real} y_offset
		///
		return sprite_get_yoffset(get_sprite()) * get_yscale();
	};
	static get_width	= function() {	/// @OVERRIDE
		/// @func	get_width()
		/// @return {real} width
		///
		return sprite_get_width(get_sprite()) * get_xscale();
	};
	static get_height	= function() {	/// @OVERRIDE
		/// @func	get_height()
		/// @return {real} height
		///
		return sprite_get_height(get_sprite()) * get_yscale();
	};
	static get_left		= function() {	/// @OVERRIDE
		/// @func	get_left()
		/// @return {real} x_pos
		///
		return get_x() - get_xoffset();
	};
	static get_right	= function() {	/// @OVERRIDE
		/// @func	get_right()
		/// @return {real} x_pos
		///
		return get_left() + get_width();
	};
	static get_top		= function() {	/// @OVERRIDE
		/// @func	get_top()
		/// @return {real} y_pos
		///
		return get_y() - get_yoffset();
	};
	static get_bottom	= function() {	/// @OVERRIDE
		/// @func	get_bottom()
		/// @return {real} y_pos
		///
		return get_top() + get_height();
	};
	static get_center_x = function() {	/// @OVERRIDE
		/// @func	get_center_x()
		/// @return {real} x_pos
		///
		return get_left() + get_width() * 0.5;
	};
	static get_center_y = function() {	/// @OVERRIDE
		/// @func	get_center_y()
		/// @return {real} y_pos
		///
		return get_top() + get_height() * 0.5;
	};
	
	/// Setters
	static set_sprite	= function(_sprite) {
		/// @func	set_sprite(sprite)
		/// @param	{real}	   sprite_index
		/// @return {UiSprite} self
		///
		__sprite = _sprite;
		return self;
	};
	static set_index	= function(_index) {
		/// @func	set_sprite(index)
		/// @param	{real}	   sprite_index
		/// @return {UiSprite} self
		///
		return set_sprite(_index);
	};
	static set_image	= function(_image) {
		/// @func	set_image(image)
		/// @param	{real}	   image
		/// @return {UiSprite} self
		///
		__image = _image;
		return self;
	};
	static set_frame	= function(_frame) {
		/// @func	set_frame(frame)
		/// @param	{real}	   frame
		/// @return {UiSprite} self
		///
		return set_image(_frame);
	};
	static set_speed	= function(_speed) {
		/// @func	set_speed(speed)
		/// @param	{real}	   speed
		/// @return {UiSprite} self
		///
		__speed = _speed;
		return self;
	};
	static set_scale	= function(_scale, _yscale = _scale) {
		/// @func	set_scale(scale, yscale*)
		/// @param	{real}	   scale
		/// @param	{real}	   yscale=scale
		/// @return {UiSprite} self
		///
		__xscale = _scale;
		__yscale = _yscale;
		return self;
	};
	static set_angle	= function(_angle) {
		/// @func	set_angle(angle)
		/// @param	{real}	   angle
		/// @return {UiSprite} self
		///
		__angle = _angle;
		return self;
	};
	
	#endregion
	
	action_update_add("update_main", render, true);
	action_render_add("render_main", render, true);
};
function UiLine   (_config_name = __GENTUI_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_config_name, _config) constructor {
	/// @func  UiLine(config) : Ui(config)
	///
	#region __this /////////////////
	
	with (__this) {
		__points   = [];
		__point    = {
			__left_most:   undefined,
			__right_most:  undefined,
			__top_most:	   undefined,
			__bottom_most: undefined,
		};
		__n_points = 0;
	}
	
	/// Dynamically Add Passed In Points To Points Array
	if (variable_struct_exists(_config, "points")) {
		for (var _i = 0, _len = array_length(_config.points); _i < _len; _i++) {
			var _point = _config.points[_i];
			add_point(_point.x, _point.y);
		}
	}
		
	__events_init(
		"point_added"
	);
	
	#endregion
	#region Core ///////////////////
	
	static render	 = function() {
		/// @func	render()
		/// @return {UiLine} self
		///
		var _thickness = get_thickness();
		var _color	   = get_color();
		var _p1, _p2;
		
		for (var _i = 0, _len = __this.__n_points; _i < _len - 1; _i++) {
			_p1	= __this.__points[_i];
			_p2 = __this.__points[_i + 1];
			
			draw_line_width_color(
				_p1.get_x(),
				_p1.get_y(),
				_p2.get_x(),
				_p2.get_y(),
				_thickness,
				_color, _color,
			);
		};
		return self;
	};
	static add_point = function(_x, _y) {
		/// @func add_point(x, y)
		/// @param	{real}	 x
		/// @param	{real}	 y
		/// @return {UiLine} self
		///
		var _point = new Ui(,,{ // create empty object to hold coordinates
			x: _x,
			y: _y,
		});
		array_push(__this.__points, _point);
		pin_components(_point);
		__this.__n_points++;
		
		/// Update Bounding Box
		with (__this.__point) {
			if (__left_most   == undefined || _x < __left_most  ) __left_most   = _x;	
			if (__right_most  == undefined || _x > __right_most ) __right_most  = _x;	
			if (__top_most    == undefined || _y < __top_most   ) __top_most    = _y;	
			if (__bottom_most == undefined || _y > __bottom_most) __bottom_most = _y;	
		}
		
		event_publish("point_added", { x: _x, y: _y });
		
		return self;
	};
	
	#endregion
	#region Getters & Setters //////
	
	/// Getters
	static get_width	= function() {	/// @OVERRIDE
		/// @func	get_width()
		/// @return {real} width
		///
		with (__this.__point) {
			return __right_most - __left_most;
		}
	};
	static get_height	= function() {	/// @OVERRIDE
		/// @func	get_height()
		/// @return {real} height
		///
		with (__this.__point) {
			return __bottom_most - __top_most;
		}
	};
	static get_left		= function() {	/// @OVERRIDE
		/// @func	get_left()
		/// @return {real} x_pos
		///
		with (__this.__point) {
			return __left_most;
		}
	};
	static get_right	= function() {	/// @OVERRIDE
		/// @func	get_right()
		/// @return {real} x_pos
		///
		with (__this.__point) {
			return __right_most;
		}
	};
	static get_top		= function() {	/// @OVERRIDE
		/// @func	get_top()
		/// @return {real} y_pos
		///
		with (__this.__point) {
			return __top_most;
		}
	};
	static get_bottom	= function() {	/// @OVERRIDE
		/// @func	get_bottom()
		/// @return {real} y_pos
		///
		with (__this.__point) {
			return __bottom_most;
		}
	};
	static get_center_x = function() {	/// @OVERRIDE
		/// @func	get_center_x()
		/// @return {real} x_pos
		///
		return get_left() + get_width() * 0.5;
	};
	static get_center_y = function() {	/// @OVERRIDE
		/// @func	get_center_y()
		/// @return {real} y_pos
		///
		return get_top() + get_height() * 0.5;
	};
	
	#endregion
	
	action_render_add("render_main", render, true);
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function UiCircle (_config_name = __GENTUI_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_config_name, _config) constructor {
	/// @func UiCircle(config) : Ui(config)
	///
	exit; // <-- not yet ready
	
	static render = function() {};
	
	static __draw_circle_curve = function(_x, _y, _radius, _precision, _angle_start, _angle_end, _thickness, _outline, _alpha = undefined) {
		/// @func   draw_circle_curve(x, y, radius, precision, angle_start, angle_end, thickness, outline?, alpha*)
		/// @desc   extended functionality to allow more advanced circle drawing options.
		/// @param  x			-> {real}
		/// @param  y			-> {real}
		/// @param  radius		-> {real}
		/// @param  precision	-> {real}
		/// @param  angle_start	-> {angle}
		/// @param  angle_end	-> {angle}
		/// @param  thickness	-> {real}
		/// @param  outline		-> {bool}
		/// @param  alpha		-> {real}
		/// @return NA
		///
		static _precision_min = 3;
		_precision = max(_precision_min, _precision);
	
		var _angle_iter	   = _angle_end / _precision;
		var _len_perimeter = _radius + (_thickness * 0.5);
		var _len_middle	   = _radius - (_thickness * 0.5);
		var _angle		   = _angle_start + _angle_end;
		var _dist_perimeter, _dist_middle;
	
		if (_alpha != undefined) {
			draw_set_alpha(_alpha);
		}
		if (_outline) {
			draw_primitive_begin(pr_trianglestrip);
			draw_vertex(_x + lengthdir_x(_len_middle, _angle_start), _y + lengthdir_y(_len_middle, _angle_start));

			for (var i = 1; i <= _precision; i += 1) {
				_dist_perimeter = _angle_start    + _angle_iter * i;
				_dist_middle	= _dist_perimeter - _angle_iter;
				draw_vertex(_x + lengthdir_x(_len_perimeter, _dist_middle),		_y + lengthdir_y(_len_perimeter, _dist_middle));
				draw_vertex(_x + lengthdir_x(_len_middle,	 _dist_perimeter),	_y + lengthdir_y(_len_middle,	 _dist_perimeter));
			}
			draw_vertex(_x + lengthdir_x(_len_perimeter, _angle), _y + lengthdir_y(_len_perimeter, _angle));
			draw_vertex(_x + lengthdir_x(_len_middle, _angle), _y + lengthdir_y(_len_middle, _angle));
		}
		else {
			draw_primitive_begin(pr_trianglefan);
			draw_vertex(_x, _y);

			for (i = 1; i <= _precision; i += 1) {
				_dist_perimeter = _angle_start	  + _angle_iter * i;
				_dist_middle	= _dist_perimeter - _angle_iter;
				draw_vertex(_x + lengthdir_x(_len_perimeter, _dist_middle), _y + lengthdir_y(_len_perimeter, _dist_middle));
			}
			draw_vertex(_x + lengthdir_x(_len_perimeter, _angle), _y + lengthdir_y(_len_perimeter, _angle));
		}	
		draw_primitive_end();
		if (_alpha != undefined) {
			draw_set_alpha(1.0);
		}
	};
		
	action_render_add("render_main", render, true);
};
function UiArc	  (_config_name = __GENTUI_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_config_name, _config) constructor {
	/// This should use the draw_circle_curve() function instead
};
function UiTextbox(_config_name = __GENTUI_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_config_name, _config) constructor {
	/// @func UiTextbox(config) : Ui(config)
	///
	exit; // <-- not yet ready
	
	static render = function() {};
	
	action_render_add("render_main", render, true);
};

