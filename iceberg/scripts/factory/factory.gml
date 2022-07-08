//////////////////////////////////////////////////////
//	Factories									    //										
//		-	factories are class objects that get 	//
//			instantiated so that GameMaker objects 	//
//			can be instantiated through strictly 	//
//			defined methodologies. 	    			//
//		-	this allows different GameMaker objects //
//			to implement separate factories so that //
//			object instantiation can be handle in a //	    
//			context sensitive manner, while still 	//
//			mantaining proper abstraction.			//
//////////////////////////////////////////////////////

function Factory() constructor {};


/// To Implement...
function camera_create_instance(_x = 0, _y = 0) {
	/// @func	camera_create_instance(x*, y*)
	/// @param	{real}	   x=0
	/// @param	{real}	   y=0
	/// @return {instance} camera
	///
	var _camera = instance_create_depth(_x, _y, 0, obj_camera);
	/// _camera.setup();
	return _camera;
};
function UnitFactory() constructor {};

