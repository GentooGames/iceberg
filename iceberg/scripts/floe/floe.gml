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
	CHANGE,
	HOLD,
	LEAVE_PREP,
	LEAVE,
	END,
};

#endregion
#region default config values //////

/// ...

#endregion

#endregion

function FloeEffect() constructor {
	/// @func FloeEffect()
	///
	__padding	=  20;		// offset to move effects offscreen for smoother animations
	__color		=  c_black;
	__alpha		=  1.0;
	__speed		=  0.1;
	__threshold	=  0.1;
	__hold_time = -1;
	__this		= {
		__control:	 {
			__state:	   __FLOE_STATE.HIDDEN,
			__progress:	   0.0,
			__target:	   1.0,
			__is_reversed: false,
			__hold_timer:  0,
		},
		__callbacks: {
			__on_enter:	 {
				__method: undefined,
				__data:	  undefined,
			},
			__on_change: {
				__method: undefined,
				__data:	  undefined,
			},
			__on_leave:  {
				__method: undefined,
				__data:	  undefined,
			},
			__on_end:	 {
				__method: undefined,
				__data:	  undefined,
			},	
		},
		__audio:	 {
			__emitter: audio_emitter_create(),
			__method:  audio_play_sound_on,
			__sounds:  {
				__enter:  undefined,
				__change: undefined,
				__leave:  undefined,
			},
		},
	};

	static update  = function() {
		/// @func	update()
		/// @return {FloeEffect} self
		///
		var _self = self;
		with (__this) {
			switch (__control.__state) {
				case __FLOE_STATE.ENTER_PREP: {
					with (__callbacks.__on_enter) {
						if (__method != undefined) {
							__method(__data);		
						}
					}
					with (__audio) {
						if (__sounds.__enter != undefined) {
							__method(__emitter, __sounds.__enter, 0, 0);
						}
					}
					__control.__state = __FLOE_STATE.ENTER;
					break;	
				}
				case __FLOE_STATE.ENTER: {
					var _speed	   = _self.__speed;
					var _threshold = _self.__threshold;
					
					with (__control) {
						__progress = lerp(__progress, __target, _speed);
				
						if (abs(__progress - __target) <= _threshold) {
							__progress = __target;
							__state	   = __FLOE_STATE.CHANGE;
						}
					}
					break;	
				}
				case __FLOE_STATE.CHANGE: {
					var _hold_time = _self.__hold_time;
					
					with (__callbacks.__on_change) {
						if (__method != undefined) {
							__method(__data);	
						}
					}
					with (__audio) {
						if (__sounds.__change != undefined) {
							__method(__emitter, __sounds.__change, 0, 0);
						}
					}
					with (__control) {
						__hold_timer = _hold_time;
						__state		 = __FLOE_STATE.HOLD;
					}
					break;	
				}
				case __FLOE_STATE.HOLD:	{
					with (__control) {
						if (__hold_timer > 0) {
							__hold_timer--;	
						}
						else {
							__state = __FLOE_STATE.LEAVE_PREP;
						}
					}
					break;	
				}
				case __FLOE_STATE.LEAVE_PREP: {
					with (__callbacks.__on_leave) {
						if (__method != undefined) {
							__method(__data);		
						}	
					}
					with (__audio) {
						if (__sounds.__leave != undefined) {
							__method(__emitter, __sounds.__leave, 0, 0);
						}
					}
					__control.__state = __FLOE_STATE.LEAVE;
					break;	
				}
				case __FLOE_STATE.LEAVE: {
					var _speed	   = _self.__speed;
					var _threshold = _self.__threshold;
					
					with (__control) {
						__progress = lerp(__progress, __target, _speed);
				
						if (abs(__progress - __target) <= _threshold) {
							__progress = __target;
							__state	   = __FLOE_STATE.END;
						}
					}
					break;	
				}
				case __FLOE_STATE.END: {
					with (__callbacks.__on_end) {
						if (__method != undefined) {
							__method(__data);	
						}
					}
					__control.__state = __FLOE_STATE.HIDDEN;
					break;	
				}
			};
		}
		return self;
	};
	static cleanup = function() {
		/// @func	cleanup()
		/// @return {FloeEffect} self
		///
		with (__this.__audio) {
			if (audio_emitter_exists(__emitter)) {
				audio_emitter_free(__emitter);
				__emitter = undefined;
			}
		}
		return self
	};
	
	#region Setters ////////
		
	static set_color		= function(_color) {
		/// @func	set_color(color)
		/// @param	{color} color
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		__color = _color;
		return self;
	};
	static set_alpha		= function(_alpha) {
		/// @func	set_alpha(alpha)
		/// @param	{real} alpha
		/// @return {FloeEffect} self
		///
		__alpha = _alpha;
		return self;
	};
	static set_speed		= function(_speed) {
		/// @func	set_speed(speed)
		/// @param	{real} speed
		/// @return {FloeEffect} self
		///
		__speed = _speed;
		return self;
	};
	static set_threshold	= function(_threshold) {
		/// @func	set_threshold(threshold)
		/// @param	{real} threshold
		/// @return {FloeEffect} self
		///
		__threshold = _threshold;
		return self;
	};
	static set_hold_time	= function(_hold_time) {
		/// @func	set_hold_time(hold_time)
		/// @param	{real} hold_time
		/// @return {FloeEffect} self
		///
		__hold_time = _hold_time;
		return self;
	};
	static set_on_enter		= function(_callback, _data) {
		/// @func	set_on_enter(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		with (__this.__callbacks.__on_enter) {
			__method = _callback;
			__data	 = _data;
		}
		return self;
	};
	static set_on_change	= function(_callback, _data) {
		/// @func	set_on_change(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		with (__this.__callbacks.__on_change) {
			__method = _callback;
			__data	 = _data;
		}
		return self;
	};
	static set_on_leave		= function(_callback, _data) {
		/// @func	set_on_leave(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		with (__this.__callbacks.__on_leave) {
			__method = _callback;
			__data	 = _data;
		}
		return self;
	};
	static set_on_end		= function(_callback, _data) {
		/// @func	set_on_end(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		with (__this.__callbacks.__on_end) {
			__method = _callback;
			__data	 = _data;
		}
		return self;
	};
	static set_progress		= function(_progress) {
		/// @func	set_progress(progress)
		/// @param	{real} progress
		/// @return {FloeEffect} self
		///
		__this.__control.__progress = _progress;
		return self;
	};
	static set_target		= function(_target) {
		/// @func	set_target(target)
		/// @param	{real} target
		/// @return {FloeEffect} self
		///
		__this.__control.__target = _target;
		return self;
	};
	static set_state		= function(_state) {
		/// @func	set_state(state)
		/// @param	{enum} state
		/// @return {FloeEffect} self
		///
		__this.__control.__state = _state;
		return self;
	};
	static set_is_reversed	= function(_is_reversed) {
		/// @func	set_is_reversed(is_reversed)
		/// @param	{boolean} is_reversed?
		/// @return {FloeEffect} self
		///
		__this.__control.__is_reversed = _is_reversed;
		return self;
	};
	
	#endregion
	#region Getters ////////
	
	static get_color		 = function() {
		/// @func	get_color()
		/// @return {color} color
		///
		return __color;
	};
	static get_alpha		 = function() {
		/// @func	get_alpha()
		/// @return {real} alpha
		///
		return __alpha;
	};
	static get_speed		 = function() {
		/// @func	get_speed()
		/// @return {real} speed
		///
		return __speed;
	};
	static get_threshold	 = function() {
		/// @func	get_threshold()
		/// @return {real} threshold
		///
		return __threshold;
	};
	static get_hold_time	 = function() {
		/// @func	get_hold_time()
		/// @return {real} hold_time
		///
		return __hold_time;
	};
	static get_on_enter		 = function() {
		/// @func	get_on_enter()
		/// @return {struct} on_enter
		///
		return __this.__callbacks.__on_enter;
	};
	static get_on_change	 = function() {
		/// @func	get_on_change()
		/// @return {struct} on_change
		///
		return __this.__callbacks.__on_change;
	};
	static get_on_leave		 = function() {
		/// @func	get_on_leave()
		/// @return {struct} on_leave
		///
		return __this.__callbacks.__on_leave;
	};
	static get_on_end		 = function() {
		/// @func	get_on_end()
		/// @return {struct} on_end
		///
		return __this.__callbacks.__on_end;
	};
	static get_progress		 = function() {
		/// @func	get_progress()
		/// @return {real} progress
		///
		return __this.__control.__progress;
	};
	static get_target		 = function() {
		/// @func	get_target()
		/// @return {real} target
		///
		return __this.__control.__target;
	};
	static get_state		 = function() {
		/// @func	get_state()
		/// @return {enum} state
		///
		return __this.__control.__state;
	};
	static get_is_reversed   = function() {
		/// @func	get_is_reversed()
		/// @return {boolean} is_reversed?
		///
		return __this.__control.__is_reversed;
	};
	static get_audio_emitter = function() {
		/// @func	get_audio_emitter()
		/// @return {emitter_id} audio_emitter
		///
		return __this.__audio.__emitter;
	};
	
	#endregion
	#region Actions ////////
	
	static enter   = function() {
		/// @func	enter()
		/// @return {FloeEffect} self
		///
		with (__this.__control) {
			__state  = __FLOE_STATE.ENTER_PREP;
			__target = __is_reversed ? 0 : 1;
		}
		return self;
	};
	static leave   = function() {
		/// @func	leave()
		/// @return {FloeEffect} self
		///
		with (__this.__control) {
			__state  = __FLOE_STATE.LEAVE_PREP;
			__target = __is_reversed ? 1 : 0;
		}
		return self;
	};
	static reverse = function(_reverse_progress = true) {
		/// @func	reverse(reverse_progress?*)
		/// @param	{bool} reverse_progress=true
		/// @return {FloeEffect} self
		///
		with (__this.__control) {
			__is_reversed = !__is_reversed;
			__target	  = 1 - __target;
		
			if (_reverse_progress) {
				__progress = 1 - __progress;
			}
		}
		return self;
	};
		
	#endregion
};
function FloeEffectSurface() : FloeEffect() constructor {
	/// @func FloeEffectSurface()
	///
	with (__this) {
		__surface = {
			__surface: surface_create(SURF_W, SURF_H),
		};
	}
	
	static cleanup_super = cleanup;
	static cleanup		 = function() {
		/// @func	cleanup()
		/// @return {FloeEffect} self
		///
		cleanup_super();
		
		with (__this.__surface) {
			if (surface_exists(__surface)) {
				surface_free(__surface);
			}
			__surface = undefined;
		}
		return self;
	};
	static render_begin  = function() {
		/// @func	render_begin()
		/// @return {FloeEffect} self
		///
		with (__this.__surface) {
			if (!surface_exists(__surface)) {
				__surface = surface_create(SURF_W, SURF_H);
			}
			surface_set_target(__surface); 
			draw_clear_alpha(c_black, 0.0);
		}
		return self;
	};
	static render_end    = function(_surface_shader_method) {
		/// @func	render_end(surface_shader_method*)
		/// @param	{shader} surface_shader_method
		/// @return {FloeEffect} self
		///
		surface_reset_target();	
		
		if (_surface_shader_method != undefined) {
			_surface_shader_method();	
		}
		draw_surface(__this.__surface.__surface, 0, 0);
		
		if (_surface_shader_method != undefined) {
			shader_reset();	
		}
		return self;
	};
		
	#region Getters ////////
	
	static get_surface = function() {
		/// @func	get_surface()
		/// @return {surface_id} surface
		///
		return __this.__surface.__surface;
	};
		
	#endregion
};
function FloeEffectFade() : FloeEffect() constructor {
	/// @func FloeEffectFade()
	///
	__threshold = 0.01;
	
	static render = function() {
		/// @func	render()
		/// @return {FloeEffect}
		///
		var _alpha = __alpha * __this.__control.__progress;
		draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, __color, _alpha);
		return self;
	};	
};
function FloeEffectWipeLeft() : FloeEffect() constructor {
	/// @func FloeEffectWipeLeft()
	///
	__threshold = 0.01;
	
	static render = function() {
		/// @func	render()
		/// @return {FloeEffect} 
		///
		var _width = SURF_W + __padding;
		var _x	   = _width - (_width * __this.__control.__progress) - (__padding * 0.5);
		draw_rectangle_alt(_x, 0, _width, SURF_H, 0, __color, __alpha);
		return self;
	};	
};
function FloeEffectWipeRight() : FloeEffect() constructor {
	/// @func FloeEffectWipeRight()
	///
	__threshold = 0.01;
	
	static render = function() {
		/// @func	render()
		/// @return {FloeEffect} self
		///
		var _width = SURF_W + __padding;
		var _x	   = -_width + (_width * __this.__control.__progress) - (__padding * 0.5);
		draw_rectangle_alt(_x, 0, _width, SURF_H, 0, __color, __alpha);
		return self;
	};	
};
function FloeEffectCircleCenter() : FloeEffectSurface() constructor {
	/// @func FloeEffectCircleCenter()
	///
	__threshold = 0.01;
	
	static render = function() {
		/// @func	render()
		/// @return {FloeEffect} self
		///
		render_begin(); {
			draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, __color, __alpha);
			gpu_set_blendmode(bm_subtract); {
				var _base   = SURF_H;
				var _radius = _base - (_base * __this.__control.__progress);
				draw_circle_color(SURF_W * 0.5, SURF_H * 0.5, _radius, c_white, c_white, false);
			} gpu_set_blendmode(bm_normal);
		} render_end();
		
		return self;
	};	
};
function FloeEffectCircleTarget() : FloeEffectSurface() constructor {
	/// @func FloeEffectCircleTarget()
	///
	__threshold = 0.01;
	
	static render = function() {
		/// @func render()
		///
		render_begin();
		
		/// ...
		
		render_end();
	};	
};
function FloeEffectBorderCenter() : FloeEffectSurface() constructor {
	/// @func FloeEffectBorderCenter()
	///
	__threshold = 0.01;
	
	static render = function() {
		/// @func	render()
		/// @return {FloeEffect} self
		///
		render_begin(); {
			draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, __color, __alpha);
			gpu_set_blendmode(bm_subtract); {
				var _base_w =  SURF_W + __padding;
				var _base_h =  SURF_H + __padding;
				var _width	= _base_w - (_base_w * __this.__control.__progress);
				var _height = _base_h - (_base_h * __this.__control.__progress);
				var _x		= (_base_w - _width ) * 0.5 - (__padding * 0.5);
				var _y		= (_base_h - _height) * 0.5 - (__padding * 0.5);
				draw_rectangle_alt(_x, _y, _width, _height, 0, c_white, 1.0);
			} gpu_set_blendmode(bm_normal);
		} render_end();
		
		return self;
	};	
};
function FloeEffectBorderTarget() : FloeEffectSurface() constructor {
	/// @func FloeEffectBorderTarget()
	///
	__threshold = 0.01;
	
	static render = function() {
		/// @func	render()
		/// @return {FloeEffect} self
		///
		render_begin();
		
		/// ...
		
		render_end();
		
		return self;
	};	
};
function FloeEffectBorderSprite(_sprite, _image = 0) : FloeEffectSurface() constructor {
	/// @func	FloeEffectBorderSprite(sprite, image*)
	/// @param	{sprite_index} sprite
	/// @param	{image_index } image=0
	///
	__sprite	= _sprite;
	__image		= _image;
	__threshold	=  0.005;
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
	
	__this.__control.__sprite_validated = false;
	
	static __validate_sprite = function() {
		/// @func __validate_sprite()
		///
		if (!__this.__control.__sprite_validated) {
			if (__sprite == undefined) {
				throw("ERROR: FloeEffectBorderSprite.sprite cannot be undefined");	
			}
			if (!sprite_get_nineslice(__sprite).enabled) {
				throw("ERROR: FloeEffectBorderSprite.sprite must be a nine-slice sprite");
			}
			__this.__control.__sprite_validated = true;
		}
	};
	
	#endregion
	#region Internal ///////
	
	static render = function() {
		/// @func render()
		///
		__validate_sprite();
		
		var _max_w	 =  SURF_W;
		var _max_h	 =  SURF_H;
		var _start_w = _max_w + (-__x_offset * 2);
		var _start_h = _max_h + (-__y_offset * 2);
		var _start_x = (SURF_W - _max_w) + __x_offset;
		var _start_y = (SURF_H - _max_h) + __y_offset;
		
		var _x = _start_x + ((_max_w - __x_offset) * (0.5 * __this.__control.__progress));
		var _y = _start_y + ((_max_h - __y_offset) * (0.5 * __this.__control.__progress));
		var _w = _start_w - ((_max_w - __x_offset) * __this.__control.__progress);
		var _h = _start_h - ((_max_h - __y_offset) * __this.__control.__progress);
		
		/// Sprite Shadow
		if (__draw_shadow) {
			shader_set(shdr_alpha_dither); {
				var _shadow_x = _x +  __shadow_inset;
				var _shadow_y = _y +  __shadow_inset;
				var _shadow_w = _w - (__shadow_inset * 2);
				var _shadow_h = _h - (__shadow_inset * 2);
				draw_sprite_stretched_ext(__sprite, __image, _shadow_x, _shadow_y, _shadow_w, _shadow_h, __shadow_color, __shadow_alpha);
			} shader_reset();
		}
		
		/// Primary Sprite
		draw_sprite_stretched_ext(__sprite, __image, _x, _y, _w, _h, __color, __alpha);
		
		/// Overlay Edge
		if (__overlay_edge) {
			render_begin(); {
				draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, __color, 1);
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
	};
		
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
	
	#endregion
};
////////////////////////////////////////////////////////////////////////////
function FloeEffectBorderTrees() : FloeEffectBorderSprite(__spr_transition_border_silhouette_trees) constructor {	// <-- custom implementation example. remove
	__overlay_edge = true;
	__draw_shadow  = true;
	__shadow_alpha = 0.8;
	__shadow_inset = 20;
	__color		   = CONFIG.color.orange;
	__x_offset	   = -50;
	__y_offset	   = -60;
};


