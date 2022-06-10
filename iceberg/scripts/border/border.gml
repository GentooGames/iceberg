/// TODO: setup pin-parent and property propegation

function Border(_sprite) constructor {
	/// @func	Border(sprite)
	/// @param	{sprite_index} sprite
	///
	x		  =  new Prop({ name: "x",	  value: 0	    });
	y		  =  new Prop({ name: "y",	  value: 0	    });
	width	  =  new Prop({ name: "width",  value: SURF_W });
	height	  =  new Prop({ name: "height", value: SURF_H });
	alpha	  =  new Prop({ name: "alpha",  value: 1	    });
	sprite	  = _sprite;
	image	  =  0;
	color	  =  c_white;
	angle	  =  0;
	springs	  = {} with (springs) {
		tension	  = __SPRING_DEFAULT_TENSION;
		dampening = __SPRING_DEFAULT_DAMPENING;
		speed	  = __SPRING_DEFAULT_SPEED;
	};
	particles = {} with (particles) {
		system	= PARTICLES.get_system();
		emitter	= part_emitter_create(system);
	};
	audio	  = {} with (audio) {
		emitter = audio_emitter_create();
		sfx		= {
			effects: {
				on_spring_size: undefined,
				on_bounce_size: undefined,
			},
		};
	};
	
	/// Shadow /////////////////
	shadow_visible	= true;
	shadow_color	= c_black;
	shadow_alpha	= 0.8;
	shadow_inset	= 20;
	
	/// Overlay ////////////////
	overlay_edge    = false;
	overlay_inset_x = 0;
	overlay_inset_y = 0;
	
	/// Private ////////////////
	__width_base  = width.value;	// track base values to center border on size change
	__height_base = height.value;	// track base values to center border on size change
	__surface	  = surface_create(__width_base, __height_base);
	
	#region Private ////////////
	
	static __update_pos		  = function() {
		/// @func __update_pos()
		///
		x.update();
		y.update();
	};
	static __update_size	  = function() {
		/// @func __update_size()
		///
		width.update();
		height.update();
	};
	static __update_sprite	  = function() {
		/// @func __update_sprite()
		///
		alpha.update();
	};
	static __update_particles = function() {
		/// @func __update_particles()
		///
	};
	static __update_audio	  = function() {
		/// @func __update_audio()
		///
		audio_emitter_position(get_emitter_audio(), get_x(), get_y(), 0);
	};
	
	#endregion
	#region Internal ///////////
	
	static update		  = function() {
		/// @func	update()
		/// @return {Border} self
		///
		__update_pos();
		__update_size();
		__update_sprite();
		__update_particles();
		__update_audio();
		
		return self;
	};
	static render_shadow  = function() {
		/// @func render_shadow()
		///
		if (!shadow_visible) exit;
		
		shader_set(shdr_alpha_dither); {
			draw_sprite_stretched_ext(
				sprite,
				image,
				get_x() + shadow_inset, 
				get_y() + shadow_inset,
				get_width()  - (shadow_inset * 2),
				get_height() - (shadow_inset * 2),
				shadow_color, 
				shadow_alpha * get_alpha(),
			);
		} shader_reset();
	};
	static render_border  = function() {
		/// @func render_border()
		///
		__surface = surface_ensure(__surface, get_width(), get_height());
		surface_set_target(__surface); 
		
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_stretched_ext(
			sprite,
			image,
			get_x(), 
			get_y(),
			get_width(),  
			get_height(),
			color, 
			1,
		);
		surface_reset_target();
	};
	static render_overlay = function() {
		/// @func render_overlay()
		///
		if (!overlay_edge) exit;
		
		var _alpha = alpha.get();
		draw_rectangle_alt(0, 0, __width_base, get_y() + overlay_inset_y, 0, color, _alpha);							// top
		draw_rectangle_alt(0, get_y() + get_height() - overlay_inset_y, __width_base, __height_base, 0, color, _alpha);	// bottom
		draw_rectangle_alt(get_x() + get_width()  - overlay_inset_x, 0, __width_base, __height_base, 0, color, _alpha);	// right
		draw_rectangle_alt(get_x() - __width_base + overlay_inset_x, 0, __width_base, __height_base, 0, color, _alpha);	// left
	};
	static render_surface = function() {
		/// @func render_surface()
		///
		var _alpha = alpha.get();
		draw_surface_ext(__surface, 0, 0, 1, 1, 0, c_white, _alpha);
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
	
	#endregion
	#region Getters ////////////
	
	/// Properties - Core //////
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
	static get_alpha	= function() {
		/// @func	get_alpha()
		/// @return	{real} alpha
		///	
		return alpha.get();
	};
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
	static get_color	= function() {
		/// @func	get_color()
		/// @return	{color} color
		///	
		return color;
	};
		
	/// Properties - Extended //
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
	static get_left		= function() {
		/// @func	get_left()
		/// @return	{real} x
		///
		return get_x();
	};
	static get_top		= function() {
		/// @func	get_top()
		/// @return	{real} y
		///
		return get_y();
	};
	static get_right	= function() {
		/// @func	get_right()
		/// @return	{real} x
		///
		return get_x() + get_width();
	};
	static get_bottom	= function() {
		/// @func	get_bottom()
		/// @return	{real} y
		///
		return get_y() + get_height();
	};
	static get_center_x = function() {
		/// @func	get_center_x()
		/// @return	{real} x
		///
		return get_x() + (get_width() * 0.5);
	};
	static get_center_y = function() {
		/// @func	get_center_y()
		/// @return	{real} y
		///
		return get_y() + (get_height() * 0.5);
	};
		
	/// Properties - Spring ////
	static get_spring_tension	= function() {
		/// @func	get_spring_tension()
		/// @return	{real} tension
		///
		return springs.tension;
	};
	static get_spring_dampening = function() {
		/// @func	get_spring_dampening()
		/// @return	{real} dampening
		///
		return springs.dampening;
	};
	static get_spring_speed		= function() {
		/// @func	get_spring_speed()
		/// @return	{real} speed
		///
		return springs.speed;
	};
		
	#endregion
	#region Setters ////////////
	
	/// Properties - Core //////
	static set_x			= function(_x) {
		/// @func	set_x(x)
		/// @param	{real} x=x
		/// @return {Border} self
		///
		return set_xy(_x,);
	};
	static set_y			= function(_y) {
		/// @func	set_y(y)
		/// @param	{real} y=y
		/// @return {Border} self
		///
		return set_xy(,_y);
	};
	static set_xy			= function(_x, _y) {
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
	static set_width		= function(_width) {
		/// @func	set_height(width)
		/// @param	{real} width
		/// @return {Border} self
		///
		return set_size(_width,);
	};
	static set_height		= function(_height) {
		/// @func	set_height(height)
		/// @param	{real} height
		/// @return {Border} self
		///
		return set_size(,_height);
	};
	static set_size			= function(_width, _height) {
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
	static set_size_base	= function(_width, _height) {
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
	static set_alpha		= function(_alpha) {
		/// @func	set_alpha(alpha)
		/// @param	{real} alpha
		/// @return {Border} self
		///
		alpha.set(_alpha);
		return self;
	};
	static set_sprite		= function(_sprite) {
		/// @func	set_sprite(sprite)
		/// @param	{real} _sprite
		/// @return {Border} self
		///
		sprite = _sprite;
		return self;
	};
	static set_image		= function(_image) {
		/// @func	set_image(image)
		/// @param	{real} image
		/// @return {Border} self
		///
		image = _image;
		return self;
	};
	static set_color		= function(_color) {
		/// @func	set_color(color)
		/// @param	{real} color
		/// @return {Border} self
		///
		color = _color;
		return self;
	};
	
	/// Properties - Extended //
	static set_width_target  = function(_width) {
		/// @func	set_width_target(width)
		/// @param	{real} width
		/// @return {Border} self
		///
		return set_size_target(_width);
	};
	static set_height_target = function(_height) {
		/// @func	set_height_target(height)
		/// @param	{real} height
		/// @return {Border} self
		///
		return set_size_target(,_height);
	};
	static set_size_target	 = function(_width, _height) {
		/// @func	set_size_target(width*, height*)
		/// @param	{real} width=undefined
		/// @param	{real} height=undefined
		/// @return {Border} self
		///
		if (_width != undefined) {
			width.set_target(_width);
		}
		if (_height != undefined) {
			height.set_target(_height);
		}
		return self;
	};
	static set_x_offset		 = function(_x_offset) {
		/// @func	set_x_offset(x_offset)
		/// @param	{real} x_offset
		/// @return {Border} self
		///
		return set_xy_offset(_x_offset);
	};
	static set_y_offset		 = function(_y_offset) {
		/// @func	set_y_offset(y_offset)
		/// @param	{real} y_offset
		/// @return {Border} self
		///
		return set_xy_offset(,_y_offset);
	};
	static set_xy_offset	 = function(_x_offset, _y_offset) {
		/// @func	set_xy_offset(x_offset*, y_offset*)
		/// @param	{real} x_offset=undefined
		/// @param	{real} y_offset=undefined
		/// @return {Border} self
		///
		if (_x_offset != undefined) {
			x.set_offset(_x_offset);
		}
		if (_y_offset != undefined) {
			y.set_offset(_y_offset);
		}
		return self;
	};
	static adjust_x_offset	 = function(_amount) {
		/// @func	adjust_x_offset(amount)
		/// @param	{real} amount
		/// @return {Border} self
		///
		adjust_xy_offset(_amount);
		return self;
	};
	static adjust_y_offset	 = function(_amount) {
		/// @func	adjust_y_offset(amount)
		/// @param	{real} amount
		/// @return {Border} self
		///
		adjust_xy_offset(,_amount);
		return self;
	};
	static adjust_xy_offset	 = function(_x_amount, _y_amount) {
		/// @func	adjust_xy_offset(x_offset*, y_offset*)
		/// @param	{real} x_amount=undefined
		/// @param	{real} y_amount=undefined
		/// @return {Border} self
		///
		if (_x_amount != undefined) {
			set_x_offset(get_x_offset() + _x_amount);
		}
		if (_y_amount != undefined) {
			set_y_offset(get_y_offset() + _y_amount);
		}
		return self;
	};
		
	/// Properties - Spring ////
	static set_spring_tension	= function(_tension) {
		/// @func	set_spring_tension(tension)
		/// @param	{real} tension
		/// @return	{Border} self
		///
		springs.tension = _tension;
		return self;
	};
	static set_spring_dampening = function(_dampening) {
		/// @func	set_spring_dampening(dampening)
		/// @param	{real} dampening
		/// @return	{Border} self
		///
		springs.dampening = _dampening;
		return self;
	};
	static set_spring_speed		= function(_speed) {
		/// @func	set_spring_speed(speed)
		/// @param	{real} speed
		/// @return	{Border} self
		///
		springs.speed = _speed;
		return self;
	};
	
	#endregion
	#region Effects ////////////
	
	static spring_width		= function(_speed) {
		/// @func	spring_width(speed)
		/// @param	{real} speed
		/// @return {Border} self
		///
		return spring_size(_speed);
	};
 	static spring_height	= function(_speed) {
		/// @func	spring_height(speed)
		/// @param	{real} speed
		/// @return {Border} self
		///
		return spring_size(,_speed);
	};
	static spring_size		= function(_x_speed, _y_speed) {
		/// @func	spring_size(x_speed*, y_speed*)
		/// @param	{real} x_speed=undefined
		/// @param	{real} y_speed=undefined
		/// @return {Border} self
		///
		if (_x_speed != undefined) {
			width.spring(_x_speed);	
		}
		if (_y_speed != undefined) {
			height.spring(_y_speed);	
		}
			
		var _sfx  = audio.sfx.effects.on_spring_size;
		if (_sfx != undefined) {
			AUDIO.play_mod(get_emitter_audio(), _sfx, false);
		}
		return self;
	};	
	static bounce_width_to  = function(_x_target, _spring_speed = springs.speed) {
		/// @func	bounce_width_to(x_target, spring_speed)
		/// @param	{real} x_target=undefined
		/// @param	{real} spring_speed=springs.speed
		/// @return {Border} self
		///
		return bounce_size_to(_x_target,,_spring_speed);
	};	
	static bounce_height_to = function(_y_target, _spring_speed = springs.speed) {
		/// @func	bounce_height_to(y_target, spring_speed)
		/// @param	{real} y_target=undefined
		/// @param	{real} spring_speed=springs.speed
		/// @return {Border} self
		///
		return bounce_size_to(,_y_target,,_spring_speed);
	};	
	static bounce_size_to	= function(_x_target, _y_target, _spring_speed_x = springs.speed, _spring_speed_y = _spring_speed_x) {
		/// @func	bounce_size_to(x_target*, y_target*, spring_speed_x*, spring_speed_y*)
		/// @param	{real} x_target=undefined
		/// @param	{real} y_target=undefined
		/// @param	{real} spring_speed_x=springs.speed
		/// @param	{real} spring_speed_y=spring_speed_x
		/// @return {Border} self
		///
		if (_x_target != undefined) {
			set_width_target(_x_target);
			spring_height(_spring_speed_x);		
		}
		if (_y_target != undefined) {
			set_height_target(_y_target);
			spring_width(_spring_speed_y);		
		}
		
		var _sfx  = audio.sfx.effects.on_bounce_size;
		if (_sfx != undefined) {
			AUDIO.play_mod(get_emitter_audio(), _sfx, false);
		}
		return self;
	};
	
	#endregion
	#region Audio //////////////
	
	static get_emitter_audio		= function() {
		/// @func	get_emitter_audio()
		/// @return	{emitter_index} emitter_id
		///
		return audio.emitter;
	};
	static set_sound_on_spring_size = function(_audio_id) {
		/// @func	set_sound_on_spring_size(audio_id)
		/// @param	{sound_index} audio_id
		/// @return {Border} self
		///
		audio.sfx.effects.on_spring_size = _audio_id;
		return self;
	};
	static set_sound_on_bounce_size = function(_audio_id) {
		/// @func	set_sound_on_bounce_size(audio_id)
		/// @param	{sound_index} audio_id
		/// @return {Border} self
		///
		audio.sfx.effects.on_bounce_size = _audio_id;
		return self;
	};
	
	#endregion
};
function BorderSineWave(_sprite) : Border(_sprite) constructor {
	/// @func	BorderSineWave(sprite)
	/// @param	{sprite_index} sprite
	/// 
	shader    = shdr_sine_wave;
	u_time	  = shader_get_uniform(shader, "u_time");
	u_texel   = shader_get_uniform(shader, "u_texel");
	u_x_props = shader_get_uniform(shader, "u_x_props");
	u_y_props = shader_get_uniform(shader, "u_y_props");
	
	x_texel	  = 0.03;
	y_texel	  = 0.03;
	x_props	  = [
		0.005,	// speed
		20.0,	// frequency
		0.05,	// size
	];
	y_props	  = [
		0.005,	// speed
		20.0,	// frequency
		0.05,	// size
	];
	
	static render_uniforms = function() {
		/// @func render_uniforms()
		///
		shader_set_uniform_f(u_time,  current_time);
		shader_set_uniform_f(u_texel, x_texel, y_texel);
		shader_set_uniform_f_array(u_x_props, x_props);
		shader_set_uniform_f_array(u_y_props, y_props);
	};
	static render		   = function() {
		/// @func render()
		///
		render_shadow();
		render_border();
		
		shader_set(shader); {
			render_uniforms();
			render_surface();
		} shader_reset();
		
		render_overlay();
	};
};
function BorderTrees() : BorderSineWave(__spr_transition_border_silhouette_trees) constructor {
	/// @func BorderTrees()
	/// 	
	set_x_offset(-50);
	set_y_offset(-60);
	color = CONFIG.color.orange;
	
	/// Overlay
	overlay_edge	= true;
	overlay_inset_x = 60;
	overlay_inset_y = 60;
}
























