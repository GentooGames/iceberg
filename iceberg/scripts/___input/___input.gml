global.___input_system = {
    initialized: false,
	
	/// Internal ///////////
    setup:  function() {
        /// @func   setup()
        /// @return NA
        ///
        if (initialized) exit;
		#region ----------------
		
        log("<INPUT> setup()");
        initialized = true;
		
		#endregion
		#region Events /////////
		
		EventObject(, "input");
		event_register([
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
			/// ...
			
			/// keyboard_button_*
			"keyboard_button_pressed",
			"keyboard_button",
			"keyboard_button_released",
		]);
		
		#endregion
    },
    update: function() {
        /// @func   update()
        /// @return NA
        /// 
		if (!initialized) exit;
		__update_mouse_events();
		__update_keyboard_events();
    },
    
	/// Core ///////////////
	mouse:    {
        device: 0,
        
		/// Core ///////////////////////////
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
        wheel_down:      function() {
            /// @func   wheel_down()
            /// @return NA
            ///
            return mouse_wheel_down();
        },
        wheel_up:        function() {
            /// @func   wheel_up()
            /// @return NA
            ///
            return mouse_wheel_up();
        },
        
        /// Getters ////////////////////////
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
			
		/// Other //////////////////////////
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
    },
    keyboard: {
		/// Core ///////////////////////////
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
    },
		
	/// Private ////////////
	__update_mouse_events:	  function() {
		/// @func	__update_mouse_events()
		/// @return {struct} self
		///
		if (mouse.button(mb_any)) {
			event_publish("mouse_button", {
				button: mouse_button,
				x:		INPUT.mouse.get_x(),
				y:		INPUT.mouse.get_y(),
				x_gui:	INPUT.mouse.get_x_gui(),
				y_gui:	INPUT.mouse.get_y_gui(),
			});
		}
		if (mouse.button_pressed(mb_any)) {
			event_publish("mouse_button_pressed", {
				button: mouse_button,
				x:		INPUT.mouse.get_x(),
				y:		INPUT.mouse.get_y(),
				x_gui:	INPUT.mouse.get_x_gui(),
				y_gui:	INPUT.mouse.get_y_gui(),
			});
		}
        if (mouse.button_released(mb_any)) {
			event_publish("mouse_button_released", {
				button: mouse_button,
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
			event_publish("keyboard_button", {
				button: keyboard_key,
			});
		}
        if (keyboard.button_pressed(vk_anykey)) {
			event_publish("keyboard_button_pressed", {
				button: keyboard_key,
			});
		}
        if (keyboard.button_released(vk_anykey)) {
			event_publish("keyboard_button_released", {
				button: keyboard_key,
			});
		}
			
		return self;
	},
};
#macro INPUT global.___input_system

#macro mouse_x_gui INPUT.mouse.get_x_gui()
#macro mouse_y_gui INPUT.mouse.get_y_gui()