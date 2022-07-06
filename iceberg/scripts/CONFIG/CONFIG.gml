function ___config() {
	/// @func ___config()
	///
	global.___config = {
		meta: {
			version: "0.00",	
		},
		game: {
			admin: {
				unlock_all: false,
			},
		},
		color: {
			black:			#000000,
			white:			#dff6f5,
			yellow:			#f4b41b,
			orange:			#f47e1b,
			red:			#f4b41b,
			red_dark:		#a93b3b,
			green_lime:		#b6d53c,
			green:			#71aa34,
			green_mid:		#397b44,
			green_dark:		#3c5956,
			gray_light:		#cfc6b8,
			gray:			#a0938e,
			gray_mid:		#7d7071,
			gray_dark:		#5a5353,
			gray_purple:	#302c2e,
			blue_aqua:		#8aebf1,
			blue_teal:		#28ccdf,
			blue:			#3978a8,
			blue_dark:		#394778,
			blue_gray:		#4f546b,
			purple_pink:	#8e478c,
			purple: 		#564064,
			purple_dark:	#39314b,
			lavender:		#827094,
			pink:			#ffaeb6,
			pink_light:		#ffaeb6,
			sand:			#f4cca1,
			sand_dark:		#eea160,
			brown_orange:	#bf7958,
			brown:			#a05b53,
			brown_mid:		#7a444a,
			brown_dark:		#5e3643,
			brown_purple:	#472d3c,
		},
		world: {},
	    entity: {},
	};
	#region Macros /////////
	
	#macro CONFIG global.___config
	
	#endregion
};
function color_get_random() {
	/// @func	color_get_random()
	/// @return {color} color
	///
	var _struct = CONFIG.color;
	var _colors	= variable_struct_get_names(_struct);
	var _index	= irandom(array_length(_colors) - 1);
	return _struct[$ _colors[_index]];
};

