/*
	Features:
		- multiple shape configurations
			- square/rectangle
			- circle
			- triangle
			- etc
		- adjustable precision
			- adjust the number of vertex points dynamically as a result of precision adjusting
*/

enum BORDER_SHAPE {
	RECTANGLE,
	CIRCLE,
	TRIANGLE,
};
enum PATH_TYPE {
	NOT_SMOOTH = 0,
	SMOOTH = 1,
};

function BorderRibbon() constructor {
	/// @func BorderRibbon()
	///
	shape	  = BORDER_SHAPE.RECTANGLE;
	precision = 5;
	thickness = 50;
	
	__primitive_type = pr_trianglestrip;
	__vertices		 = [];
	__n_vertices	 = 0;
	__path			 = path_add();
	__path_type		 = PATH_TYPE.SMOOTH;
	__path_closed	 = false;
	path_set_kind(__path, __path_type);
	path_set_closed(__path, __path_closed);
	__debug_render   = true;
	
	#region Private ////////////
	
	static __construct_vertices = function() {
		__clear_vertices();
		if (path_get_number(__path) >= 2) {
			for (var _i = 0, _len = 1, _iter = _len / precision; _i <= _len; _i += _iter) {
				/// Get Coordinate Points
				if (_i <= _len - _iter) {
					var _p1_x	 =  path_get_x(__path, _i);
					var _p1_y	 =  path_get_y(__path, _i);
					var _p2_x	 =  path_get_x(__path, _i + _iter);
					var _p2_y	 =  path_get_y(__path, _i + _iter);
					var _pbase_x = _p1_x;
					var _pbase_y = _p1_y;
				}
				else {
					var _p1_x	 =  path_get_x(__path, _i - _iter);
					var _p1_y	 =  path_get_y(__path, _i - _iter);
					var _p2_x	 =  path_get_x(__path, _i);
					var _p2_y	 =  path_get_y(__path, _i);
					var _pbase_x = _p2_x;
					var _pbase_y = _p2_y;
				}
				var _dir = angle_perpendicular(_p1_x, _p1_y, _p2_x, _p2_y);
	
				
				/// Create Vertex Points
				var _off_x =  lengthdir_x(thickness * 0.5, _dir);
				var _off_y =  lengthdir_y(thickness * 0.5, _dir);
				var _v1_x  = _pbase_x + _off_x;
				var _v1_y  = _pbase_y + _off_y;
				var _v2_x  = _pbase_x - _off_x;
				var _v2_y  = _pbase_y - _off_y;
				array_push(__vertices, { x: _v1_x, y: _v1_y });
				array_push(__vertices, { x: _v2_x, y: _v2_y });
				__n_vertices += 2;
			};
		}	
	};
	static __clear_vertices		= function() {
		__vertices   = [];
		__n_vertices = 0;
	};
	
	#region Debug //////////////
	
	static __debug_render_path									= function() {
		static _color = CONFIG.color.red;
		if (!path_empty(__path)) {
			var _x = path_get_x(__path, 0);
			var _y = path_get_y(__path, 0);
			draw_set_color(_color);
			draw_path(__path, _x, _y, false);
			draw_set_color(c_white);
		}
	};
	static __debug_render_path_anchor_points					= function() {
		static _color = CONFIG.color.green_lime;
		for (var _i = 0, _len = path_get_number(__path), _iter = 1; _i < _len; _i += _iter) {
			var _px = path_get_point_x(__path, _i);
			var _py = path_get_point_y(__path, _i);
			draw_circle_color(_px, _py, 10, _color, _color, true);
			draw_circle_color(_px, _py, 2,  _color, _color, false);
		}
	};
	static __debug_render_path_anchor_points_line_connect		= function() {
		static _color = CONFIG.color.green_lime;
		for (var _i = 0, _len = path_get_number(__path), _iter = 1; _i < _len; _i += _iter) {
			var _px = path_get_point_x(__path, _i);
			var _py = path_get_point_y(__path, _i);
			if (_i < _len - _iter) {
				var _p2x = path_get_point_x(__path, _i + _iter);
				var _p2y = path_get_point_y(__path, _i + _iter);
				draw_line_color(_px, _py, _p2x, _p2y, _color, _color);
			}
			else if (_i != 0) {
				var _p2x = path_get_point_x(__path, _i - _iter);
				var _p2y = path_get_point_y(__path, _i - _iter);
				draw_line_color(_px, _py, _p2x, _p2y, _color, _color);
			}
		}
	};
	static __debug_render_path_anchor_points_line_perpendicular = function() {
		static _color = CONFIG.color.green_lime;
		for (var _i = 0, _len = path_get_number(__path), _iter = 1; _i < _len; _i += _iter) {
			var _px = path_get_point_x(__path, _i);
			var _py = path_get_point_y(__path, _i);
			
			if (_i < _len - _iter) {
				var _p2x		= path_get_point_x(__path, _i + _iter);
				var _p2y		= path_get_point_y(__path, _i + _iter);
				var _perp_dir	= point_direction(_px, _py, _p2x, _p2y) + 90;
				var _perp_len_x	= lengthdir_x(thickness, _perp_dir);
				var _perp_len_y	= lengthdir_y(thickness, _perp_dir);
				draw_line_color(_px + _perp_len_x, _py + _perp_len_y, _px - _perp_len_x, _py - _perp_len_y, _color, _color);
			}
			else if (_i != 0) {
				var _p2x		= path_get_point_x(__path, _i - _iter);
				var _p2y		= path_get_point_y(__path, _i - _iter);
				var _perp_dir	= point_direction(_px, _py, _p2x, _p2y) + 90;
				var _perp_len_x	= lengthdir_x(thickness, _perp_dir);
				var _perp_len_y	= lengthdir_y(thickness, _perp_dir);
				draw_line_color(_px + _perp_len_x, _py + _perp_len_y, _px - _perp_len_x, _py - _perp_len_y, _color, _color);
			}
		}
	};
	static __debug_render_path_points							= function() {
		static _color = CONFIG.color.brown_purple;
		for (var _i = 0, _len = 1, _iter = _len / precision; _i <= _len; _i += _iter) {
			var _px = path_get_x(__path, _i);
			var _py = path_get_y(__path, _i);
			draw_circle_color(_px, _py, 4, _color, _color, false);
		}
	};
	static __debug_render_path_points_line_connect				= function() {
		static _color = CONFIG.color.brown_purple;
		for (var _i = 0, _len = 1, _iter = _len / precision; _i < _len - _iter; _i += _iter) {
			if (_i < _len - _iter && _i != 0) {
				var _px  = path_get_x(__path, _i);
				var _py  = path_get_y(__path, _i);
				var _px2 = path_get_x(__path, _i + _iter);
				var _py2 = path_get_y(__path, _i + _iter);
				draw_line_color(_px, _py, _px2, _py2, _color, _color);
			}
		}
	};
	static __debug_render_path_points_line_perpendicular		= function() {
		static _color = CONFIG.color.brown_purple;
		for (var _i = 0, _len = 1, _iter = _len / precision; _i < _len; _i += _iter) {
			var _px = path_get_x(__path, _i);
			var _py = path_get_y(__path, _i);
			
			if (_i < _len - _iter) {
				var _p2x		= path_get_x(__path, _i + _iter);
				var _p2y		= path_get_y(__path, _i + _iter);
				var _perp_dir	= point_direction(_px, _py, _p2x, _p2y) + 90;
				var _perp_len_x	= lengthdir_x(thickness, _perp_dir);
				var _perp_len_y	= lengthdir_y(thickness, _perp_dir);
				draw_line_color(_px + _perp_len_x, _py + _perp_len_y, _px - _perp_len_x, _py - _perp_len_y, _color, _color);
			}
			else if (_i != 0) {
				var _p2x		= path_get_x(__path, _i - _iter);
				var _p2y		= path_get_y(__path, _i - _iter);
				var _perp_dir	= point_direction(_px, _py, _p2x, _p2y) + 90;
				var _perp_len_x	= lengthdir_x(thickness, _perp_dir);
				var _perp_len_y	= lengthdir_y(thickness, _perp_dir);
				draw_line_color(_px + _perp_len_x, _py + _perp_len_y, _px - _perp_len_x, _py - _perp_len_y, _color, _color);
			}
		}	
	};
	static __debug_render_vertices								= function() {
		static _color = CONFIG.color.blue;
		for (var _i = 0; _i < __n_vertices; _i++) {
			var _vertex = __vertices[_i];
			draw_circle_color(_vertex.x, _vertex.y, 4, _color, _color, false);
		}
	};
	static __debug_render_vertices_index						= function() {
		static _color = CONFIG.color.red;
		for (var _i = 0; _i < __n_vertices; _i++) {
			var _vertex = __vertices[_i];
			draw_text_transformed_color(_vertex.x, _vertex.y, _i, 1, 1, 0, _color, _color, _color, _color, 1);
		}
	};
	
	#endregion
	
	#endregion
	#region Internal ///////////
	
	static update  = function() {
		/// @func update()
		///
		if (INPUT.mouse.button_pressed(mb_left)) {
			add_point(mouse_x, mouse_y);
		}	
		if (INPUT.mouse.button_pressed(mb_right)) {
			clear_points();
		}	
		if (INPUT.mouse.button_pressed(mb_middle)) {
			__debug_render = !__debug_render;	
		}
		if (INPUT.mouse.wheel_down()) {
			adjust_precision(-1);
		}
		if (INPUT.mouse.wheel_up()) {
			adjust_precision(1);
		}
	};
	static render  = function() {	
		/// @func render()
		///
		draw_primitive_begin(__primitive_type);
		for (var _i = 0; _i < __n_vertices; _i++) {
			var _vertex = __vertices[_i];
			draw_vertex(_vertex.x, _vertex.y);
		};
		draw_primitive_end();
		
		if (__debug_render) {
			__debug_render_path_anchor_points();
			__debug_render_path_anchor_points_line_connect();
			__debug_render_path_anchor_points_line_perpendicular();
			__debug_render_path_points();
			__debug_render_path_points_line_connect();
			__debug_render_path_points_line_perpendicular();
			__debug_render_vertices();				
			__debug_render_vertices_index();
			__debug_render_path();		
		}
	};
	static cleanup = function() {
		/// @func cleanup()
		///
		path_delete(path);	
		__path = undefined;
	};
	
	#endregion
	#region Public /////////////
	
	static add_point		= function(_x, _y) {
		/// @func add_point(x, y)
		///
		path_add_point(__path, _x, _y, 100);
		__construct_vertices();
	};
	static clear_points		= function() {
		/// @func clear_points()
		///
		path_clear_points(__path);
		__construct_vertices();
	};
	static adjust_precision = function(_amount) {
		/// @func	adjust_precision(amount)
		/// @param	{real} amount
		/// @return {Border} self
		///
		return set_precision(precision + _amount);
	};
	static set_precision	= function(_precision) {
		/// @func	set_precision(precision)
		/// @param	{real} precision
		/// @return {Border} self
		///
		if (_precision >= 0) {
			precision = _precision;
			path_set_precision(__path, precision);
			__construct_vertices();
		}
		return self;
	};
	
	#endregion
};




