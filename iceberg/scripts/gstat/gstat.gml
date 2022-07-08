///////////////////////////////////
// .---. .---- .---. .---. .---. //
// |  -. L---.   |   r---j   |   //
// L---J ----J   |   |   |   |   //
////////////////////////////$(º)>//
#region docs, info & configs //////

#region about
/*
	written_by:__gentoo__________________
	version:_____0.1.0___________________
*/   
#endregion
#region change log

#region version 0.1.0
/*	
	Date: xx/xx/2022
	1. Released first version.
*/
#endregion

#endregion
#region docs & help
/*
	/// ...
*/
#endregion
#region upcoming features
/*
	/// ...
*/
#endregion
#region default config values
/*
	/// ...
*/
#endregion
#region enums

enum __STAT_MOD { 
	LINEAR, 
	SCALAR,
}

#endregion

#endregion

function GStat(_value, _decay) constructor {
	/// @func	GStat(value, decay)
	/// @param	{real}	value
	/// @param	{real}	decay
	/// @return {GStat} self
	///
	owner	 =  other;
	base	 = _value;
	decay	 = _decay;
	mods	 = {};
	mod_keys = [];
	n_mods	 = 0;
	override = undefined;
	
	static get			= function() {
		/// @func	get()
		/// @desc	...
		/// @return NA
		///
		if (get_override() != undefined) {
			return get_override();
		}
		return (get_base() - get_decay()) + get_mods_sum();
	};
	static get_base 	= function() {
		/// @func	get_base()
		/// @desc	...
		/// @return {real} base
		///
		return base;
	};
	static get_decay	= function() {
		/// @func	get_decay()
		/// @desc	...
		/// @return {real} decay
		///
		return decay;
	};
	static get_override = function() {
		/// @func	get_override()
		/// @desc	...
		/// @return {real} override
		///
		return override;	
	};
	static set_base 	= function(_amount) {
		/// @func   set_base(amount)
		/// @param  {real} amount
		/// @desc	...
		/// @return {GStat} self
		///
		base = _amount;
		return self;
	}
	static set_decay	= function(_amount) {
		/// @func	set_decay(amount)
		/// @param	{real} amount
		/// @desc	...
		/// @return {GStat} self
		///
		decay = _amount;
		return self;
	};
	static set_override = function(_amount) {
		/// @func	set_override(amount)
		/// @param	{real} amount
		/// @desc	...
		/// @return {GStat} self
		///
		override = _amount;
		return self;
	};
	static wipe_decay	= function() {
		/// @func	wipe_decay()
		/// @desc	...
		/// @return {GStat} self
		/// 
		decay = 0;
		return self;
	};
	
	// Mods
	static new_mod		  = function(_key, _type, _amount, _uses) {
		/// @func	new_mod(key, type, amount, uses)
		/// @param	{real/string} key
		/// @param	{__STAT_MOD} type
		/// @param	{real} amount
		/// @param	{real} uses
		/// @desc	...
		/// @return {struct} data
		///
		var _data = {
			key:    _key,
			type:   _type,
			amount: _amount, 
			uses:   _uses,
			/*
			uses: {
				turn: 2,
				attack: 0,
				move: 0,
			}
			*/
		};
		mods[$ _key] = _data;
		array_push(mod_keys, _key);
		n_mods++;
		return _data;
	};
	static new_mod_linaer = function() {
		/// @func	new_mod_linear(key, amount, uses)
		///	@param  {real/string} key
		///	@param  {real} amount 
		///	@param  {real} uses   
		/// @desc	...
		/// @return {real} mod
		///
		return new_mod(_key, __STAT_MOD.LINEAR, _amount, _uses);
	};
	static new_mod_scalar = function() {
		/// @func	new_mod_scalar(key, amount, uses)
		/// @param	{real/string} key
		/// @param	{real} amount
		/// @param	{real} uses  
		/// @desc	...
		/// @return {real} mod
		///
		return new_mod(_key, __STAT_MOD.SCALAR, _amount, _uses);
	};
	static get_mod_sum	  = function(_mod) {
		/// @func	get_mod_sum(mod)
		/// @param	{struct} mod
		/// @desc	...
		/// @return	{real} sum
		///
		switch (_mod.type) {
			case __STAT_MOD.LINEAR: {
				return _mod.amount;
			}
			case __STAT_MOD.SCALAR: {
				return _mod.amount * base;
			}
		}
	};
	static get_mods_sum   = function() {
		/// @func	get_mods_sum()
		/// @desc	...
		/// @return	{real} sum
		///
		var _sum = 0;
		for (var _i = n_mods - 1; _i >= 0; _i--) {
			var _key = mod_keys[_i];
			var _mod = mods[$ _key];
			_sum += get_mod_sum(_mod);	
		}
		return _sum;
	};
	static remove_mod	  = function(_key) {
		/// @func	remove_mod(key)
		/// @param	{real/string} key
		/// @desc	...
		/// @return {GStat} self
		///
		variable_struct_remove(mods, _key);
		array_find_delete(mod_keys, _key);
		n_mods--;
		return self;
	};
	
	// Tick
	static tick_turn			= function() {
		/// @func	tick_turn()
		/// @desc	...
		/// @return NA
		///
		tick_mod_uses_turn();	
	};
	static tick_attack			= function() {
		/// @func	tick_attack()
		/// @desc	...
		/// @return NA
		///
		tick_mod_uses_attack();
	};
	static tick_move			= function() {
		/// @func	tick_move()
		/// @desc	...
		/// @return NA
		///
		tick_mod_uses_move();
	};
	static tick_mod_uses_turn	= function() {
		/// @func	tick_mod_uses_turn()
		/// @desc	...
		/// @return NA
		///
		for (var _i = n_mods - 1; _i >= 0; _i--) {
			var _key  = mod_keys[_i];
			var _mod  = mods[$ _key];
			if (_mod == undefined) {
				array_delete(mod_keys, _i, 1);
				continue;
			}
			if (!variable_struct_exists(_mod.uses, "turn")) continue;
			//
			if (_mod.uses.turn != undefined && _mod.uses.turn > 0) {
				_mod.uses.turn--;
				if (_mod.uses.turn == 0) {
					remove_mod(_key);
				}
			}
		}
	};
	static tick_mod_uses_attack = function() {
		/// @func	tick_mod_uses_attack()
		/// @desc	...
		/// @return	NA
		///
		for (var _i = n_mods - 1; _i >= 0; _i--) {
			var _key  = mod_keys[_i];
			var _mod  = mods[$ _key];
			if (_mod == undefined) {
				array_delete(mod_keys, _i, 1);
				continue;
			}
			if (!variable_struct_exists(_mod.uses, "attack")) continue;
			//
			if (_mod.uses.attack != undefined && _mod.uses.attack > 0) {
				_mod.uses.attack--;
				if (_mod.uses.attack == 0) {
					remove_mod(_key);
				}
			}
		}
	};
	static tick_mod_uses_move	= function() {
		/// @func	tick_mod_uses_move()
		/// @desc	...
		/// @return NA
		///
		for (var _i = n_mods - 1; _i >= 0; _i--) {
			var _key  = mod_keys[_i];
			var _mod  = mods[$ _key];
			if (_mod == undefined) {
				array_delete(mod_keys, _i, 1);
				continue;
			}
			if (!variable_struct_exists(_mod.uses, "move")) continue;
			//
			if (_mod.uses.move != undefined && _mod.uses.move > 0) {
				_mod.uses.move--;
				if (_mod.uses.move == 0) {
					remove_mod(_key);
				}
			}
		}
	};
	
	static add		= function(_amount) {
		/// @func	add(amount)
		/// @param	{real} amount
		/// @desc	...
		/// @return NA
		///
		decay -= _amount;
	};
	static subtract = function(_amount) {
		/// @func	subtract(amount)
		/// @param	{real} amount
		/// @desc	...
		/// @return NA
		///
		decay += _amount;
	};
};
function GStatSpecial(_decay) : GStat(undefined, _decay) constructor {
	/// @func	GStatSpecial(decay)
	/// @param	{real} decay
	/// @desc	...
	/// @return {GStatSpecial} self
	///
	static get_mods_sum = function() {
		/// @func	get_mods_sum()
		/// @desc	...
		/// @return {real} sum
		///
		return 0;
	};
	static get			= function(_base) {
		/// @func	get(base)
		/// @param	{real} base
		/// @desc	...
		/// @return {real} stat_value
		///
		if (get_override() != undefined) {
			return get_override();
		}
		return (_base - get_decay()) + get_mods_sum();
	};
};
function GStatNoDecay(_value) : GStat(_value, undefined) constructor {
	/// @func	GStatNoDecay(value)
	/// @param	{real} value
	/// @desc	...
	/// @return {GStatNoDecay} self
	///
	static get_mods_sum = function() {
		/// @func	get_mods_sum()
		/// @desc	...
		/// @return {real} sum
		///
		return 0;
	};
	static get			= function(_base) {
		/// @func	get(base)
		/// @param	{real} base
		/// @desc	...
		/// @return {real} stat_value
		///
		if (get_override() != undefined) {
			return get_override();
		}
		return get_base() + get_mods_sum();
	};
};

