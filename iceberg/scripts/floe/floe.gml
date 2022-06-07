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
	- define custom sprites to draw for transitions
	- optimize performance through not drawing the surface every frame
	- transition hold time
	- make sure to garbage collect surfaces on FloeEffects()
	- different interpolation types/methods
	- transitions to do
		- "old school tv shutdown"
		- cross-fade
		- pixelation
*/
#endregion
#region enums

enum FLOE_STATE {
	HIDDEN,
	ENTER,
	CHANGE,
	HOLD,
	LEAVE,
	END,
};

#endregion
#region default config values

/// ...

#endregion

#endregion

#macro __FLOE_EFFECT_DEFAULT_COLOR		c_black
#macro __FLOE_EFFECT_DEFAULT_ALPHA		1.0
#macro __FLOE_EFFECT_DEFAULT_SPEED		0.1
#macro __FLOE_EFFECT_DEFAULT_THRESHOLD	0.1

function FloeEffect() constructor {
	/// @func FloeEffect()
	///
	color		= __FLOE_EFFECT_DEFAULT_COLOR;
	alpha		= __FLOE_EFFECT_DEFAULT_ALPHA;
	speed		= __FLOE_EFFECT_DEFAULT_SPEED;
	threshold	= __FLOE_EFFECT_DEFAULT_THRESHOLD;
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
		
	static update  = function() {
		/// @func update()
		///
		switch (state) {
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
				state = FLOE_STATE.HOLD;
				break;	
			}
			case FLOE_STATE.HOLD:	{
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
		//show_debug_message("effect_surface: " + string(surface_exists(surface)));
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
		if (on_enter.callback != undefined) {
			on_enter.callback(on_enter.data);		
		}
		state  = FLOE_STATE.ENTER;
		target = is_reversed ? 0 : 1;
	};
	static leave   = function() {
		/// @func leave()
		///
		if (on_leave.callback != undefined) {
			on_leave.callback(on_leave.data);		
		}
		state  = FLOE_STATE.LEAVE;
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
	static render_end   = function() {
		/// @func render_end()
		///
		surface_reset_target();	
		draw_surface(surface, 0, 0);
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
		var _pad	= 50;
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
		var _pad	= 50;
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
		
		var _width  =  SW - (SW * progress);
		var _height =  SH - (SH * progress);
		var _x		= (SW - _width ) * 0.5;
		var _y		= (SH - _height) * 0.5;
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