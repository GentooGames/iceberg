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

