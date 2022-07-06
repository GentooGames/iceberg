function ___user_settings() {
	/// @func ___user_settings()
	///
	global.___user_settings = {
		general: {
			language: "en-US",	
		},
		gameplay: {
			blood_level: 0.5,
		},
		audio: {
			master_volume:	0.6,
			music_volume:	1.0,
			sfx_volume:		1.0,
		},
		video: {
			screen_shake:	1.0,
			screen_flash:	1.0,
		},
		controls: {
			controller: {
				joystick: {
					deadzone:		0.25,
					sensitivity:	0.15,
					acceleration:	0.20,
					aim_assist:		true,
					invert_y_axis:  false,
				},
				rumble: 1.0,
			}
		},
		accessibility: {
			font: {
				dyslexic_mode:	false,
				scale:			1.0,
				alpha:			1.0,
			},
			ui: {
				scale:	1.0,	
				alpha:	1.0,
			},
			colorblind_mode: false,
		},
	};
	#macro USER_SETTINGS			global.___user_settings
	#macro LANGUAGE					USER_SETTINGS.general.language
	#macro BLOOD_LEVEL				USER_SETTINGS.gameplay.blood_level
	#macro VOLUME_MASTER			USER_SETTINGS.audio.master_volume
	#macro VOLUME_MUSIC				USER_SETTINGS.audio.music_volume
	#macro VOLUME_SFX				USER_SETTINGS.audio.sfx_volume
	#macro SCREEN_SHAKE				USER_SETTINGS.video.screen_shake
	#macro SCREEN_FLASH				USER_SETTINGS.video.screen_flash
	#macro JOYSTICK_DEADZONE		USER_SETTINGS.controls.controller.joystick.deadzone
	#macro JOYSTICK_SENSITIVITY		USER_SETTINGS.controls.controller.joystick.sensitivity
	#macro JOYSTICK_ACCELERATION	USER_SETTINGS.controls.controller.joystick.acceleration
	#macro JOYSTICK_AIM_ASSIST		USER_SETTINGS.controls.controller.joystick.aim_assist
	#macro JOYSTICK_INVERT_Y_AXIS	USER_SETTINGS.controls.controller.joystick.invert_y_axis
	#macro GAMEPAD_RUMBLE			USER_SETTINGS.controls.controller.rumble
	#macro FONT_DYSLEXIC_MODE		USER_SETTINGS.accessibility.font.dyslexic_mode
	#macro FONT_SCALE				USER_SETTINGS.accessibility.font.scale
	#macro FONT_ALPHA				USER_SETTINGS.accessibility.font.alpha
	#macro UI_SCALE					USER_SETTINGS.accessibility.ui.scale
	#macro UI_ALPHA					USER_SETTINGS.accessibility.ui.alpha
	#macro COLORBLINE_MODE			USER_SETTINGS.accessibility.colorblind_mode
};