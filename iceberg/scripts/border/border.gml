function Border(_sprite, _image = 0) constructor {
	/// @func	Border(sprite, image*)
	/// @param	{sprite_index} sprite
	/// @param	{image_index } image=0
	///
	sprite = new GProp({ name: "sprite", value: _sprite });
	image  = new GProp({ name: "image",	 value: _image  });
	color  = new GProp({ name: "color",	 value: c_white });
	alpha  = new GProp({ name: "alpha",	 value: 1	    });
	x	   = new GProp({ name: "x",		 value: 0	    });
	y	   = new GProp({ name: "y",		 value: 0	    });
	width  = new GProp({ name: "width",	 value: SURF_W  });
	height = new GProp({ name: "height", value: SURF_H  });
	
	/// Shadow
	shadow_visible = true;
	shadow_color   = c_black;
	shadow_alpha   = 0.8;
	shadow_inset   = 20;
	
	/// Overlay
	overlay_edge    = false;
	overlay_inset_x = 0;
	overlay_inset_y = 0;
	
	/// Private
	__width_base  = width.value;	// track base values to center border on size change
	__height_base = height.value;	// track base values to center border on size change
	__surface	  = surface_create(__width_base, __height_base);
	
	static update		  = function() {
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
		
		return self;
	};
	static render_shadow  = function() {
		/// @func render_shadow()
		///
		if (!shadow_visible) exit;
		
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
	static render_border  = function() {
		/// @func render_border()
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
	};
	static render_overlay = function() {
		/// @func render_overlay()
		///
		if (!overlay_edge) exit;
		
		draw_rectangle_alt(0, 0, __width_base, get_y() + overlay_inset_y, 0, color.get(), 1);								// top
		draw_rectangle_alt(0, get_y() + get_height() - overlay_inset_y, __width_base, __height_base, 0, color.get(), 1);	// bottom
		draw_rectangle_alt(get_x() + get_width() - overlay_inset_x, 0, __width_base, __height_base, 0, color.get(), 1);		// right
		draw_rectangle_alt(0, 0, get_x() + overlay_inset_x, __height_base, 0, color.get(), 1);								// left
	};
	static render_surface = function() {
		/// @func render_surface()
		///
		draw_surface(__surface, 0, 0);
	};
	static render		  = function() {
		/// @func render()
		///
		render_shadow();
		render_border();
		render_surface();
		render_overlay();	
	};
	static cleanup		  = function() {
		if (surface_exists(__surface)) {
			surface_free(__surface);	
		}
		__surface = undefined;
	};
	
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
		return x.get() + (__width_base - width.get()) * 0.5;
	};
	static get_y		= function() {
		/// @func	get_y()
		/// @return	{real} y
		///
		return y.get() + (__height_base - height.get()) * 0.5;
	};
	static get_x_offset	= function() {
		/// @func	get_x_offset()
		/// @return	{real} x_offset
		///
		return x.offset;
	};
	static get_y_offset	= function() {
		/// @func	get_y_offset()
		/// @return	{real} y_offset
		///
		return y.offset;
	};
	static get_width	= function() {
		/// @func	get_width()
		/// @return	{real} width
		///
		return width.get() - (get_x_offset() * 2);
	};
	static get_height	= function() {
		/// @func	get_height()
		/// @return	{real} height
		///
		return height.get() - (get_y_offset() * 2);	
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
	static set_size_base = function(_width, _height) {
		/// @func	set_size_base(width*, height*)
		/// @param	{real} width=undefined
		/// @param	{real} height=undefined
		/// @return {Border} self
		///
		if (_width != undefined) {
			__width_base = _width;
		}
		if (_height != undefined) {
			__height_base = _height;
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
	
	#endregion
	#region Effects
	
	static spring_width  = function(_speed) {
		/// @func	spring_width(speed)
		/// @param	{real} speed
		/// @return {Border} self
		///
		width.spring(_speed);
		return self;
	};
 	static spring_height = function(_speed) {
		/// @func	spring_height(speed)
		/// @param	{real} speed
		/// @return {Border} self
		///
		height.spring(_speed);
		return self;
	};
	
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
	
	/// Overlay
	overlay_edge	= true;
	overlay_inset_x = 60;
	overlay_inset_y = 60;
	
	static render = function() {
		/// @func render()
		///
		render_shadow();
		render_border();
		
		/// Render Surface With Sine Wave Shader
		shader_set(shader); {
			shader_set_uniform_f(u_time,  current_time);
			shader_set_uniform_f(u_texel, 0.03, 0.03);
			shader_set_uniform_f_array(u_x_props, [u_x_speed, u_x_freq, u_x_size]);
			shader_set_uniform_f_array(u_y_props, [u_y_speed, u_y_freq, u_y_size]);
			render_surface();
		} shader_reset();
		
		render_overlay();
	};
}

























