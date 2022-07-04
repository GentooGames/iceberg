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

function AudioLayer() constructor {
	/// @func	AudioLayer()
	/// @return	{AudioLayer} self
	///
	emitters      = {};
	emitter_names = [];
	n_emitters	  = 0;
	
	// include option to stash into sync_group?
	
	static add_emitter	  = function() {};
	static remove_emitter = function() {};
	static get_emitter	  = function() {};
};	

global.___system_audio = {
    initialized: false,
	
	/// Internal ///////////
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
			
			layers   = [];  // audio layers
			n_layers = 0;
			
			#endregion
			#region Queues /////////
			
			queue = ds_queue_create();
			
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
	update:	  function() {
		/// @func   update()
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
};
#macro AUDIO global.___system_audio

