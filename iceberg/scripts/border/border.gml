function Border(_sprite, _image = 0) constructor {
	/// @func	Border(sprite, image*)
	/// @param	{sprite_index} sprite
	/// @param	{image_index } image=0
	///
	sprite   = _sprite;
	image    = _image;
	scale    = 1;
	yscale   = 1 * scale;
	xscale   = 1 * scale;
	width    = SURF_W;
	height   = SURF_H;
	color    = c_white;
	alpha    = 1;
	x	     = 0;
	y	     = 0;
	x_offset = 0;
	y_offset = 0;
	
	/// Shadow
	shadow_visible = true;
	shadow_color   = c_black;
	shadow_alpha   = 0.8;
	shadow_inset   = 20;
	
	/// Private
	__surface = surface_create(width, height);
	
	#region Internal
	
	static update		 = function() {};
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
			draw_surface(__surface, x, y);
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
	#region Private 
	
	/// ...
	
	#endregion
	#region Public
	
	#region Getters
	
	static get_sprite	= function() {
		/// @func	get_sprite()
		/// @return	{sprite_index} sprite
		///	
		return sprite;
	};
	static get_image	= function() {
		/// @func	get_image()
		/// @return	{image_index} image
		///	
		return image;
	};
	static get_alpha	= function() {
		/// @func	get_alpha()
		/// @return	{real} alpha
		///	
		return alpha;
	};
	static get_x		= function() {
		/// @func	get_x()
		/// @return	{real} x
		///
		return x + get_x_offset();
	};
	static get_y		= function() {
		/// @func	get_y()
		/// @return	{real} y
		///
		return y + get_y_offset();
	};
	static get_x_offset	= function() {
		/// @func	get_x_offset()
		/// @return	{real} x_offset
		///
		return x_offset * get_xscale();
	};
	static get_y_offset	= function() {
		/// @func	get_y_offset()
		/// @return	{real} y_offset
		///
		return y_offset * get_yscale();
	};
	static get_width	= function() {
		/// @func	get_width()
		/// @return	{real} width
		///
		return (width * get_xscale()) - (get_x_offset() * 2);
	};
	static get_height	= function() {
		/// @func	get_height()
		/// @return	{real} height
		///
		return (height * get_yscale()) - (get_y_offset() * 2);	
	};
	static get_color	= function() {
		/// @func	get_color()
		/// @return	{color} color
		///	
		return color;
	};
	static get_alpha	= function() {
		/// @func	get_alpha()
		/// @return	{real} alpha
		///	
		return alpha;
	};
	static get_scale	= function() {
		/// @func	get_scale()
		/// @return	{real} scale
		///	
		return scale;
	};
	static get_xscale	= function() {
		/// @func	get_xscale()
		/// @return	{real} xscale
		///	
		return xscale * get_scale();
	};
	static get_yscale	= function() {
		/// @func	get_yscale()
		/// @return	{real} yscale
		///	
		return yscale * get_scale();
	};
		
	#endregion
	#region Setters
	
	static set_pos		= function(_x = x, _y = y) {
		/// @func	set_pos(x*, y*)
		/// @param	{real} x=x
		/// @param	{real} y=y
		///
		x = _x;
		y = _y;
		return self;
	};
	static set_x		= function(_x) {
		/// @func	set_pos(x)
		/// @param	{real} x=x
		///
		return set_pos(_x,);
	};
	static set_y		= function(_y) {
		/// @func	set_pos(y)
		/// @param	{real} y=y
		///
		return set_pos(,_y);
	};
	static set_offset	= function(_x_offset = x_offset, _y_offset = y_offset) {
		/// @func	set_offset(x_offset*, y_offset*)
		/// @param	{real} x_offset=x_offset
		/// @param	{real} y_offset=y_offset
		///
		x_offset = _x_offset;
		y_offset = _y_offset;
		set_size();
		set_pos();
		return self;
	};
	static set_x_offset = function(_x_offset) {
		/// @func	set_x_offset(x_offset)
		/// @param	{real} x_offset
		///
		return set_offset(_x_offset,);
	};
	static set_y_offset = function(_y_offset) {
		/// @func	set_y_offset(y_offset)
		/// @param	{real} y_offset
		///
		return set_offset(,_y_offset);
	};
	static set_size		= function(_width = width, _height = height) {
		/// @func	set_size(width*, height*)
		/// @param	{real} width=width
		/// @param	{real} height=height
		///
		width  = _width;
		height = _height;
		return self;
	};
	static set_width	= function(_width) {
		/// @func	set_height(width)
		/// @param	{real} width
		///
		return set_size(_width,);
	};
	static set_height	= function(_height) {
		/// @func	set_height(height)
		/// @param	{real} height
		///
		return set_size(,_height);
	};
	static set_color	= function(_color) {
		/// @func	set_color(color)
		/// @param	{real} color
		///
		color = _color;
		return self;
	};
	static set_alpha	= function(_alpha) {
		/// @func	set_alpha(alpha)
		/// @param	{real} alpha
		///
		alpha = _alpha;
		return self;
	};
	
	#endregion
	
	#endregion
};
function BorderTrees() : Border(__spr_transition_border_silhouette_trees, 1) constructor {
	/// @func BorderTrees()
	/// 	
	set_x_offset(-50);
	set_y_offset(-60);
	set_color(CONFIG.color.orange);
	
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
			draw_surface(__surface, x, y);
		} shader_reset();
	};
}
