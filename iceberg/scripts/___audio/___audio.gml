global.___system_audio = {
    initialized: false,
    emitter: {
        sfx:     audio_emitter_create(),
        music:   audio_emitter_create(),
        ambient: audio_emitter_create(),
        voice:   audio_emitter_create(),
    },
	
	/// Internal ///////////
    setup:  function() {
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
			#region Events /////////
		
			EventObject(,"audio");
			event_register([
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
	update:	function() {
		/// @func   update()
        /// @return {struct} self
        ///
        if (initialized) {};
		return self;
	},
		
	/// Core ///////////////
    play:			function(_emitter_id, _audio_id,  _loops, _priority = 0) {
        /// @func   play(emitter_id, sound_id, loops, priority*)
        /// @param  {emitter}	  emitter_id
        /// @param  {audio_index} audio_id
        /// @param  {bool}		  loops      
        /// @param  {real}		  priority=0
        /// @return {audio_id}	  audio_inst_id
        ///
        var _audio_instance = audio_play_sound_on(_emitter_id, _audio_id, _loops, _priority);
		event_publish("played", _audio_instance);
		return _audio_instance;
    },
	play_array:		function(_emitter_id, _audio_ids, _loops, _priority = 0) {
		/// @func   play_array(emitter_id, _audio_id, loops, priority*)
        /// @param  {emitter} emitter_id 
        /// @param  {array}   audio_id   
        /// @param  {bool}	  loops      
        /// @param  {real}	  priority=0
        /// @return {struct}  audio_inst_ids
        ///
		var _sound_id, _sound_inst;
		var _played = {};
		for (var _i = 0, _len = array_length(_audio_ids); _i < _len; _i++) {
			_sound_id	= _audio_ids[_i];
			_sound_inst =  play(_emitter_id, _sound_id, _loops, _priority);
			_played[$ audio_get_name(_sound_id)] = _sound_inst;
		}
		return _played;
	},
    play_mod:		function(_emitter_id, _audio_id,  _loops, _priority = 0, _range_min = 0.9, _range_max = 1.1) {
        /// @func   play_mod(emitter_id, audio_id, loops, priority*, range_min*, range_max*)
        /// @param  {emitter_index} emitter_id 
        /// @param  {audio_index}	audio_id   
        /// @param  {bool}			loops      
        /// @param  {real}			priority=0
		/// @param	{real}			range_min=0.9
		/// @param	{real}			range_max=1.1
        /// @return {audio_index}	audio_inst
        ///
        set_pitch(_audio_id, random_range(_range_min, _range_max));
        return play(_emitter_id, _audio_id, _loops, _priority);
    },
	play_mod_array: function(_emitter_id, _audio_ids, _loops, _priority = 0, _range_min = 0.9, _range_max = 1.1) {
		/// @func   play_mod_array(emitter_id, audio_id, loops, priority*, range_min*, range_max*)
        /// @param  {emitter} emitter_id 
        /// @param  {array}   audio_ids
        /// @param  {bool}	  loops      
        /// @param  {real}	  priority=0
		/// @param	{real}	  range_min=0.9
		/// @param	{real}	  range_max=1.1
        /// @return {struct}  audio_inst_ids
        ///
		var _sound_id, _sound_inst;
		var _played = {};
		for (var _i = 0, _len = array_length(_audio_ids); _i < _len; _i++) {
			_sound_id	= _audio_ids[_i];
			_sound_inst =  play_mod(_emitter_id, _sound_id, _loops, _priority, _range_min, _range_max);
			_played[$ audio_get_name(_sound_id)] = _sound_inst;
		}
		return _played;
	},
    stop:			function(_audio_id) {
        /// @func   stop(sound_id)
        /// @param  {audio_index} audio_id
        /// @return {struct}	  self
        ///
    	audio_stop_sound(_audio_id);
		event_publish("stopped", _audio_id);
		return self;
    },
	stop_array:		function(_audio_ids) {
		/// @func   stop_array(audio_ids)
        /// @param  {array}  audio_ids
        /// @return {struct} self
        ///
		for (var _i = 0, _len = array_length(_audio_ids); _i < _len; _i++) {
    		stop(_audio_ids[_i]);
		}
		return self;
	},
    stop_all:		function() {
        /// @func   stop_all()
        /// @return {struct} self
        ///
        audio_stop_all();
		event_publish("all_stopped");
		return self;
    },
    
	/// Setters ////////////
	set_pitch:         function(_sound_id, _pitch) {
        /// @func   set_pitch(sound_id, pitch)
        /// @param  sound_id {sound}
        /// @param  pitch    {real}
        /// @return {struct} self
        ///
        audio_sound_pitch(_sound_id, _pitch);
		event_publish("pitch_assigned", { sound: _sound_id, pitch: _pitch });
		return self;
    },
    set_emitter_gain:  function(_emitter_id, _gain) {
        /// @func   set_emitter_gain(emitter_id, gain)
        /// @param  emitter_id {emitter}
        /// @param  gain       {real}
        /// @return {struct} self
        ///
        audio_emitter_gain(_emitter_id, _gain);	
		event_publish("emitter_gain_assigned", { emitter: _emitter_id, gain: _gain });
		return self;
    },
    set_emitter_pitch: function(_emitter_id, _pitch) {
        /// @func   set_emitter_pitch(emitter_id, pitcj)
        /// @param  emitter_id {emitter}
        /// @param  pitch      {real}
        /// @return {struct} self
        ///
        audio_emitter_pitch(_emitter_id, _pitch);	
		event_publish("emitter_pitch_assigned", { emitter: _emitter_id, pitch: _pitch });
		return self;
    },
    
    /// Checkers ///////////
    is_playing:			  function(_audio_id) {
        /// @func   is_playing(audio_id)
        /// @param  {audio_id} audio_id
        /// @return {boolean}  is_playing?
        ///
        return audio_is_playing(_audio_id);
    },
    is_playing_array_any: function(_audio_ids) {
        /// @func   is_playing_array_any(audio_ids)
        /// @param  {array}	  audio_ids
        /// @return {boolean} is_playing?
        ///
    	for (var _i = 0, _len = array_length(_audio_ids); _i < _len; _i++) {
    		if (is_playing(_audio_ids[_i])) {
    			return true;
    		}
    	}
    	return false;
    },
	is_playing_array_all: function(_audio_ids) {
		/// @func   is_playing_array_all(audio_ids)
        /// @param  {array}	  audio_ids
        /// @return {boolean} are_playing?
        ///
    	for (var _i = 0, _len = array_length(_audio_ids); _i < _len; _i++) {
    		if (!is_playing(_audio_ids[_i])) {
    			return false;
    		}
    	}
    	return true;
	},
};
#macro AUDIO global.___system_audio

