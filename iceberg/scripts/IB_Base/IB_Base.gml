
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	//  ______   ______   ______   ______    //
	// /\  == \ /\  __ \ /\  ___\ /\  ___\   //
	// \ \  __< \ \  __ \\ \___  \\ \  __\   //
	//  \ \_____\\ \_\ \_\\/\_____\\ \_____\ //
	//   \/_____/ \/_/\/_/ \/_____/ \/_____/ //
	//                                       //
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	function IB_Base(_config = {}) constructor {
	
		var _self  = self;
		var _owner = other; // default to <other>,
							// may be overwritten
		// public 
		static initialize	   = function() {
			if (!is_initialized()) {
				__.base.initialization.initialized = true;
				__on_initialize();
			}
			return self;
		};
		static cleanup		   = function() {
			if (is_initialized() && !is_cleaned_up()) {
				__.base.cleanup.cleaned_up = true;
				__on_cleanup();
			}
			return self;
		};
		static destroy		   = function() {
			if (is_initialized() && !is_destroyed()) {
				__.base.destruction.destroyed = true;
				__on_destruction();
			}
			return self;
		};
		static activate		   = function(_active = true) {
			if (is_initialized()) {
				if (_active) {
					__.base.activation.active = true;
					__on_activate();
				}
				else deactivate();
			}
			return self;
		};
		static deactivate	   = function() {
			if (is_initialized()) {
				__.base.activation.active = false;
				__on_deactivate();
			}
			return self;
		};
		static show			   = function(_visible = true) {
			if (is_initialized()) {
				if (_visible) {
					__.base.visibility.visible = true;
					__on_show();
				}
				else hide();
			}
			return self;
		};
		static hide			   = function() {
			if (is_initialized()) {
				__.base.visibility.visible = false;
				__on_hide();
			}
			return self;
		};
		static update_begin	   = function(_active  = is_active()) {
			if (is_initialized() && _active) {
				__on_update_begin();
			}
			return self;
		};
		static update		   = function(_active  = is_active()) {
			if (is_initialized() && _active) {
				__on_update();
			}
			return self;
		};
		static update_end	   = function(_active  = is_active()) {
			if (is_initialized() && _active) {
				__on_update_end();
			}
			return self;
		};
		static render		   = function(_visible = is_visible()) {
			if (is_initialized() && _visible) {
				__on_render();
			}
			return self;
		};
		static render_gui	   = function(_visible = is_visible()) {
			if (is_initialized() && _visible) {
				__on_render_gui();
			}
			return self;
		};
		
		static on_initialize   = function(_callback, _data = undefined) {
			array_push(__.base.initialization.on_initialization, {
				callback: _callback, 
				data:	  _data,
			});
			return self;
		};
		static on_cleanup	   = function(_callback, _data = undefined) {
			array_push(__.base.cleanup.on_cleanup, {
				callback: _callback,
				data:	  _data,
			});
			return self;
		};
		static on_destroy	   = function(_callback, _data = undefined) {
			array_push(__.base.destruction.on_destruction, {
				callback: _callback,
				data:	  _data,
			});
			return self;
		};
		static on_activate	   = function(_callback, _data = undefined) {
			array_push(__.base.activation.on_activation, {
				callback: _callback, 
				data:	  _data,
			});
			return self;
		};
		static on_deactivate   = function(_callback, _data = undefined) {
			array_push(__.base.activation.on_deactivation, {
				callback: _callback, 
				data:	  _data,
			});
			return self;
		};
		static on_show		   = function(_callback, _data = undefined) {
			array_push(__.base.visibility.on_show, {
				callback: _callback,
				data:	  _data,
			});
			return self;
		};
		static on_hide		   = function(_callback, _data = undefined) {
			array_push(__.base.visibility.on_hide, {
				callback: _callback,
				data:	  _data,
			});
			return self;
		};
		static on_update_begin = function(_callback, _data = undefined) {
			array_push(__.base.update.on_begin, {
				callback: _callback, 
				data: _data,
			});
			return self;
		};
		static on_update	   = function(_callback, _data = undefined) {
			array_push(__.base.update.on_update, {
				callback: _callback, 
				data: _data,
			});
			return self;
		};
		static on_update_end   = function(_callback, _data = undefined) {
			array_push(__.base.update.on_end, {
				callback: _callback, 
				data: _data,
			});
			return self;
		};
		static on_render	   = function(_callback, _data = undefined) {
			array_push(__.base.render.on_render, {
				callback: _callback, 
				data: _data,
			});
			return self;
		};
		static on_render_gui   = function(_callback, _data = undefined) {
			array_push(__.base.render.on_render_gui, {
				callback: _callback, 
				data: _data,
			});
			return self;
		};
		
		static get_guid		   = function() {
			return __.meta.guid;	
		};
		static get_name		   = function() {
			return __.meta.name;
		};
		static get_owner	   = function() {
			return __.owner;	
		};
		static get_uid		   = function() {
			return __.meta.uid;
		};
		static set_name		   = function(_name) {
			__.meta.name = _name;
			return self;
		};
		static set_owner	   = function(_owner) {
			__.owner = _owner;
			return self;
		};
		static set_uid		   = function(_uid) {
			__.meta.uid = _uid;
			return self;
		};
		
		static is_initialized  = function() {
			return __.base.initialization.initialized;	
		};
		static is_cleaned_up   = function() {
			return __.base.cleanup.cleaned_up;	
		};
		static is_destroyed	   = function() {
			return __.base.destruction.destroyed;	
		};
		static is_active	   = function() {
			return __.base.activation.active;	
		};
		static is_visible	   = function() {
			return __.base.visibility.visible;
		};
		
		// private
		self[$ "__"] ??= {};
		with (__) {
			static __on_activate	 = function() {
				var _callbacks = __.base.activation.on_activation;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			static __on_cleanup		 = function() {
				var _callbacks = __.base.cleanup.on_cleanup;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			static __on_deactivate	 = function() {
				var _callbacks = __.base.activation.on_deactivation;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			static __on_destruction	 = function() {
				var _callbacks = __.base.destruction.on_destruction;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			static __on_hide		 = function() {
				var _callbacks = __.base.visibility.on_hide;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			static __on_initialize	 = function() {
				var _callbacks = __.base.initialization.on_initialization;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			static __on_render		 = function() {
				var _callbacks = __.base.render.on_render;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			static __on_render_gui	 = function() {
				var _callbacks = __.base.render.on_render_gui;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			static __on_show		 = function() {
				var _callbacks = __.base.visibility.on_show;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			static __on_update_begin = function() {
				var _callbacks = __.base.update.on_begin;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			static __on_update		 = function() {
				var _callbacks = __.base.update.on_update;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			static __on_update_end	 = function() {
				var _callbacks = __.base.update.on_end;
				for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
					var _callback = _callbacks[_i];
					_callback.callback(_callback.data);
				};
			};
			
			root  = _self;
			owner = _config[$ "owner"] ?? _owner;
		
			// meta
			meta = {};
			meta.generate_guid = method(_self, function() {
				
				// guid is a static variable that doesnt change
				// during the life cycle. this is a reference to 
				// the class definition + ptr value. even if the 
				// defined name and uid values change, this guid
				// value will always remain constant, making it
				// a great value to use for global storage / 
				// reference keys.
				
				return __.meta.generate_name() + "_" + __.meta.generate_uid();	
			});
			meta.generate_name = method(_self, function() {
				
				// each class has the opportunity to be given a 
				// unique name property. if the name is not defined
				// then a name will automatically be generated 
				// using the following runtime_function:
				
				return instanceof(self);
			});
			meta.generate_uid  = method(_self, function() {
				
				// uid is designed to be a "unique id" that 
				// is set by the user, and is different than
				// the class's name property. 
				
				return string(ptr(self));
			});
			
			meta.guid = _config[$ "guid"] ?? meta.generate_guid();
			meta.name = _config[$ "name"] ?? meta.generate_name();
			meta.uid  = _config[$ "uid" ] ?? meta.generate_uid();
		
			// base
			base = {};
			base.activation		= {
				active:			_config[$ "active"] ?? true,
				on_activation:	 [],
				on_deactivation: [],
			};
			base.cleanup		= {
				cleaned_up: false,
				on_cleanup: [],
			};				
			base.destruction	= {
				destroyed:		false,
				on_destruction: [],
			};
			base.initialization = {
				initialized:	   false, 
				on_initialization: [],
			};
			base.render			= {
				on_render:	   [],
				on_render_gui: [],
			};
			base.update			= {
				on_begin:  [],
				on_update: [],
				on_end:	   [],
			};
			base.visibility		= {
				visible: _config[$ "visible"] ?? true,
				on_hide:  [],
				on_show:  [],
			};
		};
	};
	
	