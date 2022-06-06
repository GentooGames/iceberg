#region Base Tasks (Abstract)

/// @function CameraTask(priority)
/// @description This is an abstract base class for all camera tasks
/// @note This should never instantiated only inherited.
function CameraTask(_priority) constructor {
	
	enum CameraTaskStatus {
		Finished,
		Running
	}
	
	enum CameraTaskKind {
		PreMovement,
		PostMovement
	}
	
	priority = _priority
	remove = false;
	type = CameraTask;
	
	/// @function run(camera)
	/// @description This function runs the camera task.
	/// @param {Camera} camera The instance of the camera running the task.
	/// @param {real} delta The delta time since last frame (milliseconds).
	/// @note Needs to be implemented in inherited classes.
	static run = function(_camera, _delta) {}
	
	/// @function setup(*)
	/// @description This function replaces the CameraTask constructor initialization.
	/// @param {*} params The task parameters
	/// @note Needs to be implemented in inherited classes.
	static setup = function() {}
	
}

/// @function CameraTimedTask()
/// @description This is an abstract base class for all timed camera tasks
/// @note This should never instantiated only inherited.
function CameraTimedTask(_priority) : CameraTask(_priority) constructor {
	
	duration = 0;
		
	currentTime = 0;
	endTime = 0;
	
	callback = undefined;
	
	static run = function(_camera, _delta) {
		currentTime += _delta;
	}

	static setup = function(_duration, _callback) {
		if (_duration == undefined) _duration = 0;
		
		duration = max(math_get_epsilon(), _duration * 1000);
		startTime = current_time;
		currentTime = startTime;
		endTime = currentTime + duration;
		
		callback = _callback;
	}

	/// @function getProgress()
	/// @description Returns the progress [0-1] fo the current timed task.
	static getProgress = function() {
		return min(abs(currentTime - startTime) / duration, 1);
	}
	
	/// @function hasFinished()
	/// @description Returns whether or not the task has finished.
	static hasFinished = function() {
		return currentTime > endTime;
	}

}

#endregion
#region Builtin Tasks

/// @function CameraFollowTask()
/// @description This task will force the camera follow an instance.
/// @note Should not be used directly (use Camera class instead).
function CameraFollowTask() : CameraTask(10) constructor {
	
	instance = noone;

	static run = function(_camera, _delta) {

		// Compute the average target point of all instances
		var _totalX = 0, _totalY = 0, _count = instance_number(instance)
		with (instance) {
			_totalX += x;
			_totalY += y;
		}
		
		// Set the target point of the camera
		var _target = _camera.target;
		_target[@ 0] = _totalX / _count;
		_target[@ 1] = _totalY / _count;
		
		// This task is always running (must be manually canceled)
		return CameraTaskStatus.Running;
	}
		
	static setup = function(_instance) {
		instance = _instance;
		
		remove = _instance == noone;
	}	

}

/// @function CameraFocusTask()
/// @description This task will make the camera focus on a coordinate.
/// @note Should not be used directly (use Camera class instead).
function CameraFocusTask() : CameraTask(20) constructor {

	targetX = 0;
	targetY = 0;

	static run = function(_camera, _delta) {

		// If we reach the target point then this task is over (finished)
		//if (point_direction(_camera.x, _camera.y, targetX, targetY) < 0.001)
		//	return CameraTaskStatus.Finished;

		// Set the target point of the camera
		var _target = _camera.target;
		_target[@ 0] = targetX;
		_target[@ 1] = targetY;
		
		// Return as running
		return CameraTaskStatus.Running;
	}
		
	static setup = function(_x, _y) {
		targetX = _x;
		targetY = _y;
		
		remove = _x == undefined || _y == undefined;
	}
		
}

/// @function CameraLockTask()
/// @description This task will lock the camera to a given axis coordinate.
/// @note Should not be used directly (use Camera class instead).
function CameraLockTask() : CameraTask(30) constructor {

	lockX = undefined;
	lockY = undefined;

	static run = function(_camera, _delta) {

		// Lock the camera to the position
		var _target = _camera.target;
		if (lockX != undefined) _target[@ 0] = lockX;
		if (lockY != undefined) _target[@ 1] = lockY;

		// This task is always running (must be manually canceled)
		return CameraTaskStatus.Running;
		
	}
		
	static setup = function(_x, _y) {
		lockX = _x;
		lockY = _y;
		
		remove = _x == undefined && _y == undefined;
	}	
	
}

/// @function CameraMoveTask()
/// @description This task is resposible for moving the camera towards the target position.
/// @note This tasks is automatically added to the camera tasks upon creation.
function CameraMoveTask() : CameraTask(40) constructor {

	moveFunc = undefined
	amount = 0;

	static run = function(_camera, _delta) {

		// Move to targetX/targetY point
		var _target = _camera.target, _size = _camera.size;
		
		_target[@ 0] -= _size[0] * .5;
		_target[@ 1] -= _size[1] * .5;
		
		moveFunc(_camera.pos, _target, amount);

		// This task is always running (must be manually canceled)
		return CameraTaskStatus.Running;
	}
		
	static setup = function(_func, _amount) {
		moveFunc = _func;
		amount = _amount;
	}	
	
}

