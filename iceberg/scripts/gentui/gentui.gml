/////////////////////////////////////
// .---. r---. .   . .---. .   . . //
// |  -. r--   | \ |   |   |   | | //
// L---J L---J |   V   |   L---J | //
#region //////////////////////$(*)>//

#region about ///////////////////////
/*
	written_by:__gentoo_____________
	version:_____0.2.0______________
*/
#endregion
#region change log //////////////////

#region version 0.2.x

#region version 0.2.0
/*
	Date: 06/14/2022
	1.	merged in fryman's pull request updating return values for state_execute_... methods
	2.	added method descriptions for Ui() base component class
	3.	renamed set_execute_on_enter() to set_state_execute_on_enter()
	4.	renamed set_execute_on_exit() to set_state_execute_on_exit()
	5.	renamed hover_enter() to hover_execute_enter() 
	6.	renamed hover_hold() to hover_execute_hold() 
	7.	renamed hover_leave() to hover_execute_exit() 
			- let's normalize the "leave" keyword, and use "exit" instead, and will use this for all similarly named methods
	8.	renamed hover_leave_add_action() to hover_exit_add_action()
	9.	renamed hover_leave_add_trigger() to hover_exit_add_trigger()
	10. renamed click_pressed() to click_execute_pressed()
	11. renamed click_down() to click_execute_down()
	12. renamed click_released() to click_execute_released()
	xx.	added new UiComponent -> UiCircle() implementing draw_circle_curve() functionality
	xx.	added new UiComponent -> UiTextbox() 
*/
#endregion

#endregion
#region version 0.1.x

#region version 0.1.1
/*	
	Date: 05/26/2022
	1. components now propegate their alpha values down to pinned children components
	2. global config macros to toggle property propegation
	3. components now implement local property instantiations of the following global default macros:
		- execute_on_enter
		- execute_on_exit
		- propegate_pos_to_child
		- propegate_scale_to_child
		- propegate_alpha_to_child
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
/*
	- to implement...
*/
#endregion
#region upcoming features ///////////
/*
	- ability to have parent components implement child components' update() and render() methods automatically
		- additionally, setup corresponding depth system for custom depth sorting if automatic updates and renders are used
	- propegate parent angle to children components
	- have mouse click detection and interactions respond to different angles. currently not supported!
	- docs & help
	- improve performance with draw_rectangle_alt, draw_line_alt utilizing one pixel sprite
		- dynamically generate one pixel sprite using surface, sprite_save, etc
	- add support for UI components to render contents to a surface
		- only update surface contents when necessary, and bake children surfaces onto parent
*/
#endregion
#region default config values ///////

#macro __UI_DEFAULT_AUTO_BIND_METHODS					false
														
#macro __UI_COMPONENT_DEFAULT_VISIBLE					true
#macro __UI_COMPONENT_DEFAULT_ALPHA						1.0
#macro __UI_COMPONENT_DEFAULT_COLOR						c_white
#macro __UI_COMPONENT_DEFAULT_X							0
#macro __UI_COMPONENT_DEFAULT_Y							0
#macro __UI_COMPONENT_DEFAULT_WIDTH						0
#macro __UI_COMPONENT_DEFAULT_HEIGHT					0
#macro __UI_COMPONENT_DEFAULT_ANGLE						0
#macro __UI_COMPONENT_DEFAULT_SCALE						1
#macro __UI_COMPONENT_DEFAULT_XSCALE					1
#macro __UI_COMPONENT_DEFAULT_YSCALE					1
#macro __UI_COMPONENT_DEFAULT_OUTLINE					false
#macro __UI_COMPONENT_DEFAULT_THICKNESS					1
#macro __UI_COMPONENT_DEFAULT_INPUT_DEVICE				0
#macro __UI_COMPONENT_DEFAULT_USE_GUI_SPACE				false
#macro __UI_COMPONENT_DEFAULT_LABEL_TEXT				""
#macro __UI_COMPONENT_DEFAULT_LABEL_WRAP				false
#macro __UI_COMPONENT_DEFAULT_LABEL_WRAP_WIDTH		   -1
#macro __UI_COMPONENT_DEFAULT_LABEL_LINE_SPACE		   -1
#macro __UI_COMPONENT_DEFAULT_LABEL_HALIGN				fa_left
#macro __UI_COMPONENT_DEFAULT_LABEL_VALIGN				fa_top
#macro __UI_COMPONENT_DEFAULT_SPRITE_IMAGE_INDEX		0
#macro __UI_COMPONENT_DEFAULT_SPRITE_IMAGE_SPEED		1
#macro __UI_COMPONENT_DEFAULT_STATE_EXECUTE_ON_ENTER	true
#macro __UI_COMPONENT_DEFAULT_STATE_EXECUTE_ON_EXIT		true
#macro __UI_COMPONENT_DEFAULT_PROPEGATE_POS_TO_CHILD	true
#macro __UI_COMPONENT_DEFAULT_PROPEGATE_SCALE_TO_CHILD	true
#macro __UI_COMPONENT_DEFAULT_PROPEGATE_ALPHA_TO_CHILD	false

#endregion

