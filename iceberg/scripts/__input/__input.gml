global._input = {};
#macro INPUT   global._input
////////////////////////////////
#macro mouse_x_gui INPUT.mouse.get_x_gui()
#macro mouse_y_gui INPUT.mouse.get_y_gui()

INPUT = {
    initialized: false,
	
    setup:  function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) exit;
		#region ----------------
		
        log("<INPUT> setup()");
        initialized = true;
		
		#endregion
    },
    update: function() {
        /// @func   update()
		/// @desc	...
        /// @return NA
        /// 
		if (!initialized) exit;
		
        if (mouse.button_pressed(mb_any)) {
			PUBLISH("input_mouse_button_pressed", {
				button: mouse_button,
				x:		INPUT.mouse.get_x(),
				y:		INPUT.mouse.get_y(),
				x_gui:	INPUT.mouse.get_x_gui(),
				y_gui:	INPUT.mouse.get_y_gui(),
			});
		}
        if (mouse.button(mb_any)) {
			PUBLISH("input_mouse_button", {
				button: mouse_button,
				x:		INPUT.mouse.get_x(),
				y:		INPUT.mouse.get_y(),
				x_gui:	INPUT.mouse.get_x_gui(),
				y_gui:	INPUT.mouse.get_y_gui(),
			});
		}
        if (mouse.button_released(mb_any)) {
			PUBLISH("input_mouse_button_released", {
				button: mouse_button,
				x:		INPUT.mouse.get_x(),
				y:		INPUT.mouse.get_y(),
				x_gui:	INPUT.mouse.get_x_gui(),
				y_gui:	INPUT.mouse.get_y_gui(),
			});
		}
        if (keyboard.button_pressed(vk_anykey)) {
			PUBLISH("input_keyboard_button_pressed", {
				button: keyboard_key,
			});
		}
        if (keyboard.button(vk_anykey)) {
			PUBLISH("input_keyboard_button", {
				button: keyboard_key,
			});
		}
        if (keyboard.button_released(vk_anykey)) {
			PUBLISH("input_keyboard_button_released", {
				button: keyboard_key,
			});
		}
    },
		
    mouse: {
        device: 0,
        
        button_pressed:  function(_button) {
            /// @func   button_pressed(button)
            /// @param  button  {mb_button}
			/// @desc	...
            /// @return pressed {bool}
            ///
            return device_mouse_check_button_pressed(device, _button);
        },
        button:          function(_button) {
            /// @func   button(button)
            /// @param  button {mb_button}
			/// @desc	...
            /// @return down {bool}
            /// 
            return device_mouse_check_button(device, _button);
        },
        button_released: function(_button) {
            /// @func   button_released(button)
            /// @param  button {mb_button}
			/// @desc	...
            /// @return released {bool}
            ///
            return device_mouse_check_button_released(device, _button);
        },
        wheel_down:      function() {
            /// @func   wheel_down()
			/// @desc	...
            /// @return NA
            ///
            return mouse_wheel_down();
        },
        wheel_up:        function() {
            /// @func   wheel_up()
			/// @desc	...
            /// @return NA
            ///
            return mouse_wheel_up();
        },
        
        /// Getters
        get_x:      function() {
            /// @func   get_x()
			/// @desc	...
            /// @return x {real}
            ///
            return device_mouse_x(device);
        },
        get_y:      function() {
            /// @func   get_y()
			/// @desc	...
            /// @return y {real}
            ///
            return device_mouse_y(device);
        },
        get_x_gui:  function() {
            /// @func   get_x_gui()
			/// @desc	...
            /// @return x_gui {real}
            ///
            return device_mouse_x_to_gui(device);
        },
        get_y_gui:  function() {
            /// @func   get_y_gui()
			/// @desc	...
            /// @return y_gui {real}
            ///
            return device_mouse_y_to_gui(device);
        },
        get_i:      function() {
            /// @func   get_i()
			/// @desc	...
            /// @return i {real}
            ///
            return global_xy_to_i(get_x(), get_y());
        },
        get_j:      function() {
            /// @func   get_j()
			/// @desc	...
            /// @return j {real}
            ///
            return global_xy_to_j(get_x(), get_y());
        },
			
		/// Other
		to_string: function(_button_index) {
			/// @func	to_string(button_index)
			/// @param	button_index -> {mb}
			/// @desc	...
			/// @return string -> {string}
			/// @tested false
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
        button_pressed:  function(_button) { 
            /// @func   button_pressed(button)
            /// @param  button  {kb_button}
			/// @desc	...
            /// @return pressed {bool}
            ///
            return keyboard_check_pressed(_button);  
        },
        button:          function(_button) {
            /// @func   button(button)
            /// @param  button {kb_button}
			/// @desc	...
            /// @return down {bool}
            ///
            return keyboard_check(_button);
        },
        button_released: function(_button) {
            /// @func   button_released(button)
            /// @param  button {kb_button}
			/// @desc	...
            /// @return released {bool}
            ///
            return keyboard_check_released(_button);  
        },
		//switch_check:	 function(_keycode) {
		//	/// @func	switch_check(keycode)
		//	/// @param	{real} keycode
		//	/// @return NA
		//	///
		//	
		//},
    },
};

