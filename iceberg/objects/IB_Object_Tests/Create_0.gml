
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	//  ______  ______   ______   ______  ______    //
	// /\__  _\/\  ___\ /\  ___\ /\__  _\/\  ___\   //
	// \/_/\ \/\ \  __\ \ \___  \\/_/\ \/\ \___  \  //
	//    \ \_\ \ \_____\\/\_____\  \ \_\ \/\_____\ //
	//     \/_/  \/_____/ \/_____/   \/_/  \/_____/ //
	//                                              //
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	// IB_Object_Tests.create //
	var _self = self;

	// private
	__ = {};
	with (__) {
		new_suite = method(_self, function(_suite_function, _suite_string_prefix) {
			var _suite = _suite_function();
			__.runner.addTestSuite(_suite);
			__.runner.discover(_suite, _suite_string_prefix);
			return _suite;
		});
		runner	  = undefined;
	};

	// auto-init
	if (IB_CONFIG.tests.run) {
		
		__.runner = new TestRunner("runner");
		
		__.new_suite(__IB_TestSuite_IB_Base, "__IB_TestCase_IB_Base_");
		
		__.runner.run();
	}
	
	////////////////////

	room_goto_next();
	