function ___audio() {
	/// @func ___audio()
	///
	global.___system_audio = {
	    initialized: false,
		
		#region Core ///////
		
	    setup:    function() {
	        /// @func   setup()
	        /// @return {struct} self
	        ///
	        if (!initialized) {
				#region ----------------
		
		        log("<AUDIO> setup()");
				initialized = true;
		
				audio_falloff_set_model(audio_falloff_linear_distance);
		        audio_master_gain(0);
		        audio_listener_orientation(0, 1, 0, 0, 0, 1);  
		
				#endregion
				#region Layers /////////
			
				layers		= {};
				layer_names = [];
				n_layers	= 0;
			
				#endregion
				#region Queues /////////
			
				queue = ds_queue_create();
			
				#endregion
				#region Events /////////
		
				eventer = new Eventable().setup();
				eventer.register([
					"played",
					"stopped",
					"all_stopped",
					"pitch_assigned",
					"emitter_gain_assigned",
					"emitter_pitch_assigned",
				]);
		
				#endregion
			}
			return self;
	    },
		update:	  function() {
			/// @func   update()
	        /// @return {struct} self
	        ///
	        if (initialized) {};
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
			if (initialized) {
				#region ----------------
		
		        log("<AUDIO> teardown()");
				initialized = false;
			
				#endregion
				#region Layers /////////
			
				layers   = [];
				n_layers = 0;
			
				#endregion
				#region Queues /////////
			
				ds_queue_destroy(queue);
				queue = undefined;
			
				#endregion
			}
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
		
		
		
		#endregion
	};
	#region Macros /////////
	
	#macro AUDIO global.___system_audio
	
	#endregion
	AUDIO.setup();  /// <-- automatically invoke setup()
};
function AudioLayer() constructor {
	/// @func	AudioLayer()
	/// @return	{AudioLayer} self
	///
	/*
		To Do:
			- audio layers
				- audio_create_sync_group()?
				- audio fadeouts
			- audio queueing
	
		Audio Categories:
			- world
				- sfx
				- music
				- ambient
				- voice
			- ui
				- sfx
				- music
			
		Approach:
			- every sound exists on a layer
			- every action to either queue or fade is tied to a sound/layer
				- actions can be executed at the sound or layer level
	*/
	
	emitters      = {};
	emitter_names = [];
	n_emitters	  = 0;
	
	static add_emitter	  = function(_name) {
		/// @func	add_emitter(name)
		/// @param	{string} name
		/// @return {AudioLayer} self
		///
		if (get_emitter(_name) == undefined) {
			emitters[$ _name]  = audio_emitter_create();
			array_push(emitter_names, _name);
			n_emitters++;
		}
		return self;
	};
	static remove_emitter = function(_name, _free = true) {
		/// @func	remove_emitter(name, free?*)
		/// @param	{string}  name
		/// @param	{boolean} free=true
		/// @return {AudioLayer} self
		///
		if (get_emitter(_name) != undefined) {
			if (_free) {
				audio_emitter_free(emitters[$ _name]);
			}
			variable_struct_remove(emitters, _name);
			for (var _i = n_emitters - 1; _i >= 0; _i--) {
				if (emitter_names[_i] == _name) {
					array_delete(emitter_names, _i, 1);	
				}
			}
			n_emitters--;
		}
		return self;
	};
	static get_emitter	  = function(_name) {
		/// @func	get_emitter(name)
		/// @param	{string} name
		/// @return {emitter_id} emitter
		///
		return emitters[$ _name];
	};
	static has_emitter	  = function(_name) {
		/// @func	has_emitter(name)
		/// @param	{string}  name
		/// @return {boolean} has_emitter?
		///
		return get_emitter(_name) != undefined;
	};
		
	/// Actions
	static set_gain			 = function(_gain) {
		/// @func	set_gain(gain)
		/// @param	{real} gain
		/// @return	{AudioLayer} self
		///
		for (var _i = 0; _i < n_emitters; _i++) {
			var _emitter_name = emitter_names[_i];
			var _emitter	  = emitters[$ _emitter_name];
			audio_emitter_gain(_emitter, _gain);
		}
		return self;
	};
	static set_pitch		 = function(_pitch) {
		/// @func	set_pitch(pitch)
		/// @param	{real} pitch
		/// @return	{AudioLayer} self
		///
		for (var _i = 0; _i < n_emitters; _i++) {
			var _emitter_name = emitter_names[_i];
			var _emitter	  = emitters[$ _emitter_name];
			audio_emitter_pitch(_emitter, _pitch);
		}
		return self;
	};
	static set_position		 = function(_x, _y, _z) {
		/// @func	set_position(x, y, z)
		/// @param	{real} x
		/// @param	{real} y
		/// @param	{real} z
		/// @return	{AudioLayer} self
		///
		for (var _i = 0; _i < n_emitters; _i++) {
			var _emitter_name = emitter_names[_i];
			var _emitter	  = emitters[$ _emitter_name];
			audio_emitter_position(_emitter, _x, _y, _z);
		}
		return self;
	};
	static set_velocity		 = function(_vx, _vy, _vz) {
		/// @func	set_velocity(vx, vy, vz)
		/// @param	{real} vx
		/// @param	{real} vy
		/// @param	{real} vz
		/// @return	{AudioLayer} self
		///
		for (var _i = 0; _i < n_emitters; _i++) {
			var _emitter_name = emitter_names[_i];
			var _emitter	  = emitters[$ _emitter_name];
			audio_emitter_velocity(_emitter, _vx, _vy, _vz);
		}
		return self;
	};
	static set_falloff		 = function(_falloff_ref, _falloff_max, _falloff_factor = 1) {
		/// @func	set_falloff(falloff_ref, falloff_max, falloff_factor*)
		/// @param	{real} falloff_ref
		/// @param	{real} falloff_max
		/// @param	{real} falloff_factor=1
		/// @return	{AudioLayer} self
		///
		for (var _i = 0; _i < n_emitters; _i++) {
			var _emitter_name = emitter_names[_i];
			var _emitter	  = emitters[$ _emitter_name];
			audio_emitter_falloff(_emitter, _falloff_ref, _falloff_max, _falloff_factor);
		}
		return self;
	};
	static set_listener_mask = function(_mask) {
		/// @func	set_listener_mask(mask)
		/// @param	{real} mask
		/// @return {AudioLayer} self
		///
		for (var _i = 0; _i < n_emitters; _i++) {
			var _emitter_name = emitter_names[_i];
			var _emitter	  = emitters[$ _emitter_name];
			audio_emitter_set_listener_mask(_emitter, _mask);
		}
		return self;
	};
};	