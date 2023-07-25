/**
 * Crispy is a unit testing framework for GameMaker Studio 2.3+
 * GitHub: https://github.com/bfrymire/crispy
 * Author: Brent Frymire
 */
 
#macro CRISPY_NAME							"Crispy"
#macro CRISPY_AUTHOR						"Brent Frymire"
#macro CRISPY_VERSION						"1.5.0"
#macro CRISPY_DATE							"2022-3-6"
#macro CRISPY_RUN							true		// Boolean flag that can be used to automatically run tests
#macro CRISPY_DEBUG							false		// Enables outputting extra context on some silent functions
#macro CRISPY_VERBOSITY						2			// Determines how verbose assertion outputs will be. Acceptable values are 0, 1, or 2
#macro CRISPY_TIME_PRECISION				6			// Number of decimal places timers will be output to
#macro CRISPY_PASS_MSG_SILENT				"."			// Output string when an assertion passes silently
#macro CRISPY_FAIL_MSG_SILENT				"F"			// Output string when an assertion fails silently
#macro CRISPY_PASS_MSG_VERBOSE				"ok"		// Output string when an assertion passes verbosely
#macro CRISPY_FAIL_MSG_VERBOSE				"Fail"		// Output string when an assertion fails verbosely
#macro CRISPY_STRUCT_UNPACK_ALLOW_DUNDER	false		// Enables dunder variables to be overwritten when using crispyStructUnpack

show_debug_message("Using " + CRISPY_NAME + " unit testing framework by " + CRISPY_AUTHOR + ". This is version " + CRISPY_VERSION + ", released on " + CRISPY_DATE + ".");

#region helper functions

