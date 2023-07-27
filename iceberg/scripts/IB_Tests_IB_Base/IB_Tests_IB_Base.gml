	
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
		
		// setup
		_test_suite.setUp(function() {
		
		});
		
		// run begin
		_test_suite.onRunBegin(function() {
			base = new IB_Base();
		});
		
		// run end
		_test_suite.onRunEnd(function() {
			base.cleanup();
			delete base;
		});
		
		// teardown
		_test_suite.tearDown(function() {
		
		});
		
		return _test_suite;
	};
	
	////////////////////////////////////
	
	// initialize()
	function __IB_TestCase_IB_Base_On_Initialize_Initialized_Is_True() {
		parent.base.initialize();
		assertTrue(parent.base.is_initialized(), "base.is_initialized() should return true");
	};
	function __IB_TestCase_IB_Base_On_Initialize_Callbacks_Execute_If_Initialized_Is_False() {};
	function __IB_TestCase_IB_Base_On_Initialize_Callbacks_Do_Not_Execute_If_Initialized_Is_True() {};
	
	// cleanup()
	function __IB_TestCase_IB_Base_On_Cleanup_CleanedUp_Is_True() {};
	function __IB_TestCase_IB_Base_On_Cleanup_Callbacks_Execute_If_Initialized_Is_True() {};
	function __IB_TestCase_IB_Base_On_Cleanup_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	function __IB_TestCase_IB_Base_On_Cleanup_Callbacks_Do_Not_Execute_If_CleanedUp_Is_True() {};
	
	// destroy()
	function __IB_TestCase_IB_Base_On_Destroy_Destroyed_Is_True() {};
	function __IB_TestCase_IB_Base_On_Destroy_Callbacks_Execute_If_Initialized_Is_True() {};
	function __IB_TestCase_IB_Base_On_Destroy_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	function __IB_TestCase_IB_Base_On_Destroy_Callbacks_Do_Not_Execute_If_Destroyed_Is_True() {};
	
	// activate()
	function __IB_TestCase_IB_Base_On_Activate_Activated_Is_True_If_Param_Is_True() {};
	function __IB_TestCase_IB_Base_On_Activate_Activated_Is_False_If_Param_Is_False() {};
	function __IB_TestCase_IB_Base_On_Activate_Callbacks_Execute_If_Initialized_Is_True() {};
	function __IB_TestCase_IB_Base_On_Activate_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	
	// deactivate()
	function __IB_TestCase_IB_Base_On_Deactivate_Activated_Is_False() {};
	function __IB_TestCase_IB_Base_On_Deactivate_Callbacks_Execute_If_Initialized_Is_True() {};
	function __IB_TestCase_IB_Base_On_Deactivate_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	
	// show()
	function __IB_TestCase_IB_Base_On_Show_Visible_Is_True_If_Param_Is_True() {};
	function __IB_TestCase_IB_Base_On_Show_Visible_Is_False_If_Param_Is_False() {};
	function __IB_TestCase_IB_Base_On_Show_Callbacks_Execute_If_Initialized_Is_True() {};
	function __IB_TestCase_IB_Base_On_Show_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	
	// hide()
	function __IB_TestCase_IB_Base_On_Hide_Visible_Is_False() {};
	function __IB_TestCase_IB_Base_On_Hide_Callbacks_Execute_If_Initialized_Is_True() {};
	function __IB_TestCase_IB_Base_On_Hide_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	
	// update_begin()
	function __IB_TestCase_IB_Base_On_UpdateBegin_Callbacks_Execute_If_Initialized_Is_True_And_Active_Is_True() {};
	function __IB_TestCase_IB_Base_On_UpdateBegin_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	function __IB_TestCase_IB_Base_On_UpdateBegin_Callbacks_Do_Not_Execute_If_Active_Is_False() {};
	
	// update()
	function __IB_TestCase_IB_Base_On_Update_Callbacks_Execute_If_Initialized_Is_True_And_Active_Is_True() {};
	function __IB_TestCase_IB_Base_On_Update_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	function __IB_TestCase_IB_Base_On_Update_Callbacks_Do_Not_Execute_If_Active_Is_False() {};
	
	// update_end()
	function __IB_TestCase_IB_Base_On_UpdateEnd_Callbacks_Execute_If_Initialized_Is_True_And_Active_Is_True() {};
	function __IB_TestCase_IB_Base_On_UpdateEnd_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	function __IB_TestCase_IB_Base_On_UpdateEnd_Callbacks_Do_Not_Execute_If_Active_Is_False() {};
	
	// render()
	function __IB_TestCase_IB_Base_On_Render_Callbacks_Execute_If_Initialized_Is_True_And_Visible_Is_True() {};
	function __IB_TestCase_IB_Base_On_Render_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	function __IB_TestCase_IB_Base_On_Render_Callbacks_Do_Not_Execute_If_Visible_Is_False() {};
	
	// render_gui()
	function __IB_TestCase_IB_Base_On_RenderGui_Callbacks_Execute_If_Initialized_Is_True_And_Visible_Is_True() {};
	function __IB_TestCase_IB_Base_On_RenderGui_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {};
	function __IB_TestCase_IB_Base_On_RenderGui_Callbacks_Do_Not_Execute_If_Visible_Is_False() {};
	
	// on_initialize()
	function __IB_TestCase_IB_Base_On_OnInitialize_Callback_Is_Stored_In_Array() {};
	
	// on_cleanup()
	function __IB_TestCase_IB_Base_On_OnCleanup_Callback_Is_Stored_In_Array() {};
	
	// on_destroy()
	function __IB_TestCase_IB_Base_On_OnDestroy_Callback_Is_Stored_In_Array() {};
	
	// on_activate()
	function __IB_TestCase_IB_Base_On_OnActivate_Callback_Is_Stored_In_Array() {};
	
	// on_deactivate()
	function __IB_TestCase_IB_Base_On_OnDeactivate_Callback_Is_Stored_In_Array() {};
	
	// on_show()
	function __IB_TestCase_IB_Base_On_OnShow_Callback_Is_Stored_In_Array() {};
	
	// on_hide()
	function __IB_TestCase_IB_Base_On_OnHide_Callback_Is_Stored_In_Array() {};
	
	// on_update_begin()
	function __IB_TestCase_IB_Base_On_OnUpdateBegin_Callback_Is_Stored_In_Array() {};
	
	// on_update()
	function __IB_TestCase_IB_Base_On_OnUpdate_Callback_Is_Stored_In_Array() {};
	
	// on_update_end()
	function __IB_TestCase_IB_Base_On_OnUpdateEnd_Callback_Is_Stored_In_Array() {};
	
	// on_render()
	function __IB_TestCase_IB_Base_On_OnRender_Callback_Is_Stored_In_Array() {};
	
	// on_render_gui()
	function __IB_TestCase_IB_Base_On_OnRenderGui_Callback_Is_Stored_In_Array() {};
	
	// set_name()
	function __IB_TestCase_IB_Base_On_SetName_Name_Property_Is_Set() {};
	
	// set_owner()
	function __IB_TestCase_IB_Base_On_SetName_Owner_Property_Is_Set() {};
	
	// set_uid()
	function __IB_TestCase_IB_Base_On_SetName_Uid_Property_Is_Set() {};
	
	