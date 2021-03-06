enum FLUID_INTERP_STRATEGY {
	NONE,
	CONST,
	LERP,	
};
#macro __FLUID_PROPERTY_ID_DELINEATOR "."

function FluidProperty(_data) constructor {
	/// @func	FluidProperty(data)
	/// @param	{struct} data
	/// @return {FluidProperty} self
	/// @desc	FluidProperty is a class abstraction for generalized property variables.
	///			The goal is to create an easy way to modulate property values and interpolate
	///			the current property value to a given target value, with additive springs, 
	///			offset values, and swappable interpolation strategies.
	///
	owner   = _data[$ "owner" ] ?? other;
	name    = _data[$ "name"  ] ?? undefined;
	value   = _data[$ "value" ] ?? 0.0;
	offset  = _data[$ "offset"] ?? 0.0;
	target  = _data[$ "target"] ?? value;
	interp  = {}; with (interp ) {
		type		= _data[$ "interp_type"		  ] ?? FLUID_INTERP_STRATEGY.LERP;
		speed		= _data[$ "interp_speed"	  ] ?? 0.1;
		threshold	= _data[$ "interp_threshold"  ] ?? 0.0;
		on_complete	= _data[$ "interp_on_complete"] ?? undefined;
		complete	=  false;
	};
	springs = {}; with (springs) {
		tension		= __SPRING_DEFAULT_TENSION;
		dampening	= __SPRING_DEFAULT_DAMPENING;
		speed		= __SPRING_DEFAULT_SPEED;
		spring_main	= new Spring(tension, dampening);
	};
	
	#region Public /////////
	
	#region Internal ///////
	
	static update = function() {
		/// @func	update()
		/// @return {FluidProperty} self
		///
		if (interp.type != FLUID_INTERP_STRATEGY.NONE) {
			switch (interp.type) {
				case FLUID_INTERP_STRATEGY.CONST: __interp_update_const(); break;
				case FLUID_INTERP_STRATEGY.LERP:  __interp_update_lerp();  break;	
			};
			__interp_check_complete();
		}
		springs.spring_main.update();
		return self;
	};
	
	#endregion
	#region Getters ////////
	
	static get_name				  = function() {};
	static get_raw				  = function() {
		/// @func	get_raw()
		/// @return {any} value
		///
		return value;
	};
	static get					  = function() {
		/// @func	get()	
		/// @return {any} value
		///
		return get_raw() + get_spring_value();
	};
	static get_total			  = get;
	static get_target			  = function() {
		/// @func	get_target()
		/// @return {any} target
		///
		return target + get_offset();
	};
	static get_offset			  = function() {
		/// @func	get_offset()
		/// @return {any} offset
		///
		return offset;
	};
	static get_interp_type		  = function() {};
	static get_interp_speed		  = function() {};
	static get_interp_threshold   = function() {};
	static get_interp_on_complete = function() {};
	static get_spring			  = function() {
		/// @func	get_spring()
		/// @return {real} spring.val
		///
		return springs.spring_main;
	};
	static get_spring_value		  = function() {
		/// @func	get_spring_value()
		/// @return {real} spring.val
		///
		return springs.spring_main.get();
	};
	static get_spring_tension	  = function() {};
	static get_spring_dampening	  = function() {};
	static get_spring_speed		  = function() {};
		
	#endregion
	#region Setters ////////
	
	static set_name				  = function(_name) {};
	static set_value			  = function(_value) {
		/// @func	set_value(value)
		/// @param	{any} value
		///	@return {FluidProperty} self
		///
		value  = _value + offset;
		target =  value;
		return self;
	};
	static set					  = set_value;
	static set_target			  = function(_target) {
		/// @func	set_target(target)
		/// @param	{real} target
		///	@return {FluidProperty} self
		///
		target = _target;
		return self;
	};
	static set_offset			  = function(_offset) {
		/// @func	set_offset(offset)
		/// @param	{real} offset
		///	@return {FluidProperty} self
		///	
		offset = _offset;
		return self;
	};
	static set_interp_type		  = function(_interp_type) {};
	static set_interp_speed		  = function(_interp_speed) {};
	static set_interp_threshold   = function(_interp_threshold) {};
	static set_interp_on_complete = function(_on_complete) {};
	static set_spring_tension     = function(_tension) {
		/// @func	set_spring_tensions(tension)
		/// @param	{real} tension
		/// @return {FluidProperty} self
		///
		springs.tension = _tension;
		return self;
	};
	static set_spring_dampening   = function(_dampening) {
		/// @func	set_spring_dampening(dampening)
		/// @param	{real} dampening
		/// @return {FluidProperty} self
		///
		springs.dampening = _dampening;
		return self;
	};
	static set_spring_speed		  = function(_speed) {
		/// @func	set_spring_speed(speed)
		/// @param	{real} speed
		/// @return {FluidProperty} self
		///
		springs.speed = _speed;
		return self;
	};
	
	#endregion
	#region Other //////////
	
	static snap	  = function() {
		/// @func	snap()
		///	@return {FluidProperty} self
		///
		value = get_target();
		return self;
	};
	static spring = function(_speed = springs.speed) { // <-- replace springs.speed with default value getter
		/// @func	spring()
		/// @return {FluidProperty} self
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
				callback();	
			}
		}
		interp.complete = true;
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
		return _prefix + __FLUID_PROPERTY_ID_DELINEATOR + "prop" + __FLUID_PROPERTY_ID_DELINEATOR + name + __FLUID_PROPERTY_ID_DELINEATOR;
	};
	
	#endregion
};	