function crispyThrowExpected(_self, _name, _expected, _received) {
	/**
	 * Helper function for Crispy to throw an error message that displays
	 * 		what type of value the function was expecting
	 * @function crispyThrowExpected
	 * @param {struct} self - Struct that is calling the function, usually self
	 * @param {string} name - String of the name of the function that is
	 * 		currently running the error message
	 * @param {string} expected - String of the type of value expected to receive
	 * @param {string} received - String of the type of value received
	 */
	// Throw error message if wrong type is passed into parameters
	if !is_struct(_self) {
		throw("crispyThrowExpected() _self parameter expected a struct, received " + typeof(_self) + ".");
	}
	if !is_string(_name) {
		throw("crispyThrowExpected() _name parameter expected a string, received " + typeof(_name) + ".");
	}
	if !is_string(_expected) {
		throw("crispyThrowExpected() _expected parameter expected a string, received " + typeof(_expected) + ".");
	}
	if !is_string(_received) {
		throw("crispyThrowExpected() _received parameter expected a string, received " + typeof(_received) + ".");
	}

	var _char = string_lower(string_ord_at(_expected, 1));
	var _vowels = ["a", "e", "i", "o", "u"];
	var _len = array_length(_vowels);
	var _preposition = "a";
	for(var i = 0; i < _len; i++) {
		if _char == _vowels[i] {
			_preposition = "an";
			break;
		}
	}
	_name = _name == "" ? "" : "." + _name;
	var _msg = instanceof(_self) + _name + "() expected " + _preposition + " ";
	_msg += _expected + ", received " + _received + ".";
	throw(_msg);
}
function crispyDebugMessage(_message) {
	/**
	 * Helper function for Crispy to display its debug messages
	 * @function crispyDebugMessage
	 * @param {string} message - Text to be displayed in the Output Window
	 */
	if !is_string(_message) {
		crispyThrowExpected(self, "crispyDebugMessage", "string", typeof(_message));
	}
	show_debug_message(CRISPY_NAME + ": " + _message);
}
function crispyGetTime() {
	/**
	 * Returns the current time in micro-seconds since the project started running
	 * @function
	 * @returns {number} Time that your game has been running in milliseconds
	 */
	return get_timer();
}
function crispyGetTimeDiff() {
	/**
	 * Returns the difference between two times
	 * @function
	 * @param {number} start_time - Starting time in milliseconds
	 * @param {number} stop_time - Stopping time in milliseconds
	 * @returns {number} Difference between start_time and stop_time
	 */
	var _start_time = (argument_count > 0) ? argument[0] : undefined;
	var _stop_time = (argument_count > 1) ? argument[1] : undefined;

	if !is_real(_start_time) {
		crispyThrowExpected(self, "crispyGetTimeDiff", "number", typeof(_start_time));
	}
	if !is_real(_stop_time) {
		crispyThrowExpected(self, "crispyGetTimeDiff", "number", typeof(_stop_time));
	}
	return _stop_time - _start_time;
}
function CrispyLog(_case) constructor {
	/**
	 * Saves the result and output of assertion
	 * @constructor CrispyLog
	 * @param {TestCase} case - TestCase struct
	 * @param {struct} unpack - Struct to use with crispyStructUnpack
	 */
	if instanceof(_case) != "TestCase" {
		try {
			var _type = instanceof(_case);
		} catch(_e) {
			var _type = typeof(_case);
		}
		crispyThrowExpected(self, "", "TestCase", _type);
	}

	// Give self cripsyStructUnpack() function
	crispyMixinStructUnpack(self);

	/**
	 * Constructs text based on outcome of test assertion and verbosity
	 * @function getMsg
	 * @returns {string} Text based on outcome of test assertion and
	 * 		verbosity
	 */
	static getMsg = function() {
		if verbosity == 2 && display_name != "" {
			var _msg = display_name + " ";
		} else {
			var _msg = "";
		}
		switch (verbosity) {
			case 0:
				if pass {
					_msg += CRISPY_PASS_MSG_SILENT;
				} else {
					_msg += CRISPY_FAIL_MSG_SILENT;
				}
				break;
			case 1: // TODO: Figure out if anything specific should be
					// 		 output when CRISPY_VERBOSITY is 1
			case 2:
				if pass {
					_msg += "..." + CRISPY_PASS_MSG_VERBOSE;
				} else {
					if !is_undefined(msg) && msg != "" {
						_msg += "- " + msg;
					} else {
						if !is_undefined(helper_text) {
							_msg += "- " + helper_text;
						}
					}
				}
				break;
		}
		return _msg;
	}

	verbosity = CRISPY_VERBOSITY;
	pass = true;
	msg = undefined;
	helper_text = undefined;
	class = _case.class;
	name = _case.name;

	// Create the display name of log based on TestCase name and class
	var _display_name = "";
	if !is_undefined(name) {
		_display_name += name;
	}
	if !is_undefined(class) {
		if _display_name != "" {
			_display_name += "." + class;
		} else {
			_display_name += class;
		}
	}
	display_name = _display_name;

	/**
	 * Run struct unpacker if unpack argument was provided
	 */
	if argument_count > 1 {
		crispyStructUnpack(argument[1]);
	}

}
function crispyTimeConvert() {
	/**
	 * Converts the given time milliseconds to seconds as a string
	 * @function
	 * @param {number} time - Time in milliseconds
	 * @returns {string} time in seconds with CRISPY_TIME_PRECISION number
	 * 		of decimal points as a string
	 */
    var _time = (argument_count > 0) ? argument[0] : undefined;

	if !is_real(_time) {
		crispyThrowExpected(self, "crispyTimeConvert", "number", typeof(_time));
	}

	return string_format(_time / 1000000, 0, CRISPY_TIME_PRECISION);

}
function crispyStructUnpack(_unpack, _name_must_exist) {
	/**
	 * Helper function for structs that will replace a destination's
	 * 		variable name values with the given source's variable name values
	 * @function crispyStructUnpack
	 * @param {struct} unpack - Struct used to replace existing values with
	 * @param [boolean=true] name_must_exist - Boolean flag that prevents
	 * 		new variable names from being added to the destination struct if
	 * 		the variable name does not already exist
	 */
	// Throw error if passed value isn't a struct
	if !is_struct(_unpack) {
		crispyThrowExpected(self, "crispyStructUnpack", "struct", typeof(_unpack));
	}

	// Optional parameter _name_must_exist defaults to true
	if !is_bool(_name_must_exist) {
		_name_must_exist = true;
	}

	var _names = variable_struct_get_names(_unpack);
	var _len = array_length(_names);
	for(var i = 0; i < _len; i++) {
		var _name = _names[i];
		if !CRISPY_STRUCT_UNPACK_ALLOW_DUNDER && crispyIsInternalVariable(_name) {
			if CRISPY_DEBUG {
				crispyDebugMessage("Variable names beginning and ending in double underscores are reserved for the framework. Skip unpacking struct name: " + _name);
			}
			continue;
		}
		var _value = variable_struct_get(_unpack, _name);
		if _name_must_exist {
			if !variable_struct_exists(self, _name) {
				if CRISPY_DEBUG {
					crispyDebugMessage("Variable name \"" + _name + "\" not found in struct, skip writing variable name.");
				}
				continue;
			}
		}
		variable_struct_set(self, _name, _value);
	}
}
function crispyMixinStructUnpack() {
	/**
	 * Mixin function that extends structs to have the crispyStructUnpack() function
	 * @function
	 * @param {struct} struct - Struct to give crispyStructUnpack method to
	 */
	var _struct = (argument_count > 0) ? argument[0] : undefined;

	if !is_struct(_struct) {
		crispyThrowExpected(self, crispyMixinStructUnpack, "struct", typeof(_struct));
	}

	_struct.crispyStructUnpack = method(_struct, crispyStructUnpack);

}
function crispyIsInternalVariable(_name) {
	/**
	 * Helper function for Crispy that returns whether or not a given variable name follows internal variable
	 * 		naming convention
	 * @function
	 * @param {string} name - Name of variable to check
	 * @returns {boolean} If name follows internal variable naming convention
	 */
	if !is_string(_name) {
		crispyThrowExpected("crispyIsInternalVariable", "", "string", typeof(_name));
	}
	
	var _len = string_length(_name);
	if _len > 4 && string_copy(_name, 1, 2) == "__" && string_copy(_name, _len - 1, _len) == "__" {
		return true;
	}
	return false;
}
	
