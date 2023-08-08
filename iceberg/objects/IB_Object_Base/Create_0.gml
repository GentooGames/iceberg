	
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	//  ______   ______   ______   ______    //
	// /\  == \ /\  __ \ /\  ___\ /\  ___\   //
	// \ \  __< \ \  __ \\ \___  \\ \  __\   //
	//  \ \_____\\ \_\ \_\\/\_____\\ \_____\ //
	//   \/_____/ \/_/\/_/ \/_____/ \/_____/ //
	//                                       //
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	// IB_Object_Base.create //
	event_inherited();
	
	var _self	= self;
	var _config = self[$ "config"] ?? self;
		
	initialize		= function() {
		if (!is_initialized()) {
			__.base.initialization.initialized = true;
			__.on_initialize();
		}
		return self;
	};
	cleanup			= function() {
		if (is_initialized() && !is_cleaned_up()) {
			__.base.cleanup.cleaned_up = true;
			__.on_cleanup();
		}
		return self;
	};
	destroy			= function(_immediate = true) {
		if (is_initialized() && !is_destroyed()) {
			__.base.destruction.destroyed = true;
			__.on_destroy();
			if (_immediate) {
				instance_destroy();
			}
		}
		return self;
	};
	activate		= function(_active = true) {
		if (is_initialized()) {
			if (_active) {
				__.base.activation.active = true;
				__.on_activate();
			}
			else deactivate();
		}
		return self;
	};
	deactivate		= function() {
		if (is_initialized()) {
			__.base.activation.active = false;
			__.on_deactivate();
		}
		return self;
	};
	show			= function(_visible = true) {
		if (is_initialized()) {
			if (_visible) {
				__.base.visibility.visible = true;
								   visible = true;
				__.on_show();
			}
			else hide();
		}
		return self;
	};
	hide			= function() {
		if (is_initialized()) {
			__.base.visibility.visible = false;
							   visible = false;
			__.on_hide();
		}
		return self;
	};
	update_begin	= function(_active  = is_active()) {
		if (is_initialized() && _active) {
			__.on_update_begin();
		}
		return self;
	};
	update			= function(_active  = is_active()) {
		if (is_initialized() && _active) {
			__.on_update();
		}
		return self;
	};
	update_end		= function(_active  = is_active()) {
		if (is_initialized() && _active) {
			__.on_update_end();
		}
		return self;
	};
	render			= function(_visible = is_visible()) {
		if (is_initialized() && _visible) {
			__.on_render();
		}
		return self;
	};
	render_gui		= function(_visible = is_visible()) {
		if (is_initialized() && _visible) {
			__.on_render_gui();
		}
		return self;
	};
	
	on_initialize	= function(_callback, _data = undefined) {
		array_push(__.base.initialization.on_initialization, {
			callback: _callback, 
			data: _data,
		});
		return self;
	};
	on_cleanup		= function(_callback, _data = undefined) {
		array_push(__.base.cleanup.on_cleanup, {
			callback: _callback,
			data:	  _data,
		});
		return self;
	};
	on_destroy		= function(_callback, _data = undefined) {
		array_push(__.base.destruction.on_destruction, {
			callback: _callback, 
			data:	  _data,
		});
		return self;
	};
	on_activate		= function(_callback, _data = undefined) {
		array_push(__.base.activation.on_activation, {
			callback: _callback, 
			data:	  _data,
		});
		return self;
	};
	on_deactivate	= function(_callback, _data = undefined) {
		array_push(__.base.activation.on_deactivation, {
			callback: _callback, 
			data:	  _data,
		});
		return self;
	};
	on_show			= function(_callback, _data = undefined) {
		array_push(__.base.visibility.on_show, {
			callback: _callback,
			data:	  _data,
		});
		return self;
	};
	on_hide			= function(_callback, _data = undefined) {
		array_push(__.base.visibility.on_hide, {
			callback: _callback,
			data:	  _data,
		});
		return self;
	};
	on_update_begin	= function(_callback, _data = undefined) {
		array_push(__.base.update.on_begin, {
			callback: _callback,
			data: _data,
		});
		return self;
	};
	on_update		= function(_callback, _data = undefined) {
		array_push(__.base.update.on_update, {
			callback: _callback, 
			data: _data,
		});
		return self;
	};
	on_update_end	= function(_callback, _data = undefined) {
		array_push(__.base.update.on_end, {
			callback: _callback,
			data: _data,
		});
		return self;
	};
	on_render		= function(_callback, _data = undefined) {
		array_push(__.base.render.on_render, {
			callback: _callback, 
			data: _data,
		});
		return self;
	};
	on_render_gui	= function(_callback, _data = undefined) {
		array_push(__.base.render.on_render_gui, {
			callback: _callback, 
			data: _data,
		});
		return self;
	};
	
	get_guid		= function() {
		return __.meta.guid;	
	};
	get_name		= function() {
		return __.meta.name;
	};
	get_owner		= function() {
		return __.owner;	
	};
	get_uid			= function() {
		return __.meta.uid;
	};
	set_name		= function(_name) {
		__.meta.name = _name;
		return self;
	};
	set_owner		= function(_owner) {
		__.owner = _owner;
		return self;
	};
	set_uid			= function(_uid) {
		__.meta.uid = _uid;
		return self;
	};

	is_initialized	= function() {
		return __.base.initialization.initialized;	
	};
	is_cleaned_up	= function() {
		return __.base.cleanup.cleaned_up;
	};
	is_destroyed	= function() {
		return __.base.destruction.destroyed;	
	};
	is_active		= function() {
		return __.base.activation.active;	
	};
	is_visible		= function() {
		return __.base.visibility.visible;
	};
	

	self[$ "__"] ??= {};
	with (__) {
		on_activate		= method(_self, function() {
			var _callbacks = __.base.activation.on_activation;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		on_cleanup		= method(_self, function() {
			var _callbacks = __.base.cleanup.on_cleanup;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		on_deactivate	= method(_self, function() {
			var _callbacks = __.base.activation.on_deactivation;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		on_destroy		= method(_self, function() {
			var _callbacks = __.base.destruction.on_destruction;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		on_hide			= method(_self, function() {
			var _callbacks = __.base.visibility.on_hide;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		on_initialize	= method(_self, function() {
			var _callbacks = __.base.initialization.on_initialization;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		on_render		= method(_self, function() {
			var _callbacks = __.base.render.on_render;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		on_render_gui	= method(_self, function() {
			var _callbacks = __.base.render.on_render_gui;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		on_show			= method(_self, function() {
			var _callbacks = __.base.visibility.on_show;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		on_update_begin = method(_self, function() {
			var _callbacks = __.base.update.on_begin;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		on_update		= method(_self, function() {
			var _callbacks = __.base.update.on_update;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		on_update_end	= method(_self, function() {
			var _callbacks = __.base.update.on_end;
			for (var _i = 0, _len = array_length(_callbacks); _i < _len; _i++) {
				var _callback = _callbacks[_i];
				_callback.callback(_callback.data);
			};
		});
		
		root  = _self;
		owner = _config[$ "owner"];
		
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
			
			return __.meta.generate_name() + "_" + __.meta.generate_uid()
		});
		meta.generate_name = method(_self, function() {
			
			// each class has the opportunity to be given a 
			// unique name property. if the name is not defined
			// then a name will automatically be generated 
			// using the following runtime_function:
			
			return object_get_name(object_index);
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
		base.debugging		= {
			active:			 false,
			on_activation:   [],
			on_deactivation: [],
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
			visible: _self.visible,
			on_hide:  [],
			on_show:  [],
		};
			
		variable_struct_remove(_self, "owner" );
		variable_struct_remove(_self, "guid"  );
		variable_struct_remove(_self, "name"  );
		variable_struct_remove(_self, "uid"   );
		variable_struct_remove(_self, "active");
	};
	
	
	
	
	
	
	