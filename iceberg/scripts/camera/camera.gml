/// @constant Lerp camera move mode (can be set using setMoveMode)
#macro cm_lerp 0

/// @constant Fixed amount camera move mode (can be set using setMoveMode)
#macro cm_fixed 1

/// @constant Smoothly damped camera move mode (can be set using setMoveMode)
#macro cm_damped 2

/// @function Camera(x, y, width, height)
/// @description Class resposible for executing camera tasks upon a given view.
/// @param {real} x Camera x coordinate (left border)
/// @param {real} y Camera y coordinate (top border)
/// @param {view[0-7]} [view=0] View to attach to camera to.
/// @param {boolean} [autoload=true] Should the camera use autoload?
function Camera(_x, _y, _view, _autoload) constructor {

	#region Params

	if (_view == undefined) _view = 0;
	if (_autoload == undefined) _autoload = true;

	#endregion

	#region Fields
	
	// These are private variables
	__tasks = {};
	__active = [];

	#endregion

	#region Properties

	// Get default initial size (same as view, zoom = 1)
	var _width = view_get_wport(_view);
	var _height = view_get_hport(_view);

	// These variables can be read (readonly) by the tasks
	id = camera_create_view(_x, _y, _width, _height);
	view = _view;
	
	// @property autoload
	// @note: By default there is no need to control the camera update logic it will
	// just work because it uses the 'camera_end_script' to execute its tasks.
	// However you can control the camera yourself by setting 'autoload' to false
	// (through the constructor or 'setAutoload' method) and using 'update' to
	// manually call task execution.
	// ATTENTION: When using camera tasks that require drawing to screen you need to
	// call the 'update' method inside a draw event.
	autoload = _autoload;

	view_enabled = true;
	view_visible[_view] = true;

	// These variables can be changed (read/write) by the tasks
	pos = [_x, _y];				// The position of the camera (left, top)
	size = [_width, _height];	// The pixel size of the camera (width, height)
	target = [0, 0];			// The position to move towards (center based)
	shift = [0, 0];				// The camera shifting amount
	zoomValue = 1;				// The amount of camera zoom (compared to the view)

	#endregion

	#region Private Methods

	static __fetchTask = function(_type) {
		var _task = __tasks[$ _type];
		if (_task != undefined) return _task;
		
		var _task = new _type();
		_task.type = _type;
		
		return _task;
	}

	static __registerTask = function(_task) {
		if (__tasks[$ _task.type] != undefined) return;
		
		__addTask(_task);
		
		variable_struct_set(__tasks, _task.type, _task);
		
		// Check if camera should load itself into the 'end script' function
		if (autoload) camera_set_end_script(id, update);
	}
	
	static __addTask = function(_task) {
		var _it = array_length(__active);
		
		if (_it == 0) {
			return array_push(__active, _task);
		}

		repeat(_it) {
			if (__active[--_it].priority >= _task.priority) {
				return array_insert(__active, _it + 1, _task);
			}
		}
		array_insert(__active, _it, _task);
	}

	#endregion

	#region Internal Methods

	update = function() {

		var _delta = delta_time * 0.001;
		
		// Cache variables (performance)
		var _pos = pos, _size = size, _target = target, _shift = shift;
		
		// Reset non-commulative temporary variables
		_shift[@ 0] = 0;
		_shift[@ 1] = 0;
		_target[@ 0] = 0;
		_target[@ 1] = 0;
	
		// Run camera tasks
		var _task, _it = array_length(__active);
		repeat(_it) {
			_task = __active[--_it];
			
			if (_task.remove || _task.run(self, _delta) == CameraTaskStatus.Finished) {
				array_delete(__active, _it, 1);
				variable_struct_remove(__tasks, _task.type);
			}
		}
		
		// Apply camera position with position shiftX/shiftY
		camera_set_view_pos(id, _pos[0] + _shift[0], _pos[1] + _shift[1]);
	}

	#endregion

	#region Public Methods

	/// @function follow(instance)
	/// @description Enables camera following mode.
	/// @param {object/instance} instance The instance to be followed
	/// @note To disable set 'instance' to 'noone'
	static follow = function(_instance) {
		var _task = __fetchTask(CameraFollowTask);
		
		_task.setup(_instance);
		__registerTask(_task);
	}
	
	/// @function focus(x, y)
	/// @description Enables camera focus mode.
	/// @param {real} x The x coordinate to focus on.
	/// @param {real} y The y coordinate to focus on.
	/// @note To disable set x/y to 'undefined'
	static focus = function(_x, _y) {
		var _task = __fetchTask(CameraFocusTask);
		
		_task.setup(_x, _y);
		__registerTask(_task);
	}

	/// @function limit(x1, y1, x2, y2)
	/// @description Limits the camera to the specified region.
	/// @param {real} x1 The left corner limit of the camera.
	/// @param {real} y1 The top corner limit of the camera.
	/// @param {real} x2 The right corner limit of the camera.
	/// @param {real} y2 The bottom corner limit of the camera.
	/// @note To disable provide NO parameters or set x1/y1/x2/y2 to 'undefined'
	static limit = function(_x1, _y1, _x2, _y2) {
		var _task = __fetchTask(CameraLimitTask);
		
		_task.setup(_x1, _y1, _x2, _y2);
		__registerTask(_task);
	}

	/// @function lock(horizontal, vertical)
	/// @description Locks the camera movement either vertically or horizontally.
	/// @param {boolean} horizontal Should the camera lock on the horizontal axis?
	/// @param {boolean} vertical Should the camera lock on the vertical axis?
	static lock = function(_horiz, _vert) {
		var _task = __fetchTask(CameraLockTask);
		
		_task.setup(_horiz ? target[0] + size[0]*.5 : undefined, _vert ? target[1] + size[1]*.5 : undefined);
		__registerTask(_task);
	}

	/// @function zoom(target, duration, [callback=undefined])
	/// @description Applies zoom transition over a certain amount of time.
	/// @param {real} target The target zoom value.
	/// @param {real} duration The duration of the transition (in seconds).
	/// @param {callable} [callback=undefined] Callback function to be executed when finished.
	static zoom = function(_target, _duration, _callback) {
		var _task = __fetchTask(CameraZoomTask);
		
		_task.setup(zoomValue, _target, _duration, _callback);
		__registerTask(_task);
	}

	/// @function shake(strength, duration, [callback=undefined])
	/// @description Applies a shake effect during a certain amount of time.
	/// @param {real} strength The strength of the camera shake.
	/// @param {real} duration The duration of the effect (in seconds).
	/// @param {callable} [callback=undefined] Callback function to be executed when finished.
	static shake = function(_strength, _duration, _callback) {
		var _task = __fetchTask(CameraShakeTask);
		
		_task.setup(_strength, _duration, _callback);
		__registerTask(_task);
	}
	
	/// @function flash(color, interval, duration, [callback=undefined])
	/// @description Applies a flash effect during a certain amount of time.
	/// @param {color} color The color of the flash.
	/// @param {real} interval The frame interval of each flash.
	/// @param {real} duration The duration of the effect (in seconds).
	/// @param {callable} [callback=undefined] Callback function to be executed when finished.
	static flash = function(_color, _interval, _duration, _callback) {
		var _task = __fetchTask(CameraFlashTask);
		
		_task.setup(_color, _interval, _duration, _callback);
		__registerTask(_task);
	}

	/// @function execute(taskType, argsArray)
	/// @description Executes a custom task with arguments.
	/// @param {constructor} taskType The constructor function of the camera task.
	/// @param {*[]} argsArray The arguments to pass to the setup function.
	static execute = function(_type, _argsArray) {
		var _task = __fetchTask(_type);
		
		// Extract method index 'script_execute_ext' does not accepts methods
		var _setup = method_get_index(_task.setup);
		with (_task) script_execute_ext(_setup, _argsArray);
		
		__registerTask(_task);
	}

	/// @function clearTasks()
	/// @description Clears all currently running tasks.
	/// @note Not safe to call from within the task execution loop.
	static clearTasks = function() {
		__tasks = {};
		__active = [];
	}

	#endregion

	#region Getters & Setters
	
	/// @function setMoveType(type, amount)
	/// @description Sets camera movement type using one of the cm_* constants.
	/// @param {cm_*} type The camera movement type to be used.
	/// @param {real} amount The amount of movement to be applied each step.
	/// @note There are 3 camera movement types:
	///		- cm_lerp: lerps the position towards the target position.
	///		- cm_fixed: moves towards the target position at a fixed pixel rate.
	///		- cm_damped: similar to lerp but uses a ease-in algorithm. 
	static setMoveType = function(_type, _amount) {
		switch(_type) {
			case cm_lerp:
				setModeLerp(_amount);
				break;
			case cm_fixed:
				setModeFixed(_amount);
				break;
			case cm_damped:
				setModeDamped(_amount);
				break;
		}
	}
	
	/// @function setModeDamped([amount=25])
	/// @description Sets camera to smoothly damped movement.
	/// @param {real} [amount=25] The amount of movement to be applied each step (higher == smooth)
	static setModeDamped = function(_amount) {
		
		static dampedFunc = function(_from, _to, _amount) {
			
			var _toX = _to[0], _toY = _to[1];
			
			var _changeX = _from[0] - _toX;
			var _changeY = _from[1] - _toY;
		
			var _outX = outVel[0], _outY = outVel[1];
			
			var _tempX = (_outX + omega * _changeX);
			var _tempY = (_outY + omega * _changeY);
		
			outVel[0] = (_outX - omega * _tempX) * fastExp;
			outVel[1] = (_outY - omega * _tempY) * fastExp;
			
			_from[@ 0] = _toX + (_changeX + _tempX) * fastExp;
			_from[@ 1] = _toY + (_changeY + _tempY) * fastExp;
		}
		
		if (_amount == undefined) _amount = 20;
		
		var _omega = 2 / _amount;
		var _fastExp = 1 / (1 + _omega + 0.48 * _omega * _omega + 0.235 * _omega * _omega * _omega);
		
		var _moveFunc = method({ omega: _omega, fastExp: _fastExp, outVel: [0, 0] }, dampedFunc);
		
		var _task = __fetchTask(CameraMoveTask);
		_task.setup(_moveFunc, _amount);
		
		__registerTask(_task);
	}

	/// @function setModeFixed([amount=15])
	/// @description Sets camera to fixed amount movement.
	/// @param {real} [amount=15] The amount of movement to be applied each step (higher == faster)
	static setModeFixed = function(_amount) {
		
		static fixedFunc = function(_from, _to, _amount) {
			
			if (point_distance(_from[0], _from[1], _to[0], _to[1]) < _amount) {
				_from[@ 0] = _to[0];
				_from[@ 1] = _to[1];
				return;
			}
			
			var _dir = point_direction(_from[0], _from[1], _to[0], _to[1]);
			
			_from[@ 0] += lengthdir_x(_amount, _dir);
			_from[@ 1] += lengthdir_y(_amount, _dir);
		}
		
		if (_amount == undefined) _amount = 15;
		
		var _task = __fetchTask(CameraMoveTask);
		_task.setup(fixedFunc, _amount);
		
		__registerTask(_task);
	}

	/// @function setModeLerp([amount=.2])
	/// @description Sets camera to lerp movement.
	/// @param {real} [amount=.2] The amount of movement to be applied each step (higher == faster)
	static setModeLerp = function(_amount) {
		
		static lerpFunc = function(_from, _to, _amount) {
			
			_from[@ 0] = lerp(_from[0], _to[0], _amount);
			_from[@ 1] = lerp(_from[1], _to[1], _amount);
		}
		
		if (_amount == undefined) _amount = .2;
		
		var _task = __fetchTask(CameraMoveTask);
		_task.setup(lerpFunc, _amount);
		
		__registerTask(_task);
	}

	/// @function setAutoload(enabled)
	/// @description Sets camera autoload property on/off.
	/// @param {boolean} enabled Should the autoload be enabled.
	/// @note Read autoload property above.
	static setAutoload = function(_enabled) {
		autoload = _enabled;
		
		// Remove '__update' from camera end script (if set)
		if (_enabled == false && camera_get_end_script(id) == __update) {
			camera_set_end_script(id, noone);
		}
	}

	/// @function setEnabled(enabled)
	/// @description Sets camera on/off.
	/// @param {boolean} enabled Should the camera be enabled.
	static setEnabled = function(_enabled) {
		view_visible[view] = _enabled;
		
		// If is being enabled enable views
		if (_enabled) view_enabled = true;
	}

	/// @function setView(view)
	/// @description Sets view the camera should use.
	/// @param {view[0-7]} view The view id.
	static setView = function(_view) {
		var _width = view_get_wport(_view);
		var _height = view_get_hport(_view);
		
		size = [_width, _height];
		zoomValue = 1;
		
		// Destroy old camera
		var _camera = view_get_camera(_view);
		if (_camera != -1) {
			camera_destroy(_camera);
		}
		
		view_set_camera(_view, id);
		camera_set_view_pos(id, pos[0], pos[1]);
	}

	#endregion

	#region Initialization
	
	setMoveType(cm_lerp, .2);
	setView(view);
	
	#endregion

}

