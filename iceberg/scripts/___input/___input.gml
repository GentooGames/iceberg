function ___input() {
	/// @func ___input()
	///
	global.___system_input = {
	    initialized: false,
		
		mouse:    {
	        device: 0,
			
			#region Actions ////////
			
	        button_pressed:  function(_button) {
	            /// @func   button_pressed(button)
	            /// @param  {mb_button} button
	            /// @return {boolean}	pressed
	            ///
	            return device_mouse_check_button_pressed(get_device(), _button);
	        },
	        button:          function(_button) {
	            /// @func   button(button)
	            /// @param  {mb_button} button
	            /// @return {boolean}	released
	            /// 
	            return device_mouse_check_button(get_device(), _button);
	        },
	        button_released: function(_button) {
	            /// @func   button_released(button)
	            /// @param  {mb_button} button
	            /// @return {boolean}	released
	            ///
				return device_mouse_check_button_released(get_device(), _button);
	        },
	        wheel_up:        function() {
	            /// @func   wheel_up()
	            /// @return {boolean} mouse_wheel_up
	            ///
	            return mouse_wheel_up();
	        },
			wheel_down:      function() {
	            /// @func   wheel_down()
	            /// @return {boolean} mouse_wheel_down
	            ///
	            return mouse_wheel_down();
	        },
        
			#endregion
			#region Getters ////////
			
	        get_x:      function() {
	            /// @func   get_x()
	            /// @return {real} x
	            ///
	            return device_mouse_x(get_device());
	        },
	        get_y:      function() {
	            /// @func   get_y()
	            /// @return {real} y
	            ///
	            return device_mouse_y(get_device());
	        },
	        get_x_gui:  function() {
	            /// @func   get_x_gui()
	            /// @return {real} x_gui
	            ///
	            return device_mouse_x_to_gui(get_device());
	        },
	        get_y_gui:  function() {
	            /// @func   get_y_gui()
	            /// @return {real} y_gui
	            ///
	            return device_mouse_y_to_gui(get_device());
	        },
	        get_iso_i:  function() {
	            /// @func   get_iso_i()
	            /// @return {real} iso_i
	            ///
				static _tile_width  = 16;
				static _tile_height = 8;
	            return iso_xy_to_i(_tile_width, _tile_height, get_x(), get_y());
	        },
	        get_iso_j:  function() {
	            /// @func   get_iso_j()
	            /// @return {real} iso_j
	            ///
				static _tile_width  = 16;
				static _tile_height = 8;
	            return iso_xy_to_j(_tile_width, _tile_height, get_x(), get_y());
	        },
			get_device: function() {
				/// @func	get_device()
				/// @return {real} device_index
				/// 
				return device;
			},
			
			#endregion
			#region Util ///////////
			
			to_string: function(_button_index) {
				/// @func	to_string(button_index)
				/// @param	{mb}	 button_index
				/// @return {string} string
				///
				switch (_button_index) {
					case mb_left:   return "left_mouse_button";
					case mb_right:  return "right_mouse_button";
					case mb_middle: return "middle_mouse_button";
				}
				return "";
			},
				
			#endregion
	    },
	    keyboard: {
			#region Actions ////////
			
	        button_pressed:  function(_button) { 
	            /// @func   button_pressed(button)
	            /// @param  {kb_button} button
	            /// @return {bool}		pressed
	            ///
	            return keyboard_check_pressed(_button);  
	        },
	        button:          function(_button) {
	            /// @func   button(button)
	            /// @param  {kb_button} button
	            /// @return {bool}		down
	            ///
	            return keyboard_check(_button);
	        },
	        button_released: function(_button) {
	            /// @func   button_released(button)
	            /// @param  {kb_button} button
	            /// @return {bool}		released
	            ///
	            return keyboard_check_released(_button);  
	        },
				
			#endregion
	    },
		
		#region Core ///////
		
	    setup:    function() {
	        /// @func   setup()
	        /// @return {struct} self
	        ///
	        if (!initialized) {
				#region ----------------
		
		        log("<INPUT> setup()");
		        initialized = true;
		
				#endregion
				#region Events /////////
		
				eventer = new Eventable().setup();
				eventer.disable_logging();
				eventer.register([
					/// mouse_button_pressed
					"mouse_button_pressed",
					"mouse_left_button_pressed",
			        "mouse_right_button_pressed",
			        "mouse_middle_button_pressed",  
			
					/// mouse_button
					"mouse_button",
					"mouse_left_button",
			        "mouse_right_button",
			        "mouse_middle_button",  
			
					/// mouse_button_released
					"mouse_button_released",
					"mouse_left_button_released",
			        "mouse_right_button_released",
			        "mouse_middle_button_released",  
			
					/// mouse_wheel
					"mouse_wheel_up",
					"mouse_wheel_down",
			
					/// keyboard_button_*
					"keyboard_button_pressed",
					"keyboard_button",
					"keyboard_button_released",
				]);
		
				#endregion
			}
			return self;
	    },
	    update:   function() {
	        /// @func   update()
	        /// @return {struct} self
	        /// 
			if (initialized) {
				__update_mouse_events();
				__update_keyboard_events();
			}
			return self;
	    },
		render:	  function() {
			/// @func	render()
			/// @return {struct} self
			///
			if (initialized) {};
			return self;
		},
		teardown: function() {
			/// @func	teardown()
			/// @return {struct} self
			///
			if (initialized) {};
			return self;
		},
    
		#endregion
		#region Actions ////
		
		
		
		#endregion
		#region Getters ////
		
		
		
		#endregion
		#region Setters ////
		
		
		
		#endregion
		#region Checkers ///
		
		
		
		#endregion
		#region __Private //
		
		__update_mouse_events:	  function() {
			/// @func	__update_mouse_events()
			/// @return {struct} self
			///
			if (mouse.button(mb_any)) {
				eventer.broadcast("mouse_button", {
					button: mouse_button,
					x:		INPUT.mouse.get_x(),
					y:		INPUT.mouse.get_y(),
					x_gui:	INPUT.mouse.get_x_gui(),
					y_gui:	INPUT.mouse.get_y_gui(),
				});
			}
			if (mouse.button_pressed(mb_any)) {
				eventer.broadcast("mouse_button_pressed", {
					button: mouse_button,
					x:		INPUT.mouse.get_x(),
					y:		INPUT.mouse.get_y(),
					x_gui:	INPUT.mouse.get_x_gui(),
					y_gui:	INPUT.mouse.get_y_gui(),
				});
			}
	        if (mouse.button_released(mb_any)) {
				eventer.broadcast("mouse_button_released", {
					button: mouse_button,
					x:		INPUT.mouse.get_x(),
					y:		INPUT.mouse.get_y(),
					x_gui:	INPUT.mouse.get_x_gui(),
					y_gui:	INPUT.mouse.get_y_gui(),
				});	
			}
			if (mouse.wheel_up()) {
				eventer.broadcast("mouse_wheel_up", {
					x:		INPUT.mouse.get_x(),
					y:		INPUT.mouse.get_y(),
					x_gui:	INPUT.mouse.get_x_gui(),
					y_gui:	INPUT.mouse.get_y_gui(),	
				});
			}
			if (mouse.wheel_down()) {
				eventer.broadcast("mouse_wheel_down", {
					x:		INPUT.mouse.get_x(),
					y:		INPUT.mouse.get_y(),
					x_gui:	INPUT.mouse.get_x_gui(),
					y_gui:	INPUT.mouse.get_y_gui(),	
				});
			}
			return self;
		},
		__update_keyboard_events: function() {
			/// @func	__update_keyboard_events()
			/// @return {struct} self
			///
			if (keyboard.button(vk_anykey)) {
				eventer.broadcast("keyboard_button", {
					button: keyboard_key,
				});
			}
	        if (keyboard.button_pressed(vk_anykey)) {
				eventer.broadcast("keyboard_button_pressed", {
					button: keyboard_key,
				});
			}
	        if (keyboard.button_released(vk_anykey)) {
				eventer.broadcast("keyboard_button_released", {
					button: keyboard_key,
				});
			}
			return self;
		},
			
		#endregion
	};
	#region Macros /////////
	
	#macro INPUT		global.___system_input
	#macro mouse_x_gui	INPUT.mouse.get_x_gui()
	#macro mouse_y_gui	INPUT.mouse.get_y_gui()
	
	#endregion
	INPUT.setup(); /// <-- automatically invoke setup()
}