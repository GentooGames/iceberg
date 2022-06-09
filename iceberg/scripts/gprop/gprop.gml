enum INTERP {
	NONE,
	CONST,
	LERP,	
};

#macro __GPROP_ID_DELINEATOR							"."
#macro __GPROP_DEFAULT_INTERP_ON_COMPLETE_PUBLISH		true
#macro __GPROP_DEFAULT_INTERP_ON_COMPLETE_EVENT_SUFFIX "interp_completed"
#macro __GPROP_DEFAULT_SPRING_TENSION					__SPRING_DEFAULT_TENSION
#macro __GPROP_DEFAULT_SPRING_DAMPENING					__SPRING_DEFAULT_DAMPENING
#macro __GPROP_DEFAULT_SPRING_SPEED						__SPRING_DEFAULT_SPEED

function GProp(_data) constructor {
	/// @func	GProp(data)
	/// @param	{struct} data
	///
	owner  =  other;
	name   = _data[$ "name"	 ];
	value  = _data[$ "value" ] ?? 0.0;
	offset = _data[$ "offset"] ?? 0.0;
	target = _data[$ "target"] ?? value;
	interp = {
		type:	      _data[$ "interp_type"	      ] ?? INTERP.LERP,
		speed:	      _data[$ "interp_speed"	  ] ?? 0.1,
		threshold:    _data[$ "interp_threshold"  ] ?? 0.0,
		on_complete:  _data[$ "interp_on_complete"] ?? {
			callback: _data[$ "interp_on_complete_callback"		],
			data:	  _data[$ "interp_on_complete_callback_data"],
		}
		complete:      false,
	};
	
	static update	  = function() {
		/// @func update()
		///
		if (interp.type != INTERP.NONE) {
			switch (interp.type) {
				case INTERP.CONST: __interp_update_const(); break;
				case INTERP.LERP:  __interp_update_lerp();  break;	
			};
			__interp_check_complete();
		}
		__spring.update();
	};
	static get		  = function() {
		/// @func	get()
		/// @return {any} value
		///
		return value + __spring.get();
	};
	static get_target = function() {
		/// @func	get_target()
		/// @return {any} target
		///
		return target + offset;
	};
	static set		  = function(_value) {
		/// @func	set_value(value)
		/// @param	{any} value
		///	@return {GProp} self
		///
		value  = _value + offset;
		target =  value;
		return self;
	};
	static snap		  = function() {
		/// @func	snap()
		///	@return {GProp} self
		///
		value = get_target();
		return self;
	};
	static spring	  = function(_speed = __GPROP_DEFAULT_SPRING_SPEED) {
		__spring.fire(_speed);
		return self;	
	};
	
	#region Private ////////
	
	__spring = new Spring(__GPROP_DEFAULT_SPRING_TENSION, __GPROP_DEFAULT_SPRING_DAMPENING);
	
	static __interp_update_const			   = function() {
		/// @func __interp_update_const()
		///
		if (get() - value <= interp.speed) {
			value += interp.speed;
		}
		/// @TODO: add in smoothing?
	};
	static __interp_update_lerp				   = function() {
		/// @func __interp_update_lerp()
		///
		value = lerp(value, get_target(), interp.speed);
	};
	static __interp_check_complete			   = function() {
		/// @func __interp_check_complete()
		///
		if (abs(value - get()) <= interp.threshold) {
			if (!interp.complete) {
				__interp_complete();
			}
		}
		else {
			interp.complete = false;	
		}
	};
	static __interp_complete				   = function() {
		/// @func __interp_complete()
		///
		with (interp.on_complete) {
			if (callback != undefined) {
				callback(data);	
			}
		}
		interp.complete = true;
		
		if (__GPROP_DEFAULT_INTERP_ON_COMPLETE_PUBLISH) {
			PUBLISH(__interp_on_complete_get_event_name(), { id: other });
		}
	};
	static __interp_on_complete_get_event_name = function() {
		/// @func __interp_on_complete_get_event_name()
		///
		return __unique_id_get() + __GPROP_DEFAULT_INTERP_ON_COMPLETE_EVENT_SUFFIX;
	};
	static __unique_id_get					   = function() {
		/// @func	__unique_id_get()
		/// @return {string} id
		///
		/// Is Struct
		if (is_struct(owner)) {
			var _prefix = instanceof(owner);
		}
		/// Is Instance
		else {
			var _prefix = object_get_name(owner.object_index);
		}
		return _prefix + __GPROP_ID_DELINEATOR + "prop" + __GPROP_ID_DELINEATOR + name + __GPROP_ID_DELINEATOR;
	};
	
	#endregion
	#region Other //////////
	
	if (__GPROP_DEFAULT_INTERP_ON_COMPLETE_PUBLISH) {
		if (!PUBLISHER.has_registered_channel(__interp_on_complete_get_event_name())) {
			PUBLISHER.register_channel(__interp_on_complete_get_event_name());	
		}
	}
	
	#endregion
};	



