//////////////////////////////////////////////////////
//	Components										//								
//		-	components are class objects that 		//
//			containerize reusable functionality.    //	
//		-	components can be instantiated as stand //
//			alone objects, or be tied into a 		//
//			greater component system designed to 	//
//			organize and provide structure to a 	//
//			series of components.					//							
//		-	any form of generalized logic that can 	//
//			be shared across multiple objects 		//
//			(regardless of object inheritence) 		//
//			should be encapsulated into a component //
//////////////////////////////////////////////////////

function Component() constructor {
	/// @func	Component()
	/// @return {Component} self
	///
	IIntegral();

	__owner  = other;
	__name	 = undefined;
	__active = true;
	
	static setup    = function() {}; /// @OVERRIDE
	static update   = function() {}; /// @OVERRIDE
	static render   = function() {}; /// @OVERRIDE
	//static teardown = function() {}; /// @OVERRIDE
	
	static actvate	  = function() {
		/// @func	actvate()
		/// @return {Component} self
		///
		__active = true;
		return self;
	};
	static deactivate = function() {
		/// @func	deactivate()
		/// @return {Component} self
		///
		__active = false;
		return self;
	};
		
};