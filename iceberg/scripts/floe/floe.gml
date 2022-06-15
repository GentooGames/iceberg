/////////////////////////////
// r---. .     .---. r---. //
// r--   |     |   | r--   //
// L     L---- L---J L---J //
//////////////////////$(º)>//
#region docs, info & configs

#region about
/*
	written_by:__gentoo______
	version:_____0.1.0_______
*/ 
#endregion
#region change log

#region version 0.1.1
/*
	Date: 06/13/2022
	1. Added sfx_emitters & sounds
	2. Added general getter methods for base FloeEffect() class
*/
#endregion
#region version 0.1.0
/*	
	Date: 06/06/2022
	1. Released first version.
*/
#endregion

#endregion
#region docs & help

/// ...

#endregion
#region upcoming features
/*	
	- different interpolation types/methods
	- optimize performance through not drawing the surface every frame
	- transitions to do
		- "old school tv shutdown"
		- cross-fade
		- pixelation
*/
#endregion
#region enums

enum FLOE_STATE {
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
#region default config values

/// ...

#endregion

#endregion

function FloeEffect() constructor {
	/// @func FloeEffect()
	///
	color		=  c_black;
	alpha		=  1.0;
	speed		=  0.1;
	threshold	=  0.1;
	hold_time	= -1;
	on_enter	= {
		callback: undefined,
		data:	  undefined,
	};
	on_change	= {
		callback: undefined,
		data:	  undefined,
	};
	on_leave	= {
		callback: undefined,
		data:	  undefined,
	};
	on_end		= {
		callback: undefined,
		data:	  undefined,
	};
	
	#region Private ////////
	
	__progress	  = 0.0;
	__target	  = 1.0;
	__state		  = FLOE_STATE.HIDDEN;
	__is_reversed = false;
	__hold_timer  = 0;
	__padding	  = 20;	// offset to move effects offscreen for smoother animations
	
	/// Audio
	__sfx_emitter	  = audio_emitter_create();
	__sfx_play_method = audio_play_sound_on;	// change pointer for custom audio playing method
	__sfx_enter		  = undefined;
	__sfx_change	  = undefined;
	__sfx_leave		  = undefined;
	
	#endregion
	#region Internal ///////
	
	static update  = function() {
		/// @func update()
		///
		switch (__state) {
			case FLOE_STATE.ENTER_PREP: {
				if (on_enter.callback != undefined) {
					on_enter.callback(on_enter.data);		
				}
				if (__sfx_enter != undefined) {
					__sfx_play_method(__sfx_emitter, __sfx_enter, 0, 0);
				}
				__state = FLOE_STATE.ENTER;
				break;	
			}
			case FLOE_STATE.ENTER:	{
				__progress = lerp(__progress, __target, speed);
				
				if (abs(__progress - __target) <= threshold) {
					__progress = __target;
					__state	 = FLOE_STATE.CHANGE;
				}
				break;	
			}
			case FLOE_STATE.CHANGE:	{
				if (on_change.callback != undefined) {
					on_change.callback(on_change.data);	
				}
				if (__sfx_change != undefined) {
					__sfx_play_method(__sfx_emitter, __sfx_change, 0, 0);
				}
				__hold_timer = hold_time;
				__state = FLOE_STATE.HOLD;
				break;	
			}
			case FLOE_STATE.HOLD:	{
				if (__hold_timer > 0) {
					__hold_timer--;	
				}
				else {
					__state = FLOE_STATE.LEAVE_PREP;
				}
				break;	
			}
			case FLOE_STATE.LEAVE_PREP: {
				if (on_leave.callback != undefined) {
					on_leave.callback(on_leave.data);		
				}	
				if (__sfx_leave != undefined) {
					__sfx_play_method(__sfx_emitter, __sfx_leave, 0, 0);
				}
				__state = FLOE_STATE.LEAVE;
				break;	
			}
			case FLOE_STATE.LEAVE:	{
				__progress = lerp(__progress, __target, speed);
				
				if (abs(__progress - __target) <= threshold) {
					__progress = __target;
					__state	 = FLOE_STATE.END;
				}
				break;	
			}
			case FLOE_STATE.END:	{
				if (on_end.callback != undefined) {
					on_end.callback(on_end.data);	
				}
				__state = FLOE_STATE.HIDDEN;
				break;	
			}
		};
	};
	static cleanup = function() {
		audio_emitter_free(__sfx_emitter);
	};
	
	#endregion
	#region Setters ////////
		
	static set_color		= function(_color) {
		/// @func	set_color(color)
		/// @param	{color} color
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		color = _color;
		return self;
	};
	static set_alpha		= function(_alpha) {
		/// @func	set_alpha(alpha)
		/// @param	{real} alpha
		/// @return {FloeEffect} self
		///
		alpha = _alpha;
		return self;
	};
	static set_speed		= function(_speed) {
		/// @func	set_speed(speed)
		/// @param	{real} speed
		/// @return {FloeEffect} self
		///
		speed = _speed;
		return self;
	};
	static set_threshold	= function(_threshold) {
		/// @func	set_threshold(threshold)
		/// @param	{real} threshold
		/// @return {FloeEffect} self
		///
		threshold = _threshold;
		return self;
	};
	static set_hold_time	= function(_hold_time) {
		/// @func	set_hold_time(hold_time)
		/// @param	{real} hold_time
		/// @return {FloeEffect} self
		///
		hold_time = _hold_time;
		return self;
	};
	static set_on_enter		= function(_callback, _data) {
		/// @func	set_on_enter(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		with (on_enter) {
			callback = _callback;
			data	 = _data;
		}
		return self;
	};
	static set_on_change	= function(_callback, _data) {
		/// @func	set_on_change(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		with (on_change) {
			callback = _callback;
			data	 = _data;
		}
		return self;
	};
	static set_on_leave		= function(_callback, _data) {
		/// @func	set_on_leave(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		with (on_leave) {
			callback = _callback;
			data	 = _data;
		}
		return self;
	};
	static set_on_end		= function(_callback, _data) {
		/// @func	set_on_end(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return {FloeEffect} self
		///
		with (on_end) {
			callback = _callback;
			data	 = _data;
		}
		return self;
	};
	static set_progress		= function(_progress) {
		/// @func	set_progress(progress)
		/// @param	{real} progress
		/// @return {FloeEffect} self
		///
		__progress = _progress;
		return self;
	};
	static set_target		= function(_target) {
		/// @func	set_target(target)
		/// @param	{real} target
		/// @return {FloeEffect} self
		///
		__target = _target;
		return self;
	};
	static set_state		= function(_state) {
		/// @func	set_state(state)
		/// @param	{enum} state
		/// @return {FloeEffect} self
		///
		__state = _state;
		return self;
	};
	static set_is_reversed	= function(_is_reversed) {
		/// @func	set_is_reversed(is_reversed)
		/// @param	{boolean} is_reversed?
		/// @return {FloeEffect} self
		///
		__is_reversed = _is_reversed;
		return self;
	};
	static set_sound_enter	= function(_sound) {
		/// @func	set_sound_enter(sound)
		/// @param	{sound_id} sound
		/// @return {FloeEffect} self
		///
		__sfx_enter = _sound;
		return self;
	};
	static set_sound_change	= function(_sound) {
		/// @func	set_sound_change(sound)
		/// @param	{sound_id} sound
		/// @return {FloeEffect} self
		///
		__sfx_change = _sound;
		return self;
	};
	static set_sound_leave	= function(_sound) {
		/// @func	set_sound_leave(sound)
		/// @param	{sound_id} sound
		/// @return {FloeEffect} self
		///
		__sfx_leave = _sound;
		return self;
	};
	
	#endregion
	#region Getters ////////
	
	get_color		  = function() {
		/// @func	get_color()
		/// @return {color} color
		///
		return color;
	};
	get_alpha		  = function() {
		/// @func	get_alpha()
		/// @return {real} alpha
		///
		return alpha;
	};
	get_speed		  = function() {
		/// @func	get_speed()
		/// @return {real} speed
		///
		return speed;
	};
	get_threshold	  = function() {
		/// @func	get_threshold()
		/// @return {real} threshold
		///
		return threshold;
	};
	get_hold_time	  = function() {
		/// @func	get_hold_time()
		/// @return {real} hold_time
		///
		return hold_time;
	};
	get_on_enter	  = function() {
		/// @func	get_on_enter()
		/// @return {struct} on_enter
		///
		return on_enter;
	};
	get_on_change	  = function() {
		/// @func	get_on_change()
		/// @return {struct} on_change
		///
		return on_change;
	};
	get_on_leave	  = function() {
		/// @func	get_on_leave()
		/// @return {struct} on_leave
		///
		return on_leave;
	};
	get_on_end		  = function() {
		/// @func	get_on_end()
		/// @return {struct} on_end
		///
		return on_end;
	};
	get_progress	  = function() {
		/// @func	get_progress()
		/// @return {real} progress
		///
		return __progress;
	};
	get_target		  = function() {
		/// @func	get_target()
		/// @return {real} target
		///
		return __target;
	};
	get_state		  = function() {
		/// @func	get_state()
		/// @return {enum} state
		///
		return __state;
	};
	get_is_reversed   = function() {
		/// @func	get_is_reversed()
		/// @return {boolean} is_reversed?
		///
		return __is_reversed;
	};
	get_audio_emitter = function() {
		/// @func	get_audio_emitter()
		/// @return {emitter_id} audio_emitter
		///
		return __sfx_emitter;
	};
	get_sfx_on_enter  = function() {
		/// @func	get_sfx_on_enter()
		/// @return {audio_id} sfx_on_enter
		///
		return __sfx_enter;
	};
	get_sfx_on_change = function() {
		/// @func	get_sfx_on_change()
		/// @return {audio_id} sfx_on_change
		///
		return __sfx_change;
	};
	get_sfx_on_leave  = function() {
		/// @func	get_sfx_on_leave()
		/// @return {audio_id} sfx_on_leave
		///
		return __sfx_leave;
	};
	
	#endregion
	#region Actions ////////
	
	static enter   = function() {
		/// @func enter()
		///
		__state  = FLOE_STATE.ENTER_PREP;
		__target = __is_reversed ? 0 : 1;
	};
	static leave   = function() {
		/// @func leave()
		///
		__state  = FLOE_STATE.LEAVE_PREP;
		__target = __is_reversed ? 1 : 0;
	};
	static reverse = function(_reverse_progress = true) {
		/// @func	reverse(reverse_progress?*)
		/// @param	{bool} reverse_progress=true
		///
		__is_reversed = !__is_reversed;
		__target	  = 1 - __target;
		
		if (_reverse_progress) {
			__progress = 1 - __progress;
		}
	};
		
	#endregion
};
function FloeEffectSurface() : FloeEffect() constructor {
	/// @func FloeEffectSurface()
	///
	__surface = surface_create(SURF_W, SURF_H);
	
	#region Internal ///////
	
	static cleanup_super = cleanup;
	static cleanup		 = function() {
		/// @func cleanup()
		///
		cleanup_super();
		if (surface_exists(__surface)) {
			surface_free(__surface);
		}
		__surface = undefined;
	};
	static render_begin  = function() {
		/// @func render_begin()
		///
		if (!surface_exists(__surface)) {
			__surface = surface_create(SURF_W, SURF_H);
		}
		surface_set_target(__surface); 
		draw_clear_alpha(c_black, 0.0);
	};
	static render_end    = function(_surface_shader_method) {
		/// @func	render_end(surface_shader_method*)
		/// @param	{shader} surface_shader_method
		///
		surface_reset_target();	
		
		if (_surface_shader_method != undefined) {
			_surface_shader_method();	
		}
		draw_surface(__surface, 0, 0);
		
		if (_surface_shader_method != undefined) {
			shader_reset();	
		}
	};
		
	#endregion
	#region Getters ////////
	
	static get_surface = function() {
		/// @func	get_surface()
		/// @return {surface_id} surface
		///
		return __surface;
	};
		
	#endregion
};
function FloeEffectFade() : FloeEffect() constructor {
	/// @func FloeEffectFade()
	///
	threshold = 0.01;
	
	static render = function() {
		/// @func render()
		///
		var _alpha = alpha * __progress;
		draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, color, _alpha);
	};	
};
function FloeEffectWipeLeft() : FloeEffect() constructor {
	/// @func FloeEffectWipeLeft()
	///
	threshold = 0.01;
	
	static render = function() {
		/// @func render()
		///
		var _width = SURF_W + __padding;
		var _x	   = _width - (_width * __progress) - (__padding * 0.5);
		draw_rectangle_alt(_x, 0, _width, SURF_H, 0, color, alpha);
	};	
};
function FloeEffectWipeRight() : FloeEffect() constructor {
	/// @func FloeEffectWipeRight()
	///
	threshold = 0.01;
	
	static render = function() {
		/// @func render()
		///
		var _width = SURF_W + __padding;
		var _x	   = -_width + (_width * __progress) - (__padding * 0.5);
		draw_rectangle_alt(_x, 0, _width, SURF_H, 0, color, alpha);
	};	
};
function FloeEffectCircleCenter() : FloeEffectSurface() constructor {
	/// @func FloeEffectCircleCenter()
	///
	threshold = 0.01;
	
	static render = function() {
		/// @func render()
		///
		render_begin(); {
			draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, color, alpha);
			gpu_set_blendmode(bm_subtract); {
				var _base   = SURF_H;
				var _radius = _base - (_base * __progress);
				draw_circle_color(SURF_W * 0.5, SURF_H * 0.5, _radius, c_white, c_white, false);
			} gpu_set_blendmode(bm_normal);
		} render_end();
	};	
};
function FloeEffectCircleTarget() : FloeEffectSurface() constructor {
	/// @func FloeEffectCircleTarget()
	///
	threshold = 0.01;
	
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
	threshold = 0.01;
	
	static render = function() {
		/// @func render()
		///
		render_begin(); {
			draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, color, alpha);
			gpu_set_blendmode(bm_subtract); {
				var _base_w =  SURF_W + __padding;
				var _base_h =  SURF_H + __padding;
				var _width	= _base_w - (_base_w * __progress);
				var _height = _base_h - (_base_h * __progress);
				var _x		= (_base_w - _width ) * 0.5 - (__padding * 0.5);
				var _y		= (_base_h - _height) * 0.5 - (__padding * 0.5);
				draw_rectangle_alt(_x, _y, _width, _height, 0, c_white, 1.0);
			} gpu_set_blendmode(bm_normal);
		} render_end();
	};	
};
function FloeEffectBorderTarget() : FloeEffectSurface() constructor {
	/// @func FloeEffectBorderTarget()
	///
	threshold = 0.01;
	
	static render = function() {
		/// @func render()
		///
		render_begin();
		
		/// ...
		
		render_end();
	};	
};
function FloeEffectBorderSprite(_sprite, _image = 0) : FloeEffectSurface() constructor {
	/// @func	FloeEffectBorderSprite(sprite, image*)
	/// @param	{sprite_index} sprite
	/// @param	{image_index } image=0
	///
	sprite		  = _sprite;
	image		  = _image;
	threshold	  =  0.005;
	x_offset	  = -get_sprite_width()  * 0.5;		// amount sprite will be offset from origin
	y_offset	  = -get_sprite_height() * 0.5;		// amount sprite will be offset from origin
	
	/// Shadow
	draw_shadow   = false;
	shadow_alpha  = 1.0;
	shadow_color  = c_black;
	shadow_inset  = 0;	
	
	/// Overlay
	overlay_edge	= true;
	overlay_inset_x	= get_sprite_width()  * (1 / 6);	// amount that overlay surface will inset into the sprite
	overlay_inset_y	= get_sprite_height() * (1 / 6);	// amount that overlay surface will inset into the sprite

	#region Private ////////
	
	__validated	= false;
	
	static __validate_sprite = function() {
		/// @func __validate_sprite()
		///
		if (!__validated) {
			if (sprite == undefined) {
				throw("ERROR: FloeEffectBorderSprite.sprite cannot be undefined");	
			}
			if (!sprite_get_nineslice(sprite).enabled) {
				throw("ERROR: FloeEffectBorderSprite.sprite must be a nine-slice sprite");
			}
			__validated = true;
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
		var _start_w = _max_w + (-x_offset * 2);
		var _start_h = _max_h + (-y_offset * 2);
		var _start_x = (SURF_W - _max_w) + x_offset;
		var _start_y = (SURF_H - _max_h) + y_offset;
		
		var _x = _start_x + ((_max_w - x_offset) * (0.5 * __progress));
		var _y = _start_y + ((_max_h - y_offset) * (0.5 * __progress));
		var _w = _start_w - ((_max_w - x_offset) * __progress);
		var _h = _start_h - ((_max_h - y_offset) * __progress);
		
		/// Sprite Shadow
		if (draw_shadow) {
			shader_set(shdr_alpha_dither); {
				var _shadow_x = _x +  shadow_inset;
				var _shadow_y = _y +  shadow_inset;
				var _shadow_w = _w - (shadow_inset * 2);
				var _shadow_h = _h - (shadow_inset * 2);
				draw_sprite_stretched_ext(sprite, image, _shadow_x, _shadow_y, _shadow_w, _shadow_h, shadow_color, shadow_alpha);
			} shader_reset();
		}
		
		/// Primary Sprite
		draw_sprite_stretched_ext(sprite, image, _x, _y, _w, _h, color, alpha);
		
		/// Overlay Edge
		if (overlay_edge) {
			render_begin(); {
				draw_rectangle_alt(0, 0, SURF_W, SURF_H, 0, color, 1);
				gpu_set_blendmode(bm_subtract); {
					draw_rectangle_alt(
						_x +  overlay_inset_x,
						_y +  overlay_inset_y,
						max(0, _w - (overlay_inset_x * 2)), 
						max(0, _h - (overlay_inset_y * 2)), 
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
		return sprite;
	};
	static get_sprite_width  = function() {
		/// @func	get_sprite_width()
		/// @return {real} sprite_width
		///
		return sprite_get_width(sprite);	
	};
	static get_sprite_height = function() {
		/// @func	get_sprite_height()
		/// @return {real} sprite_height
		///
		return sprite_get_height(sprite);	
	};
	static get_image		 = function() {
		/// @func	get_image()
		/// @return {real} image_index
		///
		return image;
	};
	static get_x_offset		 = function() {
		/// @func	get_x_offset()
		/// @return {real} x_offset
		///
		return x_offset;
	};
	static get_y_offset		 = function() {
		/// @func	get_y_offset()
		/// @return {real} y_offset
		///
		return y_offset;
	};
	static get_draw_shadow	 = function() {
		/// @func	get_draw_shadow()
		/// @return {boolean} draw_shadow?
		///
		return draw_shadow;
	};
	static get_shadow_alpha  = function() {
		/// @func	get_shadow_alpha()
		/// @return {real} shadow_alpha
		///
		return shadow_alpha;
	};
	static get_shadow_color  = function() {
		/// @func	get_shadow_color()
		/// @return {real} shadow_color
		///
		return shadow_color;	
	};
	static get_shadow_inset	 = function() {
		/// @func	get_shadow_inset()
		/// @return {real} shadow_inset
		///
		return shadow_inset;	
	};
	static get_overlay_edge  = function() {
		/// @func	get_overlay_edge()
		/// @return {boolean} overlay_edge?
		///
		return overlay_edge;
	};
	
	#endregion
	#region Setters ////////
	
	static set_sprite		 = function(_sprite) {
		/// @func	set_sprite(sprite)
		/// @param	{sprite_index} sprite
		/// @return {FloeEffect} self
		///
		sprite = _sprite;
		return self;
	};
	static set_image		 = function(_image) {
		/// @func	set_image(image)
		/// @param	{image_index} image
		/// @return {FloeEffect} self
		///
		image = _image;
		return self;
	};
	static set_x_offset		 = function(_x_offset) {
		/// @func	set_x_offset(x_offset)
		/// @param	{real} x_offset
		/// @return {FloeEffect} self
		///
		x_offset = _x_offset;
		return self;
	};
	static set_y_offset		 = function(_y_offset) {
		/// @func	set_y_offset(y_offset)
		/// @param	{real} y_offset
		/// @return {FloeEffect} self
		///
		y_offset = _y_offset;
		return self;
	};
	static set_draw_shadow   = function(_draw_shadow) {
		/// @func	set_draw_shadow(draw_shadow?)
		/// @param	{boolean} draw_shadow?
		/// @return {FloeEffect} self
		///
		draw_shadow = _draw_shadow;
		return self;
	};
	static set_shadow_alpha	 = function(_shadow_alpha) {
		/// @func	set_shadow_alpha(shadow_alpha)
		/// @param	{real} shadow_alpha
		/// @return {FloeEffect} self
		///
		shadow_alpha = _shadow_alpha;
		return self;
	};
	static set_shadow_color	 = function(_shadow_color) {
		/// @func	set_shadow_color(shadow_color)
		/// @param	{color} shadow_color
		/// @return {FloeEffect} self
		///
		shadow_color = _shadow_color;
		return self;
	};
	static set_shadow_inset	 = function(_shadow_inset) {
		/// @func	set_shadow_inset(shadow_inset)
		/// @param	{real} shadow_inset
		/// @return {FloeEffect} self
		///
		shadow_inset = _shadow_inset;
		return self;
	};
	static set_overlay_edge	 = function(_overlay_edge) {
		/// @func	set_overlay_edge(overlay_edge?)
		/// @param	{boolean} overlay_edge?
		/// @return {FloeEffect} self
		///
		overlay_edge = _overlay_edge;
		return self;
	};
	
	#endregion
};
////////////////////////////////////////////////////////////////////////////
function FloeEffectBorderTrees() : FloeEffectBorderSprite(__spr_transition_border_silhouette_trees) constructor {
	overlay_edge = true;
	draw_shadow  = true;
	shadow_alpha = 0.8;
	shadow_inset = 20;
	color		 = CONFIG.color.orange;
	x_offset	 = -50;
	y_offset	 = -60;
};


