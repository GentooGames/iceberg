
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	//  ______  ______   ______   ______  ______    //
	// /\__  _\/\  ___\ /\  ___\ /\__  _\/\  ___\   //
	// \/_/\ \/\ \  __\ \ \___  \\/_/\ \/\ \___  \  //
	//    \ \_\ \ \_____\\/\_____\  \ \_\ \/\_____\ //
	//     \/_/  \/_____/ \/_____/   \/_/  \/_____/ //
	//                                              //
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	// IB_Object_Tests.create //

	if (IB_CONFIG.tests.run) {
		
		// test suites
		test_suite_IB_Base = new TestSuite("IB_Base");
		
		// test runner
		test_runner = new TestRunner("runner");
		
		test_runner.addTestSuite(test_suite_IB_Base);
		
		test_runner.discover(test_suite_IB_Base, "Test_IB_Base_");
	
		test_runner.run();
	}

	room_goto_next();
	