#endregion
function Ui(_config) constructor {
	/// @func  Ui(config)
	///
	/// @desc  this is the base ui component, containing all core features and functionality that is inherited and implemented
	///		   by all other ui components. an instance of this class will have no visual representation, but can still be utilized
	///		   for creating more "abstract" data containers. see UiLine().add_point() for an example, where a "point" is created
	///		   by instantiating a new Ui() class instance, and passing in x & y values for later reference.
	///
	/// @use   generally this class will be implemented through inheritance of the other Ui components; however, if you wish to implement
	///		   an explicit instance of this class, you can do so using the following: 
	///		   var _abstractUiPointContainer = new Ui({x : _x, y: _y});		/// creates a component containing coordinate points
	///
	/// @param {instance/struct} owner=other
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
	/// @param {bool}  propegate_position*
	/// @param {bool}  propegate_scale*
	/// @param {bool}  propegate_alpha*
	///
	#region Properties 
	
	_				 = {
		update: {
			active:  true,
			methods: [],
			size:	 0,
		},
		render: {
			active:  true,
			methods: [],
			size:	 0,
		},
		state:  {
			active:   true,
			current:  undefined,	
			name:	  "",
			states:   {}, 
			on_enter: {},
			on_exit:  {},
		},
		pin:    {
			pins:	[],
			size:	0,
			parent:	undefined,
			xoff:	0,
			yoff:	0,
		},
		events: {
			on_hover: {
				enter: {
					active:    true,
					action:    {
						methods: [],	
						size:    0,	
					},
					trigger:   {
						methods: [],
						size:    0,
					},
					did_enter: false,
				},
				hold:  {
					active:  true,
					action:  {
						methods: [],	
						size:    0,	
					},
					trigger: {
						methods: [],
						size:    0,
					},
				},
				leave: {
					active:    true,
					action:    {
						methods: [],	
						size:    0,	
					},
					trigger:   {
						methods: [],
						size:    0,
					},
					did_leave: false,
				},
			},
			on_click: {
				pressed: {
					active:  true,
					action:  {
						methods: [],	
						size:    0,	
					},
					trigger: {
						methods: [],
						size:    0,
					},
				},
				down: {
					active:  true,
					action:  {
						methods: [],	
						size:    0,	
					},
					trigger: {
						methods: [],
						size:    0,
					},
				},
				released: {
					active:  true,
					action:  {
						methods: [],	
						size:    0,	
					},
					trigger: {
						methods: [],
						size:    0,
					},
				},
			},
		},
	};	
	owner			 = _config[$ "owner"		   ] ?? other;
	x				 = _config[$ "x"			   ] ?? __UI_COMPONENT_DEFAULT_X;
	y				 = _config[$ "y"			   ] ?? __UI_COMPONENT_DEFAULT_Y;
	color			 = _config[$ "color"		   ] ?? __UI_COMPONENT_DEFAULT_COLOR;
	alpha			 = _config[$ "alpha"		   ] ?? __UI_COMPONENT_DEFAULT_ALPHA;
	angle			 = _config[$ "angle"		   ] ?? __UI_COMPONENT_DEFAULT_ANGLE;
	scale			 = _config[$ "scale"		   ] ?? __UI_COMPONENT_DEFAULT_SCALE;
	xscale			 = _config[$ "xscale"		   ] ?? __UI_COMPONENT_DEFAULT_XSCALE;
	yscale			 = _config[$ "yscale"		   ] ?? __UI_COMPONENT_DEFAULT_YSCALE;
	width			 = _config[$ "width"		   ] ?? __UI_COMPONENT_DEFAULT_WIDTH  * scale;
	height			 = _config[$ "height"		   ] ?? __UI_COMPONENT_DEFAULT_HEIGHT * scale;
	visible			 = _config[$ "visible"		   ] ?? __UI_COMPONENT_DEFAULT_VISIBLE;
	thickness		 = _config[$ "thickness"	   ] ?? __UI_COMPONENT_DEFAULT_THICKNESS;
	input_device	 = _config[$ "input_device"	   ] ?? __UI_COMPONENT_DEFAULT_INPUT_DEVICE;
	use_gui_space	 = _config[$ "use_gui_space"   ] ?? __UI_COMPONENT_DEFAULT_USE_GUI_SPACE;
	execute_on_enter = _config[$ "execute_on_enter"] ?? __UI_COMPONENT_DEFAULT_STATE_EXECUTE_ON_ENTER;
	execute_on_exit	 = _config[$ "execute_on_exit" ] ?? __UI_COMPONENT_DEFAULT_STATE_EXECUTE_ON_EXIT;
	propegate_pos	 = _config[$ "propegate_pos"   ] ?? __UI_COMPONENT_DEFAULT_PROPEGATE_POS_TO_CHILD;
	propegate_scale	 = _config[$ "propegate_scale" ] ?? __UI_COMPONENT_DEFAULT_PROPEGATE_SCALE_TO_CHILD;
	propegate_alpha	 = _config[$ "propegate_alpha" ] ?? __UI_COMPONENT_DEFAULT_PROPEGATE_ALPHA_TO_CHILD;
	
	#endregion
	#region Core 
	
	static step = function() {
		/// @func	step()
		/// @desc	tick update for the component class. call this in a step event, or
		///			wherever the code for this component class should be updated.
		/// @return	{Ui} self
		///
		if (_.update.active) {
			for (var _i = 0; _i < _.update.size; _i++) {
				_.update.methods[_i]();	
			}
		}
		if (_.state.active) {
			state_execute();
		};
			
		#region Check For Event Triggers
		
		var _self = self;
		with (_.events) {
			if (on_click.pressed.active) {
				with (on_click.pressed.trigger) {
					for (var _i = 0; _i < size; _i++) {
						if (methods[_i]()) {
							_self.click_execute_pressed();
							break;	
						}
					};
				}
			}
			if (on_click.down.active) {
				with (on_click.down.trigger) {
					for (var _i = 0; _i < size; _i++) {
						if (methods[_i]()) {
							_self.click_execute_down();
							break;	
						}
					};
				}
			}
			if (on_click.released.active) {
				with (on_click.released.trigger) {
					for (var _i = 0; _i < size; _i++) {
						if (methods[_i]()) {
							_self.click_execute_released();
							break;	
						}
					};
				}
			}
			if (on_hover.enter.active) {
				with (on_hover.enter) {
					for (var _i = 0; _i < trigger.size; _i++) {
						if (trigger.methods[_i]()) {
							if (!did_enter) {
								_self.hover_execute_enter();
								did_enter = true;
								break;	
							}
						}
						else {
							did_enter = false;
						}
					};
				}
			}
			if (on_hover.hold.active) {
				with (on_hover.hold) {
					for (var _i = 0; _i < trigger.size; _i++) {
						if (trigger.methods[_i]()) {
							_self.hover_execute_hold();
							break;	
						}
					};
				}
			}
			if (on_hover.leave.active) {
				with (on_hover.leave) {
					for (var _i = 0; _i < trigger.size; _i++) {
						if (trigger.methods[_i]()) {
							if (!did_leave) {
								_self.hover_execute_exit();
								did_leave = true;
								break;	
							}
						}
						else {
							did_leave = false;
						}
					};
				}
			}
		}
		
		#endregion
		
		return self;
	};
	static draw = function() {
		/// @func	draw()
		/// @desc	tick update for the component class rendering. call this in a draw 
		///			event, or wherever the code for this component class should be rendered.
		/// @return	{Ui} self
		///
		if (visible && _.render.active) {
			for (var _i = 0; _i < _.render.size; _i++) {
				_.render.methods[_i]();	
			}
		}
		return self;
	};	
	static show	= function() {
		/// @func	show()
		/// @desc	toggle the visibility of component to visible
		/// @return {Ui} self
		///
		set_visible(true);
		return self;
	};
	static hide	= function() {
		/// @func	hide()
		/// @desc	toggle the visibility of component to hidden
		/// @return {Ui} self
		///
		set_visible(false);
		return self;
	};
	
	#endregion
	#region Getters 
	
	static get_owner			= function() {
		/// @func	get_owner()
		/// @return {instance/struct} owner
		///
		return owner;
	};
	static get_x				= function() {
		/// @func	get_x()
		/// @return {real} x
		///
		with (_.pin) {
			if (parent != undefined && other.propegate_pos) {
				return parent.get_x() - (xoff * parent.get_xscale());	// apply parent scale to position offset
			}
		}
		return x;	
	};
	static get_y				= function() {
		/// @func	get_y()
		/// @return {real} y
		///
		with (_.pin) {
			if (parent != undefined && other.propegate_pos) {
				return parent.get_y() - (yoff * parent.get_yscale());	// apply parent scale to position offset
			}
		}
		return y;	
	};
	static get_width			= function() {	/// @OVERRIDE
		/// @func	get_width()
		/// @return {real} width
		///
		return width * get_xscale();
	};
	static get_height			= function() {	/// @OVERRIDE
		/// @func	get_height()
		/// @return {real} height
		///
		return height * get_yscale();
	};
	static get_right			= function() {	/// @OVERRIDE
		/// @func	get_right()
		/// @return {x} right
		///
		return get_x() + get_width();
	};
	static get_left				= function() {	/// @OVERRIDE
		/// @func	get_left()
		/// @return {x} left
		///
		return get_x();
	};
	static get_top				= function() {	/// @OVERRIDE
		/// @func	get_top()
		/// @return {y} top
		///
		return get_y();
	};
	static get_bottom			= function() {	/// @OVERRIDE
		/// @func	get_bottom()
		/// @return {y} bottom
		///
		return get_y() + get_height();
	};
	static get_center_x			= function() {	/// @OVERRIDE
		/// @func	get_center_x()
		/// @return {x} center
		///
		return get_x() + (get_width() * 0.5);
	};
	static get_center_y			= function() {	/// @OVERRIDE
		/// @func	get_center_y()
		/// @return {y} center
		///
		return get_y() + (get_height() * 0.5);
	};
	static get_color			= function() {
		/// @func	get_color()
		/// @return {real} color
		///
		return color;
	};
	static get_alpha			= function() {
		/// @func	get_alpha()
		/// @return {real} alpha
		///
		var _parent_alpha = 1;
		if (_.pin.parent != undefined && propegate_alpha) {
			_parent_alpha = _.pin.parent.get_alpha();
		}
		return alpha * _parent_alpha;
	};
	static get_angle			= function() {
		/// @func	get_angle()
		/// @return {real} angle
		///
		return angle;
	};
	static get_xscale			= function() {
		/// @func	get_xscale()
		/// @return {real} xscale
		///
		return xscale * get_scale();
	};
	static get_yscale			= function() {
		/// @func	get_yscale()
		/// @return {real} yscale
		///
		return yscale * get_scale();
	};
	static get_scale			= function() {
		/// @func	get_scale()
		/// @return {real} scale
		///
		var _parent_scale = 1;
		if (_.pin.parent != undefined && propegate_scale) {
			_parent_scale = _.pin.parent.get_scale();
		}
		return scale * _parent_scale;
	};
	static get_visible			= function() {
		/// @func	get_visible()
		/// @return {boolean} visible
		///
		return visible;
	};
	static get_thickness		= function() {
		/// @func	get_thickness()
		/// @return {real} thickness
		///
		return thickness * get_scale();
	};
	static get_input_device		= function() {
		/// @func	get_input_device()
		/// @desc	input device registered for use with device_mouse_x_...
		/// @return {real} input_device
		
		return input_device;
	};
	static get_use_gui_space	= function() {
		/// @func	get_use_gui_space()
		/// @desc	if toggled to true, component will be rendered on gui_space and look for mouse interactions
		///			with coordinates based off of the gui_space positioning
		/// @return {bool} use_gui_space?
		///
		return use_gui_space;
	};
	static get_mouse_xy			= function() {
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
	static get_execute_on_enter	= function() {
		/// @func	get_execute_on_enter()
		/// @return {boolean} execute_state_on_enter?
		///
		return execute_on_enter;
	};
	static get_execute_on_exit  = function() {
		/// @func	get_execute_on_exit()
		/// @return {boolean} execute_state_on_exit?
		///
		return execute_on_exit;
	};
	static get_propegate_pos	= function() {
		/// @func	get_propegate_pos()
		/// @desc	if propegate_pos toggled to true, the position properties will be sent down to
		///			pinned children and used for their sub-positioning, so that elements stick together
		/// @return {boolean} propegate_position?
		///
		return propegate_pos;
	};
	static get_propegate_scale	= function() {
		/// @func	get_propegate_scale()
		/// @desc	if propegate_scale toggled to true, the scale properties will be sent down to pinned
		///			children and used for their scaling and positioning, so that elements stick/scale together
		/// @return {boolean} propegate_scale?
		///
		return propegate_scale;
	};
	static get_propegate_alpha	= function() {
		/// @func	get_propegate_alpha()
		/// @desc	if propegate_alpha toggled to true, the alpha properties will be sent down to pinned
		///			children and used for their alpha, so that elements blend/fade together
		/// @return {boolean} propegate_alpha?
		///
		return propegate_alpha;
	};
	
	#endregion
	#region Setters
	
	static set_properties			  = function(_properties_struct) {
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
	static set_owner				  = function(_owner) {
		/// @func	set_owner(owner)
		/// @param	{instance/struct} owner
		/// @return {Ui} self
		///
		owner = _owner;
		return self;
	};
	static set_x					  = function(_x) {
		/// @func	set_x(x)
		/// @param	{real} x
		/// @return {Ui} self
		///
		x = _x;
		return self;
	};
	static set_y					  = function(_y) {
		/// @func	set_y(y)
		/// @param	{real} y
		/// @return {Ui} self
		///
		y = _y;
		return self;
	};
	static set_pos					  = function(_x, _y) {
		/// @func	set_y(y)
		/// @param	{real} y
		/// @return {Ui} self
		///
		set_x(_x);
		set_y(_y);
		return self;
	};
	static set_width				  = function(_width) {
		/// @func	set_width(width)
		/// @param	{real} width
		/// @return {Ui} self
		///
		width = _width;
		return self;
	};
	static set_height				  = function(_height) {
		/// @func	set_height(height)
		/// @param	{real} height
		/// @return {Ui} self
		///
		height = _height;
		return self;
	};
	static set_color				  = function(_color) {
		/// @func	set_color(color)
		/// @param	{color} color
		/// @return {Ui} self
		///
		color = _color;
		return self;
	};
	static set_alpha				  = function(_alpha) {
		/// @func	set_alpha(alpha)
		/// @param	{real} alpha
		/// @return {Ui} self
		///
		alpha = _alpha;
		return self;
	};
	static set_angle				  = function(_angle) {
		/// @func	set_angle(angle)
		/// @param	{real} angle
		/// @return {Ui} self
		///
		angle = _angle;
		return self;
	};
	static set_xscale				  = function(_xscale) {
		/// @func	set_xscale(xscale)
		/// @param	{real} xscale
		/// @return {Ui} self
		///
		xscale = _xscale;
		return self;
	};
	static set_yscale				  = function(_yscale) {
		/// @func	set_yscale(yscale)
		/// @param	{real} yscale
		/// @return {Ui} self
		///
		yscale = _yscale;
		return self;
	};
	static set_scale				  = function(_scale) {
		/// @func	set_scale(scale)
		/// @param	{real} scale
		/// @return {Ui} self
		///
		scale = _scale;
		return self;
	};
	static set_visible				  = function(_visible) {
		/// @func	set_visible(visible)
		/// @param	{boolean} visible?
		/// @return {Ui} self
		///
		visible = _visible;
		return self;
	};
	static set_thickness			  = function(_thickness) {
		/// @func	set_thickness(thickness)
		/// @param	{real} thickness
		/// @return {Ui} self
		///
		thickness = _thickness;
		return self;
	};
	static set_input_device			  = function(_device) {
		/// @func	set_input_device(interact_action)
		/// @param	{real}		   device
		/// @return {UiInteractor} self
		///
		input_device = _device;
		return self;
	};
	static set_use_gui_space		  = function(_use_gui_space) {
		/// @func	set_use_gui_space(use_gui_space?)
		/// @param	{boolean}	   use_gui_space?
		/// @return {UiInteractor} self
		///
		use_gui_space = _use_gui_space;
		return self;
	};	
	static set_propegate_pos		  = function(_propegate_pos) {
		/// @func	set_propegate_pos(propegate_pos?)
		/// @param	{boolean}	   propegate_pos?
		/// @return {UiInteractor} self
		///
		propegate_pos = _propegate_pos;
		return self;
	};	
	static set_propegate_scale		  = function(_propegate_scale) {
		/// @func	set_propegate_pos(propegate_scale?)
		/// @param	{boolean}	   propegate_scale?
		/// @return {UiInteractor} self
		///
		propegate_scale = _propegate_scale;
		return self;
	};	
	static set_propegate_alpha		  = function(_propegate_alpha) {
		/// @func	set_propegate_alpha(propegate_alpha?)
		/// @param	{boolean}	   propegate_alpha?
		/// @return {UiInteractor} self
		///
		propegate_alpha = _propegate_alpha;
		return self;
	};	
	static set_state_execute_on_enter = function(_execute_on_enter) {
		/// @func	set_state_execute_on_enter(execute_on_enter?)
		/// @desc	whether or not the defined on_enter state function should execute whenever
		///			transitioning into a new state.
		/// @param	{boolean}	   execute_on_enter?
		/// @return {UiInteractor} self
		///
		execute_on_enter = _execute_on_enter;
		return self;
	};	
	static set_state_execute_on_exit  = function(_execute_on_exit) {
		/// @func	set_state_execute_on_exit(execute_on_exit?)
		/// @desc	whether or not the defined on_exit state function should execute whenever
		///			transitioning out of the current state.
		/// @param	{boolean}	   execute_on_exit?
		/// @return {UiInteractor} self
		///
		execute_on_exit = _execute_on_exit;
		return self;
	};	
		
	#endregion
	#region Actions
	
	/// Update
	static update_add_action = function(_update_action, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	update_add_action(update_action, auto_bind?*)
		/// @desc	adds a new update action into the update stack to be execute on_update()
		/// @param	{method/function} update_action	->	method/function to be used for said "action"
		/// @param	{boolean}		  auto_bind?*	->	should the update_action method be bound to the Ui() component class automatically?
		///												if this is disabled, then whichever binding is configured upon pass-through will be used.
		///												see GameMaker's method() function for more information 
		///												https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Variable_Functions/method.htm
		/// @return {Ui} self
		///
		if (_auto_bind) {
			_update_action = method(self, _update_action);	
		}
		with (_.update) {
			array_push(methods, _update_action);	
			size++;
		}
		return self;
	};
	static update_enable	 = function() {
		/// @func	update_enable()
		/// @desc	set the update actions to be enabled, so that they are run during the update() tick
		/// @return {Ui} self
		///
		_.update.active = true;
		return self;
	};
	static update_disable	 = function() {
		/// @func	update_disable()
		/// @desc	set the update actions to be disabled, so that they are NOT run during the update() tick
		/// @return {Ui} self
		///
		_.update.active = false;
		return self;
	};
	static update_toggle	 = function() {
		/// @func	update_toggle()
		/// @desc	toggle the update actions to be enabled/disabled during the update() tick
		/// @return {Ui} self
		///
		_.update.active = !_.update.active;
		return self;
	};
	static update_set_active = function(_update) {
		/// @func	update_set_active(update?)
		/// @param	{boolean} update?
		/// @desc	set whether or not the update actions should be enabled to run during the update() tick
		/// @return {Ui} self
		///
		_.update.active = _update;
		return self;
	};
	
	/// Render
	static render_add_action = function(_render_action, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	render_add_action(render_action, auto_bind?*)
		/// @desc	add a new action/method to the render stack for execution in the render() tick.
		/// @param	{method/function} render_action	->	method/function to be used for said "action"
		/// @param	{boolean}		  auto_bind?*	->	should the render_action method be bound to the Ui() component class automatically?
		///												if this is disabled, then whichever binding is configured upon pass-through will be used.
		///												see GameMaker's method() function for more information 
		///												https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Variable_Functions/method.htm
		/// @return {Ui} self
		///
		if (_auto_bind) {
			_render_action = method(self, _render_action);	
		}
		with (_.render) {
			array_push(methods, _render_action);	
			size++;
		}
		return self;
	};
	static render_enable	 = function() {
		/// @func	render_enable()
		/// @desc	set the render actions to be enabled, so that they are run during the render() tick
		/// @return {Ui} self
		///
		_.render.active = true;
		return self;
	};
	static render_disable	 = function() {
		/// @func	render_disable()
		/// @desc	set the render actions to be disabled, so that they are NOT run during the render() tick
		/// @return {Ui} self
		///
		_.render.active = false;
		return self;
	};
	static render_toggle	 = function() {
		/// @func	render_toggle()
		/// @desc	toggle the render actions to be enabled/disabled during the render() tick
		/// @return {Ui} self
		///
		_.render.active = !_.render.active;
		return self;
	};
	static render_set_active = function(_render) {
		/// @func	render_set_active(render?)
		/// @param	{boolean} render?
		/// @desc	set whether or not the render actions should be enabled to run during the render() tick
		/// @return {Ui} self
		///
		_.render.active = _render;
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
		with (_.events.on_hover) {
			if (enter.active) {
				with (enter.action) {
					for (var _i = 0; _i < size; _i++) {
						methods[_i]();	
					}
				}
			}
		}
		return self;
	};
	static hover_enter_add_action  = function(_hover_enter_action, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	hover_enter_add_action(hover_enter_action, auto_bind?*)
		/// @desc	add a new action/method to the on_hover_enter stack for execution when hover_enter is triggered.
		///			see hover_enter_add_trigger() for configuring a trigger that would execute the on_hover_enter stack.
		/// @param	{method/function} hover_enter_action
		/// @param	{boolean}		  auto_bind?=true
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_hover_enter_action = method(self, _hover_enter_action);	
		}
		with (_.events.on_hover.enter.action) {
			array_push(methods, _hover_enter_action);
			size++;
		}
		return self;	
	};
	static hover_enter_add_trigger = function(_hover_enter_trigger, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	hover_enter_add_trigger(hover_enter_trigger, auto_bind?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the hover_on_enter 
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} hover_enter_trigger
		/// @param	{boolean}		  auto_bind?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_hover_enter_trigger = method(self, _hover_enter_trigger);	
		}
		with (_.events.on_hover.enter.trigger) {
			array_push(methods, _hover_enter_trigger);
			size++;
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
		if (_.events.on_hover.hold.active) {
			with (_.events.on_hover.hold.action) {
				for (var _i = 0; _i < size; _i++) {
					methods[_i]();	
				}
			}
		}
		return self;
	};
	static hover_hold_add_action   = function(_hover_hold_action, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	hover_hold_add_action(hover_hold_action, auto_bind?*)
		/// @desc	add a new action/method to the on_hover_hold stack for execution when hover_hold is triggered.
		///			see hover_hold_add_trigger() for configuring a trigger that would execute the on_hover_hold stack.
		/// @param	{method/function} hover_hold_action
		/// @param	{boolean}		  auto_bind?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_hover_hold_action = method(self, _hover_hold_action);	
		}
		with (_.events.on_hover.hold.action) {
			array_push(methods, _hover_hold_action);
			size++;
		}
		return self;	
	};
	static hover_hold_add_trigger  = function(_hover_hold_trigger, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	hover_hold_add_trigger(hover_hold_trigger, auto_bind?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the hover_on_hold
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} hover_hold_trigger
		/// @param	{boolean}		  auto_bind?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_hover_hold_trigger = method(self, _hover_hold_trigger);	
		}
		with (_.events.on_hover.hold.trigger) {
			array_push(methods, _hover_hold_trigger);
			size++;
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
		with (_.events.on_hover) {
			if (leave.active) {
				with (leave.action) {
					for (var _i = 0; _i < size; _i++) {
						methods[_i]();	
					}
				}
			}
		}
		return self;
	};
	static hover_exit_add_action   = function(_hover_leave_action, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	hover_exit_add_action(hover_leave_action, auto_bind?*)
		/// @desc	add a new action/method to the on_hover_enter stack for execution when hover_enter is triggered.
		///			see hover_enter_add_trigger() for configuring a trigger that would execute the on_hover_enter stack.
		/// @param	{method/function} hover_leave_action
		/// @param	{boolean}		  auto_bind?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_hover_leave_action = method(self, _hover_leave_action);	
		}
		with (_.events.on_hover.leave.action) {
			array_push(methods, _hover_leave_action);
			size++;
		}
		return self;	
	};
	static hover_exit_add_trigger  = function(_hover_leave_trigger, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	hover_exit_add_trigger(hover_leave_trigger, auto_bind?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the hover_on_exit
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} hover_leave_trigger
		/// @param	{boolean}		  auto_bind?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_hover_leave_trigger = method(self, _hover_leave_trigger);	
		}
		with (_.events.on_hover.leave.trigger) {
			array_push(methods, _hover_leave_trigger);
			size++;
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
		if (_.events.on_click.pressed.active) {
			with (_.events.on_click.pressed.action) {
				for (var _i = 0; _i < size; _i++) {
					methods[_i]();	
				}
			}
		}
		return self;
	};
	static click_pressed_add_action	  = function(_click_pressed_action, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	click_pressed_add_action(click_pressed_action, auto_bind?*)
		/// @desc	add a new action/method to the click_pressed stack for execution when click_pressed is triggered.
		///			see click_pressed_add_trigger() for configuring a trigger that would execute the on_click_pressed stack.
		/// @param	{method/function} click_pressed_action
		/// @param	{boolean}		  auto_bind?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_click_pressed_action = method(self, _click_pressed_action);	
		}
		with (_.events.on_click.pressed.action) {
			array_push(methods, _click_pressed_action);
			size++;
		}
		return self;	
	};
	static click_pressed_add_trigger  = function(_click_pressed_trigger, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	click_pressed_add_trigger(click_pressed_trigger, auto_bind?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the click_pressed
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} click_pressed_trigger
		/// @param	{boolean}		  auto_bind?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_click_pressed_trigger = method(self, _click_pressed_trigger);	
		}
		with (_.events.on_click.pressed.trigger) {
			array_push(methods, _click_pressed_trigger);
			size++;
		}
		return self;	
	};
	static click_execute_down		  = function() {
		/// @func	click_execute_down()
		/// @desc	method to invoke for one-time-execution of the click_down logic bound to the
		///			click_down stack. this will most likely not need to be manually invoked, and
		/// @return {UiInteractor} self
		///
		if (_.events.on_click.down.active) {
			with (_.events.down.hold.action) {
				for (var _i = 0; _i < size; _i++) {
					methods[_i]();	
				}
			}
		}
		return self;
	};
	static click_down_add_action	  = function(_click_down_action, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	click_down_add_action(click_down_action, auto_bind?*)
		/// @desc	add a new action/method to the click_down stack for execution when click_down is triggered.
		///			see click_down_add_trigger() for configuring a trigger that would execute the on_click_down stack.
		/// @param	{method/function} click_down_action
		/// @param	{boolean}		  auto_bind?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_click_down_action = method(self, _click_down_action);	
		}
		with (_.events.on_click.down.action) {
			array_push(methods, _click_down_action);
			size++;
		}
		return self;	
	};
	static click_down_add_trigger	  = function(_click_down_trigger, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	click_down_add_trigger(click_down_trigger, auto_bind?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the click_down
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} click_down_trigger
		/// @param	{boolean}		  auto_bind?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_click_down_trigger = method(self, _click_down_trigger);	
		}
		with (_.events.on_click.down.trigger) {
			array_push(methods, _click_down_trigger);
			size++;
		}
		return self;	
	};
	static click_execute_released	  = function() {
		/// @func	click_execute_released()
		/// @desc	method to invoke for one-time-execution of the click_released logic bound to the
		///			click_released stack. this will most likely not need to be manually invoked, and
		/// @return {UiInteractor} self
		///
		if (_.events.on_click.released.active) {
			with (_.events.on_click.released.action) {
				for (var _i = 0; _i < size; _i++) {
					methods[_i]();	
				}
			}
		}
		return self;
	};
	static click_released_add_action  = function(_click_released_action, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	click_released_add_action(click_released_action, auto_bind?*)
		/// @desc	add a new action/method to the click_released stack for execution when click_released is triggered.
		///			see click_released_add_trigger() for configuring a trigger that would execute the on_click_released stack.
		/// @param	{method/function} click_released_action
		/// @param	{boolean}		  auto_bind?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_click_released_action = method(self, _click_released_action);	
		}
		with (_.events.on_click.released.action) {
			array_push(methods, _click_released_action);
			size++;
		}
		return self;	
	};
	static click_released_add_trigger = function(_click_released_trigger, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	click_released_add_trigger(click_released_trigger, auto_bind?*)
		/// @desc	add a new trigger/method used for conditional validation to determine if the click_released
		///			stack should be executed. the trigger method should always return a boolean.
		/// @param	{method/function} click_released_trigger
		/// @param	{boolean}		  auto_bind?*
		/// @return {UiInteractor}	  self
		///
		if (_auto_bind) {
			_click_released_trigger = method(self, _click_released_trigger);	
		}
		with (_.events.on_click.released.trigger) {
			array_push(methods, _click_released_trigger);
			size++;
		}
		return self;	
	};
	
	#endregion
	#region State Machine
	
	static state_add			  = function(_state_name, _state_method, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	state_add(state_name, state_method, auto_bind?*)
		/// @desc	add a new state_method bound to a given state_name
		/// @param	{string}		  state_name
		/// @param	{method/function} state_method
		/// @param	{boolean}		  auto_bind?*
		/// @return	{Ui}			  self
		///
		if (!state_exists(_state_name)) {
			if (_auto_bind) {
				_state_method = method(self, _state_method);	
			}
			_.state.states[$ _state_name] = _state_method;
		}
		return self;
	};
	static state_add_on_enter	  = function(_state_name, _state_method, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	state_add_on_enter(state_name, state_method, auto_bind?*)
		/// @desc	add a new state_on_enter method bound to a given state_name
		/// @param	{string}		  state_name
		/// @param	{method/function} state_method
		/// @param	{boolean}		  auto_bind?*
		/// @return	{Ui}			  self
		///
		if (!variable_struct_exists(_.state.on_enter, _state_name)) {
			if (_auto_bind) {
				_state_method = method(self, _state_method);	
			}
			_.state.on_enter[$ _state_name] = _state_method;
		}
		return self;
	};
	static state_add_on_exit	  = function(_state_name, _state_method, _auto_bind = __UI_DEFAULT_AUTO_BIND_METHODS) {
		/// @func	state_add_on_exit(state_name, state_method, auto_bind?*)
		/// @desc	add a new state_on_exit method bound to a given state_name
		/// @param	{string}		  state_name
		/// @param	{method/function} state_method
		/// @param	{boolean}		  auto_bind?*
		/// @return	{Ui}			  self
		///
		if (!variable_struct_exists(_.state.on_exit, _state_name)) {
			if (_auto_bind) {
				_state_method = method(self, _state_method);	
			}
			_.state.on_exit[$ _state_name] = _state_method;
		}
		return self;
	};
	static state_get			  = function(_state_name) {
		/// @func	state_get(state_name)
		/// @desc	return the method associated to the given state name that would be executed during a state update.
		/// @param	{string}		  state_name
		/// @return {method/function} state
		///
		return _.state.states[$ _state_name];
	};
	static state_get_current	  = function() {
		/// @func	state_get_current()
		/// @desc	get the currently executing state method
		/// @return {method/function} state
		///
		return _.state.current;
	};
	static state_get_current_name = function() {
		/// @func	state_get_current_name()
		/// @desc	get the name of the currently executing state method.
		/// @return {string} name
		///
		return _.state.name;
	};
	static state_set_current	  = function(_state_name) {
		/// @func	state_set_current(state_name)	
		/// @desc	set the current state method to that of the passed state_name's method
		/// @param	{string} name
		/// @return	{Ui}	 self
		///
		if (execute_on_enter) {
			state_execute_on_exit(state_get_current_name());
		}
		_.state.current =  state_get(_state_name);
		_.state.name	= _state_name;
		
		if (execute_on_exit) {
			state_execute_on_enter(_state_name);
		}
		return self;
	};
	static state_exists			  = function(_state_name) {
		/// @func	state_exists(state_name)
		/// @desc	return if the given state_name has been registered as a state_method.
		/// @param	{string}  state_name
		/// @return {boolean} state_exists?
		///
		return variable_struct_exists(_.state.states, _state_name);
	};
	static state_change			  = function(_state_name) {
		/// @func	state_change(state_name)
		/// @desc	do state transition if a state exists with the given name.
		/// @param	{string} state_name
		/// @return {Ui}	 self
		///
		if (state_exists(_state_name)) {
			state_set_current(_state_name);
		}
		return self;
	};
	static state_execute		  = function() {
		/// @func	state_execute()
		/// @return {Ui} self
		///
		var _state_current  = state_get_current();
		if (_state_current != undefined) {
			_state_current();	
		}
		return self;
	};
	static state_is				  = function(_state_name) {
		/// @func	state_is(state_name)
		/// @desc	check if the current state_is the same as that of the passed in state_name
		/// @param	{string}  state_name 
		/// @return {boolean} state_is?
		///
		return _state_name == state_get_current_name();
	};
	static state_execute_on_enter = function(_state_name) {
		/// @func	state_execute_on_enter(state_name)
		/// @desc	one-time encapsulation of the state_on_enter logic. this method will probably not need to be 
		///			manually invoked, and should be executed automatically if state_execute_on_enter is toggled to true
		/// @param	{string} name
		/// @return {Ui} self
		///
		if (variable_struct_exists(_.state.on_enter, _state_name)) {
			_.state.on_enter[$ _state_name]();	
		}
		return self;
	};
	static state_execute_on_exit  = function(_state_name) {
		/// @func	state_execute_on_exit(state_name)
		/// @desc	one-time encapsulation of the state_on_exit logic. this method will probably not need to be 
		///			manually invoked, and should be executed automatically if state_execute_on_exit is toggled t
		/// @param	{string} name
		/// @return {Ui} self
		///
		if (variable_struct_exists(_.state.on_exit, _state_name)) {
			_.state.on_exit[$ _state_name]();	
		}
		return self;
	};
	
	#endregion
	#region Pins
	
	static pin_components = function() {
		/// @func	pin_components(component1, ..., componentN)	
		/// @desc	pin x number of passed in components to this self component. pinned components 
		///			will propegate position, scale, and alpha to children components if the associated
		///			flag toggles are set to true.
		/// @param	{Ui} components
		/// @return {Ui} component
		///
		for (var _i = 0; _i < argument_count; _i++) {
			var _component = argument[_i];
			array_push(_.pin.pins, _component);
			_.pin.size++;
			_component.set_pin_parent(self);	
		}
		return self;
	};
	static set_pin_parent = function(_parent) {
		/// @func	set_pin_parent(parent)
		/// @param  {Ui} parent
		/// @return {Ui} self
		///
		_.pin.xoff   = _parent.get_x() - get_x();
		_.pin.yoff   = _parent.get_y() - get_y();
		_.pin.parent = _parent;
		return self;
	};
		
	#endregion
	#region Interactions
	
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
	#region Util Functions
	
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
function UiPanel (_config) : Ui(_config) constructor {
	/// @func  UiPanel(config) : Ui(config)
	/// @param {bool} outline*
	///
	#region Properties
	
	outline = _config[$ "outline"] ?? __UI_COMPONENT_DEFAULT_OUTLINE;
	
	#endregion
	#region Core 
	
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
	#region Getters & Setters
	
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
function UiLabel (_config) : Ui(_config) constructor {
	/// @func  UiLabel(config) : Ui(config)
	/// @param {string}	  text*
	/// @param {bool}	  wrap*
	/// @param {real}	  wrap_width*
	/// @param {real}	  line_space*
	/// @param {constant} halign*
	/// @param {constant} valign*
	///
	#region Properties
	
	text		= _config[$ "text"		] ?? __UI_COMPONENT_DEFAULT_LABEL_TEXT;
	wrap		= _config[$ "wrap"		] ?? __UI_COMPONENT_DEFAULT_LABEL_WRAP;
	wrap_width	= _config[$ "wrap_width"] ?? __UI_COMPONENT_DEFAULT_LABEL_WRAP_WIDTH;
	line_space  = _config[$ "line_space"] ?? __UI_COMPONENT_DEFAULT_LABEL_LINE_SPACE;
	halign		= _config[$ "halign"	] ?? __UI_COMPONENT_DEFAULT_LABEL_HALIGN;
	valign		= _config[$ "valign"	] ?? __UI_COMPONENT_DEFAULT_LABEL_VALIGN;
	
	#endregion
	#region Core
	
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
	#region Getters & Setters
		
	/// Getters
	static get_text		  = function() {
		/// @func	get_text()
		/// @return {string} text
		///
		return text;
	};
	static get_wrap		  = function() {
		/// @func	get_wrap()
		/// @return {bool} wrap?
		///
		return wrap;
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
	static set_wrap		  = function(_wrap) {
		/// @func	set_wrap(wrap?)
		/// @param	{bool} wrap?
		/// @return {Ui} self
		///
		wrap = _wrap;
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
		/// @func	set_line_space(halign)
		/// @param	{constant} halign
		/// @return {Ui} self
		///
		halign = _halign;
		return self;
	};
	static set_valign	  = function(_valign) {
		/// @func	set_line_space(valign)
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
function UiSprite(_config) : Ui(_config) constructor {
	/// @func  UiSprite(config) : Ui(config)
	/// @param {sprite_index} sprite*
	/// @param {real} image*
	/// @param {real} speed*
	///
	#region Properties
	
	if (!variable_struct_exists(_config, "sprite")) {
		throw("***error in UiSprite*** sprite not defined.");	
	}
		
	sprite = _config[$ "sprite"] ?? undefined;
	image  = _config[$ "image" ] ?? __UI_COMPONENT_DEFAULT_SPRITE_IMAGE_INDEX;
	speed  = _config[$ "speed" ] ?? __UI_COMPONENT_DEFAULT_SPRITE_IMAGE_SPEED;

	#endregion
	#region Core
	
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
	#region Getters & Setters
	
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
function UiLine  (_config) : Ui(_config) constructor {
	/// @func  UiLine(config) : Ui(config)
	///
	#region Properties
	
	points   = [];
	point    = {
		left_most:	 undefined,
		right_most:	 undefined,
		top_most:	 undefined,
		bottom_most: undefined,
	};
	n_points = 0;
	
	/// Dynamically Add Passed In Points To Points Array
	if (variable_struct_exists(_config, "points")) {
		for (var _i = 0, _len = array_length(_config.points); _i < _len; _i++) {
			var _point = _config.points[_i];
			add_point(_point.x, _point.y);
		}
	}
	
	#endregion
	#region Core
	
	static render	 = function() {
		/// @func	render()
		/// @return {UiLine} self
		///
		var _thickness = get_thickness();
		var _color	   = get_color();
		var _p1, _p2;
		
		for (var _i = 0, _len = n_points; _i < _len - 1; _i++) {
			_p1	= points[_i];
			_p2 = points[_i + 1];
			
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
		var _point = new Ui({ // create empty object to hold coordinates
			x: _x,
			y: _y,
		});
		array_push(points, _point);
		pin_components(_point);
		n_points++;
		
		/// Update Bounding Box
		if (point.left_most   == undefined || _x < point.left_most  ) point.left_most   = _x;	
		if (point.right_most  == undefined || _x > point.right_most ) point.right_most  = _x;	
		if (point.top_most    == undefined || _y < point.top_most   ) point.top_most    = _y;	
		if (point.bottom_most == undefined || _y > point.bottom_most) point.bottom_most = _y;	
		
		return self;
	};
	
	#endregion
	#region Getters & Setters
	
	/// Getters
	static get_width	= function() {	/// @OVERRIDE
		/// @func	get_width()
		/// @return {real} width
		///
		return point.right_most - point.left_most;
	};
	static get_height	= function() {	/// @OVERRIDE
		/// @func	get_height()
		/// @return {real} height
		///
		return point.bottom_most - point.top_most;
	};
	static get_left		= function() {	/// @OVERRIDE
		/// @func	get_left()
		/// @return {real} x_pos
		///
		return point.left_most;
	};
	static get_right	= function() {	/// @OVERRIDE
		/// @func	get_right()
		/// @return {real} x_pos
		///
		return point.right_most;
	};
	static get_top		= function() {	/// @OVERRIDE
		/// @func	get_top()
		/// @return {real} y_pos
		///
		return point.top_most;
	};
	static get_bottom	= function() {	/// @OVERRIDE
		/// @func	get_bottom()
		/// @return {real} y_pos
		///
		return point.bottom_most;
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
function UiCircle(_config) : Ui(_config) constructor {
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
function UiTextbox(_config) : Ui(_config) constructor {
	/// @func UiTextbox(config) : Ui(config)
	///
	exit; // <-- not yet ready
	
	static render = function() {};
};