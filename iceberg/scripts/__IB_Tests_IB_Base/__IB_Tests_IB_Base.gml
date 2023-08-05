	
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
		parent.base.destroy(false);
		
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
		parent.base.destroy(false);
		
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
		parent.base.destroy(false);
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.destroy() should not execute stored callbacks if not initialized first");
	};
	function __IB_TestCase_IB_Base_On_Destroy_Callbacks_Do_Not_Execute_If_Destroyed_Is_True() {
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.destroy(false);
		
		// store a simple callback that we can validate later
		parent.base.on_destroy(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// trigger event
		parent.base.destroy(false);
		
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
		var _active = true;
		parent.base.activate(_active);
		
		// trigger event
		var _active = false;
		parent.base.activate(_active);
		
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
	function __IB_TestCase_IB_Base_On_Show_Visible_Is_True_If_No_Param() {
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.show();
		
		// validate execution
		assertTrue(parent.base.is_visible(), "base.is_visible() should be true");
	};
	function __IB_TestCase_IB_Base_On_Show_Visible_Is_True_If_Param_Is_True() {
	
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _visible = true;
		parent.base.show(_visible);
		
		// validate execution
		assertTrue(parent.base.is_visible(), "base.is_visible() should be true");
	};
	function __IB_TestCase_IB_Base_On_Show_Visible_Is_False_If_Param_Is_False() {
	
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _visible = true;
		parent.base.show(_visible);
		
		// trigger event
		var _visible = false;
		parent.base.show(_visible);
		
		// validate execution
		assertFalse(parent.base.is_visible(), "base.is_visible() should be false");
	};
	function __IB_TestCase_IB_Base_On_Show_Callbacks_Execute_If_Initialized_Is_True() {
		
		// store a simple callback that we can validate later
		parent.base.on_show(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.show();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.show() should execute stored callbacks");
	};
	function __IB_TestCase_IB_Base_On_Show_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_show(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// do not initialize object
		
		// trigger event
		parent.base.show();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.show() should not execute stored callbacks if not initialized first");
	};
	
	// hide()
	function __IB_TestCase_IB_Base_On_Hide_Visible_Is_False() {
	
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.hide();
		
		// validate execution
		assertFalse(parent.base.is_visible(), "base.is_visible() should be false");
	};
	function __IB_TestCase_IB_Base_On_Hide_Callbacks_Execute_If_Initialized_Is_True() {
		
		// store a simple callback that we can validate later
		parent.base.on_hide(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		parent.base.hide();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.hide() should execute stored callbacks");
	};
	function __IB_TestCase_IB_Base_On_Hide_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_hide(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// do not initialize object
		
		// trigger event
		parent.base.hide();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.hide() should not execute stored callbacks if not initialized first");
	};
	
	// update_begin()
	function __IB_TestCase_IB_Base_On_UpdateBegin_Callbacks_Execute_If_Initialized_Is_True_And_Active_Is_True() {
	
		// store a simple callback that we can validate later
		parent.base.on_update_begin(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _active = true;
		parent.base.update_begin(_active);
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.update_begin() should execute stored callbacks");
	};
	function __IB_TestCase_IB_Base_On_UpdateBegin_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_update_begin(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// do not initialize object
		
		// trigger event
		parent.base.update_begin();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.update_begin() should not execute stored callbacks if not initialized first");
	};
	function __IB_TestCase_IB_Base_On_UpdateBegin_Callbacks_Do_Not_Execute_If_Active_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_update_begin(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _active = false;
		parent.base.update_begin(_active);
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.update_begin() should not execute stored callbacks if not activated first");
	};
	
	// update()
	function __IB_TestCase_IB_Base_On_Update_Callbacks_Execute_If_Initialized_Is_True_And_Active_Is_True() {
		
		// store a simple callback that we can validate later
		parent.base.on_update(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _active = true;
		parent.base.update(_active);
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.update() should execute stored callbacks");
	};
	function __IB_TestCase_IB_Base_On_Update_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_update(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// do not initialize object
		
		// trigger event
		parent.base.update();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.update() should not execute stored callbacks if not initialized first");
	};
	function __IB_TestCase_IB_Base_On_Update_Callbacks_Do_Not_Execute_If_Active_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_update(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _active = false;
		parent.base.update(_active);
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.update() should not execute stored callbacks if not activated first");
	};
	
	// update_end()
	function __IB_TestCase_IB_Base_On_UpdateEnd_Callbacks_Execute_If_Initialized_Is_True_And_Active_Is_True() {
	
		// store a simple callback that we can validate later
		parent.base.on_update_end(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _active = true;
		parent.base.update_end(_active);
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.update_end() should execute stored callbacks");
	};
	function __IB_TestCase_IB_Base_On_UpdateEnd_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {
		
		// store a simple callback that we can validate later
		parent.base.on_update_end(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// do not initialize object
		
		// trigger event
		parent.base.on_update_end();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.on_update_end() should not execute stored callbacks if not initialized first");
	};
	function __IB_TestCase_IB_Base_On_UpdateEnd_Callbacks_Do_Not_Execute_If_Active_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_update_end(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _active = false;
		parent.base.update_end(_active);
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.update_end() should not execute stored callbacks if not activated first");
	};
	
	// render()
	function __IB_TestCase_IB_Base_On_Render_Callbacks_Execute_If_Initialized_Is_True_And_Visible_Is_True() {
	
		// store a simple callback that we can validate later
		parent.base.on_render(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _visible = true;
		parent.base.render(_visible);
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.render() should execute stored callbacks");
	};
	function __IB_TestCase_IB_Base_On_Render_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {
		
		// store a simple callback that we can validate later
		parent.base.on_render(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// do not initialize object
		
		// trigger event
		parent.base.on_render();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.on_render() should not execute stored callbacks if not initialized first");
	};
	function __IB_TestCase_IB_Base_On_Render_Callbacks_Do_Not_Execute_If_Visible_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_render(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _visible = false;
		parent.base.on_render(_visible);
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.on_render() should not execute stored callbacks if not activated first");
	};
	
	// render_gui()
	function __IB_TestCase_IB_Base_On_RenderGui_Callbacks_Execute_If_Initialized_Is_True_And_Visible_Is_True() {
	
		// store a simple callback that we can validate later
		parent.base.on_render_gui(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _visible = true;
		parent.base.render_gui(_visible);
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertTrue(_did_execute, "base.render_gui() should execute stored callbacks");
	};
	function __IB_TestCase_IB_Base_On_RenderGui_Callbacks_Do_Not_Execute_If_Initialized_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_render_gui(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// do not initialize object
		
		// trigger event
		parent.base.render_gui();
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.render_gui() should not execute stored callbacks if not initialized first");
	};
	function __IB_TestCase_IB_Base_On_RenderGui_Callbacks_Do_Not_Execute_If_Visible_Is_False() {
	
		// store a simple callback that we can validate later
		parent.base.on_render_gui(function() {
			parent.base[$ "test_var"] = 1;
		});
		
		// initialize object
		parent.base.initialize();
		
		// trigger event
		var _visible = false;
		parent.base.render_gui(_visible);
		
		// validate execution
		var _did_execute = parent.base[$ "test_var"] != undefined;
		assertFalse(_did_execute, "base.render_gui() should not execute stored callbacks if not activated first");
	};
	
	// on_initialize()
	function __IB_TestCase_IB_Base_On_OnInitialize_Callback_Is_Stored_In_Array() {
	
		// store callback
		parent.base.on_initialize(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.initialization.on_initialization;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_initialize callbacks should be of size 1");
	};
	
	// on_cleanup()
	function __IB_TestCase_IB_Base_On_OnCleanup_Callback_Is_Stored_In_Array() {
	
		// store callback
		parent.base.on_cleanup(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.cleanup.on_cleanup;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_cleanup callbacks should be of size 1");
	};
	
	// on_destroy()
	function __IB_TestCase_IB_Base_On_OnDestroy_Callback_Is_Stored_In_Array() {
	
		// store callback
		parent.base.on_destroy(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.destruction.on_destruction;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_destroy callbacks should be of size 1");
	};
	
	// on_activate()
	function __IB_TestCase_IB_Base_On_OnActivate_Callback_Is_Stored_In_Array() {
	
		// store callback
		parent.base.on_activate(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.activation.on_activation;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_activate callbacks should be of size 1");
	};
	
	// on_deactivate()
	function __IB_TestCase_IB_Base_On_OnDeactivate_Callback_Is_Stored_In_Array() {
		
		// store callback
		parent.base.on_deactivate(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.activation.on_deactivation;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_deactivate callbacks should be of size 1");
	};
	
	// on_show()
	function __IB_TestCase_IB_Base_On_OnShow_Callback_Is_Stored_In_Array() {
	
		// store callback
		parent.base.on_show(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.visibility.on_show;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_show callbacks should be of size 1");
	};
	
	// on_hide()
	function __IB_TestCase_IB_Base_On_OnHide_Callback_Is_Stored_In_Array() {
	
		// store callback
		parent.base.on_hide(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.visibility.on_hide;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_hide callbacks should be of size 1");
	};
	
	// on_update_begin()
	function __IB_TestCase_IB_Base_On_OnUpdateBegin_Callback_Is_Stored_In_Array() {
	
		// store callback
		parent.base.on_update_begin(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.update.on_begin;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_update_begin callbacks should be of size 1");
	};
	
	// on_update()
	function __IB_TestCase_IB_Base_On_OnUpdate_Callback_Is_Stored_In_Array() {
	
		// store callback
		parent.base.on_update(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.update.on_update;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_update callbacks should be of size 1");
	};
	
	// on_update_end()
	function __IB_TestCase_IB_Base_On_OnUpdateEnd_Callback_Is_Stored_In_Array() {
	
		// store callback
		parent.base.on_update_end(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.update.on_end;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_update_end callbacks should be of size 1");
	};
	
	// on_render()
	function __IB_TestCase_IB_Base_On_OnRender_Callback_Is_Stored_In_Array() {
	
		// store callback
		parent.base.on_render(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.render.on_render;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_render callbacks should be of size 1");
	};
	
	// on_render_gui()
	function __IB_TestCase_IB_Base_On_OnRenderGui_Callback_Is_Stored_In_Array() {
	
		// store callback
		parent.base.on_render_gui(function() {});
		
		// validate 
		var _callbacks_array = parent.base.__.base.render.on_render_gui;
		var _callbacks_count = array_length(_callbacks_array);
		assertEqual(_callbacks_count, 1, "on_render_gui callbacks should be of size 1");
	};
	
	// set_name()
	function __IB_TestCase_IB_Base_On_SetName_Name_Property_Is_Set() {
	
		static _name = "gentoo";
	
		// set name member
		parent.base.set_name(_name);
		
		// validate 
		assertEqual(parent.base.get_name(), _name, "set_name should set name member");
	};
	
	// set_owner()
	function __IB_TestCase_IB_Base_On_SetName_Owner_Property_Is_Set() {
	
		static _owner = "gentoo";
	
		// set owner reference
		parent.base.set_owner(_owner);
		
		// validate 
		assertEqual(parent.base.get_owner(), _owner, "set_owner should set owner reference");
	};
	
	// set_uid()
	function __IB_TestCase_IB_Base_On_SetName_Uid_Property_Is_Set() {
	
		static _uid = "gentoo";
	
		// set owner reference
		parent.base.set_uid(_uid);
		
		// validate 
		assertEqual(parent.base.get_uid(), _uid, "set_uid should set uid member");
	};
	
	