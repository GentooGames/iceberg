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
	- Canopy Trees
		- define custom sprites to draw for transitions using nine-slice
		- draw canopy trees onto surface w/sine-wave shader for subtle animations
		- canopy trees particle leaves
	
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

#macro __FLOE_DEFAULT_EFFECT_IN			FloeEffectBorderSprite
#macro __FLOE_DEFAULT_EFFECT_IN_DATA	{ sprite: __spr_transition_border_silhouette_trees, image: 1 }
#macro __FLOE_DEFAULT_EFFECT_OUT		__FLOE_DEFAULT_EFFECT_IN
#macro __FLOE_DEFAULT_EFFECT_OUT_DATA	__FLOE_DEFAULT_EFFECT_IN_DATA
#macro __FLOE_EFFECT_DEFAULT_COLOR		c_black
#macro __FLOE_EFFECT_DEFAULT_ALPHA		1.0
#macro __FLOE_EFFECT_DEFAULT_SPEED		0.1
#macro __FLOE_EFFECT_DEFAULT_THRESHOLD	0.1
#macro __FLOE_EFFECT_DEFAULT_HOLD_TIME	-1
#macro __FLOE_EFFECT_DEFAULT_PADDING	20

function FloeEffect() constructor {
	/// @func FloeEffect()
	///
	color		= __FLOE_EFFECT_DEFAULT_COLOR;
	alpha		= __FLOE_EFFECT_DEFAULT_ALPHA;
	speed		= __FLOE_EFFECT_DEFAULT_SPEED;
	threshold	= __FLOE_EFFECT_DEFAULT_THRESHOLD;
	hold_time	= __FLOE_EFFECT_DEFAULT_HOLD_TIME;
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
	
	progress	= 0.0;
	target		= 1.0;
	surface		= undefined;
	state		= FLOE_STATE.HIDDEN;
	is_reversed	= false;
	hold_timer  = 0;
		
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
	static cleanup = function() {
		/// @func cleanup()
		///
		if (surface != undefined) {
			if (surface_exists(surface)) {
				surface_free(surface);
			}
			surface = undefined;
		}
	};
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
	surface = surface_create(SW, SH);
	
	static render_begin = function() {
		/// @func render_begin()
		///
		if (!surface_exists(surface)) {
			surface = surface_create(SW, SH);
		}
		surface_set_target(surface); 
		draw_clear_alpha(c_black, 0.0);
	};
	static render_end   = function(_shader_method) {
		/// @func	render_end(shader_method*)
		/// @param	{shader} shader_method
		///
		surface_reset_target();	
		
		if (_shader_method != undefined) {
			_shader_method();	
		}
		draw_surface(surface, 0, 0);
		
		if (_shader_method != undefined) {
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
		draw_rectangle_alt(0, 0, SW, SH, 0, color, _alpha);
	};	
};
function FloeEffectWipeLeft() : FloeEffect() constructor {
	/// @func FloeEffectWipeLeft()
	///
	threshold = 0.01;
	
	static render = function() {
		/// @func render()
		///
		var _pad	= __FLOE_EFFECT_DEFAULT_PADDING;
		var _width	= SW + _pad;
		var _x		= _width - (_width * progress) - (_pad * 0.5);
		draw_rectangle_alt(_x, 0, _width, SH, 0, color, alpha);
	};	
};
function FloeEffectWipeRight() : FloeEffect() constructor {
	/// @func FloeEffectWipeRight()
	///
	threshold = 0.01;
	
	static render = function() {
		/// @func render()
		///
		var _pad	= __FLOE_EFFECT_DEFAULT_PADDING;
		var _width	= SW + _pad;
		var _x		= -_width + (_width * progress) - (_pad * 0.5);
		draw_rectangle_alt(_x, 0, _width, SH, 0, color, alpha);
	};	
};
function FloeEffectCircleCenter() : FloeEffectSurface() constructor {
	/// @func FloeEffectCircleCenter()
	///
	threshold = 0.01;
	
	static render = function() {
		/// @func render()
		///
		render_begin();
		draw_rectangle_alt(0, 0, SW, SH, 0, color, alpha);
		gpu_set_blendmode(bm_subtract);
		
		var _base   = SH;
		var _radius = _base - (_base * progress);
		draw_circle_color(SW * 0.5, SH * 0.5, _radius, c_white, c_white, false);
		
		gpu_set_blendmode(bm_normal);
		render_end();
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
		render_begin();
		draw_rectangle_alt(0, 0, SW, SH, 0, color, alpha);
		gpu_set_blendmode(bm_subtract);
		
		var _pad	=  __FLOE_EFFECT_DEFAULT_PADDING;
		var _base_w =  SW + _pad;
		var _base_h =  SH + _pad;
		var _width	= _base_w - (_base_w * progress);
		var _height = _base_h - (_base_h * progress);
		var _x		= (_base_w - _width ) * 0.5 - (_pad * 0.5);
		var _y		= (_base_h - _height) * 0.5 - (_pad * 0.5);
		draw_rectangle_alt(_x, _y, _width, _height, 0, c_white, 1.0);
		
		gpu_set_blendmode(bm_normal);
		render_end();
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
function FloeEffectBorderSprite(_data) : FloeEffectSurface() constructor {
	/// @func FloeEffectBorderSprite(data)
	///
	threshold = 0.005;
	sprite	  = _data.sprite;
	image	  = _data.image;
	color	  = CONFIG.color.orange;//_data.color;
	shader	  = shdr_sine_wave;
	u_time	  = shader_get_uniform(shader, "u_time");
	u_texel	  = shader_get_uniform(shader, "u_texel");
	u_x_props = shader_get_uniform(shader, "u_x_props");
	u_y_props = shader_get_uniform(shader, "u_y_props");
	
	static render = function() {
		/// @func render()
		///
		color = TRANSITION.color;
		
		var _offset = 60;
		var _x		= -_offset;
		var _y		= -_offset;
		var _width	= SW + (_offset * 2) - (SW * progress);
		var _height = SH + (_offset * 2) - (SH * progress) + 5;
		_x += SW * (0.5 * progress);
		_y += SH * (0.5 * progress);
		
		shader_set(shdr_alpha_dither);
		var _pad = 15;
		draw_sprite_stretched_ext(sprite, 0, _x + _pad, _y + _pad, _width - (_pad * 2), _height - (_pad * 2), color, 0.8);
		shader_reset();
		
		draw_sprite_stretched_ext(sprite, image, _x, _y, _width, _height, color, 1);
		
		/// Surface Rendering
		render_begin();
		draw_rectangle_alt(0, 0, SW, SH, 0, color, 1);
		gpu_set_blendmode(bm_subtract);
		draw_rectangle_alt(
			_x +  _offset,
			_y +  _offset,
			_width  - (_offset * 2), 
			_height - (_offset * 2), 
			0, 
			c_white, 
			1
		);
		gpu_set_blendmode(bm_normal);
		render_end();
		//render_end(function() {
		//	shader_set(shader);
		//	shader_set_uniform_f(u_time, current_time);
		//	var _texel_min    = 0.003;
		//	var _texel_max    = 0.03;
		//	var _texel_ratio  = 1;
		//	var _texel_width  = (_texel_max - _texel_min) * _texel_ratio;
		//	var _texel_height = (_texel_max - _texel_min) * _texel_ratio;
		//	shader_set_uniform_f(u_texel, _texel_width, _texel_height);
		//	shader_set_uniform_f_array(u_x_props, [0.005, 20.0, 0.2]);
		//	shader_set_uniform_f_array(u_y_props, [0.005, 20.0, 0.2]);
		//});
	};
};