/// @function CameraZoomTask()
/// @description This task will zoom the camera to a specific amount.
/// @note Should not be used directly (use Camera class instead).
function CameraZoomTask() : CameraTimedTask(50) constructor {
	
	startZoom = 1;
	targetZoom = 1;
	
	diffZoom = 1;

	static run_CameraTimedTask = run;
	static run = function(_camera, _delta) {
		
		// Call base run method (timed task)
		run_CameraTimedTask(_camera, _delta);
		
		var _zoom = startZoom + getProgress() * diffZoom;
		
		// Zoom is inversly applied (bigger zoom -> less size)
		var _view = _camera.view;
		var _camW = view_wport[_view] / _zoom;
		var _camH = view_hport[_view] / _zoom;
		
		var _pos = _camera.pos, _size = _camera.size;
		
		// The camera shift needs to be instant
		_pos[@ 0] -= (_camW - _size[0]) * .5;
		_pos[@ 1] -= (_camH - _size[1]) * .5;
		
		// Apply changes to camera variables
		_size[@ 0] = _camW;
		_size[@ 1] = _camH;
		
		_camera.zoomValue = _zoom;
		
		// Apply changes to camera size
		camera_set_view_size(_camera.id, _camW, _camH);
		
		// If task has finished execute callback
		if (hasFinished()) {
			if (callback != undefined) callback();
			return CameraTaskStatus.Finished;
		}
		
		// This task is still running
		return CameraTaskStatus.Running;
		
	}
	
	static setup_CameraTimedTask = setup;
	static setup = function(_start, _target, _duration, _callback) {
		
		setup_CameraTimedTask(_duration, _callback);
		
		startZoom = _start;
		targetZoom = _target;
		
		diffZoom = _target - _start;
		
		remove = _start == _target;
	}	

}

/// @function CameraLimitTask()
/// @description This task will restrict the camera to a given region.
/// @note Should not be used directly (use Camera class instead).
function CameraLimitTask() : CameraTask(60) constructor {

	limitX1 = undefined;
	limitY1 = undefined;
	limitX2 = undefined;
	limitY2 = undefined;

	static run = function(_camera, _delta) {
		
		// Cache variables
		var _size = _camera.size, _pos = _camera.pos;
		
		_pos[@ 0] = clamp(_pos[0], limitX1, limitX2 - _size[0]);
		_pos[@ 1] = clamp(_pos[1], limitY1, limitY2 - _size[1]);

		// This task is always running (must be manually canceled)
		return CameraTaskStatus.Running;
		
	}
		
	static setup = function(_x1, _y1, _x2, _y2) {
		
		if (_x1 == undefined) _x1 = -infinity;
		if (_y1 == undefined) _y1 = -infinity;
		if (_x2 == undefined) _x2 = infinity;
		if (_y2 == undefined) _y2 = infinity;
		
		limitX1 = _x1;
		limitY1 = _y1;
		limitX2 = _x2;
		limitY2 = _y2;
		
		remove = _x1 == -infinity && _y1 == -infinity && _x2 == infinity && _y2 == infinity;
	}	
	
}

/// @function CameraShakeTask()
/// @description This task will shake the camera by a specific amount.
/// @note Should not be used directly (use Camera class instead).
function CameraShakeTask() : CameraTimedTask(70) constructor {
	
	strength = 0;

	static run_CameraTimedTask = run;
	static run = function(_camera, _delta) {
		
		// Call base run method (timed task)
		run_CameraTimedTask(_camera, _delta);
		
		// Compute shake random offset
		var _shakeX = irandom_range(-strength, strength);
		var _shakeY = irandom_range(-strength, strength);

		var _shift = _camera.shift;

		// Adjust the current position of the camera
		_shift[@ 0] = _shakeX; 
		_shift[@ 1] = _shakeY;

		// If task has finished execute callback
		if (hasFinished()) {
			if (callback != undefined) callback();
			return CameraTaskStatus.Finished;
		}

		// This task is still running
		return CameraTaskStatus.Running;
		
	}
	
	static setup_CameraTimedTask = setup;
	static setup = function(_strength, _duration, _callback) {
	
		setup_CameraTimedTask(_duration, _callback);
	
		strength = _strength;
		
		remove = !_strength;
	}	

}

/// @function CameraFlashTask()
/// @description This task will flash the camera using a given color.
/// @note Should not be used directly (use Camera class instead).
function CameraFlashTask() : CameraTimedTask(80) constructor {
	
	color = undefined;
	
	counter = 0;
	interval = 0;
	halfInterval = 0;
	
	static run_CameraTimedTask = run;
	static run = function(_camera, _delta) {
		
		// Call base run method (timed task)
		run_CameraTimedTask(_camera, _delta);
		
		// Increase counter and check against half interval
		if (counter++ % interval < halfInterval) {
			
			var _pos = _camera.pos;
			var _size = _camera.size;
			
			var _x = _pos[0], _y = _pos[1], _color = color;
			
			// Draw overlay rectangle
			draw_rectangle_color(_x, _y, _x + _size[0], _y + _size[1], _color, _color, _color, _color, false);
		}

		// If task has finished execute callback
		if (hasFinished()) {
			if (callback != undefined) callback();
			return CameraTaskStatus.Finished;
		}

		// This task is still running
		return CameraTaskStatus.Running;
		
	}
	
	static setup_CameraTimedTask = setup;
	static setup = function(_color, _interval, _duration) {
		
		setup_CameraTimedTask(_duration);
		
		color = _color;
		interval = _interval;
		
		halfInterval = _interval * .5;
		
		remove = !_color || !_interval;
	}	

}

#endregion

