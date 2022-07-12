/// @desc obj_test : Create
event_inherited();

setup  = method_inherit(setup,  function() {
	/// @func setup()
	///
	
	stash = new Stash();
	stash.add("entry_1", 10);
	show_message(stash.get("entry_1"));
	stash.add("entry_1", 20);
	stash.add("entry_1", 40);
	show_message(stash.get("entry_1"));
	stash.remove("entry_1", 20);
	show_message(stash.get("entry_1"));
	stash.remove("entry_1");
	show_message(stash.get("entry_1"));
	//show_message(stash.get_count());
	
	//components = new Components();
	
	//coop = new Coop()
	//	//.add_component(new Actionable(), "fsm")
	//	.add_component(new Moveable())
		
	//coop.get_component("fsm")
	//	.actionable_state_add("test_state", {
	//		enter: function() {},
	//		step:  function() {},
	//		leave: function() {},
	//		draw:  function() {},
	//	})
		
	//coop.get_component("Moveable")
	//	.moveset_new("default", {
	//		speed: 4.0,
	//		accel: 0.5,
	//		fric:  0.3,
	//	})
	//	.moveset_new("ice", {
	//		speed: 6.0,
	//		accel: 0.2, 
	//		fric:  0.1, 
	//	})
		
})();
update = method_inherit(update, function() {
	/// @func update()
	///
	
	//coop.update();
});
render = method_inherit(render, function() {
	/// @func render()
	///
	
	//coop.render();
});
