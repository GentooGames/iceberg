/// @function Vector2(x, y)
/// @description Constructs a vector with the given individual elements.
/// @param {real} [x=0] The X component.
/// @param {real} [y=0] The Y component.
function Vector2(_x, _y) constructor {
	
	if (_x == undefined) _x = 0;
	if (_y == undefined) _y = 0;
	
	x = _x;
	y = _y;
	
	/// @function length()
	/// @description Returns the length of the vector2.
	/// @returns {real}
	static length = function() {
		return point_distance(0, 0, x, y);
	}
	
	/// @function lengthSquared()
	/// @description Returns the squared length of the vector2.
	/// @returns {real}
	static lengthSquared = function() {
		return x * x + y * y;
	}

	/// @function withMagnitude(magnitude)
	/// @description Returns a new vector with the given magnitude.
	/// @params {real} magnitude The magnitude of the new vector.
	/// @returns {Vector2}
	static withMagnitude = function(_magitude) {
		var _dir = point_direction(0, 0, x, y);
		var _x = lengthdir_x(_magitude, _dir);
		var _y = lengthdir_y(_magitude, _dir);
		
		return new Vector2(_x, _y);
	}

	/// @function normalize()
	/// @description Returns a new normalized vector.
	/// @returns {Vector2}
	static normalize = function() {

		var _dir = point_direction(0, 0, x, y);
		var _x = lengthdir_x(1, _dir);
		var _y = lengthdir_y(1, _dir);
		
		return new Vector2(_x, _y);
	}

	/// @function reflect(normal)
	/// @description Returns a new reflected vector given a normal vector.
	/// @params {Vector2} normal The normal vector.
	/// @returns {Vector2}
	static reflect = function(_normal) {
		var _dot = dot_product(x, y, _normal.x, _normal.y);
		var _factor = 2.0 * _dot;
        return new Vector2(x - _factor * _normal.x, y - _factor * _normal.y);
	}
	
	/// @function limit(min, max)
	/// @description Returns a new vector limited by a min/max values.
	/// @params {Vector2} minimum The minimum vector size.
	/// @params {Vector2} minimum The maximum vector size.
	/// @returns {Vector2}
	static limit = function(_min, _max) {
		var _x = clamp(x, _min.x, _max.x);
		var _y = clamp(y, _min.y, _max.y);
		return new Vector2(_x, _y);
	}
	
	/// @function interpolate(dest, amount)
	/// @description Returns a new vector interpolated towards a destination by a given amount.
	/// @params {Vector2} dest The destination vector.
	/// @params {real} amount The amount to lerp by.
	/// @returns {Vector2}
	static interpolate = function(_dest, _amount) {
		var _x = lerp(x, _dest.x, _amount);
		var _y = lerp(y, _dest.y, _amount);
		return new Vector2(_x, _y);
	}

	/// @function add(vect)
	/// @description Returns a new vector with the sum of the given vector.
	/// @params {Vector2} vect The vector to be added.
	/// @returns {Vector2}
	static add = function(_vect) {
		var _x = x + _vect.x;
		var _y = y + _vect.y;
		return Vector2(_x, _y);
	}
	
	/// @function subtract(vect)
	/// @description Returns a new vector with the subtraction by the given vector.
	/// @params {Vector2} vect The vector to be subtracted.
	/// @returns {Vector2}
	static subtract = function(_vect) {
		var _x = x - _vect.x;
		var _y = y - _vect.y;
		return Vector2(_x, _y);
	}

	/// @function multiply(vect)
	/// @description Returns a new vector with the multiplication by the given vector.
	/// @params {Vector2} vect The vector to muliply by.
	/// @returns {Vector2}
	static multiply = function(_vect) {
		var _x = x * _vect.x;
		var _y = y * _vect.y;
		return Vector2(_x, _y);
	}

	/// @function multiplyBy(amount)
	/// @description Returns a new vector with the multiplication by the given amount.
	/// @params {real} amount The amount to muliply by.
	/// @returns {Vector2}
	static multiplyBy = function(_amount) {
		var _x = x * _amount;
		var _y = y * _amount;
		return Vector2(_x, _y);
	}

	/// @function divide(vect)
	/// @description Returns a new vector with the division by the given vector.
	/// @params {Vector2} vect The vector to divide by.
	/// @returns {Vector2}
	static divide = function(_vect) {
		var _x = x / _vect.x;
		var _y = y / _vect.y;
		return Vector2(_x, _y);
	}
	
	/// @function divideBy(amount)
	/// @description Returns a new vector with the disivion by the given amount.
	/// @params {real} amount The amount to divide by.
	/// @returns {Vector2}
	static divideBy = function(_value) {
		var _x = x / _value;
		var _y = y / _value;
		return Vector2(_x, _y);
	}
	
	/// @function negate()
	/// @description Returns a new vector with a negated vector.
	/// @returns {Vector2}
	static negate = function() {
		return Vector2(-x, -y);
	}
	
	/// @function equals()
	/// @description Checks vector equality.
	/// @params {Vector2} vect The vector to check equality.
	/// @returns {boolean}
	static equals = function(_vect) {
		return x == _vect.x && y == _vect.y;
	}

	/// @function copyToArray(array, index)
	/// @description Copies the contents of the vector into the given array, starting from the given index.
	/// @param {array=[]} array The destination array.
	/// @param {index=0} index The index to write to (array will be expanded if needed).
	/// @returns The destination array.
	static copyToArray = function(_array, _index) {
		
		if (_index == undefined) _index = 0;
		
		_array[@ _index] = x;
		_array[@ _index + 1] = y;
	}


}

