function Border(_sprite, _image = 0) constructor {
	/// @func	Border(sprite, image*)
	/// @param	{sprite_index} sprite
	/// @param	{image_index } image=0
	///
	sprite   = new GProp({ name: "sprite",	 value: _sprite			});
	image    = new GProp({ name: "image",	 value: _image			});
	color    = new GProp({ name: "color",	 value: c_white			});
	alpha    = new GProp({ name: "alpha",	 value: 1				});
	x	     = new GProp({ name: "x",		 value: 0				});
	y	     = new GProp({ name: "y",		 value: 0				});
	width	 = new GProp({ name: "width",	 value: SURF_W			});
	height   = new GProp({ name: "height",	 value: SURF_H			});
	scale    = new GProp({ name: "scale",	 value: 1				});
	x_scale  = new GProp({ name: "x_scale",  value: 1 * scale.value });
	y_scale  = new GProp({ name: "y_scale",  value: 1 * scale.value });
	
	/// Shadow
	shadow_visible = true;
	shadow_color   = c_black;
	shadow_alpha   = 0.8;
	shadow_inset   = 20;
	
	/// Private
	__surface = surface_create(width.value, height.value);
	
	#region Internal
	
	static update		 = function() {
		/// @func	update()
		/// @return {Border} self
		///
		sprite.update();
		image.update();
		color.update();
		alpha.update();
		x.update();
		y.update();
		width.update();
		height.update();
		scale.update();
		x_scale.update();
		y_scale.update();
		
		return self;
	};
	static render_shadow = function() {
		/// @func render_shadow()
		///
		shader_set(shdr_alpha_dither); {
			draw_sprite_stretched_ext(
				get_sprite(), 
				get_image(), 
				get_x() + shadow_inset, 
				get_y() + shadow_inset,
				get_width()  - (shadow_inset * 2),
				get_height() - (shadow_inset * 2),
				shadow_color, 
				shadow_alpha,
			);
		} shader_reset();
	};
	static render_border = function(_draw_surface = true) {
		/// @func	render_border(draw_surface?*)
		/// @param	{bool} draw_surface=true
		///
		__surface = surface_ensure(__surface, get_width(), get_height());
		surface_set_target(__surface); {
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_stretched_ext(
				get_sprite(), 
				get_image(), 
				get_x(), 
				get_y(),
				get_width(),  
				get_height(),
				get_color(), 
				get_alpha(),
			);
		} surface_reset_target();
		
		if (_draw_surface) {
			draw_surface(__surface, 0, 0);
		}
	};
	static render		 = function() {
		/// @func render()
		///
		if (shadow_visible) {
			render_shadow();
		}
		render_border();
	};
	static cleanup		 = function() {
		if (surface_exists(__surface)) {
			surface_free(__surface);	
		}
		__surface = undefined;
	};
	
	#endregion
	#region Public
	
	#region Getters
	
	static get_sprite	= function() {
		/// @func	get_sprite()
		/// @return	{sprite_index} sprite
		///	
		return sprite.get();
	};
	static get_image	= function() {
		/// @func	get_image()
		/// @return	{image_index} image
		///	
		return image.get();
	};
	static get_color	= function() {
		/// @func	get_color()
		/// @return	{color} color
		///	
		return color.get();
	};
	static get_alpha	= function() {
		/// @func	get_alpha()
		/// @return	{real} alpha
		///	
		return alpha.get();
	};
	static get_x		= function() {
		/// @func	get_x()
		/// @return	{real} x
		///
		return x.get();
	};
	static get_y		= function() {
		/// @func	get_y()
		/// @return	{real} y
		///
		return y.get();
	};
	static get_x_offset	= function() {
		/// @func	get_x_offset()
		/// @return	{real} x_offset
		///
		return x.offset * get_x_scale();
	};
	static get_y_offset	= function() {
		/// @func	get_y_offset()
		/// @return	{real} y_offset
		///
		return y.offset * get_y_scale();
	};
	static get_width	= function() {
		/// @func	get_width()
		/// @return	{real} width
		///
		return (width.get() * get_x_scale()) - (get_x_offset() * 2);
	};
	static get_height	= function() {
		/// @func	get_height()
		/// @return	{real} height
		///
		return (height.get() * get_y_scale()) - (get_y_offset() * 2);	
	};
	static get_scale	= function() {
		/// @func	get_scale()
		/// @return	{real} scale
		///	
		return scale.get();
	};
	static get_x_scale	= function() {
		/// @func	get_x_scale()
		/// @return	{real} x_scale
		///	
		return x_scale.get() * get_scale();
	};
	static get_y_scale	= function() {
		/// @func	get_y_scale()
		/// @return	{real} y_scale
		///	
		return y_scale.get() * get_scale();
	};
		
	#endregion
	#region Setters
	
	static set_sprite	 = function(_sprite) {
		/// @func	set_sprite(sprite)
		/// @param	{real} _sprite
		/// @return {Border} self
		///
		sprite.set(_sprite);
		return self;
	};
	static set_image	 = function(_image) {
		/// @func	set_image(image)
		/// @param	{real} image
		/// @return {Border} self
		///
		image.set(_image);
		return self;
	};
	static set_color	 = function(_color) {
		/// @func	set_color(color)
		/// @param	{real} color
		/// @return {Border} self
		///
		color.set(_color);
		return self;
	};
	static set_alpha	 = function(_alpha) {
		/// @func	set_alpha(alpha)
		/// @param	{real} alpha
		/// @return {Border} self
		///
		alpha.set(_alpha);
		return self;
	};
	static set_xy		 = function(_x, _y) {
		/// @func	set_xy(x*, y*)
		/// @param	{real} x=undefined
		/// @param	{real} y=undefined
		/// @return {Border} self
		///
		if (_x != undefined) {
			x.set(_x);
		}
		if (_y != undefined) {
			y.set(_y);
		}
		return self;
	};
	static set_x		 = function(_x) {
		/// @func	set_x(x)
		/// @param	{real} x=x
		/// @return {Border} self
		///
		return set_xy(_x,);
	};
	static set_y		 = function(_y) {
		/// @func	set_y(y)
		/// @param	{real} y=y
		/// @return {Border} self
		///
		return set_xy(,_y);
	};
	static set_xy_offset = function(_x_offset, _y_offset) {
		/// @func	set_xy_offset(x_offset*, y_offset*)
		/// @param	{real} x_offset=undefined
		/// @param	{real} y_offset=undefined
		/// @return {Border} self
		///
		if (_x_offset != undefined) {
			x.offset = _x_offset;
		}
		if (_y_offset != undefined) {
			y.offset = _y_offset;
		}
		return self;
	};
	static set_x_offset  = function(_x_offset) {
		/// @func	set_x_offset(x_offset)
		/// @param	{real} x_offset
		/// @return {Border} self
		///
		return set_xy_offset(_x_offset,);
	};
	static set_y_offset  = function(_y_offset) {
		/// @func	set_y_offset(y_offset)
		/// @param	{real} y_offset
		/// @return {Border} self
		///
		return set_xy_offset(,_y_offset);
	};
	static set_size		 = function(_width, _height) {
		/// @func	set_size(width*, height*)
		/// @param	{real} width=undefined
		/// @param	{real} height=undefined
		/// @return {Border} self
		///
		if (_width != undefined) {
			width.set(_width);
		}
		if (_height != undefined) {
			height.set(_height);
		}
		return self;
	};
	static set_width	 = function(_width) {
		/// @func	set_height(width)
		/// @param	{real} width
		/// @return {Border} self
		///
		return set_size(_width,);
	};
	static set_height	 = function(_height) {
		/// @func	set_height(height)
		/// @param	{real} height
		/// @return {Border} self
		///
		return set_size(,_height);
	};
	static set_scale	 = function(_scale) {
		/// @func	set_scale(scale)
		/// @param	{real} scale
		/// @return {Border} self
		///
		scale.set(_scale);
		return self;
	};
	static set_x_scale	 = function(_x_scale) {
		/// @func	set_x_scale(x_scale)
		/// @param	{real} x_scale
		/// @return {Border} self
		///
		x_scale.set(_x_scale);
		return self;
	};
	static set_y_scale	 = function(_y_scale) {
		/// @func	set_x_scale(y_scale)
		/// @param	{real} y_scale
		/// @return {Border} self
		///
		y_scale.set(_y_scale);
		return self;
	};
	
	#endregion
	
	#endregion
};
function BorderTrees() : Border(__spr_transition_border_silhouette_trees, 1) constructor {
	/// @func BorderTrees()
	/// 	
	#region Sine Wave 
	
	shader    = shdr_sine_wave;
	u_time	  = shader_get_uniform(shader, "u_time");
	u_texel   = shader_get_uniform(shader, "u_texel");
	u_x_props = shader_get_uniform(shader, "u_x_props");
	u_y_props = shader_get_uniform(shader, "u_y_props");
	
	u_x_speed = 0.005;
	u_y_speed = 0.005;
	u_x_freq  = 20.0;
	u_y_freq  = 20.0;
	u_x_size  = 0.05;
	u_y_size  = 0.05;
	
	#endregion
	
	set_x_offset(-50);
	set_y_offset(-60);
	set_color(CONFIG.color.orange);
	
	static render = function() {
		/// @func render()
		///
		if (shadow_visible) {
			render_shadow();
		}
		render_border(false);
		
		/// Render Surface With Sine Wave Shader
		shader_set(shader); {
			shader_set_uniform_f(u_time,  current_time);
			shader_set_uniform_f(u_texel, 0.03, 0.03);
			shader_set_uniform_f_array(u_x_props, [u_x_speed, u_x_freq, u_x_size]);
			shader_set_uniform_f_array(u_y_props, [u_y_speed, u_y_freq, u_y_size]);
			draw_surface(__surface, 0, 0);
		} shader_reset();
	};
}
