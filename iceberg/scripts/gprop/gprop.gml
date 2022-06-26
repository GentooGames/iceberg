enum INTERP {
	NONE,
	CONST,
	LERP,	
};

#macro __GPROP_ID_DELINEATOR "."

function GProp(_data) constructor {
	/// @func	GProp(data)
	/// @param	{struct} data
	///
	owner   =  other;
	name    = _data[$ "name"  ] ?? "";
	value   = _data[$ "value" ] ?? 0.0;
	offset  = _data[$ "offset"] ?? 0.0;
	target  = _data[$ "target"] ?? value;
	interp  = {}; with (interp ) {
		type		= _data[$ "interp_type"		  ] ?? INTERP.LERP;
		speed		= _data[$ "interp_speed"	  ] ?? 0.1;
		threshold	= _data[$ "interp_threshold"  ] ?? 0.0;
		on_complete	= _data[$ "interp_on_complete"] ?? {
			callback:	_data[$ "interp_on_complete_callback"	  ] ?? undefined,
			data:		_data[$ "interp_on_complete_callback_data"] ?? undefined,
		};
		complete	=  false;
	};
	springs = {}; with (springs) {
		tension		= __SPRING_DEFAULT_TENSION;
		dampening	= __SPRING_DEFAULT_DAMPENING;
		speed		= __SPRING_DEFAULT_SPEED;
		spring_main	= new Spring(tension, dampening);
	};
		
	EventObject(, "gprop");
	
	#region Public /////////
	
	#region Internal ///////
	
	static update = function() {
		/// @func update()
		///
		if (interp.type != INTERP.NONE) {
			switch (interp.type) {
				case INTERP.CONST: __interp_update_const(); break;
				case INTERP.LERP:  __interp_update_lerp();  break;	
			};
			__interp_check_complete();
		}
		springs.spring_main.update();
	};
	
	#endregion
	#region Getters ////////
	
	static get_raw	  = function() {
		/// @func	get_raw()
		/// @return {any} value
		///
		return value;
	};
	static get		  = function() {
		/// @func	get()	
		/// @return {any} value
		///
		return get_raw() + get_spring();
	};
	static get_total  = get;
	static get_target = function() {
		/// @func	get_target()
		/// @return {any} target
		///
		return target + get_offset();
	};
	static get_offset = function() {
		/// @func	get_offset()
		/// @return {any} offset
		///
		return offset;
	};
	static get_spring = function() {
		/// @func	get_spring()
		/// @return {real} spring.val
		///
		return springs.spring_main.get();
	};
		
	#endregion
	#region Setters ////////
	
	static set_value  = function(_value) {
		/// @func	set_value(value)
		/// @param	{any} value
		///	@return {GProp} self
		///
		value  = _value + offset;
		target =  value;
		return self;
	};
	static set		  = set_value;
	static set_target = function(_target) {
		/// @func	set_target(target)
		/// @param	{real} target
		///	@return {GProp} self
		///
		target = _target;
		return self;
	};
	static set_offset = function(_offset) {
		/// @func	set_offset(offset)
		/// @param	{real} offset
		///	@return {GProp} self
		///	
		offset = _offset;
		return self;
	};
		
	static set_spring_tension   = function(_tension) {
		/// @func	set_spring_tensions(tension)
		/// @param	{real} tension
		/// @return {GProp} self
		///
		springs.tension = _tension;
		return self;
	};
	static set_spring_dampening = function(_dampening) {
		/// @func	set_spring_dampening(dampening)
		/// @param	{real} dampening
		/// @return {GProp} self
		///
		springs.dampening = _dampening;
		return self;
	};
	static set_spring_speed		= function(_speed) {
		/// @func	set_spring_speed(speed)
		/// @param	{real} speed
		/// @return {GProp} self
		///
		springs.speed = _speed;
		return self;
	};
	
	#endregion
	#region Other //////////
	
	static snap	  = function() {
		/// @func	snap()
		///	@return {GProp} self
		///
		value = get_target();
		return self;
	};
	static spring = function(_speed = springs.speed) { // <-- replace springs.speed with default value getter
		/// @func	spring()
		/// @return {GProp} self
		///
		springs.spring_main.fire(_speed);
		return self;	
	};
		
	#endregion
	
	#endregion
	#region Private ////////
	
	static __interp_update_const	= function() {
		/// @func __interp_update_const()
		///
		if (get() - value <= interp.speed) {
			value += interp.speed;
		}
		/// @TODO: add in smoothing?
	};
	static __interp_update_lerp		= function() {
		/// @func __interp_update_lerp()
		///
		value = lerp(value, get_target(), interp.speed);
	};
	static __interp_check_complete	= function() {
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
	static __interp_complete		= function() {
		/// @func __interp_complete()
		///
		with (interp.on_complete) {
			if (callback != undefined) {
				callback(data);	
			}
		}
		interp.complete = true;
		
		event_publish(__interp_get_event_name() + "_interp_completed", { id: other });
	};
	static __interp_get_event_name	= function() {
		/// @func __interp_get_event_name()
		///
		return __unique_id_get();
	};
	static __unique_id_get			= function() {
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
	
	if (!event_registered(__interp_get_event_name() + "_interp_completed")) {
		event_register(__interp_get_event_name() + "_interp_completed");	
	}
};	



