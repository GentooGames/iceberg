
[ASSET] xCamera
[AUTHOR] xDGameStudios
[VERSION] v1.0


[NOTES]
THe demo project serves as an example for the Camera system meaning that code for
movement and collisions should not be taken as a robust approach.


[SETUP]
In order to use the camera system first you need to setup the view/camera as normal in the IDE using
the room settings. After that you just need to call the camera constructor with the given view and that's it.


	[EXAMPLE]
		camera = new Camera(0, 0, 0, false);	 // This will prevent the autoload from executing
				
		camera.follow(oPlayer)					 // This will make the camera follow the player.
		camera.limit(0,0,room_width,room_height) // This will limit the camera movement to the room.

	This can be done inside a persistent managing object (objGame) to avoid creating multiple
	cameras (which can leading to memory leaks).


[USAGE]
This is a task/priority based camera system that uses two main classes (constructor functions)
Camera and CameraTask. A Camera has an array of takes that get executed upon its update process.

The CameraTasks are priority based meaning that a task with a higher priority will overwrite a task
with a lower priority. Below are the default (included) tasks sorted by ascending priority
(priority values are inside parenthesis)

		- follow (10): follows an instance or object type
		- focus (20): focus on a point
		- lock (30): locks movement for given axis
		- move (40): --- THIS MOVES THE CAMERA --- internal task (automatically managed)
		- zoom (50): zooms the camera by x amount compared to the view size (*)
		- limit (60): limits the camera placement to a region
		- shake (70): shakes the camera (*)
		- flash (80): creates a flash (*)
			
	(*) This tasks are special tasks the inherit from CameraTimedTask which means they will occur over a
	X amount of time (in seconds). After that time the task is automatically removed from the task stack.
	Theses tasks can also be given a callback to be executed when they reach the end.
			
	[EXAMPLE] The 'focus' task has a higher priority than the 'follow' task if the camera is given
	both tasks the focus tasks will be the one contributing the to final camera position and the follow
	will be overwritten.

This system by default uses the "camera_set_end_script" to control and execute its tasks meaning you don't
have to call update/step or any other method for it to work however if you need extra control you can disable
this mode in the constructor of the camera (or using the setAutoload(enabled) method):

	[EXAMPLE]
		camera = new Camera(0, 0, 0, false);	// This will prevent the autoload from executing
		...
		camera.update()							// This method should be called manually every step (*)
				
	(*) Take into account that given that some tasks require drawing to the screen (flash) you might
	need to call update inside a draw event.
	
If you need to terminate any of the default tasks you can call the respective function with no arguments:

	[EXAMPLE]
		camera.follow(oPlayer)	// This will make the camera follow the player.
		camera.follow()			// This will terminate the camera follow task.
		camera.follow(noone)	// Will also terminate the camera follow task.

Finally this camera system provides 3 movement modes, these modes can be exchanged whenever you see fit using the
method 'setMoveType' and providing a movement constant and an amount of move effect

		- cm_lerp: lerps between the current and next point (0 - 1, higher is faster), defaults to 0.2
		- cm_fixed: moves by fixed pixel amount (0 - max, higher is faster), defaults to 15
		- cm_damped: move using a smooth ease in-out algorithm (0 - max, higher is smoother), defaults to 25

These are the default builtin functionalities of the xCamera system as is. Please read all the function documentation
as they are fully documented which makes it easier to understand how everything works.


[ADVANCED]
As this system is completly modular you can (and probably want to) create your own tasks as you see fit. Creating a task
is as simple as, creating a constructor function and making it inherit from 'CameraTask' or 'CameraTimedTask' and give it a priority.

	[EXAMPLE]
		function MyCameraTask() : CameraTask(99) constructor {  // Here the priority is 99
			
			// This is a required function for the task logic
			static run = function(_camera, _delta) {
			} 
		
			// This is a required setup function (*)
			static setup = function(_property) {
			}
		
		}
		
		(*) The 'setup' function acts as the constructor (the constructor function is not allowed any arguments).
		
Extending from 'CameraTimedTask' is also possible to create more timed based camera effects (ie.: fadein/out). These base class
provides some useful functions:
		
		- getProgress() : the current task progress from [0-1]
		- hasFinished() : returns true when the task reached the end state.
		
These tasks however need some extra code when declared (constructor function).

	[EXAMPLE]
		function MyTimedCameraTask() : CameraTimedTask(99) constructor {  // Here the priority is 99 (example)
			
			static run_CameraTimedTask = run;			// We need to store the base run class
			static run = function(_camera, _delta) {
				
				run_CameraTimedTask(_camera, _delta);	// Call the base run method passing camera and delta variables
				
				// The rest of the code goes here
				
			}
		
			static setup_CameraTimedTask = run;					// We need to store the base setup class
			static run = function(..., _duration, _callback) {
				
				setup_CameraTimedTask(_duration, _callback);	// Call the base setup method passing duration and callback variables
				
				// The rest of the code goes here
				
			}
		}

To execute a custom task you just need to call the method 'execute' with the respective reference to the constructor function and
an array of arguments.

	[EXAMPLE]
		camera.execute(MyCameraTask, [1, 2, 3]);	// The array will be passed to the 'setup' method as SEPARATE arguments.

											
Addind multiple execution of the same camera task will not result in multiple tasks being added. Instead, the
already existing (if any) task of that type will have its 'setup' method called again with the newly provided arguments.
This can be used to terminate tasks, by applying a check inside the setup function and setting the
builtin 'remove' property to true.

	[EXAMPLE]
		function MyCameraTask() : CameraTask(99) constructor {  // Here the priority is 99 (example)
			
			// ...
		
			static setup = function(_property) {
			
				if (_property == undefined) {	// Create a check for input parameters
					remove = true;				// Set 'remove' built-in property to true (will be removed before next update)
					return;
				}
				
				// ...
				
			}
		
		}

For further examples please look at the provided default tasks to understand how they are implemented.