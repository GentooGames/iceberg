/// @func Shaker() constructor
function Shaker() constructor {
	/// @desc	...
	/// @return self -> {struct}
	///
	val	 = 0;
	size = 0;
	damp = 1;
	time = 0;
	mode = "time";
	
	static shake_damp   = function(_size, _damp = 1) {
		/// @func	shake_damp(size, damp*<1>)
		/// @param	size -> {real}
		/// @param	damp -> {real}*<1>
		/// @desc	...
		/// @return NA
		///
		size = _size;
		val	 = _size;
		damp = _damp;
		mode = "damp";
	};
	static shake_time   = function(_size, _time = 8) {
		/// @func	shake_time(size, time*<8>)
		/// @param	size -> {real}
		/// @param	time -> {real}*<8>
		/// @desc	...
		/// @return NA
		///
		size = _size;
		time = _time;
		mode = "time";
	};
	static update	    = function() {
		/// @func	update()
		/// @desc	...
		/// @return NA
		///
		switch (mode) {
			case "time": _update_time(); break;
			default:	 _update_damp(); break;
		}
	};
	
	/// _private 
	static _update_time = function() {
		/// @func	_update_time()
		/// @desc	...
		/// @return NA
		///
		val = (time--) ? random_range(-size, size) : 0;
	};
	static _update_damp = function() {
		/// @func	_update_damp()
		/// @desc	...
		/// @return NA
		///
		size = max(size - damp, 0);
		val  = random_range(-size, size);
	};
};

#macro __SPRING_DEFAULT_TENSION	  0.15
#macro __SPRING_DEFAULT_DAMPENING 0.15
#macro __SPRING_DEFAULT_SPEED	  5

/// @func Spring(tension, damp, spd*<0>, cutoff*<0.001>) constructor
function Spring(_tension, _dampening, _spd = 0, _cutoff = 0.001) constructor {
	/// @param	tension	  -> {real}	
	/// @param	dampening -> {real}	
	/// @param	speed	  -> {real}*<0>
	/// @param	cutoff    -> {real}*<0.001>	
	/// @desc	...
	/// @return self -> {Spring}
	///
	tension	  = _tension;
	dampening = _dampening;
	spd		  = 0;
	val		  = 0;
	target	  = 0;
	cutoff	  = _cutoff;
	ended	  = false;
	
	static fire	  = function(_spd, _tens = tension, _damp = dampening) {
		/// @func	fire(spd)
		/// @param	spd       -> {real}
		/// @param	tension	  -> {real}*<current>
		/// @param	dampening -> {real}*<current>
		/// @desc	...
		/// @return NA
		///
		spd		  = _spd;
		tension	  = _tens;
		dampening = _damp;
	};
	static update = function() {
		/// @func	update()
		/// @desc	...
		/// @return NA
		///
		_process();
		_apply_cutoff();
		_end();
	};
	static get	  = function() {
		/// @func	get()
		/// @return {real} val
		///
		return val;	
	};
	
	/// _private
	static _process			= function() {
		/// @func	_process()
		/// @desc	...
		/// @return NA
		///
		spd	+= (tension * (target - val)) - (dampening * spd);
		val	+= spd;
	};
	static _apply_cutoff	= function() {
		/// @func	_apply_cutoff()
		/// @desc	...
		/// @return NA
		///
		if (abs(val) <= cutoff) {
			val = 0;
		}
	};
	static _end 			= function() {
		/// @func	_end()
		/// @desc	...
		/// @return NA
		///
		ended = (val == 0);
	};
};
