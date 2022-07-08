/// @desc obj_camera
log("<INSTANCE> created " + string(object_get_name(object_index)) + ": " + string(self.id));
global._camera = self;
//#macro CAMERA global._camera
events_user(CALLBACKS, EVENTS, METHODS);
//////////////////////////////////////////
// .---. .---. .    . .---- .---. .---. //
// |     r---j | V  | r--   r---J r---J //
// L---' |   | |    | .---- |  \  |   | //
//////////////////////////////////////////

cam	    = camera_create();
viewmat = undefined;
projmat = undefined;
preset  = {
    zoom: {
        intro: 1.0,
        base:  0.3,
        focus: 0.2,
        min:   0.0,
        max:   1.0,
        speed: {
            base:   0.15,
            battle: 0.05,
        },
    },
    move: {
        speed: {
            base: 0.1,  
        },
    },
};

// Dimensions
width   = GUI.width_base; 
height  = GUI.height_base;
left    = undefined; // set in _update_edges()
right   = undefined; // set in _update_edges()
top     = undefined; // set in _update_edges()
bottom  = undefined; // set in _update_edges()

// Move & Positions
x_to         = 0;
y_to         = 0;
focus_target = undefined;
focus_point  = undefined;
move_speed   = preset.move.speed.base;

// Zoom
zoom		  = preset.zoom.base;
zoom_to		  = zoom;
zoom_speed	  = preset.zoom.speed.base;
zoom_complete = false;

// Shake
shakers		= {
	rand:	{
		x: new Shaker(),
		y: new Shaker(),
	},
	spring: {
		x:		new Spring(0.15, 0.25),
		y:		new Spring(0.15, 0.25),
		zoom:	new Spring(0.10, 0.20),
	}
}

// Panning
panning	    = false;
pan_start_x = undefined
pan_start_y = undefined
middle_mouse_down		= false;
middle_mouse_pressed	= false;
middle_mouse_released	= false;
middle_mouse_wheel_down = false;
middle_mouse_wheel_up	= false;

// iota
pos_x	  = x;		// interpolate pos
pos_y	  = y;		// interpolate pos
zoom_draw = zoom;	// interpolate zoom
CLOCK_STABLE.add_cycle_method(function() {
	_update_pos();
	_update_zoom();
	_update_shakes(); 
});
CLOCK_STABLE.variable_interpolate("pos_x",	   "iota_pos_x");
CLOCK_STABLE.variable_interpolate("pos_y",	   "iota_pos_y");
CLOCK_STABLE.variable_interpolate("zoom_draw", "iota_zoom" );

// events
EventObject("camera");
event_register([
	"zoom_completed",
]);

