/////////////////////////////////////
// .---. r---. .   . .---. .   . . //
// |  -. r--   | \ |   |   |   | | //
// L---J L---J |   V   |   L---J | //
//////////////////////////////$(º)>//
#region docs, info & configs ////////

#region about ///////////////////////
/*
	written_by:_______gentoo________
	version:__________0.2.0_________
	last_updated:___06/16/2022______
*/
#endregion
#region change log //////////////////

#region version 0.2.*

#region version 0.2.x
/*
	Date: xx/xx/2022
		Feature Additions:
			x.	abstracted actions and triggers. previously, a few set contexts existed in which the action/triggers were defined.
				these included for example: "hover_action_add()" "hover_trigger_add()"; however, this functionality does not need
				to be context sensitive and specific to the hover action. instead, we can generalize a simple action/trigger binding
				that can be defined however desired.
			x.	NEW COMPONENT: added UiCircle() implementing draw_circle_curve() functionality
			x.	NEW COMPONENT: added UiTextbox() 
*/
#endregion
#region version 0.2.0
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
			x.	renamed auto_bind to auto_bind_methods
			x.	renamed pin_propagate_pos to pin_propagate_pos_to_child
			x.	renamed pin_propagate_scale	to pin_propagate_scale_to_child
			x.	renamed pin_propagate_alpha	to pin_propagate_alpha_to_child
		
		Pull Requests:
			x.	merged in fryman's pull request updating return values for state_execute_* methods
*/
#endregion

#endregion
#region version 0.1.*

#region version 0.1.1
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
#region version 0.1.0
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
	- be able to add custom events with custom triggers. do not be restricted to just one set of predefined events
		- remove context sensitivity for actions and triggers. logic exists, do not need arbitrary context definition
		- be able to name actions and triggers, and establish relational bindings
	- set_properties() should take a config_name param for config binding?
	- check if set_properties() method should be implementing property_add()	
	- replace properties with GProps(); however, do not create a dependency to that system, instead, re-implement the basic functionality 
		- this will allow our new values to have lerp and spring motion
		- setup configs so that they can lerp to their newly assigned property values
	- ability to have parent components implement child components' update() and render() methods automatically
		- additionally, setup corresponding depth system for custom depth sorting if automatic updates and renders are used
	
	- improve performance with draw_rectangle_alt, draw_line_alt utilizing one pixel sprite
		- dynamically generate one pixel sprite using surface, sprite_save, etc
	- add support for UI components to render contents to a surface
		- only update surface contents when necessary, and bake children surfaces onto parent
	- propagate parent angle to children components
		- have mouse click detection and interactions respond to different angles. currently not supported!
		
	- docs & help
*/
#endregion
#region default config values ///////

#macro __UI_COMPONENT_DEFAULT_CONFIG_NAME_START	  "__start__"
#macro __UI_COMPONENT_DEFAULT_CONFIG_NAME_DEFAULT "__default__"

#endregion

#endregion