#endregion
#region test objects

function TestRunner(_name) : BaseTestClass(_name) constructor {
	/**
	 * Runner to hold test suites and iterates through each TestSuite, running its tests
	 * @constructor TestRunner
	 * @param {string} name - Name of runner
	 * @param [struct] unpack - Struct for crispyStructUnpack
	 */
	start_time = 0;
	stop_time = 0;
	total_time = 0;
	display_time = "0";
	suites = [];
	logs = [];


	/**
	 * Adds a Log to the array of logs
	 * @function addLog
	 * @param {Log} log - Log struct to add to logs
	 */
	static addLog = function(_log) {
		array_push(logs, _log);
	}

	/**
	 * Adds Logs to the array of logs
	 * @function captureLogs
	 * @param {CrispyLog|TestCase|TestSuite} inst - Adds logs of inst to logs
	 */
	static captureLogs = function() {
		var _inst = (argument_count > 0) ? argument[0] : undefined;
		switch (instanceof(_inst)) {
			case "CrispyLog":
				addLog(_inst);
				break;
			case "TestCase":
				var _logs_len = array_length(_inst.logs);
				for(var i = 0; i < _logs_len; i++) {
					addLog(_inst.logs[i]);
				}
				break;
			case "TestSuite":
				var _tests_len = array_length(_inst.tests);
				for(var k = 0; k < _tests_len; k++) {
					var _logs_len = array_length(_inst.tests[k].logs);
					for(var i = 0; i < _logs_len; i++) {
						addLog(_inst.tests[k].logs[i]);
					}
				}
				break;
			default:
				var _type = !is_undefined(instanceof(_inst)) ? instanceof(_inst) : typeof(_inst);
				crispyThrowExpected(self, "captureLogs", "{CrispyLog|TestCase|TestSuite}", _type);
				break;
		}
	}

	/**
	 * Adds TestSuite to array of suites
	 * @function add_test_suite
	 * @param {TestSuite} suite - TestSuite to add
	 */
	static add_test_suite = function(_suite) {
		var _inst = instanceof(_suite);
		if _inst != "TestSuite" {
			var _type = !is_undefined(_inst) ? _inst : typeof(_inst);
			crispyThrowExpected(self, "add_test_suite", "TestSuite", _type);
		}
		_suite.parent = self;
		array_push(suites, _suite);
	}

	/**
	 * Creates a horizontal row string
	 * @function hr
	 * @param [string="-"] srt - String to concat n times
	 * @param [real=70] count - Number of times to concat _str.
	 * @returns {string} String of horizontal row
	 */
	static hr = function() {
		var _str = (argument_count > 0 && is_string(argument[0])) ? argument[0] : "-";
		var _count = (argument_count > 1 && is_real(argument[1])) ? max(0, round(argument[1])) : 70;
		var _hr = "";
		repeat(_count) {
			_hr += _str;
		}
		return _hr;
	}

	/**
	 * Runs test suites and logs results
	 * @function run
	 */
  	static run = function() {
		setup();
		var _len = array_length(suites);
		for(var i = 0; i < _len; i++) {
			on_run_begin();
			suites[i].run();
			captureLogs(suites[i]);
			on_run_end();
		}
		teardown();
	}

	/**
	 * Clears logs, starts timer, and runs __setUp__
	 * @function setup
	 * @param [method] func - Method to override __setUp__ with
	 */
	static setup = function() {
		if argument_count > 0 {
			var _func = argument[0];
			if is_method(_func) {
				__setUp__ = method(self, _func);
			} else {
				crispyThrowExpected(self, "setup", "method", typeof(_func));
			}
		} else {
			logs = [];
			start_time = crispyGetTime();
			if is_method(__setUp__) {
				__setUp__();
			}
		}
	}

	/**
	 * Function ran after test, used to clean up test
	 * @function teardown
	 * @param [method] func - Method to override __tearDown__ with
	 */
	static teardown = function() {
		if argument_count > 0 {
			var _func = argument[0];
			if is_method(_func) {
				__tearDown__ = method(self, _func);
			} else {
				crispyThrowExpected(self, "teardown", "method", typeof(_func));
			}
		} else {
			// Get total run time
			stop_time = crispyGetTime();
			total_time = crispyGetTimeDiff(start_time, stop_time);
			display_time = crispyTimeConvert(total_time);

			// Display silent test results
			var _passed_tests = 0;
			var _len = array_length(logs);
			var _t = "";
			for(var i = 0; i < _len; i++) {
				if logs[i].pass {
					_t += CRISPY_PASS_MSG_SILENT;
				} else {
					_t += CRISPY_FAIL_MSG_SILENT;
				}
			}
			output(_t);

			// Horizontal row
			output(hr());

			// Show individual log messages
			for(var i = 0; i < _len; i++) {
				if logs[i].pass {
					_passed_tests += 1;
				}
				var _msg = logs[i].getMsg();
				if _msg != "" {
					output(_msg);
				}
			}

			// Finish by showing entire time it took to run the tests
			var _string_tests = _len == 1 ? "test" : "tests";
			output("");
			output(string(_len) + " " + _string_tests + " ran in " + display_time + "s");

			if _passed_tests == _len {
				output(string_upper(CRISPY_PASS_MSG_VERBOSE));
			} else {
				show_message(string_upper(CRISPY_FAIL_MSG_VERBOSE) + "ED (failures==" + string(_len - _passed_tests) + ")");
			}

			if is_method(__tearDown__) {
				__tearDown__();
			}
			
		}

	}

	/**
	 * Function for discovering individual test functions within
	 * 		scripts, and adds them to a TestSuite
	 * @function discover
	 * @param [test_suite=undefined] test_suite - TestSuite to add
	 * 		discovered test script to, else create a temporary TestSuite
	 * @param [string="test_"] script_name_start - String that script
	 * 		functions need to start with in order to be discoverable
	 */
	static discover = function(_test_suite, _script_start_pattern="test_") {
		var _created_test_suite = is_undefined(_test_suite);
		// Throw error if function pattern is not a string
		if !is_string(_script_start_pattern) {
			crispyThrowExpected(self, "_script_start_pattern", "string", typeof(_script_start_pattern));
		}
		// Throw error if function pattern is an empty string
		if _script_start_pattern == "" {
			throw(name + ".discover() argument 'script_start_pattern' cannot be an empty string.");
		}
		// If value is passed for test_suite
		if !is_undefined(_test_suite) {
			if instanceof(_test_suite) != "TestSuite" {
				crispyThrowExpected(self, "test_suite", "[TestSuite|undefined]", typeof(_test_suite));
			}
			// Throw error if test_suite was not previously added to test_runner
			if _test_suite.parent != self {
				throw(name + ".discover() argument '_test_suite' parent is not self. _test_suite may not have been added to " + self.name + " prior to running 'discover()'.");
			}
		} else {
			_test_suite = new TestSuite("__discovered_test_suite__");
		}
		var _len = string_length(_script_start_pattern);
		for(var i = 100000; i < 110000; i++) {
			if script_exists(i) {
				var _script_name = script_get_name(i);
				if string_pos(_script_start_pattern, _script_name) == 1 && string_length(_script_name) > _len {
					if CRISPY_DEBUG && CRISPY_VERBOSITY {
						crispyDebugMessage("Discovered test script: " + _script_name + " (" + string(i) + ").");
					}
					var _test_case = new TestCase(_script_name, function(){});
					_test_case.__discover__(i);
					_test_suite.add_test_case(_test_case);
				}
			}
		}
		if _created_test_suite {
			if array_length(_test_suite.tests) == 0 {
				delete _test_suite;
				if CRISPY_DEBUG && CRISPY_VERBOSITY == 2 {
					crispyDebugMessage(name + ".discover() local TestSuite deleted.");
				}
			} else {
				add_test_suite(_test_suite);
				if CRISPY_DEBUG && CRISPY_VERBOSITY == 2 {
					crispyDebugMessage(name + ".discover() local TestSuite added: " + _test_suite.name);
				}
			}
		}
	}

	/**
	 * Pass input to __output__ if string. Overwrite __output__ if method
	 * @function output
	 * @param {string|method} input - String to output or function to
	 * 		overwrite __output__
	 */
	static output = function() {
		var _input = (argument_count > 0) ? argument[0] : undefined;
		if argument_count > 0 {
			switch (typeof(_input)) {
				case "string":
						__output__(_input);
					break;
				case "method":
						__output__ = method(self, _input);
					break;
				default:
					crispyThrowExpected(self, "input", "{string|method}", typeof(_input));
					break;
			}
		} else {
			throw(name + ".output() expected 1 argument, received " + string(argument_count) + " arguments.");
		}
	}

	/**
	 * Function that gets called on output
	 * @function __output__
	 * @param {string} message - By default, outputs string to Output Console
	 * @tip This function can be overwritten by a function passed into
	 * 		the output function
	 */
	static __output__ = function(_message) {
		show_debug_message(_message);
	}
	
	/**
	 * Run struct unpacker if unpack argument was provided
	 * Stays after all variables are initialized so it may be overwritten
	 */
	if argument_count > 1 {
		crispyStructUnpack(argument[1]);
	}

}
function TestSuite(_name) : BaseTestClass(_name) constructor {
	/**
	 * Testing suite that holds tests
	 * @constructor TestSuite
	 * @param {string} name - Name of suite
	 * @param [struct] unpack - Struct for crispyStructUnpack
	 */
	parent = undefined;
	tests = [];
	
	
	/**
	 * Adds test case to array of cases
	 * @function add_test_case
	 * @param {TestCase} case - TestCase to add
	 */
	static add_test_case = function(_case) {
		var _inst = instanceof(_case);
		if _inst != "TestCase" {
			var _type = !is_undefined(_inst) ? _inst : typeof(_case);
			crispyThrowExpected(self, "add_test_case", "TestCase", _type);
		}
		_case.parent = self;
		array_push(tests, _case);
	}

	/**
	 * Event that runs before all tests to set up variables
	 * Can also overwrite __setUp__
	 * @function setup
	 * @param {method} func - Function to overwrite __setUp__
	 */
	static setup = function() {
		if argument_count > 0 {
			var _func = argument[0];
			if is_method(_func) {
				__setUp__ = method(self, _func);
			} else {
				crispyThrowExpected(self, "setup", "method", typeof(_func));
			}
		} else {
			if is_method(__setUp__) {
				__setUp__();
			}
		}
	}

	/**
	 * Event that runs after all tests to clean up variables
	 * Can also overwrite __tearDown__
	 * @function teardown
	 * @param {method} func - Function to overwrite __tearDown__
	 */
	static teardown = function() {
		if argument_count > 0 {
			var _func = argument[0];
			if is_method(_func) {
				__tearDown__ = method(self, _func);
			} else {
				crispyThrowExpected(self, "teardown", "method", typeof(_func));
			}
		} else {
			if is_method(__tearDown__) {
				__tearDown__();
			}
		}
	}

	/**
	 * Runs tests
	 * @function run
	 */
	static run = function() {
		log("<crispy> " + name);
		
		/// Setup
		log("setup() started.");
		setup();
		log("setup() completed.");
		
		/// Tests
		log("tests[] started.");
		var _len = array_length(tests);
		for(var i = 0; i < _len; i++) {
			log("\ntest: " + tests[i].name + " begin.");
			on_run_begin();
			tests[i].run();
			on_run_end();
			log("test end.");
		}
		log("\ntests[] completed.");
		
		/// Teardown
		log("teardown() started.");
		teardown();
		log("teardown() completed.");
	}

	/**
	 * Run struct unpacker if unpack argument was provided
	 * Stays after all variables are initialized so it may be overwritten
	 */
	if argument_count > 1 {
		crispyStructUnpack(argument[1]);
	}

}
function TestCase(_name, _func) : BaseTestClass(_name) constructor {
	/**
	 * Creates a Test case object to run assertions
	 * @constructor TestCase
	 * @param {string} name - Name of case
	 * @param {method} func - Test assertion to run for TestCase
	 * @param [struct] unpack - Struct for crispyStructUnpack
	 */
	if !is_method(_func) {
		crispyThrowExpected(self, "", "method", typeof(_func));
	}

	class = instanceof(self);
	parent = undefined;
	test = undefined;
	logs = [];
	__is_discovered__ = false;
	__discovered_script__ = undefined;
	createTestMethod(_func);

	/**
	 * Turns a function into a method variable for the test.
	 * @function createTestMethod
	 * @param {method} func - Function to turn into a method variable
	 */
	static createTestMethod = function(_func) {
		if !is_method(_func) {
			crispyThrowExpected(self, "createMethodVariable", "method", typeof(_func));
		}
		test = method(self, _func);
	}

	/**
	 * Adds a Log to the array of logs
	 * @function addLog
	 * @param {struct} log - Log struct
	 */
	static addLog = function() {
		var _log = (argument_count > 0) ? argument[0] : undefined;
		array_push(logs, _log);
	}

	/**
	 * Clears array of Logs
	 * @function clearLogs
	 */
	static clearLogs = function() {
		logs = [];
	}

	/**
	 * Test that first and second are equal
	 * The first and second will be checked for the same type first, then check if they're equal
	 * @function assert_equals
	 * @param {*} first - First value
	 * @param {*} second - Second value to check against _first
	 * @param [string] message - Custom message to output on failure
	 */
	static assert_equals = function() {
		// Check supplied arguments
		if argument_count < 2 {
			show_error("assert_equals expects 2 arguments, got " + string(argument_count) + ".", true);
		}
		var _first = argument[0];
		var _second = argument[1];
		var _message = (argument_count > 2) ? argument[2] : undefined;
		if !is_string(_message) && !is_undefined(_message) {
			crispyThrowExpected(self, "assert_equals", "string", typeof(_message));
		}
		// Check types of first and second
		if typeof(_first) != typeof(_second) {
			addLog(new CrispyLog(self, {
				pass: false,
				msg: "Supplied value types are not equal: " + typeof(_first) + " and " + typeof(_second) + ".",
			}));
			return;
		}
		if _first == _second {
			addLog(new CrispyLog(self), {
				pass: true,
			});
		} else {
			addLog(new CrispyLog(self, {
				pass: false,
				msg: _message,
				helper_text: "first and second are not equal: " + string(_first) + ", " + string(_second)
			}));
		}
	}

	/**
	 * Test that first and second are not equal
	 * @function assert_not_equal
	 * @param {*} first - First type to check
	 * @param {*} second - Second type to check against
	 * @param [string] message - Custom message to output on failure
	 */
	static assert_not_equal = function() {
		// Check supplied arguments
		if argument_count < 2 {
			show_error("assert_not_equal expects 2 arguments, got " + string(argument_count) + ".", true);
		}
		var _first = argument[0];
		var _second = argument[1];
		var _message = (argument_count > 2) ? argument[2] : undefined;
		if !is_string(_message) && !is_undefined(_message) {
			crispyThrowExpected(self, "assert_equals", "string", typeof(_message));
		}
		if _first != _second {
			addLog(new CrispyLog(self, {
				pass: true,
			}));
		} else {
			addLog(new CrispyLog(self, {
				pass: false,
				msg: _message,
				helper_text: "first and second are equal: " + string(_first) + ", " + string(_second),
			}));
		}
	}

	/**
	 * Test whether the provided expression is true
	 * The test will first convert the expression to a boolean, then check if it equals true
	 * @function assert_true
	 * @param {*} expr - Expression to check
	 * @param [string] message - Custom message to output on failure
	 */
	static assert_true = function() {
		// Check supplied arguments
		if argument_count < 1 {
			show_error("assert_true expects 1 argument, got " + string(argument_count) + ".", true);
		}
		var _expr = argument[0];
		var _message = (argument_count > 1) ? argument[1] : undefined;
		if !is_string(_message) && !is_undefined(_message) {
			crispyThrowExpected(self, "", "string", typeof(_message));
		}
		try {
			var _bool = bool(_expr);
		}
		catch(err) {
			addLog(new CrispyLog(self, {
				pass: false,
				helper_text:"Unable to convert " + typeof(_expr) + " into boolean. Cannot evaluate.",
			}));
			return;
		}
		if _bool == true {
			addLog(new CrispyLog(self, {
				pass: true,
			}));
		} else {
			addLog(new CrispyLog(self, {
				pass: false,
				msg: _message,
				helper_text: "Expression is not true."
			}));
		}
	}

	/**
	 * Test whether the provided expression is false
	 * The test will first convert the expression to a boolean, then check if it equals false
	 * @function assert_false
	 * @param {*} expr - Expression to check
	 * @param [string] message - Custom message to output on failure
	 */
	static assert_false = function() {
		// Check supplied arguments
		if argument_count < 1 {
			show_error("assert_false expects 1 argument, got " + string(argument_count) + ".", true);
		}
		var _expr = argument[0];
		var _message = (argument_count > 1) ? argument[1] : undefined;
		if !is_string(_message) && !is_undefined(_message) {
			crispyThrowExpected(self, "", "string", typeof(_message));
		}
		try {
			var _bool = bool(_expr);
		}
		catch(err) {
			addLog(new CrispyLog(self, {
				pass: false,
				helper_text: "Unable to convert " + typeof(_expr) + " into boolean. Cannot evaluate.",
			}));
			return;
		}
		if _bool == false {
			addLog(new CrispyLog(self, {
				pass: true,
			}));
		} else {
			addLog(new CrispyLog(self, {
				pass: false,
				msg: _message,
				helper_text: "Expression is not false.",
			}));
		}
	}

	/**
	 * Test whether the provided expression is noone
	 * @function assert_noone
	 * @param {*} expr - Expression to check
	 * @param [string] message - Custom message to output on failure
	 */
	static assert_noone = function() {
		// Check supplied arguments
		if argument_count < 1 {
			show_error("assert_noone expects 1 argument, got " + string(argument_count) + ".", true);
		}
		var _expr = argument[0];
		var _message = (argument_count > 1) ? argument[1] : undefined;
		if !is_string(_message) && !is_undefined(_message) {
			crispyThrowExpected(self, "", "string", typeof(_message));
		}
		if _expr == -4 {
			addLog(new CrispyLog(self, {
				pass: true,
			}));
		} else {
			addLog(new CrispyLog(self, {
				pass: false,
				msg: _message,
				helper_text: "Expression is not noone.",
			}));
		}
	}

	/**
	 * Test whether the provided expression is not noone
	 * @function assert_not_noone
	 * @param {*} expr - Expression to check
	 * @param [string] message - Custom message to output on failure
	 */
	static assert_not_noone = function() {
		// Check supplied arguments
		if argument_count < 1 {
			show_error("assert_not_noone expects 1 argument, got " + string(argument_count) + ".", true);
		}
		var _expr = argument[0];
		var _message = (argument_count > 1) ? argument[1] : undefined;
		if !is_string(_message) && !is_undefined(_message) {
			crispyThrowExpected(self, "", "string", typeof(_message));
		}
		if _expr != -4 {
			addLog(new CrispyLog(self, {
				pass: true,
			}));
		} else {
			addLog(new CrispyLog(self, {
				pass: false,
				msg: _message,
				helper_text: "Expression is noone.",
			}));
		}
	}

	/**
	 * Test whether the provided expression is undefined
	 * @function assert_undefined
	 * @param {*} expr - Expression to check
	 * @param [string] message - Custom message to output on failure
	 */
	static assert_undefined = function() {
		// Check supplied arguments
		if argument_count < 1 {
			show_error("assert_undefined expects 1 argument, got " + string(argument_count) + ".", true);
		}
		var _expr = argument[0];
		var _message = (argument_count > 1) ? argument[1] : undefined;
		if !is_string(_message) && !is_undefined(_message) {
			crispyThrowExpected(self, "", "string", typeof(_message));
		}
		if is_undefined(_expr) {
			addLog(new CrispyLog(self, {
				pass: true,
			}));
		} else {
			addLog(new CrispyLog(self, {
				pass: false,
				msg: _message,
				helper_text: "Expression is not undefined."
			}));
		}
	}

	/**
	 * Test whether the provided expression is not undefined
	 * @function assert_not_undefined
	 * @param {*} expr - Expression to check
	 * @param [string] message - Custom message to output on failure
	 */
	static assert_not_undefined = function() {
		// Check supplied arguments
		if argument_count < 1 {
			show_error("assert_not_undefined expects 1 argument, got " + string(argument_count) + ".", true);
		}
		var _expr = argument[0];
		var _message = (argument_count > 1) ? argument[1] : undefined;
		if !is_string(_message) && !is_undefined(_message) {
			crispyThrowExpected(self, "", "string", typeof(_message));
		}
		if !is_undefined(_expr) {
			addLog(new CrispyLog(self, {
				pass: true,
			}));
		} else {
			addLog(new CrispyLog(self, {
				pass: false,
				msg: _message,
				helper_text: "Expression is undefined.",
			}));
		}
	}


	/**
	 * Function ran before test, used to set up test
	 * @function setup
	 * @param [method] func - Method to override __setUp__ with
	 */
	static setup = function() {
		if argument_count > 0 {
			var _func = argument[0];
			if is_method(_func) {
				__setUp__ = method(self, _func);
			} else {
				crispyThrowExpected(self, "setup", "method", typeof(_func));
			}
		} else {
			clearLogs();
			if is_method(__setUp__) {
				__setUp__();
			}
		}
	}
	
	/**
	 * Function ran after test, used to clean up test
	 * @function teardown
	 * @param [method] func - Method to override __tearDown__ with
	 */
	static teardown = function() {
		if argument_count > 0 {
			var _func = argument[0];
			if is_method(_func) {
				__tearDown__ = method(self, _func);
			} else {
				crispyThrowExpected(self, "teardown", "method", typeof(_func));
			}
		} else {
			if is_method(__tearDown__) {
				__tearDown__();
			}
		}
	}

	/**
	 * Set of functions to run in order for the test
	 * @function run
	 */
	static run = function() {
		var _object_count_1 = objects_count();		
		
		setup();
		on_run_begin();
		test();
		on_run_end();
		teardown();
		
		var _object_count_2 = objects_count();
		var _count_data = objects_count_equal(_object_count_1, _object_count_2);
		if (!_count_data.equals) {
			var _object_index = _count_data.data.object_index;
			var _count_delta  = _count_data.data.count_delta;
			var _sign_string  = _count_data.data.count_sign == 1 ? "excess" : "less";
			var _msg = "<MEMORY_LEAK> in unit_test: " + name + ".\n" + 
				string(_count_delta) + " " + _sign_string + " instance(s) of {" + object_get_name(_object_index) + "}\n" +
				"Make sure to destroy instances in ut_*.teardown()";
			log("<crispy> " + _msg);
			log(_msg);
		}
	}

	/**
	 * Sets up a discovered script to use as the test
	 * @function __discover__
	 * @param {real} script - ID of script
	 * @returns {struct} self
	 */
	static __discover__ = function(_script) {
		if !is_real(_script) {
			crispyThrowExpected(self, "__discovered__", "real", typeof(_script));
		}
		__discovered_script__ = _script;
		__is_discovered__ = true;
		createTestMethod(function() {__discovered_script__()});
		return self;
	}

	/**
	 * Run struct unpacker if unpack argument was provided
	 * Stays after all variables are initialized so it may be overwritten
	 */
	if argument_count > 2 {
		crispyStructUnpack(argument[2]);
	}

}
function BaseTestClass(_name) {
	/**
	 * Base "class" that test constructors will inherit from
	 * @constructor BaseTestClass
	 * @param {string} name - Name of class
	 */
	name = undefined;
	static setup = undefined;
	static __setUp__ = undefined;
	static teardown = undefined;
	static __tearDown__ = undefined;
	static __onRunBegin__ = undefined
	static __onRunEnd__ = undefined
	setName(_name);

	// Give self cripsyStructUnpack() function
	crispyMixinStructUnpack(self);


	/**
	 * Set name of class object
	 * @function setName
	 * @param {string} name - Name of the object
	 */
	static setName = function(_name) {
		if !is_string(_name) {
			crispyThrowExpected(self, "setName", "string", typeof(_name));
		}
		name = _name;
	}

	/**
	 * Event to be called at the beginning of run
	 * @function on_run_begin
	 * @param [method] func - Method to override __onRunBegin__ with
	 */
	static on_run_begin = function() {
		if argument_count > 0 {
			var _func = argument[0];
			if is_method(_func) {
				__onRunBegin__ = method(self, _func);
			} else {
				crispyThrowExpected(self, "on_run_begin", "method", typeof(_func));
			}
		} else {
			if is_method(__onRunBegin__) {
				__onRunBegin__();
			}
		}
	}

	/**
	 * Event to be called at the end of run
	 * @function on_run_end
	 * @param [method] func - Method to override __onRunEnd__ with
	 */
	static on_run_end = function() {
		if argument_count > 0 {
			var _func = argument[0];
			if is_method(_func) {
				__onRunEnd__ = method(self, _func);
			} else {
				crispyThrowExpected(self, "on_run_end", "method", typeof(_func));
			}
		} else {
			if is_method(__onRunEnd__) {
				__onRunEnd__();
			}
		}
	}

}

#endregion
