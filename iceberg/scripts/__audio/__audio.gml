global._audio = {};
#macro AUDIO   global._audio
////////////////////////////////

AUDIO = {
	/// Properties & Associations
    initialized: false,
    emitter: {
        sfx:     audio_emitter_create(),
        music:   audio_emitter_create(),
        ambient: audio_emitter_create(),
        voice:   audio_emitter_create(),
    },
	
	/// Methods
    setup:    function() {
        /// @func   setup()
		/// @desc	...
        /// @return NA
        ///
        if (initialized) exit;
		////////////////////////
        log("<AUDIO> setup()");
        audio_falloff_set_model(audio_falloff_linear_distance);
        audio_master_gain(0);
        audio_listener_orientation(0, 1, 0, 0, 0, 1);      
        initialized = true;
    },
    play:     function(_emitter_id, _sound_id, _loops) {
        /// @func   play(emitter_id, sound_id, loops)
        /// @param  emitter_id {emitter}
        /// @param  sound_id   {sound}
        /// @param  loops      {bool}
		/// @desc   play a sound on a given emitter.
        /// @return sound_inst {sound}
        ///
        return audio_play_sound_on(_emitter_id, _sound_id, _loops, 0);
    },
    play_mod: function(_emitter_id, _sound_id, _loops) {
        /// @func   play_mod(emitter_id, sound_id, loops)
        /// @param  emitter_id {emitter}
        /// @param  sound_id   {sound}
        /// @param  loops      {bool}
		/// @desc   play a sound on a given emitter with a subtle pitch modification.
        /// @return sound_inst {sound}
        ///
        audio_sound_pitch(_sound_id, random_range(0.9, 1.1));
        return audio_play_sound_on(_emitter_id, _sound_id, _loops, 0);
    },
    stop:     function(_sound_id) {
        /// @func   stop(sound_id)
        /// @desc   stop a given sound.
        /// @param  sound_id {sound}
        /// @return NA
        ///
    	if (!is_array(_sound_id)) {
			_sound_id = [_sound_id];
		}
    	for (var _i = 0, _len = array_length(_sound_id); _i < _len; _i++) {
    		audio_stop_sound(_sound_id[_i]);
    	}
    },
    stop_all: function() {
        /// @func   stop_all()
        /// @desc   stop all sounds currently playing.
        /// @return	NA
        ///
        audio_stop_all();
    },
    
    #region Setters
    
    set_emitter_gain:  function(_emitter_id, _gain) {
        /// @func   set_emitter_gain(emitter_id, gain)
        /// @param  emitter_id {emitter}
        /// @param  gain       {real}
		/// @desc	...
        /// @return NA
        ///
        audio_emitter_gain(_emitter_id, _gain);	
    },
    set_emitter_pitch: function(_emitter_id, _pitch) {
        /// @func   set_emitter_pitch(emitter_id, pitcj)
        /// @param  emitter_id {emitter}
        /// @param  pitch      {real}
		/// @desc	...
        /// @return NA
        ///
        audio_emitter_pitch(_emitter_id, _pitch);	
    },
    set_pitch:         function(_sound_id, _pitch) {
        /// @func   set_pitch(sound_id, pitch)
        /// @param  sound_id {sound}
        /// @param  pitch    {real}
		/// @desc	...
        /// @return NA
        ///
        audio_sound_pitch(_sound_id, _pitch);
    },
    
    #endregion
    #region Checkers
    
    is_playing:       function(_sound_id) {
        /// @func   is_playing()
        /// @param  sound_id {sound}
		/// @desc   check if a given sound is currently playing
        /// @return playing  {bool}
        ///
        return audio_is_playing(_sound_id);
    },
    is_playing_array: function(_sound_ids) {
        /// @func   is_playing_array(sound_ids)
        /// @param  sound_ids {sound/array}
		/// @desc   given an array of sound ids, check if any sound is currently playing
        /// @return playing {bool}
        ///
        if (!is_array(_sound_ids)) {
			_sound_ids = [_sound_ids];
		}
    	for (var _i = 0, _len = array_length(_sound_ids); _i < _len; _i++) {
    		if (AUDIO.is_playing(_sound_ids[_i])) {
    			return true;
    		}
    	}
    	return false;
    },
    
    #endregion
};

