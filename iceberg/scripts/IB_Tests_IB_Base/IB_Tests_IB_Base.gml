	
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	//  ______   ______   ______   ______    //
	// /\  == \ /\  __ \ /\  ___\ /\  ___\   //
	// \ \  __< \ \  __ \\ \___  \\ \  __\   //
	//  \ \_____\\ \_\ \_\\/\_____\\ \_____\ //
	//   \/_____/ \/_/\/_/ \/_____/ \/_____/ //
	//                                       //
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	function __IB_TestSuite_IB_Base() {
		var _test_suite = new TestSuite("IB_Base");	
		_test_suite.setUp(function() {
			base = new IB_Base();
		});
		_test_suite.tearDown(function() {
			base.cleanup();
			delete base;
		});
		return _test_suite;
	};
	
	// initialize()
	function __IB_TestCase_IB_Base_On_Initialize_Initialized_Is_True() {
		parent.base.initialize();
		assertTrue(parent.base.is_initialized(), "base.is_initialized() should return true");
	};
	function __IB_TestCase_IB_Base_On_Initialize_Callbacks_Execute_If_Initialized_Is_False() {};
	function __IB_TestCase_IB_Base_On_Initialize_Callbacks_Do_Not_Execute_If_Initialized_Is_True() {};
	
	// cleanup()
	function __IB_TestCase_IB_Base_On_Cleanup_CleanedUp_Is_True() {};
	function __IB_TestCase_IB_Base_On_Cleanup_Callbacks_Execute_If_Initialized_Is_True_And_CleanedUp_Is_False() {};
	function __IB_TestCase_IB_Base_On_Cleanup_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	function __IB_TestCase_IB_Base_On_Cleanup_Callbacks_Do_Not_Execute_If_CleanedUp_Is_True() {};
	
	// destroy()
	
	// activate()
	
	// deactivate()
	
	// show()
	
	// hide()
	
	// update_begin()
	
	// update()
	
	// update_end()
	
	// render()
	
	// render_gui()
	
	// on_initialize()
	
	// on_cleanup()
	
	// on_destroy()
	
	// on_activate()
	
	// on_deactivate()
	
	// on_show()
	
	// on_hide()
	
	// on_update_begin()
	
	// on_update()
	
	// on_update_end()
	
	// on_render()
	
	// on_render_gui()
	
	// set_name()
	
	// set_owner()
	
	// set_uid()
	