function Ui(_owner = self, _config_name = __UI_COMPONENT_DEFAULT_CONFIG_NAME_START, _config = {}) constructor {
	/// @func  Ui(owner*, config_name*, config*)
	/// @desc  this is the base ui component, containing all core features and functionality that is inherited and implemented
	///		   by all other ui components. an instance of this class will have no visual representation, but can still be utilized
	///		   for creating more "abstract" data containers. see UiLine().add_point() for an example, where a "point" is created
	///		   by instantiating a new Ui() class instance, and passing in x & y values for later reference.
	/// @use   generally this class will be implemented through inheritance of the other Ui components; however, if you wish to implement
	///		   an explicit instance of this class, you can do so using the following: 
	///		   var _abstractUiPointContainer = new Ui({x : _x, y: _y});		/// creates an abstract component containing coordinate points
	/// @param {instance/struct} owner=other
	/// @param {bool}  active*
	/// @param {real}  x*
	/// @param {real}  y*
	/// @param {color} color*
	/// @param {real}  alpha*
	/// @param {real}  angle*
	/// @param {real}  scale*
	/// @param {real}  xscale*
	/// @param {real}  yscale*
	/// @param {real}  width*
	/// @param {real}  height*
	/// @param {bool}  visible*
	/// @param {real}  thickness*
	/// @param {real}  input_device*
	/// @param {bool}  use_gui_space*
	/// @param {bool}  state_execute_on_enter*
	/// @param {bool}  state_execute_on_exit*
	/// @param {bool}  propagate_position_to_child*
	/// @param {bool}  propagate_scale_to_child*
	/// @param {bool}  propagate_alpha_to_child*
	///
	__owner = _owner;
	__this  = {}; with (__this) {	/// <-- change default starting values here
		__default = {	/// <-- change default starting values here
			active						 : true,
			x							 : 0,
			y							 : 0,
			color						 : c_white,
			alpha						 : 1.0,
			angle						 : 0,
			scale						 : 1,
			xscale						 : 1,
			yscale						 : 1,
			width						 : 0,
			height						 : 0,
			visible						 : true,
			thickness					 : 1,
			input_device				 : 0,
			use_gui_space				 : true,
			auto_bind_methods			 : true,
			state_execute_on_enter		 : true,
			state_execute_on_exit		 : true,
			state_on_change_sync_config	 : true,
			pin_propagate_pos_to_child	 : true,
			pin_propagate_scale_to_child : true,
			pin_propagate_alpha_to_child : false,	
		};
		__update  = {
			__active:  true,
			__methods: [],
			__size:	 0,
		};
		__render  = {
			__active:  true,
			__methods: [],
			__size:	 0,
		};
		__state   = {
			__active:   true,
			__current:  undefined,	
			__name:	    "",
			__states:   {}, 
			__on_enter: {},
			__on_exit:  {},
			__configs:	{},
		};
		__pin     = {
			__pins:	  [],
			__size:	  0,
			__parent: undefined,
			__xoff:	  0,
			__yoff:	  0,
		};
		__events  = {
			__on_hover:  {
				__enter: {
					__active:    true,
					__action:    {
						__methods: [],	
						__size:    0,	
					},
					__trigger:   {
						__methods: [],
						__size:    0,
					},
					__did_enter: false,
				},
				__hold:  {
					__active:  true,
					__action:  {
						__methods: [],	
						__size:    0,	
					},
					__trigger: {
						__methods: [],
						__size:    0,
					},
				},
				__leave: {
					__active:    true,
					__action:    {
						__methods: [],	
						__size:    0,	
					},
					__trigger:   {
						__methods: [],
						__size:    0,
					},
					__did_leave: false,
				},
			},
			__on_click: {
				__pressed: {
					__active:  true,
					__action:  {
						__methods: [],	
						__size:    0,	
					},
					__trigger: {
						__methods: [],
						__size:    0,
					},
				},
				__down: {
					__active:  true,
					__action:  {
						__methods: [],	
						__size:    0,	
					},
					__trigger: {
						__methods: [],
						__size:    0,
					},
				},
				__released: {
					__active:  true,
					__action:  {
						__methods: [],	
						__size:    0,	
					},
					__trigger: {
						__methods: [],
						__size:    0,
					},
				},
			},
		};
		__config  = {}; with (__config) {
			__this			= other;
			__current		= undefined;				/// current config struct pointer
			__configs		= {};						/// all stored configs keyed out by config_name
			__properties	= {};						/// stored properties for dynamic updating
			__name			= "";						/// current config name
			__name_start	= __UI_COMPONENT_DEFAULT_CONFIG_NAME_START;
			__name_default	= __UI_COMPONENT_DEFAULT_CONFIG_NAME_DEFAULT;
		};
	};	
	__config_init(_config_name, _config);
		
	#region Core ///////////////////////////
	
	static update	  = function() {
		/// @func	update()
		/// @desc	tick update for the component class. call this in a step event, or
		///			wherever the code for this component class should be updated.
		/// @return	{Ui} self
		///
		if (!active) exit;
		
		#region Update Stack ///////
		
		if (__this.__update.__active) {
			for (var _i = 0; _i < __this.__update.__size; _i++) {
				__this.__update.__methods[_i]();	
			}
		}
			
		#endregion
		#region State Machine //////
		
		if (__this.__state.__active) {
			state_execute();
		};
		
		#endregion
		#region Event Triggers /////
		
		var _self = self;
		with (__this.__events) {
			if (__on_click.__pressed.__active) {
				with (__on_click.__pressed.__trigger) {
					for (var _i = 0; _i < __size; _i++) {
						if (__methods[_i]()) {
							_self.click_execute_pressed();
							break;	
						}
					};
				}
			}
			if (__on_click.__down.__active) {
				with (__on_click.__down.__trigger) {
					for (var _i = 0; _i < __size; _i++) {
						if (__methods[_i]()) {
							_self.click_execute_down();
							break;	
						}
					};
				}
			}
			if (__on_click.__released.__active) {
				with (__on_click.__released.__trigger) {
					for (var _i = 0; _i < __size; _i++) {
						if (__methods[_i]()) {
							_self.click_execute_released();
							break;	
						}
					};
				}
			}
			if (__on_hover.__enter.__active) {
				with (__on_hover.__enter) {
					for (var _i = 0; _i < __trigger.__size; _i++) {
						if (__trigger.__methods[_i]()) {
							if (!__did_enter) {
								_self.hover_execute_enter();
								__did_enter = true;
								break;	
							}
						}
						else {
							__did_enter = false;
						}
					};
				}
			}
			if (__on_hover.__hold.__active) {
				with (__on_hover.__hold) {
					for (var _i = 0; _i < __trigger.__size; _i++) {
						if (__trigger.__methods[_i]()) {
							_self.hover_execute_hold();
							break;	
						}
					};
				}
			}
			if (__on_hover.__leave.__active) {
				with (__on_hover.__leave) {
					for (var _i = 0; _i < __trigger.__size; _i++) {
						if (__trigger.__methods[_i]()) {
							if (!__did_leave) {
								_self.hover_execute_exit();
								__did_leave = true;
								break;	
							}
						}
						else {
							__did_leave = false;
						}
					};
				}
			}
		}
		
		#endregion
		
		return self;
	};
	static render	  = function() {
		/// @func	render()
		/// @desc	tick update for the component class rendering. call this in a draw 
		///			event, or wherever the code for this component class should be rendered.
		/// @return	{Ui} self
		///
		if (!active) exit;
		
		#region Render Stack ///////
		
		if (__visible && __this.__render.__active) {
			for (var _i = 0; _i < __this.__render.__size; _i++) {
				__this.__render.__methods[_i]();	
			}
		}
			
		#endregion
		
		return self;
	};	
	static show		  = function() {
		/// @func	show()
		/// @desc	toggle the visibility of component to visible
		/// @return {Ui} self
		///
		set_visible(true);
		return self;
	};
	static hide		  = function() {
		/// @func	hide()
		/// @desc	toggle the visibility of component to hidden
		/// @return {Ui} self
		///
		set_visible(false);
		return self;
	};
	static activate   = function() {
		/// @func	activate()
		/// @desc	set active to true
		/// @return {Ui} self
		///
		set_active(true);
		return self;
	};
	static deactivate = function() {
		/// @func	deactivate()
		/// @desc	set active to false
		/// @return {Ui} self
		///
		set_active(false);
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
		return active;
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
		return x;	
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
		return y;	
	};
	static get_width						= function() {	/// @OVERRIDE
		/// @func	get_width()
		/// @return {real} width
		///
		return width * get_xscale();
	};
	static get_height						= function() {	/// @OVERRIDE
		/// @func	get_height()
		/// @return {real} height
		///
		return height * get_yscale();
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
		return color;
	};
	static get_alpha						= function() {
		/// @func	get_alpha()
		/// @return {real} alpha
		///
		var _parent_alpha = 1;
		if (__this.__pin.__parent != undefined && __pin_propagate_alpha_to_child) {
			_parent_alpha = __this.__pin.__parent.get_alpha();
		}
		return alpha * _parent_alpha;
	};
	static get_angle						= function() {
		/// @func	get_angle()
		/// @return {real} angle
		///
		return angle;
	};
	static get_xscale						= function() {
		/// @func	get_xscale()
		/// @return {real} xscale
		///
		return xscale * get_scale();
	};
	static get_yscale						= function() {
		/// @func	get_yscale()
		/// @return {real} yscale
		///
		return yscale * get_scale();
	};
	static get_scale						= function() {
		/// @func	get_scale()
		/// @return {real} scale
		///
		var _parent_scale = 1;
		if (__this.__pin.__parent != undefined && __pin_propagate_scale_to_child) {
			_parent_scale = __this.__pin.__parent.get_scale();
		}
		return scale * _parent_scale;
	};
	static get_visible						= function() {
		/// @func	get_visible()
		/// @return {boolean} visible
		///
		return visible;
	};
	static get_thickness					= function() {
		/// @func	get_thickness()
		/// @return {real} thickness
		///
		return thickness * get_scale();
	};
	static get_input_device					= function() {
		/// @func	get_input_device()
		/// @desc	input device registered for use with device_mouse_x_...
		/// @return {real} input_device
		///
		return input_device;
	};
	static get_use_gui_space				= function() {
		/// @func	get_use_gui_space()
		/// @desc	if toggled to true, component will be rendered on gui_space and look for mouse interactions
		///			with coordinates based off of the gui_space positioning
		/// @return {bool} use_gui_space?
		///
		return use_gui_space;
	};
	static get_mouse_xy						= function() {
		/// @func	get_mouse_xy()
		/// @return {struct} mouse_xy
		///
		if (use_gui_space) {
			return {
				x: device_mouse_x_to_gui(input_device),
				y: device_mouse_y_to_gui(input_device),
			};
		}
		else {
			return {
				x: device_mouse_x(input_device),
				y: device_mouse_y(input_device),
			};
		}
	};
	static get_state_execute_on_enter		= function() {
		/// @func	get_state_execute_on_enter()
		/// @return {boolean} state_execute_on_enter?
		///
		return state_execute_on_enter;
	};
	static get_state_execute_on_exit		= function() {
		/// @func	get_execute_on_exit()
		/// @return {boolean} state_execute_on_exit?
		///
		return state_execute_on_exit;
	};
	static get_pin_propagate_pos_to_child	= function() {
		/// @func	get_pin_propagate_pos_to_child()
		/// @desc	if propagate_pos toggled to true, the position properties will be sent down to
		///			pinned children and used for their sub-positioning, so that elements stick together
		/// @return {boolean} propagate_position_to_child?
		///
		return pin_propagate_pos_to_child;
	};
	static get_pin_propagate_scale_to_child	= function() {
		/// @func	get_pin_propagate_scale_to_child()
		/// @desc	if propagate_scale toggled to true, the scale properties will be sent down to pinned
		///			children and used for their scaling and positioning, so that elements stick/scale together
		/// @return {boolean} propagate_scale_to_child?
		///
		return pin_propagate_scale_to_child;
	};
	static get_pin_propagate_alpha_to_child	= function() {
		/// @func	get_pin_propagate_alpha_to_child()
		/// @desc	if propagate_alpha toggled to true, the alpha properties will be sent down to pinned
		///			children and used for their alpha, so that elements blend/fade together
		/// @return {boolean} propagate_alpha_to_child?
		///
		return pin_propagate_alpha_to_child;
	};
		
	#endregion
	#region Setters ////////////////////////
		
	static set_properties					= function(_properties_struct) {
		/// @func	set_properties(properties_struct)
		/// @desc	ui components are designed to be modular and lightweight, as a result, this method can be used
		///			to declare and instantiate additional properties that should be associated with this component.
		///			this also prevents the initially passed in config struct, from being bloated and having to account
		///			for all possible passed in values, as we can instead, pass in added values after-the-fact using this 
		///			method.
		/// @param  {struct} properties
		/// @return {Ui}	 self
		///
		var _names = variable_struct_get_names(_properties_struct);
		var _count = array_length(_names);
		var _name, _value;
		
		for (var _i = 0; _i < _count; _i++) {
			_name  = _names[_i];
			_value = _properties_struct[$ _name];
			variable_struct_set(self, _name, _value);
		}
		return self;
	};
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
		active = _active;
		return self;
	};
	static set_x							= function(_x) {
		/// @func	set_x(x)
		/// @param	{real} x
		/// @return {Ui} self
		///
		x = _x;
		return self;
	};
	static set_y							= function(_y) {
		/// @func	set_y(y)
		/// @param	{real} y
		/// @return {Ui} self
		///
		y = _y;
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
		width = _width;
		return self;
	};
	static set_height						= function(_height) {
		/// @func	set_height(height)
		/// @param	{real} height
		/// @return {Ui} self
		///
		height = _height;
		return self;
	};
	static set_color						= function(_color) {
		/// @func	set_color(color)
		/// @param	{color} color
		/// @return {Ui} self
		///
		color = _color;
		return self;
	};
	static set_alpha						= function(_alpha) {
		/// @func	set_alpha(alpha)
		/// @param	{real} alpha
		/// @return {Ui} self
		///
		alpha = _alpha;
		return self;
	};
	static set_angle						= function(_angle) {
		/// @func	set_angle(angle)
		/// @param	{real} angle
		/// @return {Ui} self
		///
		angle = _angle;
		return self;
	};
	static set_xscale						= function(_xscale) {
		/// @func	set_xscale(xscale)
		/// @param	{real} xscale
		/// @return {Ui} self
		///
		xscale = _xscale;
		return self;
	};
	static set_yscale						= function(_yscale) {
		/// @func	set_yscale(yscale)
		/// @param	{real} yscale
		/// @return {Ui} self
		///
		yscale = _yscale;
		return self;
	};
	static set_scale						= function(_scale) {
		/// @func	set_scale(scale)
		/// @param	{real} scale
		/// @return {Ui} self
		///
		scale = _scale;
		return self;
	};
	static set_visible						= function(_visible) {
		/// @func	set_visible(visible)
		/// @param	{boolean} visible?
		/// @return {Ui} self
		///
		visible = _visible;
		return self;
	};
	static set_thickness					= function(_thickness) {
		/// @func	set_thickness(thickness)
		/// @param	{real} thickness
		/// @return {Ui} self
		///
		thickness = _thickness;
		return self;
	};
	static set_input_device					= function(_device) {
		/// @func	set_input_device(interact_action)
		/// @param	{real}		   device
		/// @return {UiInteractor} self
		///
		input_device = _device;
		return self;
	};
	static set_use_gui_space				= function(_use_gui_space) {
		/// @func	set_use_gui_space(use_gui_space?)
		/// @param	{boolean}	   use_gui_space?
		/// @return {UiInteractor} self
		///
		use_gui_space = _use_gui_space;
		return self;
	};
	static set_state_execute_on_enter		= function(_state_execute_on_enter) {
		/// @func	set_state_execute_on_enter(state_execute_on_enter?)
		/// @desc	whether or not the defined on_enter state function should execute whenever
		///			transitioning into a new state.
		/// @param	{boolean}	   state_execute_on_enter?
		/// @return {UiInteractor} self
		///
		state_execute_on_enter = _state_execute_on_enter;
		return self;
	};
	static set_state_execute_on_exit		= function(_state_execute_on_exit) {
		/// @func	set_state_execute_on_exit(state_execute_on_exit?)
		/// @desc	whether or not the defined on_exit state function should execute whenever
		///			transitioning out of the current state.
		/// @param	{boolean}	   state_execute_on_exit?
		/// @return {UiInteractor} self
		///
		state_execute_on_exit = _state_execute_on_exit;
		return self;
	};
	static set_pin_propagate_pos_to_child	= function(_pin_propagate_pos_to_child) {
		/// @func	set_pin_propagate_pos_to_child(pin_propagate_pos_to_child?)
		/// @param	{boolean}	   pin_propagate_pos_to_child?
		/// @return {UiInteractor} self
		///
		pin_propagate_pos_to_child = _pin_propagate_pos_to_child;
		return self;
	};
	static set_pin_propagate_scale_to_child	= function(_pin_propagate_scale_to_child) {
		/// @func	set_pin_propagate_scale(pin_propagate_scale_to_child?)
		/// @param	{boolean}	   pin_propagate_scale_to_child?
		/// @return {UiInteractor} self
		///
		pin_propagate_scale_to_child = _pin_propagate_scale_to_child;
		return self;
	};
	static set_pin_propagate_alpha_to_child	= function(_pin_propagate_alpha_to_child) {
		/// @func	set_pin_propagate_alpha(pin_propagate_alpha_to_child?)
		/// @param	{boolean}	   pin_propagate_alpha_to_child?
		/// @return {UiInteractor} self
		///
		pin_propagate_alpha_to_child = _pin_propagate_alpha_to_child;
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
	
	#endregion
	
	#endregion
	#region Actions ////////////////////////

	/// Update
	static update_add_action = function(_update_action, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	update_add_action(update_action, auto_bind_methods?*)
		/// @desc	adds a new update action into the update stack to be execute on_update()
		/// @param	{method/function} update_action			->	method/function to be used for said "action"
		/// @param	{boolean}		  auto_bind_methods?*	->	should the update_action method be bound to the Ui() component class automatically?
		///														if this is disabled, then whichever binding is configured upon pass-through will be used.
		///														see GameMaker's method() function for more information 
		///														https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Variable_Functions/method.htm
		/// @return {Ui} self
		///
		if (_auto_bind_method) {
			_update_action = method(self, _update_action);	
		}
		with (__this.__update) {
			array_push(__methods, _update_action);	
			__size++;
		}
		return self;
	};
	static update_enable	 = function() {
		/// @func	update_enable()
		/// @desc	set the update actions to be enabled, so that they are run during the update() tick
		/// @return {Ui} self
		///
		__this.__update.__active = true;
		return self;
	};
	static update_disable	 = function() {
		/// @func	update_disable()
		/// @desc	set the update actions to be disabled, so that they are NOT run during the update() tick
		/// @return {Ui} self
		///
		__this.__update.__active = false;
		return self;
	};
	static update_toggle	 = function() {
		/// @func	update_toggle()
		/// @desc	toggle the update actions to be enabled/disabled during the update() tick
		/// @return {Ui} self
		///
		__this.__update.__active = !__this.__update.__active;
		return self;
	};
	static update_set_active = function(_update) {
		/// @func	update_set_active(update?)
		/// @param	{boolean} update?
		/// @desc	set whether or not the update actions should be enabled to run during the update() tick
		/// @return {Ui} self
		///
		__this.__update.__active = _update;
		return self;
	};
	
	/// Render
	static render_add_action = function(_render_action, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	render_add_action(render_action, auto_bind_methods?*)
		/// @desc	add a new action/method to the render stack for execution in the render() tick.
		/// @param	{method/function} render_action			->	method/function to be used for said "action"
		/// @param	{boolean}		  auto_bind_methods?*	->	should the render_action method be bound to the Ui() component class automatically?
		///														if this is disabled, then whichever binding is configured upon pass-through will be used.
		///														see GameMaker's method() function for more information 
		///														https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Variable_Functions/method.htm
		/// @return {Ui} self
		///
		if (_auto_bind_method) {
			_render_action = method(self, _render_action);	
		}
		with (__this.__render) {
			array_push(__methods, _render_action);	
			__size++;
		}
		return self;
	};
	static render_enable	 = function() {
		/// @func	render_enable()
		/// @desc	set the render actions to be enabled, so that they are run during the render() tick
		/// @return {Ui} self
		///
		__this.__render.__active = true;
		return self;
	};
	static render_disable	 = function() {
		/// @func	render_disable()
		/// @desc	set the render actions to be disabled, so that they are NOT run during the render() tick
		/// @return {Ui} self
		///
		__this.__render.__active = false;
		return self;
	};
	static render_toggle	 = function() {
		/// @func	render_toggle()
		/// @desc	toggle the render actions to be enabled/disabled during the render() tick
		/// @return {Ui} self
		///
		__this.__render.__active = !__this.__render.__active;
		return self;
	};
	static render_set_active = function(_render) {
		/// @func	render_set_active(render?)
		/// @param	{boolean} render?
		/// @desc	set whether or not the render actions should be enabled to run during the render() tick
		/// @return {Ui} self
		///
		__this.__render.__active = _render;
		return self;
	};	
	
	/// Hover
	static hover_execute_enter	   = function() {
		/// @func	hover_execute_enter()
		/// @desc	method to invoke for one-time-execution of the hover_enter logic bound to the
		///			hover_on_enter stack. this will most likely not need to be manually invoked, and 
		///			should be handled automatically based off of defined triggers.
		/// @return {UiInteractor} self
		///
		with (__this.__events.__on_hover) {
			if (__enter.__active) {
				with (__enter.__action) {
					for (var _i = 0; _i < __size; _i++) {
						__methods[_i]();	
					}
				}
			}
		}
		return self;
	};
	static hover_enter_add_action  = function(_hover_enter_action, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	hover_enter_add_action(hover_enter_action, auto_bind_methods?*)
		/// @desc	add a new action/method to the on_hover_enter stack for execution when hover_enter is triggered.
		///			see hover_enter_add_trigger() for configuring a trigger that would execute the on_hover_enter stack.
		/// @param	{method/function} hover_enter_action
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_hover_enter_action = method(self, _hover_enter_action);	
		}
		with (__this.__events.__on_hover.__enter.__action) {
			array_push(__methods, _hover_enter_action);
			__size++;
		}
		return self;	
	};
	static hover_enter_add_trigger = function(_hover_enter_trigger, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	hover_enter_add_trigger(hover_enter_trigger, auto_bind_methods?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the hover_on_enter 
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} hover_enter_trigger
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_hover_enter_trigger = method(self, _hover_enter_trigger);	
		}
		with (__this.__events.__on_hover.__enter.__trigger) {
			array_push(__methods, _hover_enter_trigger);
			__size++;
		}
		return self;	
	};
	static hover_execute_hold	   = function() {
		/// @func	hover_execute_hold()
		/// @desc	method to invoke for one-time-execution of the hover_hold logic bound to the
		///			hover_on_hold stack. this will most likely not need to be manually invoked, and 
		///			should be handled automatically based off of defined triggers.
		/// @return {UiInteractor} self
		///
		if (__this.__events.__on_hover.__hold.__active) {
			with (__this.__events.__on_hover.__hold.__action) {
				for (var _i = 0; _i < __size; _i++) {
					__methods[_i]();	
				}
			}
		}
		return self;
	};
	static hover_hold_add_action   = function(_hover_hold_action, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	hover_hold_add_action(hover_hold_action, auto_bind_methods?*)
		/// @desc	add a new action/method to the on_hover_hold stack for execution when hover_hold is triggered.
		///			see hover_hold_add_trigger() for configuring a trigger that would execute the on_hover_hold stack.
		/// @param	{method/function} hover_hold_action
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_hover_hold_action = method(self, _hover_hold_action);	
		}
		with (__this.__events.__on_hover.__hold.__action) {
			array_push(__methods, _hover_hold_action);
			__size++;
		}
		return self;	
	};
	static hover_hold_add_trigger  = function(_hover_hold_trigger, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	hover_hold_add_trigger(hover_hold_trigger, auto_bind_methods?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the hover_on_hold
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} hover_hold_trigger
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_hover_hold_trigger = method(self, _hover_hold_trigger);	
		}
		with (__this.__events.__on_hover.__hold.__trigger) {
			array_push(__methods, _hover_hold_trigger);
			__size++;
		}
		return self;
	};
	static hover_execute_exit	   = function() {
		/// @func	hover_execute_exit()
		/// @desc	method to invoke for one-time-execution of the hover_exit logic bound to the
		///			hover_on_exit stack. this will most likely not need to be manually invoked, and 
		///			should be handled automatically based off of defined triggers.
		/// @return {UiInteractor} self
		///
		with (__this.__events.__on_hover) {
			if (__leave.__active) {
				with (__leave.__action) {
					for (var _i = 0; _i < __size; _i++) {
						__methods[_i]();	
					}
				}
			}
		}
		return self;
	};
	static hover_exit_add_action   = function(_hover_leave_action, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	hover_exit_add_action(hover_leave_action, auto_bind_methods?*)
		/// @desc	add a new action/method to the on_hover_enter stack for execution when hover_enter is triggered.
		///			see hover_enter_add_trigger() for configuring a trigger that would execute the on_hover_enter stack.
		/// @param	{method/function} hover_leave_action
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_hover_leave_action = method(self, _hover_leave_action);	
		}
		with (__this.__events.__on_hover.__leave.__action) {
			array_push(__methods, _hover_leave_action);
			__size++;
		}
		return self;	
	};
	static hover_exit_add_trigger  = function(_hover_leave_trigger, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	hover_exit_add_trigger(hover_leave_trigger, auto_bind_methods?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the hover_on_exit
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} hover_leave_trigger
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_hover_leave_trigger = method(self, _hover_leave_trigger);	
		}
		with (__this.__events.__on_hover.__leave.__trigger) {
			array_push(__methods, _hover_leave_trigger);
			__size++;
		}
		return self;
	};
	
	/// Click
	static click_execute_pressed	  = function() {
		/// @func	click_execute_pressed()
		/// @desc	method to invoke for one-time-execution of the click_pressed logic bound to the
		///			click_pressed stack. this will most likely not need to be manually invoked, and 
		///			should be handled automatically based off of defined triggers.
		/// @return {UiInteractor} self
		///
		if (__this.__events.__on_click.__pressed.__active) {
			with (__this.__events.__on_click.__pressed.__action) {
				for (var _i = 0; _i < __size; _i++) {
					__methods[_i]();	
				}
			}
		}
		return self;
	};
	static click_pressed_add_action	  = function(_click_pressed_action, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	click_pressed_add_action(click_pressed_action, auto_bind_methods?*)
		/// @desc	add a new action/method to the click_pressed stack for execution when click_pressed is triggered.
		///			see click_pressed_add_trigger() for configuring a trigger that would execute the on_click_pressed stack.
		/// @param	{method/function} click_pressed_action
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_click_pressed_action = method(self, _click_pressed_action);	
		}
		with (__this.__events.__on_click.__pressed.__action) {
			array_push(__methods, _click_pressed_action);
			__size++;
		}
		return self;	
	};
	static click_pressed_add_trigger  = function(_click_pressed_trigger, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	click_pressed_add_trigger(click_pressed_trigger, auto_bind_methods?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the click_pressed
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} click_pressed_trigger
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_click_pressed_trigger = method(self, _click_pressed_trigger);	
		}
		with (__this.__events.__on_click.__pressed.__trigger) {
			array_push(__methods, _click_pressed_trigger);
			__size++;
		}
		return self;	
	};
	static click_execute_down		  = function() {
		/// @func	click_execute_down()
		/// @desc	method to invoke for one-time-execution of the click_down logic bound to the
		///			click_down stack. this will most likely not need to be manually invoked, and
		/// @return {UiInteractor} self
		///
		if (__this.__events.__on_click.__down.__active) {
			with (__this.__events.__down.__hold.__action) {
				for (var _i = 0; _i < __size; _i++) {
					__methods[_i]();	
				}
			}
		}
		return self;
	};
	static click_down_add_action	  = function(_click_down_action, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	click_down_add_action(click_down_action, auto_bind_methods?*)
		/// @desc	add a new action/method to the click_down stack for execution when click_down is triggered.
		///			see click_down_add_trigger() for configuring a trigger that would execute the on_click_down stack.
		/// @param	{method/function} click_down_action
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_click_down_action = method(self, _click_down_action);	
		}
		with (__this.__events.__on_click.__down.__action) {
			array_push(__methods, _click_down_action);
			__size++;
		}
		return self;	
	};
	static click_down_add_trigger	  = function(_click_down_trigger, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	click_down_add_trigger(click_down_trigger, auto_bind_methods?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the click_down
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} click_down_trigger
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_click_down_trigger = method(self, _click_down_trigger);	
		}
		with (__this.__events.__on_click.__down.__trigger) {
			array_push(__methods, _click_down_trigger);
			__size++;
		}
		return self;	
	};
	static click_execute_released	  = function() {
		/// @func	click_execute_released()
		/// @desc	method to invoke for one-time-execution of the click_released logic bound to the
		///			click_released stack. this will most likely not need to be manually invoked, and
		/// @return {UiInteractor} self
		///
		if (__this.__events.__on_click.__released.__active) {
			with (__this.__events.__on_click.__released.__action) {
				for (var _i = 0; _i < __size; _i++) {
					__methods[_i]();	
				}
			}
		}
		return self;
	};
	static click_released_add_action  = function(_click_released_action, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	click_released_add_action(click_released_action, auto_bind_methods?*)
		/// @desc	add a new action/method to the click_released stack for execution when click_released is triggered.
		///			see click_released_add_trigger() for configuring a trigger that would execute the on_click_released stack.
		/// @param	{method/function} click_released_action
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_click_released_action = method(self, _click_released_action);	
		}
		with (__this.__events.__on_click.__released.__action) {
			array_push(__methods, _click_released_action);
			__size++;
		}
		return self;	
	};
	static click_released_add_trigger = function(_click_released_trigger, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	click_released_add_trigger(click_released_trigger, auto_bind_methods?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the click_released
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} click_released_trigger
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind_method) {
			_click_released_trigger = method(self, _click_released_trigger);	
		}
		with (__this.__events.__on_click.__released.__trigger) {
			array_push(__methods, _click_released_trigger);
			__size++;
		}
		return self;	
	};
	
	#endregion
	#region State Machine //////////////////
	
	static state_add					= function(_state_name, _state_method, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	state_add(state_name, state_method, auto_bind_methods?*)
		/// @desc	add a new state_method bound to a given state_name
		/// @param	{string}		  state_name
		/// @param	{method/function} state_method
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return	{Ui}			  self
		///
		if (!state_exists(_state_name)) {
			if (_auto_bind_method) {
				_state_method = method(self, _state_method);	
			}
			__this.__state.__states[$ _state_name] = _state_method;
		}
		return self;
	};
	static state_add_on_enter			= function(_state_name, _state_method, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	state_add_on_enter(state_name, state_method, auto_bind_methods?*)
		/// @desc	add a new state_on_enter method bound to a given state_name
		/// @param	{string}		  state_name
		/// @param	{method/function} state_method
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return	{Ui}			  self
		///
		if (!variable_struct_exists(__this.__state.__on_enter, _state_name)) {
			if (_auto_bind_method) {
				_state_method = method(self, _state_method);	
			}
			__this.__state.__on_enter[$ _state_name] = _state_method;
		}
		return self;
	};
	static state_add_on_exit			= function(_state_name, _state_method, _auto_bind_method = default_get("auto_bind_methods")) {
		/// @func	state_add_on_exit(state_name, state_method, auto_bind_methods?*)
		/// @desc	add a new state_on_exit method bound to a given state_name
		/// @param	{string}		  state_name
		/// @param	{method/function} state_method
		/// @param	{boolean}		  auto_bind_methods?*
		/// @return	{Ui}			  self
		///
		if (!variable_struct_exists(__this.__state.__on_exit, _state_name)) {
			if (_auto_bind_method) {
				_state_method = method(self, _state_method);	
			}
			__this.__state.__on_exit[$ _state_name] = _state_method;
		}
		return self;
	};
	static state_add_config				= function(_state_name, _config_name) {
		/// @func	state_add_config(state_name, config_name)
		/// @desc	establish a relationship between a state and a config, so that the config is
		///			automatically updated and applied upon state transition.
		/// @param	{string} state_name
		/// @param	{string} config_name
		/// @return {Ui} self
		///
		if (state_exists(_state_name)) {
			__this.__state.__configs[$ _state_name] = _config_name;	
		}
		return self;
	};
	static state_get					= function(_state_name) {
		/// @func	state_get(state_name)
		/// @desc	return the method associated to the given state name that would be executed during a state update.
		/// @param	{string}		  state_name
		/// @return {method/function} state
		///
		return __this.__state.__states[$ _state_name];
	};
	static state_get_current			= function() {
		/// @func	state_get_current()
		/// @desc	get the currently executing state method
		/// @return {method/function} state
		///
		return __this.__state.__current;
	};
	static state_get_current_name		= function() {
		/// @func	state_get_current_name()
		/// @desc	get the name of the currently executing state method.
		/// @return {string} name
		///
		return __this.__state.__name;
	};
	static state_set_current			= function(_state_name, _state_method, _config_override = undefined, _state_on_change_sync_config = default_get("state_on_change_sync_config")) {
		/// @func	state_set_current(state_name, state_method, config_override*, state_on_change_sync_config?*)	
		/// @desc	set the current state method to that of the passed state_name's method
		/// @param	{string}  state_name
		/// @param	{method}  state_method
		/// @param	{string}  config_override=undefined
		/// @param	{boolean} state_on_change_sync_config?=default
		/// @return	{Ui}	  self
		///
		if (state_execute_on_exit) {
			state_execute_state_on_exit(state_get_current_name());
		}
		
		__this.__state.__name	 = _state_name;
		__this.__state.__current = _state_method;
		
		if (state_execute_on_enter) {
			state_execute_state_on_enter(_state_name);
		}
		
		__state_sync_config(_state_name, _config_override, _state_on_change_sync_config);
		
		return self;
	};
	static state_exists					= function(_state_name) {
		/// @func	state_exists(state_name)
		/// @desc	return if the given state_name has been registered as a state_method.
		/// @param	{string}  state_name
		/// @return {boolean} state_exists?
		///
		return variable_struct_exists(__this.__state.__states, _state_name);
	};
	static state_change					= function(_state_name) {
		/// @func	state_change(state_name)
		/// @desc	do state transition if a state exists with the given name.
		/// @param	{string} state_name
		/// @return {Ui}	 self
		///
		return state_change_ext(_state_name);
	};
	static state_change_ext				= function(_state_name, _config_override = undefined, _state_on_change_sync_config = default_get("state_on_change_sync_config")) {
		/// @func	state_change_ext(state_name, config_override*, state_on_change_sync_config?*)
		/// @desc	do state transition if a state exists with the given name.
		/// @param	{string}  state_name
		/// @param	{string}  config_override=undefined
		/// @param	{boolean} state_on_change_sync_config=default
		/// @return {Ui}	  self
		///
		if (state_exists(_state_name)) {
			state_set_current(_state_name, state_get(_state_name), _config_override, _state_on_change_sync_config);
		}
		return self;
	};
	static state_execute				= function() {
		/// @func	state_execute()
		/// @return {Ui} self
		///
		var _state_current  = state_get_current();
		if (_state_current != undefined) {
			_state_current();	
		}
		return self;
	};
	static state_is						= function(_state_name) {
		/// @func	state_is(state_name)
		/// @desc	check if the current state_is the same as that of the passed in state_name
		/// @param	{string}  state_name 
		/// @return {boolean} state_is?
		///
		return _state_name == state_get_current_name();
	};
	static state_execute_state_on_enter = function(_state_name) {
		/// @func	state_execute_state_on_enter(state_name)
		/// @desc	one-time encapsulation of the state_on_enter logic. this method will probably not need to be 
		///			manually invoked, and should be executed automatically if state_execute_on_enter is toggled to true
		/// @param	{string} name
		/// @return {Ui} self
		///
		if (variable_struct_exists(__this.__state.__on_enter, _state_name)) {
			__this.__state.__on_enter[$ _state_name]();	
		}
		return self;
	};
	static state_execute_state_on_exit  = function(_state_name) {
		/// @func	state_execute_state_on_exit(state_name)
		/// @desc	one-time encapsulation of the state_on_exit logic. this method will probably not need to be 
		///			manually invoked, and should be executed automatically if state_execute_on_exit is toggled to true
		/// @param	{string} name
		/// @return {Ui} self
		///
		if (variable_struct_exists(__this.__state.__on_exit, _state_name)) {
			__this.__state.__on_exit[$ _state_name]();	
		}
		return self;
	};
	
	static __state_sync_config			= function(_state_name, _config_override, _state_on_change_sync_config) {
		/// @func	__state_sync_config(state_name, config_override, state_on_change_sync_config) 
		/// @param	{string}  state_name
		/// @param	{string}  config_overide
		/// @param	{boolean} state_on_change_sync_config?
		/// @return NA
		///
		var _config = undefined;
		
		/// Check For Config Override
		if (_config_override != undefined && config_exists(_config_override)) {
			_config = _config_override;
		}
		/// Check For Config Binding
		if (_config == undefined) {
			var _config_bind  = __this.__state.__configs[$ _state_name];
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
		return self;
	};
		
	#endregion
	#region Configs ////////////////////////
	
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
		properties_update(_config_struct);
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
	static config_apply_state		 = function (_state_name, _check_for_state_config = default_get("state_on_change_sync_config")) {
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
		/// @param	{bool} restore_all_properties?=true
		/// @return {Ui} self
		///
		if (_restore_all_properties) {
			properties_update(config_get_default());	// wipe all values to default first
		}
		return config_change(config_get_start_name());
	};
	static config_restore_to_default = function() {
		/// @func	config_restore_to_default()
		/// @return {Ui} self
		///
		return config_change(config_get_default_name());
	};
	
	static property_add				 = function(_config_in, _property_name, _default_value, _add_to_start_config = true) {
		/// @func	property_add(config_in, property_name, default_value, add_to_start_config?*)
		/// @param	{struct}  config_in
		/// @param	{string}  property_name
		/// @param	{any}	  default_value
		/// @param	{boolean} add_to_start_config=true
		/// @return {any}	  value
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
		/// Store Property Setter() For Dynamic Updates In properties_update()
		__this.__config.__properties[$ _property_name] = {
			setter: variable_struct_get(self, "set_" + _property_name),	
		};
		/// Store Default Property
		default_set(_property_name, _default_value);
		
		return _value;
	};
	static properties_update		 = function(_config = config_get_current()) {
		/// @func	properties_update(config*)
		/// @desc	assign the values of the given config_struct to self ui component.
		/// @param	{struct} config=config_get_current()
		/// @return {Ui} self
		///
		var _property_names = variable_struct_get_names(_config); 
		for (var _i = 0, _len = array_length(_property_names); _i < _len; _i++) {
			var _property_name    = _property_names[_i];
			var _property_setter  = __this.__config.__properties[$ _property_name].setter;
			if (_property_setter != undefined) {
				_property_setter(_config[$ _property_name]);
			}
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
		properties_update(_config_default_struct);
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
			property_add(_config_struct, _property_name, _property_default, false);
		}
	};
	
	#endregion
	#region Interactions ///////////////////
	
	static mouse_touching = function() {
		/// @func	mouse_touching()
		/// @desc	return if the mouse is currently touching the component.
		/// @return {boolean} mouse_touching?
		///
		var _mxy = get_mouse_xy();
		log("mxy.x: {0}, mxy.y: {1}, x: {2}, y: {3}", _mxy.x, _mxy.y, x, y);
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
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function UiPanel  (_owner = self, _config_name = __UI_COMPONENT_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_owner, _config_name, _config) constructor {
	/// @func  UiPanel(config) : Ui(config)
	/// @param {bool} outline*
	///
	outline = property_add(_config, "outline", false);
	
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
		return outline;
	};
		
	/// Setters
	static set_outline = function(_outline) {
		/// @func	set_outline(outline)
		/// @param	{real} outline
		/// @return {Ui} self
		///
		outline = _outline;
		return self;
	};
		
	#endregion
	
	render_add_action(render, true);
};
function UiLabel  (_owner = self, _config_name = __UI_COMPONENT_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_owner, _config_name, _config) constructor {
	/// @func  UiLabel(config) : Ui(config)
	/// @param {string}	  text*
	/// @param {bool}	  wrap*
	/// @param {real}	  wrap_width*
	/// @param {real}	  line_space*
	/// @param {constant} halign*
	/// @param {constant} valign*
	///
	text	   = property_add(_config, "text",		 "");
	wrap_apply = property_add(_config, "wrap_apply", false);
	wrap_width = property_add(_config, "wrap_width", -1);
	line_space = property_add(_config, "line_space", -1);
	halign	   = property_add(_config, "halign",	 fa_left);
	valign	   = property_add(_config, "valign",	 fa_top);
		
	#region Core ///////////////////
	
	static render = function() {
		/// @func	render()
		/// @return {UiLabel} self
		///
		if (has_text()) {
			draw_set_halign(halign);
			draw_set_valign(valign);
			
			var _color = get_color();
			
			if (wrap && wrap_width != -1) {
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
		return text;
	};
	static get_wrap_apply = function() {
		/// @func	get_wrap_apply()
		/// @return {bool} wrap_apply?
		///
		return wrap_apply;
	};
	static get_wrap_width = function() {
		/// @func	get_wrap_width()
		/// @return {real} wrap_width
		///
		return wrap_width;
	};
	static get_line_space = function() {
		/// @func	get_line_space()
		/// @return {real} line_space
		///
		return line_space;
	};
	static get_halign	  = function() {
		/// @func	get_halign()
		/// @return {constant} horizontal alignment
		///
		return halign;
	};
	static get_valign	  = function() {
		/// @func	get_valign()
		/// @return {constant} vertical alignment
		///
		return valign;
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
		text = _text;
		return self;
	};
	static set_wrap_apply = function(_wrap_apply) {
		/// @func	set_wrap_apply(wrap_apply?)
		/// @param	{bool} wrap_apply?
		/// @return {Ui} self
		///
		wrap_apply = _wrap_apply;
		return self;
	};
	static set_wrap_width = function(_wrap_width) {
		/// @func	set_wrap_width(wrap_width)
		/// @param	{real} wrap_width
		/// @return {Ui} self
		///
		wrap_width = _wrap_width;
		return self;
	};
	static set_line_space = function(_line_space) {
		/// @func	set_line_space(line_space)
		/// @param	{real} line_space
		/// @return {Ui} self
		///
		line_space = _line_space;
		return self;
	};
	static set_halign	  = function(_halign) {
		/// @func	set_halign(halign)
		/// @param	{constant} halign
		/// @return {Ui} self
		///
		halign = _halign;
		return self;
	};
	static set_valign	  = function(_valign) {
		/// @func	set_valign(valign)
		/// @param	{constant} valign
		/// @return {Ui} self
		///
		valign = _valign;
		return self;
	};
		
	/// Checkers
	static has_text = function() {
		/// @func	has_text()
		/// @return {boolean} has_text?
		///
		return text != "" && text != undefined;
	};
	
	#endregion
	
	render_add_action(render, true);
};
function UiSprite (_owner = self, _config_name = __UI_COMPONENT_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_owner, _config_name, _config) constructor {
	/// @func  UiSprite(config) : Ui(config)
	/// @param {sprite_index} sprite*
	/// @param {real} image*
	/// @param {real} speed*
	///
	if (!variable_struct_exists(_config, "sprite")) {
		throw("***error in UiSprite*** sprite not defined.");	
	}
		
	sprite = property_add(_config, "sprite", undefined);
	image  = property_add(_config, "image",  0);
	speed  = property_add(_config, "speed",  1);

	#region Core ///////////////////
	
	static update = function() {
		/// @func	update()
		/// @return {UiSprite} self
		///
		if (speed > 0) {
			image += speed;
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
		return sprite;
	};
	static get_index	= function() {
		/// @func	get_index()
		/// @return {real} sprite_index
		///
		return sprite;
	};
	static get_image	= function() {
		/// @func	get_image()
		/// @return {real} image_index
		///
		return image;	
	};
	static get_frame	= function() {
		/// @func	get_frame()
		/// @return {real} image_index
		///
		return image;	
	};
	static get_speed	= function() {
		/// @func	get_speed()
		/// @return {real} image_speed
		///
		return speed;	
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
		sprite = _sprite;
		return self;
	};
	static set_index	= function(_index) {
		/// @func	set_sprite(index)
		/// @param	{real}	   sprite_index
		/// @return {UiSprite} self
		///
		sprite = _index;
		return self;
	};
	static set_image	= function(_image) {
		/// @func	set_image(image)
		/// @param	{real}	   image
		/// @return {UiSprite} self
		///
		image = _image;
		return self;
	};
	static set_frame	= function(_frame) {
		/// @func	set_frame(frame)
		/// @param	{real}	   frame
		/// @return {UiSprite} self
		///
		image = _frame;
		return self;
	};
	static set_speed	= function(_speed) {
		/// @func	set_speed(speed)
		/// @param	{real}	   speed
		/// @return {UiSprite} self
		///
		speed = _speed;
		return self;
	};
	static set_scale	= function(_scale, _yscale = _scale) {
		/// @func	set_scale(scale, yscale*)
		/// @param	{real}	   scale
		/// @param	{real}	   yscale=scale
		/// @return {UiSprite} self
		///
		xscale =  _scale;
		yscale = _yscale;
		return self;
	};
	static set_angle	= function(_angle) {
		/// @func	set_angle(angle)
		/// @param	{real}	   angle
		/// @return {UiSprite} self
		///
		angle = _angle;
		return self;
	};
	
	#endregion
	
	update_add_action(update, true);
	render_add_action(render, true);
};
function UiLine   (_owner = self, _config_name = __UI_COMPONENT_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_owner, _config_name, _config) constructor {
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
		if (__this.__point.__left_most   == undefined || _x < __this.__point.__left_most  ) __this.__point.__left_most   = _x;	
		if (__this.__point.__right_most  == undefined || _x > __this.__point.__right_most ) __this.__point.__right_most  = _x;	
		if (__this.__point.__top_most    == undefined || _y < __this.__point.__top_most   ) __this.__point.__top_most    = _y;	
		if (__this.__point.__bottom_most == undefined || _y > __this.__point.__bottom_most) __this.__point.__bottom_most = _y;	
		
		return self;
	};
	
	#endregion
	#region Getters & Setters //////
	
	/// Getters
	static get_width	= function() {	/// @OVERRIDE
		/// @func	get_width()
		/// @return {real} width
		///
		return __this.__point.__right_most - __this.__point.__left_most;
	};
	static get_height	= function() {	/// @OVERRIDE
		/// @func	get_height()
		/// @return {real} height
		///
		return __this.__point.__bottom_most - __this.__point.__top_most;
	};
	static get_left		= function() {	/// @OVERRIDE
		/// @func	get_left()
		/// @return {real} x_pos
		///
		return __this.__point.__left_most;
	};
	static get_right	= function() {	/// @OVERRIDE
		/// @func	get_right()
		/// @return {real} x_pos
		///
		return __this.__point.__right_most;
	};
	static get_top		= function() {	/// @OVERRIDE
		/// @func	get_top()
		/// @return {real} y_pos
		///
		return __this.__point.__top_most;
	};
	static get_bottom	= function() {	/// @OVERRIDE
		/// @func	get_bottom()
		/// @return {real} y_pos
		///
		return __this.__point.__bottom_most;
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
	
	render_add_action(render, true);
};
function UiCircle (_owner = self, _config_name = __UI_COMPONENT_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_owner, _config_name, _config) constructor {
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
};
function UiTextbox(_owner = self, _config_name = __UI_COMPONENT_DEFAULT_CONFIG_NAME_START, _config = {}) : Ui(_owner, _config_name, _config) constructor {
	/// @func UiTextbox(config) : Ui(config)
	///
	exit; // <-- not yet ready
	
	static render = function() {};
};


