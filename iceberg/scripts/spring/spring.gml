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

