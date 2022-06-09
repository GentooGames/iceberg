/////////////////////////////
// r---. .     .---. r---. //
// r--   |     |   | r--   //
// L     L---- L---J L---J //
#region //////////////$(*)>//

#region about
/*
	written_by:__gentoo______
	version:_____0.1.0_______
*/ 
#endregion
#region change log

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
	on_enter	=  {
		callback: undefined,
		data:	  undefined,
	};
	on_change	=  {
		callback: undefined,
		data:	  undefined,
	};
	on_leave	=  {
		callback: undefined,
		data:	  undefined,
	};
	on_end		=  {
		callback: undefined,
		data:	  undefined,
	};
	
	progress	= 0.0;
	target		= 1.0;
	state		= FLOE_STATE.HIDDEN;
	is_reversed	= false;
	hold_timer  = 0;
	
	__padding	= 20;	// offset to move effects offscreen for smoother animations
		
	static update  = function() {
		/// @func update()
		///
		switch (state) {
			case FLOE_STATE.ENTER_PREP: {
				if (on_enter.callback != undefined) {
					on_enter.callback(on_enter.data);		
				}
				state = FLOE_STATE.ENTER;
				break;	
			}
			case FLOE_STATE.ENTER:	{
				progress = lerp(progress, target, speed);
				
				if (abs(progress - target) <= threshold) {
					progress = target;
					state	 = FLOE_STATE.CHANGE;
				}
				break;	
			}
			case FLOE_STATE.CHANGE:	{
				if (on_change.callback != undefined) {
					on_change.callback(on_change.data);	
				}
				hold_timer = hold_time;
				state = FLOE_STATE.HOLD;
				break;	
			}
			case FLOE_STATE.HOLD:	{
				if (hold_timer > 0) {
					hold_timer--;	
				}
				else {
					state = FLOE_STATE.LEAVE_PREP;
				}
				break;	
			}
			case FLOE_STATE.LEAVE_PREP: {
				if (on_leave.callback != undefined) {
					on_leave.callback(on_leave.data);		
				}	
				state = FLOE_STATE.LEAVE;
				break;	
			}
			case FLOE_STATE.LEAVE:	{
				progress = lerp(progress, target, speed);
				
				if (abs(progress - target) <= threshold) {
					progress = target;
					state	 = FLOE_STATE.END;
				}
				break;	
			}
			case FLOE_STATE.END:	{
				if (on_end.callback != undefined) {
					on_end.callback(on_end.data);	
				}
				state = FLOE_STATE.HIDDEN;
				break;	
			}
		};
	};
	static cleanup = function() {};
	static enter   = function() {
		/// @func enter()
		///
		state  = FLOE_STATE.ENTER_PREP;
		target = is_reversed ? 0 : 1;
	};
	static leave   = function() {
		/// @func leave()
		///
		state  = FLOE_STATE.LEAVE_PREP;
		target = is_reversed ? 1 : 0;
	};
	static reverse = function(_reverse_progress = true) {
		/// @func	reverse(reverse_progress?*)
		/// @param	{bool} reverse_progress=true
		///
		is_reversed = !is_reversed;
		target		= 1 - target;
		
		if (_reverse_progress) {
			progress = 1 - progress;
		}
	};
		
	static set_on_enter  = function(_callback, _data) {
		/// @func	set_on_enter(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return NA
		///
		with (on_enter) {
			callback = _callback;
			data	 = _data;
		}
	};
	static set_on_change = function(_callback, _data) {
		/// @func	set_on_change(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return NA
		///
		with (on_change) {
			callback = _callback;
			data	 = _data;
		}
	};
	static set_on_leave  = function(_callback, _data) {
		/// @func	set_on_leave(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return NA
		///
		with (on_leave) {
			callback = _callback;
			data	 = _data;
		}
	};
	static set_on_end	 = function(_callback, _data) {
		/// @func	set_on_end(callback, data*)
		/// @param	{method} callback
		/// @param	{any} data=undefined
		/// @return NA
		///
		with (on_end) {
			callback = _callback;
			data	 = _data;
		}
	};
};
function FloeEffectSurface() : FloeEffect() constructor {
	/// @func FloeEffectSurface()
	///
	surface = surface_create(SURF_W, SURF_H);
	
	static cleanup		= function() {
		/// @func cleanup()
		///
		if (surface_exists(surface)) {
			surface_free(surface);
		}
		surface = undefined;
	};
	static render_begin = function() {
		/// @func render_begin()
		///
		if (!surface_exists(surface)) {
			surface = surface_create(SURF_W, SURF_H);
		}
		surface_set_target(surface); 
		draw_clear_alpha(c_black, 0.0);
	};
	static render_end   = function(_surface_shader_method) {
		/// @func	render_end(surface_shader_method*)
		/// @param	{shader} surface_shader_method
		///
		surface_reset_target();	
		
		if (_surface_shader_method != undefined) {
			_surface_shader_method();	
		}
		
		draw_surface(surface, 0, 0);
		
		if (_surface_shader_method != undefined) {
			shader_reset();	
		}
	};
};
function FloeEffectFade() : FloeEffect() constructor {
	/// @func FloeEffectFade()
	///
	threshold = 0.01;
	
	static render = function() {
		/// @func render()
		///
		var _alpha = alpha * progress;
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
		var _x	   = _width - (_width * progress) - (__padding * 0.5);
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
		var _x	   = -_width + (_width * progress) - (__padding * 0.5);
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
				var _radius = _base - (_base * progress);
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
				var _width	= _base_w - (_base_w * progress);
				var _height = _base_h - (_base_h * progress);
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

	/// Private
	__validated	  = false;
	
	/// Internal
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
		
		var _x = _start_x + ((_max_w - x_offset) * (0.5 * progress));
		var _y = _start_y + ((_max_h - y_offset) * (0.5 * progress));
		var _w = _start_w - ((_max_w - x_offset) * progress);
		var _h = _start_h - ((_max_h - y_offset) * progress);
		
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
		
	/// Public
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
		
	/// Private
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
};
////////////////////////////////////////////////////////////////////////////
function FloeEffectBorderTrees() : FloeEffectBorderSprite(__spr_transition_border_silhouette_trees) constructor {
	image		 = 1;
	overlay_edge = true;
	draw_shadow  = true;
	shadow_alpha = 0.8;
	shadow_inset = 20;
	color		 = CONFIG.color.orange;
	x_offset	 = -50;
	y_offset	 = -60;
};
