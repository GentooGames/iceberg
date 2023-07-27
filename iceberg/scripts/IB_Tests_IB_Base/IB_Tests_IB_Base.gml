	
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
	///////////////////////////////////////////
	function __IB_TestCase_IB_Base_1() {
		var _sum = 2 + 3;
		assertEqual(_sum, 5);
	};
	function __IB_TestCase_IB_Base_On_Initialize_Initialized_Is_True() {
		
	};
	