global.___system_unit_test = {
	test_suites: {
	    object_onCreate: {
	        run:      false,
	        setup:    function() {
				object = instance_create_depth(0, 0, 0, objp_object);
			},
	        teardown: function() {
				instance_destroy(object);
				object = undefined;
			},
	        tests: [
				ut_object_onCreate_setEventId,
	        ],
	    },
	},
	run_tests: function() {
		/// @func   run_tests()
	    /// @return NA
	    ///
	    if (!RUN_TESTS) exit;
	    log("##################################################");
	    log("############## Running Unit Tests ################");
	    log("##################################################");
		
	    test_runner = new TestRunner("global_test_runner");
        
	    /// Iterate Through Test Suites
	    var _test_suites      = UNIT_TEST.test_suites;
	    var _test_suite_names = variable_struct_get_names(_test_suites);
	    for (var _i = 0, _n_test_suites = array_length(_test_suite_names); _i < _n_test_suites; _i++) {
	        var _test_suite_name = _test_suite_names[_i];
	        var _test_suite_data = _test_suites[$ _test_suite_name];
	        var _test_suite      = new TestSuite(_test_suite_name);
	        if (!_test_suite_data.run) continue;
            
	        if (variable_struct_exists(_test_suite_data, "setup")) {
	            if (_test_suite_data.setup != undefined) {
	                _test_suite.setup(_test_suite_data.setup);
	            }
	        }
	        if (variable_struct_exists(_test_suite_data, "teardown")) {
	            if (_test_suite_data.teardown != undefined) {
	                _test_suite.teardown(_test_suite_data.teardown);
	            }
	        }
	        if (variable_struct_exists(_test_suite_data, "on_run_begin")) {
	            if (_test_suite_data.on_run_begin != undefined) {
	                _test_suite.on_run_begin(_test_suite_data.on_run_begin);
	            }
	        }
	        if (variable_struct_exists(_test_suite_data, "on_run_end")) {
	            if (_test_suite_data.on_run_end != undefined) {
	                _test_suite.on_run_end(_test_suite_data.on_run_end);
	            }
	        }
        
			/// Iterate Through Test Cases
	        var _test_cases = _test_suite_data.tests;
	        for (var _j = 0, _n_test_cases = array_length(_test_cases); _j < _n_test_cases; _j++) {
	            var _test_data = _test_cases[_j]();
	            var _test_case = new TestCase(_test_data.name, _test_data.test);
                
	            if (variable_struct_exists(_test_data, "setup")) {
	                if (_test_data.setup != undefined) {
	                    _test_case.setup(_test_data.setup);
	                }
	            }
	            if (variable_struct_exists(_test_data, "teardown")) {
	                if (_test_data.teardown != undefined) {
	                    _test_case.teardown(_test_data.teardown);
	                }
	            }
	            if (variable_struct_exists(_test_data, "on_run_begin")) {
	                if (_test_data.on_run_begin != undefined) {
	                    _test_case.on_run_begin(_test_data.on_run_begin);
	                }
	            }
	            if (variable_struct_exists(_test_data, "on_run_end")) {
	                if (_test_data.on_run_end != undefined) {
	                    _test_case.on_run_end(_test_data.on_run_end);
	                }
	            }
	            _test_suite.add_test_case(_test_case);
	        }
	        test_runner.add_test_suite(_test_suite);
	    }
	    
		test_runner.run();
	},
};
#macro UNIT_TEST global.___system_unit_test
#macro RUN_TESTS 0 
////////////////////////////////////////////
#region object_onCreate

function ut_object_onCreate_setEventId() {
    return {
        name: "ut_object_onCreate_setEventId",
        test: function() {
            assert_equals(parent.object.event_id, "object", "object.event_id should be \"object\"");
        },
    };
};

#endregion