#macro Vector2Utils global.g_Vector2Utils
global.g_Vector2Utils = {
	
	/// @function Vector2Utils.dot(vect1, vect2)
	/// @description Returns the dot product of two vectors.
	/// @param {Vector2} vect1 The first vector.
	/// @param {Vector2} vect2 The second vector.
	/// @returns {real}
	dot : function(_vect1, _vect2) {
		return dot_product(_vect1.x, _vect1.y, _vect2.x, _vect2.y);
	},

	/// @function Vector2Utils.distance(vect1, vect2)
	/// @description Returns the Euclidean distance between the two given points.
	/// @param {Vector2} vect1 The first point.
	/// @param {Vector2} vect2 The second point.
	/// @returns {real}
	distance : function(_vect1, _vect2) {
		return point_distance(_vect1.x, _vect1.y, _vect2.x, _vect2.y);
	},

	/// @function Vector2Utils.distanceSquared(vect1, vect2)
	/// @description Returns the Euclidean distance squared between the two given points.
	/// @param {Vector2} vect1 The first point.
	/// @param {Vector2} vect2 The second point.
	/// @returns {real}
	distanceSquared : function(_vect1, _vect2) {
		var _dx = _vect1.x - _vect2.x;
        var _dy = _vect1.y - _vect2.y;
		
		return _dx * _dx + _dy * _dy;
	},
	
	/// @function Vector2Utils.withMagnitude(vect, magnitude)
	/// @description Sets vector magnitude (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	/// @param {real} magnitude The magnitude of the output vector2.
	withMagnitude : function(_vect, _mag) {		
		var _dir = point_direction(0, 0, _vect.x, _vect.y);
		_vect.x = lengthdir_x(_mag, _dir)
		_vect.y = lengthdir_y(_mag, _dir)
	},
	
	/// @function Vector2Utils.normalize(vect)
	/// @description Normalizes vector (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	normalize : function(_vect) {		
		var _dir = point_direction(0, 0, _vect.x, _vect.y);
		_vect.x = lengthdir_x(1, _dir);
		_vect.y = lengthdir_y(1, _dir);
	},
	
	/// @function Vector2Utils.reflect(vect, normal)
	/// @description Reflects vector given a normal (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	/// @param {Vector2} normal The normal vector.
	reflect : function(_vect, _normal) {
		var _dot = dot_product(_vect.x, _vect.y, _normal.x, _normal.y);
		var _factor = 2.0 * _dot;
		_vect.x = _vect.x - _factor * _normal.x;
		_vect.y = _vect.y - _factor * _normal.y;
	},
	
	/// @function Vector2Utils.limit(vect, min, max)
	/// @description Limits vector given a min/max (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	/// @param {Vector2} min The minimum vector.
	/// @param {Vector2} max The maximum vector.
	limit : function(_vect, _min, _max) {	
		_vect.x = clamp(_vect.x, _min.x, _max.x);
		_vect.y = clamp(_vect.y, _min.y, _max.y);
	},
	
	/// @function Vector2Utils.interpolate(vect, min, max)
	/// @description Interpolates vector towards destination (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	/// @param {Vector2} min The minimum vector.
	/// @param {Vector2} max The maximum vector.
	interpolate : function(_vect, _dest, _amount) {
		_vect.x = lerp(_vect.x, _dest.x, _amount);
		_vect.y = lerp(_vect.y, _dest.y, _amount);
	},

	/// @function Vector2Utils.add(vect, toAdd)
	/// @description Adds vector to an input vector (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	/// @param {Vector2} toAdd The vector to be added.
	add : function(_vect, _toAdd) {
		_vect.x += _toAdd.x;
		_vect.y += _toAdd.y;
	},
	
	/// @function Vector2Utils.subtract(vect, toSubtract)
	/// @description Subtracts vector from an input vector (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	/// @param {Vector2} toSubtract The vector to be subtracted.
	subtract : function(_vect, _toSubtract) {
		_vect.x -= _toSubtract.x;
		_vect.y -= _toSubtract.y;
	},
	
	/// @function Vector2Utils.multiply(vect, toMultiply)
	/// @description Multiplies vector by a given vector (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	/// @param {Vector2} toMultiply The vector to be multiplied.
	multiply : function(_vect, _toMultiply) {
		_vect.x *= _toMultiply.x;
		_vect.y *= _toMultiply.y;
	},
	
	/// @function Vector2Utils.multiplyBy(vect, amount)
	/// @description Multiplies vector by a given amount (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	/// @param {Vector2} amount The amount to be multiplied by.
	multiplyBy : function(_vect, _amount) {
		_vect.x *= _amount;
		_vect.y *= _amount;
	},
	
	/// @function Vector2Utils.divide(vect, toDivide)
	/// @description Divides vector by a given vector (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	/// @param {Vector2} toDivide The amount to be divided by.
	divide : function(_vect, _toDivide) {
		_vect.x /= _toDivide.x;
		_vect.y /= _toDivide.y;
	},
	
	/// @function Vector2Utils.divideBy(vect, amount)
	/// @description Divides vector by a given amount (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	/// @param {Vector2} amount The amount to be divided by.
	divideBy : function(_vect, _amount) {
		_vect.x /= _amount;
		_vect.y /= _amount;
	},
	
	/// @function Vector2Utils.negate(vect)
	/// @description Negates given vector (mutates vector).
	/// @param {Vector2} vect The Vector2 to be edited.
	negate : function(_vect) {
		_vect.x *= -1;
		_vect.y *= -1;
	}
	
}

