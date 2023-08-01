	
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
		_test_suite.setUp(function() {});
		
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
		_test_suite.tearDown(function() {});
		
		return _test_suite;
	};
	
	///////////////////////////////////////////
	
	// initialize()
	function __IB_TestCase_IB_Base_On_Initialize_Initialized_Is_True() {
		
		// trigger event
		parent.base.initialize();
		
		// validate execution
		assertTrue(parent.base.is_initialized(), "base.is_initialized() should return true");
	};
	function __IB_TestCase_IB_Base_On_Initialize_Callbacks_Execute_If_Initialized_Is_False() {
		
		// store a simple callback that we can validate later
		parent.base.on_initialize(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// trigger event
		parent.base.initialize();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.initialize() should execute stored callbacks");
	};
	function __IB_TestCase_IB_Base_On_Initialize_Callbacks_Do_Not_Execute_If_Initialized_Is_True() {
		
		// trigger event
		parent.base.initialize();
		
		// store a simple callback that we can validate later
		parent.base.on_initialize(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// try to retrigger the event, since this event was already triggered, callbacks should not run
		parent.base.initialize();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.initialize() should not execute stored callbacks if already initialized");
	};
	
	// cleanup()
	function __IB_TestCase_IB_Base_On_Cleanup_CleanedUp_Is_True() {
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.cleanup();
		
		// validate execution
		assertTrue(parent.base.is_cleaned_up(), "base.is_cleaned_up() should return true");
	};
	function __IB_TestCase_IB_Base_On_Cleanup_Callbacks_Execute_If_Initialized_Is_True() {
	
		// store a simple callback that we can validate later
		parent.base.on_cleanup(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.cleanup();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.cleanup() should execute stored callbacks");
	};
	function __IB_TestCase_IB_Base_On_Cleanup_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_cleanup(function() {
			parent.base[$ "test_var"] = 1;
		});
	
		// do not initialize object
	
		// trigger event
		parent.base.cleanup();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.cleanup() should not execute stored callbacks if not initialized first");
	};
	function __IB_TestCase_IB_Base_On_Cleanup_Callbacks_Do_Not_Execute_If_CleanedUp_Is_True() {
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.cleanup();
		
		// store a simple callback that we can validate later
		parent.base.on_cleanup(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// trigger event
		parent.base.cleanup();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.cleanup() should not execute stored callbacks if not already cleaned up");
	};
	
	// destroy()
	function __IB_TestCase_IB_Base_On_Destroy_Destroyed_Is_True() {
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.destroy();
		
		// validate execution
		assertTrue(parent.base.is_destroyed(), "base.is_destroyed() should return true");
	};
	function __IB_TestCase_IB_Base_On_Destroy_Callbacks_Execute_If_Initialized_Is_True() {
		
		// store a simple callback that we can validate later
		parent.base.on_destroy(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.destroy();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.destroy() should execute stored callbacks");
	};
	function __IB_TestCase_IB_Base_On_Destroy_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_destroy(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// do not initialize object
		
		// trigger event
		parent.base.destroy();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.destroy() should not execute stored callbacks if not initialized first");
	};
	function __IB_TestCase_IB_Base_On_Destroy_Callbacks_Do_Not_Execute_If_Destroyed_Is_True() {
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.destroy();
		
		// store a simple callback that we can validate later
		parent.base.on_destroy(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// trigger event
		parent.base.destroy();
		
		// validate executaion
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.destroy() should not execute stored callbacks if already destroyed");
	};
	
	// activate()
	function __IB_TestCase_IB_Base_On_Activate_Activated_Is_True_If_No_Param() {
	
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.activate();
		
		// validate execution
		assertTrue(parent.base.is_active(), "base.is_active() should return true");
	};
	function __IB_TestCase_IB_Base_On_Activate_Activated_Is_True_If_Param_Is_True() {
	
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.activate(true);
		
		// validate execution
		assertTrue(parent.base.is_active(), "base.is_active() should return true");
	};
	function __IB_TestCase_IB_Base_On_Activate_Activated_Is_False_If_Param_Is_False() {
	
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.activate(true);
		
		// trigger event
		parent.base.activate(false);
		
		// validate execution
		assertFalse(parent.base.is_active(), "base.is_active() should return false");
	};
	function __IB_TestCase_IB_Base_On_Activate_Callbacks_Execute_If_Initialized_Is_True() {
	
		// store a simple callback that we can validate later
		parent.base.on_activate(function() {
			parent.base[$ "test_var"] = 1;
		});
	
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.activate();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.activate() should execute stored callbacks");	
	};
	function __IB_TestCase_IB_Base_On_Activate_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_activate(function() {
			parent.base[$ "test_var"] = 1;
		});
	
		// do not initialize object
		
		// trigger event
		parent.base.activate();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.activate() should not execute stored callbacks if not initialized first");	
	};
	
	// deactivate()
	function __IB_TestCase_IB_Base_On_Deactivate_Activated_Is_False() {
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.deactivate();
		
		// validate execution
		assertFalse(parent.base.is_active(), "base.is_active() should be false");
	};
	function __IB_TestCase_IB_Base_On_Deactivate_Callbacks_Execute_If_Initialized_Is_True() {
		
		// store a simple callback that we can validate later
		parent.base.on_deactivate(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.deactivate();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.deactivate() should execute stored callbacks");
	};
	function __IB_TestCase_IB_Base_On_Deactivate_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_deactivate(function() {
			parent.base[$ "test_var"] = 1;
		});
	
		// do not initialize object
	
		// trigger event
		parent.base.cleanup();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.deactivate() should not execute stored callbacks if not initialized first");
	};
	
	// show()
	function __IB_TestCast_IB_Base_On_Show_Visible_Is_True_If_No_Param() {};
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
	
	