/////////////////////////////
// r---. .     .---. r---. //
// r--   |     |   | r--   //
// L     L---- L---J L---J //
//////////////////////$(º)>//
#region docs, info & configs

#region about //////////////////////
/*
	written_by:_______gentoo________
	version:__________0.1.2_________
	last_updated:___06/22/2022______
*/
#endregion
#region change log /////////////////

#region version 0.1.2
/*
	Date: 06/22/2022
		New Features:
			x.	integrated PubSub design pattern with event broadcasting using xdstudio's xpublisher
		QOL:
			x.	renamed private property variables to match new naming convention, with double underscores prefix
			x.	replace literal property accessors with defined getter() methods
		Bugs:
			x.	fixed "bug" where getter methods were not being declared as static
*/
#endregion
#region version 0.1.1 (released)
/*
	Date: 06/13/2022
		x. Added sfx_emitters & sounds
		x. Added general getter methods for base FloeEffect() class
*/
#endregion
#region version 0.1.0 (released)
/*	
	Date: 06/06/2022
		x. Released first version.
*/
#endregion

#endregion
#region docs & help ////////////////

/// ...

#endregion
#region upcoming features //////////
/*	
	- different interpolation types/methods
	- optimize performance through not drawing the surface every frame
	- transitions to do
		- "old school tv shutdown"
		- cross-fade
		- pixelation
*/
#endregion
#region enums //////////////////////

enum __FLOE_STATE {
	HIDDEN,
	ENTER_PREP,
	ENTER,
	CHANGE_PREP,
	CHANGE,
	HOLD_PREP,
	HOLD,
	LEAVE_PREP,
	LEAVE,
	END,
};

#endregion
#region default config values //////

#macro __FLOE_PUBLISHER	Publisher	// <-- this system utilizes a PubSub design pattern. you can replace
									// the existing implementation with a custom implementation by first
									// changing this class reference, and then updating the Events methods.
									// if you decide to intended publisher, make sure to have the following
									// asset included in your project: https://xdstudios.itch.io/xpublisher
#endregion

#endregion

