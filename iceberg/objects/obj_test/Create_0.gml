/// @desc obj_test : Create

event_inherited();

setup  = method_inherit(setup, function() {
	/// @func setup()
	///
	
	coop = new Coop()
		.add_component(new Actionable(), "fsm")
		//.add_component(new Moveable())
		//.add_component(new Scriptable(), "hello_world")
		//.add_component(new Scriptable())
	
	//show_message(coop.__generic_components);
	var _fsm = coop.get_component("fsm");
	
	//var _test_state = "test_state_1";
	//fsm = new SnowState(_test_state);
	//fsm.add(_test_state, {
	//	enter: function() {},
	//	step:  function() {},
	//	leave: function() {},
	//});
	
	
	//coop = new Coop();
	//
	//coop.add_component(Publisher, "publisher1");
	//coop.add_component(Publisher, "publisher2");
	//
	//coop.execute_all(Publisher, "publish", { msg: "hello" });
	
})();
update = method_inherit(update, function() {
	/// @func update()
	///
	coop.update();
});