function FloeEffect() constructor {
	/// @func	FloeEffect()
	/// @return {FloeEffect} self
	///
	__padding	  =  20;		// offset to move effects offscreen for smoother animations
	__color		  =  c_black;
	__alpha		  =  1.0;
	__speed		  =  0.1;
	__threshold	  =  0.1;
	__hold_time   = -1;
	__this		  =  {
		__control: {
			__initialized: false,
			__running:	   false,
			__state:	 __FLOE_STATE.HIDDEN,
			__progress:	   0.0,
			__target:	   1.0,
			__is_reversed: false,
			__hold_timer:  0,
		},
	};
	
	#region Core ///////////
	
	static __setup_effect	 = function() {
		/// @func	__setup_effect()
		/// @return {FloeEffect} self
		///
		if (!is_initialized()) {
			#region Components /////
		
			component_system_setup(
				Eventable,
			);
			get_component(Eventable)
				.register(
					"enter_started",
					"enter_completed",
					"change_started",
					"change_completed",
					"hold_started",
					"hold_completed",
					"leave_started",
					"leave_completed",
					"reversed",
					"ended",
					"reset_completed",
				);
		
			#endregion
			__this.__control.__initialized = true;
		}
		return self;
	};
	static __teardown_effect = function() {
		/// @func	__teardown_effect()
		/// @return {FloeEffect} self
		///
		if (is_initialized()) {
			#region Components /////
		
			teardown_components();
		
			#endregion
			__this.__control.__initialized = false;
		}
		return self;
	};
	static __update_effect	 = function() {
		/// @func	__update_effect()
		/// @return {FloeEffect} self
		///
		if (is_initialized()) {
			#region State //////////
		
			switch (get_state()) {
				case __FLOE_STATE.ENTER_PREP: {
					get_component(Eventable)
						.broadcast("enter_started");
						
					set_running(true);
					set_state(__FLOE_STATE.ENTER);
					break;	
				}
				case __FLOE_STATE.ENTER: {
					var _target   = get_target();
					var _progress = lerp(get_progress(), _target, get_speed());
					set_progress(_progress);
				
					if (abs(_progress - _target) <= get_threshold()) {
						set_progress(_target);
						
						get_component(Eventable)
							.broadcast("enter_completed");
							
						set_state(__FLOE_STATE.CHANGE_PREP);
					}
					break;	
				}
				case __FLOE_STATE.CHANGE_PREP: {
					get_component(Eventable)
						.broadcast("change_started");
						
					set_state(__FLOE_STATE.CHANGE);
					break;	
				}
				case __FLOE_STATE.CHANGE: {
					__this.__control.__hold_timer = get_hold_time();
					
					get_component(Eventable)
						.broadcast("change_completed");
						
					set_state(__FLOE_STATE.HOLD_PREP);
					break;	
				}
				case __FLOE_STATE.HOLD_PREP: {
					get_component(Eventable)
						.broadcast("hold_started");
						
					set_state(__FLOE_STATE.HOLD);
					break;	
				}
				case __FLOE_STATE.HOLD:	{
					if (__this.__control.__hold_timer > 0) {
						__this.__control.__hold_timer--;
					}
					else {
						get_component(Eventable)
							.broadcast("hold_completed");
							
						set_state(__FLOE_STATE.LEAVE_PREP);
					}
					break;	
				}
				case __FLOE_STATE.LEAVE_PREP: {
					get_component(Eventable)
						.broadcast("leave_started");
						
					set_state(__FLOE_STATE.LEAVE);
					break;	
				}
				case __FLOE_STATE.LEAVE: {
					var _target   = get_target();
					var _progress = lerp(get_progress(), _target, get_speed());
					set_progress(_progress);
				
					if (abs(_progress - _target) <= get_threshold()) {
						set_progress(_target);
						
						get_component(Eventable)
							.broadcast("leave_completed");
							
						set_state(__FLOE_STATE.END);
					}
					break;	
				}
				case __FLOE_STATE.END: {
					get_component(Eventable)
						.broadcast("ended");
						
					set_running(false);
					set_state(__FLOE_STATE.HIDDEN);
					break;	
				}
			};
		
			#endregion
		}
		return self;
	};
	static __render_effect	 = function() {
		/// @func	__render_effect()
		/// @return {FloeEffect} self
		///
		if (is_initialized()) {
			/// ...
		}
		return self;
	};
	
	static setup	= __setup_effect;
	static teardown = __teardown_effect;
	static update	= __update_effect;
	static render	= __render_effect;
	
	#endregion
	#region Getters ////////
	
	static get_running					 = function() {
		/// @func	get_running()
		/// @return {boolean} is_running?
		///
		return __this.__control.__running;
	};
	static get_padding					 = function() {
		/// @func	get_padding()
		/// @return {real} padding
		///
		return __padding;
	};
	static get_color					 = function() {
		/// @func	get_color()
		/// @return {color} color
		///
		return __color;
	};
	static get_alpha					 = function() {
		/// @func	get_alpha()
		/// @return {real} alpha
		///
		return __alpha;
	};
	static get_speed					 = function() {
		/// @func	get_speed()
		/// @return {real} speed
		///
		return __speed;
	};
	static get_threshold				 = function() {
		/// @func	get_threshold()
		/// @return {real} threshold
		///
		return __threshold;
	};
	static get_hold_time				 = function() {
		/// @func	get_hold_time()
		/// @return {real} hold_time
		///
		return __hold_time;
	};
	static get_progress					 = function() {
		/// @func	get_progress()
		/// @return {real} progress
		///
		return __this.__control.__progress;
	};
	static get_target					 = function() {
		/// @func	get_target()
		/// @return {real} target
		///
		return __this.__control.__target;
	};
	static get_state					 = function() {
		/// @func	get_state()
		/// @return {enum} state
		///
		return __this.__control.__state;
	};
	static get_callback_on_enter_method  = function() {
		/// @func	get_callback_on_enter_method()
		/// @return {struct} on_enter
		///
		with (__this.__callbacks.__on_enter) {
			return __method;
		}
	};
	static get_callback_on_enter_data	 = function() {
		/// @func	get_callback_on_enter_data()
		/// @return {struct} on_enter
		///
		with (__this.__callbacks.__on_enter) {
			return __data;
		}
	};
	static get_callback_on_change_method = function() {
		/// @func	get_callback_on_change_method()
		/// @return {struct} on_enter
		///
		with (__this.__callbacks.__on_change) {
			return __method;
		}
	};
	static get_callback_on_change_data	 = function() {
		/// @func	get_callback_on_change_data()
		/// @return {struct} on_enter
		///
		with (__this.__callbacks.__on_change) {
			return __data;
		}
	};
	static get_callback_on_leave_method  = function() {
		/// @func	get_callback_on_leave_method()
		/// @return {struct} on_enter
		///
		with (__this.__callbacks.__on_leave) {
			return __method;
		}
	};
	static get_callback_on_leave_data	 = function() {
		/// @func	get_callback_on_leave_data()
		/// @return {struct} on_enter
		///
		with (__this.__callbacks.__on_leave) {
			return __data;
		}
	};
	static get_callback_on_end_method	 = function() {
		/// @func	get_callback_on_end_method()
		/// @return {struct} on_enter
		///
		with (__this.__callbacks.__on_end) {
			return __method;
		}
	};
	static get_callback_on_end_data		 = function() {
		/// @func	get_callback_on_end_data()
		/// @return {struct} on_enter
		///
		with (__this.__callbacks.__on_end) {
			return __data;
		}
	};
	
	#endregion
	#region Setters ////////
		
	static set_running	   = function(_running) {
		/// @func	set_running(running?)
		/// @param	{boolean} is_running?
		/// @return {FloeEffect} self
		///
		__this.__control.__running = _running;
		return self;
	};
	static set_padding	   = function(_padding) {
		/// @func	set_padding(padding)
		/// @param	{real} padding
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		__padding = _padding;
		return self;
	};
	static set_color	   = function(_color) {
		/// @func	set_color(color)
		/// @param	{color} color
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		__color = _color;
		return self;
	};
	static set_alpha	   = function(_alpha) {
		/// @func	set_alpha(alpha)
		/// @param	{real} alpha
		/// @return {FloeEffect} self
		///
		__alpha = _alpha;
		return self;
	};
	static set_speed	   = function(_speed) {
		/// @func	set_speed(speed)
		/// @param	{real} speed
		/// @return {FloeEffect} self
		///
		__speed = _speed;
		return self;
	};
	static set_threshold   = function(_threshold) {
		/// @func	set_threshold(threshold)
		/// @param	{real} threshold
		/// @return {FloeEffect} self
		///
		__threshold = _threshold;
		return self;
	};
	static set_hold_time   = function(_hold_time) {
		/// @func	set_hold_time(hold_time)
		/// @param	{real} hold_time
		/// @return {FloeEffect} self
		///
		__hold_time = _hold_time;
		return self;
	};
	static set_progress	   = function(_progress) {
		/// @func	set_progress(progress)
		/// @param	{real} progress
		/// @return {FloeEffect} self
		///
		__this.__control.__progress = _progress;
		return self;
	};
	static set_target	   = function(_target) {
		/// @func	set_target(target)
		/// @param	{real} target
		/// @return {FloeEffect} self
		///
		__this.__control.__target = _target;
		return self;
	};
	static set_state	   = function(_state) {
		/// @func	set_state(state)
		/// @param	{enum} state
		/// @return {FloeEffect} self
		///
		__this.__control.__state = _state;
		return self;
	};
	
	#endregion
	#region Checkers ///////
	
	static is_initialized = function() {
		/// @func	is_initialized()
		/// @return {bool} is_initialized?
		///
		return __this.__control.__initialized;
	};
	static is_running	  = function() {
		/// @func	is_running()
		/// @return {boolean} is_running?
		///
		return get_running();
	};
	
	#endregion
	
	static enter   = function() {
		/// @func	enter()
		/// @return {FloeEffect} self
		///
		set_state(__FLOE_STATE.ENTER_PREP);
		var _target = __this.__control.__is_reversed ? 0 : 1;
		set_target(_target);
		return self;
	};
	static leave   = function() {
		/// @func	leave()
		/// @return {FloeEffect} self
		///
		set_state(__FLOE_STATE.LEAVE_PREP);
		var _target = __this.__control.__is_reversed ? 1 : 0;
		set_target(_target);
		return self;
	};
	static reverse = function(_reverse_progress = true) {
		/// @func	reverse(reverse_progress?*)
		/// @param	{bool} reverse_progress=true
		/// @return {FloeEffect} self
		///
		__this.__control.__is_reversed = !__this.__control.__is_reversed;
		
		/// Set Target
		var _target = 1 - get_target();
		set_target(_target);

		/// Set Progress
		if (_reverse_progress) {
			var _progress = 1 - get_progress();
			set_progress(_progress);
		}
			
		get_component(Eventable)
			.broadcast("reversed");
			
		return self;
	};
	static reset   = function() {
		/// @func	reset()
		/// @return {FloeEffect} self
		///
		set_running(false);
		set_progress(0);
		set_state(__FLOE_STATE.HIDDEN);
		
		get_component(Eventable)
			.broadcast("reset_completed");
			
		return self;
	};
};
function FloeEffectSurface() : FloeEffect() constructor {
	/// @func FloeEffectSurface()
	///
	__this.__surface = undefined;
	
	#region Core ///////////
	
	static __setup_surface    = function() {
		/// @func	__setup_surface()
		/// @return {FloeEffect} self
		///
		if (!is_initialized()) {
			__setup_effect();
			#region Surface ////////
		
			__this.__surface = surface_create(SURF_W, SURF_H);
		
			#endregion
		}
		return self;
	};
	static __teardown_surface = function() {
		/// @func	__teardown_surface()
		/// @return {FloeEffect} self
		///
		if (is_initialized()) {
			#region Surface ////////
		
			if (surface_exists(__this.__surface)) {
				surface_free(__this.__surface);
			}
			__this.__surface = undefined;
		
			#endregion
			__teardown_effect();
		}
		return self;
	};
	static __update_surface   = function() {
		/// @func	__update_surface()
		/// @return {FloeEffect} self
		///
		if (is_initialized()) {
			__update_effect();
		};
		return self;
	};
	static __render_surface   = function() {
		/// @func	__render_surface()
		/// @return {FloeEffect} self
		///
		if (is_initialized()) {
			__render_effect();
		};
		return self;
	};
		
	static setup	= __setup_surface;
	static teardown = __teardown_surface;
	static update	= __update_surface;
	static render	= __render_surface;
	
	static render_begin = function() {
		/// @func	render_begin()
		/// @return {FloeEffect} self
		///
		__this.__surface = surface_ensure(__this.__surface, SURF_W, SURF_H);
		surface_set_target(__this.__surface); 
		draw_clear_alpha(c_black, 0.0);
		return self;
	};
	static render_end   = function(_surface_shader_method) {
		/// @func	render_end(surface_shader_method*)
		/// @param	{shader} surface_shader_method
		/// @return {FloeEffect} self
		///
		surface_reset_target();	
		if (_surface_shader_method != undefined) {
			_surface_shader_method();	
		}
		draw_surface(__this.__surface, 0, 0);
		
		if (_surface_shader_method != undefined) {
			shader_reset();	
		}
		return self;
	};
	
	#endregion
};
function FloeEffectFade() : FloeEffect() constructor {
	/// @func FloeEffectFade()
	///
	set_threshold(0.01);
	
	static __render_fade = function() {
		/// @func	__render_fade()
		/// @return {FloeEffect}
		///
		if (is_initialized()) {
			__render_effect();
			#region Fade ///////
			
			var _alpha = get_alpha() * get_progress();
			draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, get_color(), _alpha);
			
			#endregion
		}
		return self;
	};	
	static render		 = __render_fade;
};
function FloeEffectWipeLeft() : FloeEffect() constructor {
	/// @func FloeEffectWipeLeft()
	///
	set_threshold(0.01);
	
	static __render_wipe = function() {
		/// @func	__render_wipe()
		/// @return {FloeEffect}
		///
		if (is_initialized()) {
			__render_effect();
			#region Wipe ///////
			
			var _width = SURF_W + get_padding();
			var _x	   = _width - (_width * get_progress()) - (get_padding() * 0.5);
			draw_rectangle_alt(_x, 0, _width, SURF_H, 0, get_color(), get_alpha());
			
			#endregion
		}
		return self;
	};	
	static render		 = __render_wipe;
};
function FloeEffectWipeRight() : FloeEffect() constructor {
	/// @func FloeEffectWipeRight()
	///
	set_threshold(0.01);
	
	static __render_wipe = function() {
		/// @func	__render_wipe()
		/// @return {FloeEffect}
		///
		if (is_initialized()) {
			__render_effect();
			#region Wipe ///////
			
			var _width = SURF_W + get_padding();
			var _x	   = -_width + (_width * get_progress()) - (get_padding() * 0.5);
			draw_rectangle_alt(_x, 0, _width, SURF_H, 0, get_color(), get_alpha());
			
			#endregion
		}
		return self;
	};	
	static render		 = __render_wipe;
};
function FloeEffectCircleCenter() : FloeEffectSurface() constructor {
	/// @func FloeEffectCircleCenter()
	///
	set_threshold(0.01);
	
	static __render_circle_center = function() {
		/// @func	__render_circle_center()
		/// @return {FloeEffect} self
		///
		if (is_initialized()) {
			__render_surface();
			#region Circle /////
			
			render_begin(); {
				draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, get_color(), get_alpha());
				gpu_set_blendmode(bm_subtract); {
				var _base   = SURF_H;
				var _radius = _base - (_base * get_progress());
				draw_circle_color(SURF_W * 0.5, SURF_H * 0.5, _radius, c_white, c_white, false);
			} gpu_set_blendmode(bm_normal);
			} render_end();
				
			#endregion
		}
		return self;
	};
	static render				  = __render_circle_center;
};
function FloeEffectCircleTarget() : FloeEffectSurface() constructor {
	/// @func FloeEffectCircleTarget()
	///
	set_threshold(0.01);
	
	static __render_circle_target = function() {
		/// @func	__render_circle_target()
		/// @return {FloeEffect} self
		///
		if (is_initialized()) {
			__render_surface();
			#region Circle /////
			
			render_begin(); {
				
				/// ...
				
			} render_end();
			
			#endregion
		}
		return self;
	};
	static render				  = __render_circle_target;
};
function FloeEffectBorderCenter() : FloeEffectSurface() constructor {
	/// @func FloeEffectBorderCenter()
	///
	set_threshold(0.01);
	
	static __render_border_center = function() {
		/// @func	__render_border_center()
		/// @return {FloeEffect} self
		///
		if (is_initialized()) {
			__render_surface();
			#region Border /////
			
			render_begin(); {
				draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, get_color(), get_alpha());
				gpu_set_blendmode(bm_subtract); {
				var _padding  = get_padding();
				var _progress = get_progress();
				var _base_w   =  SURF_W + _padding;
				var _base_h   =  SURF_H + _padding;
				var _width	  = _base_w - (_base_w * _progress);
				var _height   = _base_h - (_base_h * _progress);
				var _x		  = (_base_w - _width ) * 0.5 - (_padding * 0.5);
				var _y		  = (_base_h - _height) * 0.5 - (_padding * 0.5);
				draw_rectangle_alt(_x, _y, _width, _height, 0, c_white, 1.0);
			} gpu_set_blendmode(bm_normal);
			} render_end();
				
			#endregion
		}
		return self;
	};	
	static render				  = __render_border_center;
};
function FloeEffectBorderTarget() : FloeEffectSurface() constructor {
	/// @func FloeEffectBorderTarget()
	///
	set_threshold(0.01);
	
	static __render_border_target = function() {
		/// @func	__render_border_target()
		/// @return {FloeEffect} self
		///
		if (is_initialized()) {
			__render_surface();
			#region Border /////
			
			render_begin();
		
			/// ...
		
			render_end();
			
			#endregion
		}
		return self;
	};	
	static render				  = __render_border_target;
};
function FloeEffectBorderSprite(_sprite, _image = 0) : FloeEffectSurface() constructor {
	/// @func	FloeEffectBorderSprite(sprite, image*)
	/// @param	{sprite_index} sprite
	/// @param	{image_index } image=0
	///
	set_threshold(0.005);
	
	__sprite	= _sprite;
	__image		= _image;
	__x_offset	= -get_sprite_width()  * 0.5;	// amount sprite will be offset from origin
	__y_offset	= -get_sprite_height() * 0.5;	// amount sprite will be offset from origin
	
	/// Shadow
	__draw_shadow  = false;
	__shadow_alpha = 1.0;
	__shadow_color = c_black;
	__shadow_inset = 0;	
	
	/// Overlay
	__overlay_edge	  = true;
	__overlay_inset_x = get_sprite_width()  * (1 / 6);	// amount that overlay surface will inset into the sprite
	__overlay_inset_y = get_sprite_height() * (1 / 6);	// amount that overlay surface will inset into the sprite

	#region Private ////////
	
	__this.__control.__sprite = {
		__validated: false,
	};
	
	static __validate_sprite = function() {
		/// @func __validate_sprite()
		///
		if (!__get_sprite_validated()) {
			var _sprite  = get_sprite();
			if (_sprite == undefined) {
				throw("ERROR: FloeEffectBorderSprite.sprite cannot be undefined");	
			}
			if (!(sprite_get_nineslice(_sprite)).enabled) {
				throw("ERROR: FloeEffectBorderSprite.sprite must be a nine-slice sprite");
			}
			__set_sprite_validated(true);
		}
	};
	
	#endregion
	#region Core ///////////
	
	static __render_sprite = function() {
		/// @func	__render_sprite()
		/// @return {FloeEffect{ self
		///
		if (is_initialized()) {
			__render_surface();
			#region Sprite /////
			
			__validate_sprite();
		
			var _progress =  get_progress();
			var _max_w	  =  SURF_W;
			var _max_h	  =  SURF_H;
			var _x_offset = get_x_offset();
			var _y_offset = get_y_offset();
			var _start_w  = _max_w + (-_x_offset * 2);
			var _start_h  = _max_h + (-_y_offset * 2);
			var _start_x  = (SURF_W - _max_w) + _x_offset;
			var _start_y  = (SURF_H - _max_h) + _y_offset;
		
			var _x = _start_x + ((_max_w - _x_offset) * (0.5 * _progress));
			var _y = _start_y + ((_max_h - _y_offset) * (0.5 * _progress));
			var _w = _start_w - ((_max_w - _x_offset) * _progress);
			var _h = _start_h - ((_max_h - _y_offset) * _progress);
		
			/// Sprite Shadow
			if (get_draw_shadow()) {
				shader_set(shdr_alpha_dither); {
					var _shadow_x = _x +  __shadow_inset;
					var _shadow_y = _y +  __shadow_inset;
					var _shadow_w = _w - (__shadow_inset * 2);
					var _shadow_h = _h - (__shadow_inset * 2);
					draw_sprite_stretched_ext(__sprite, __image, _shadow_x, _shadow_y, _shadow_w, _shadow_h, __shadow_color, __shadow_alpha);
				} shader_reset();
			}
		
			/// Primary Sprite
			draw_sprite_stretched_ext(get_sprite(), get_image(), _x, _y, _w, _h, get_color(), get_alpha());
		
			/// Overlay Edge
			if (get_overlay_edge()) {
				render_begin(); {
					draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, get_color(), 1);
					gpu_set_blendmode(bm_subtract); {
						draw_rectangle_alt(
							_x + __overlay_inset_x,
							_y + __overlay_inset_y,
							max(0, _w - (__overlay_inset_x * 2)), 
							max(0, _h - (__overlay_inset_y * 2)), 
							0, 
							c_white, 
							1,
						);
					} gpu_set_blendmode(bm_normal);
				} render_end();
			}
				
			#endregion
		}
		return self;
	};
	static render		   = __render_sprite;
		
	#endregion
	#region Getters ////////
	
	static get_sprite		 = function() {
		/// @func get_sprite()
		/// @return {sprite_index} sprite
		/// 
		return __sprite;
	};
	static get_sprite_width  = function() {
		/// @func	get_sprite_width()
		/// @return {real} sprite_width
		///
		return sprite_get_width(__sprite);	
	};
	static get_sprite_height = function() {
		/// @func	get_sprite_height()
		/// @return {real} sprite_height
		///
		return sprite_get_height(__sprite);	
	};
	static get_image		 = function() {
		/// @func	get_image()
		/// @return {real} image_index
		///
		return __image;
	};
	static get_x_offset		 = function() {
		/// @func	get_x_offset()
		/// @return {real} x_offset
		///
		return __x_offset;
	};
	static get_y_offset		 = function() {
		/// @func	get_y_offset()
		/// @return {real} y_offset
		///
		return __y_offset;
	};
	static get_draw_shadow	 = function() {
		/// @func	get_draw_shadow()
		/// @return {boolean} draw_shadow?
		///
		return __draw_shadow;
	};
	static get_shadow_alpha  = function() {
		/// @func	get_shadow_alpha()
		/// @return {real} shadow_alpha
		///
		return __shadow_alpha;
	};
	static get_shadow_color  = function() {
		/// @func	get_shadow_color()
		/// @return {real} shadow_color
		///
		return __shadow_color;	
	};
	static get_shadow_inset	 = function() {
		/// @func	get_shadow_inset()
		/// @return {real} shadow_inset
		///
		return __shadow_inset;	
	};
	static get_overlay_edge  = function() {
		/// @func	get_overlay_edge()
		/// @return {boolean} overlay_edge?
		///
		return __overlay_edge;
	};
		
	static __get_sprite_validated = function() {
		/// @func	__get_sprite_validated()
		/// @return	{boolean} sprite_validated?
		///
		return __this.__control.__sprite.__validated;
	};
	
	#endregion
	#region Setters ////////
	
	static set_sprite		 = function(_sprite) {
		/// @func	set_sprite(sprite)
		/// @param	{sprite_index} sprite
		/// @return {FloeEffect} self
		///
		__sprite = _sprite;
		return self;
	};
	static set_image		 = function(_image) {
		/// @func	set_image(image)
		/// @param	{image_index} image
		/// @return {FloeEffect} self
		///
		__image = _image;
		return self;
	};
	static set_x_offset		 = function(_x_offset) {
		/// @func	set_x_offset(x_offset)
		/// @param	{real} x_offset
		/// @return {FloeEffect} self
		///
		__x_offset = _x_offset;
		return self;
	};
	static set_y_offset		 = function(_y_offset) {
		/// @func	set_y_offset(y_offset)
		/// @param	{real} y_offset
		/// @return {FloeEffect} self
		///
		__y_offset = _y_offset;
		return self;
	};
	static set_draw_shadow   = function(_draw_shadow) {
		/// @func	set_draw_shadow(draw_shadow?)
		/// @param	{boolean} draw_shadow?
		/// @return {FloeEffect} self
		///
		__draw_shadow = _draw_shadow;
		return self;
	};
	static set_shadow_alpha	 = function(_shadow_alpha) {
		/// @func	set_shadow_alpha(shadow_alpha)
		/// @param	{real} shadow_alpha
		/// @return {FloeEffect} self
		///
		__shadow_alpha = _shadow_alpha;
		return self;
	};
	static set_shadow_color	 = function(_shadow_color) {
		/// @func	set_shadow_color(shadow_color)
		/// @param	{color} shadow_color
		/// @return {FloeEffect} self
		///
		__shadow_color = _shadow_color;
		return self;
	};
	static set_shadow_inset	 = function(_shadow_inset) {
		/// @func	set_shadow_inset(shadow_inset)
		/// @param	{real} shadow_inset
		/// @return {FloeEffect} self
		///
		__shadow_inset = _shadow_inset;
		return self;
	};
	static set_overlay_edge	 = function(_overlay_edge) {
		/// @func	set_overlay_edge(overlay_edge?)
		/// @param	{boolean} overlay_edge?
		/// @return {FloeEffect} self
		///
		__overlay_edge = _overlay_edge;
		return self;
	};
		
	static __set_sprite_validated = function(_validated) {
		/// @func	__set_sprite_validated(validated?)
		/// @param	{boolean} sprite_validated?
		/// @return {FloeEffect} self
		///
		__this.__control.__sprite.__validated = _validated;
		return self;
	};
	
	#endregion
};
////////////////////////////////////////////////////////////////////////////
function FloeEffectBorderTrees() : FloeEffectBorderSprite(__spr_transition_border_silhouette_trees) constructor {	// <-- custom implementation example. remove
	__overlay_edge =  true;
	__draw_shadow  =  true;
	__shadow_alpha =  0.8;
	__shadow_inset =  20;
	__color		   =  CONFIG.color.orange;
	__x_offset	   = -50;
	__y_offset	   = -60;
};

