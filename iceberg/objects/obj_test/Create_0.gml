/// @desc obj_test : Create
event_inherited();
event_id = "test";

setup  = method_inherit(setup,  function() {
	/// @func setup()
	///
	//triggers = new Stash({
	//	name: "triggers",
	//});
	//triggers_add("test_trigger", "method()");
	//show_message(triggers_get("test_trigger"));
	//show_message(trigger_get_count());
	
	//var _self = self;
	//component = new Component();
	//interface = new Interface({ 
	//	owner:	  _self,
	//	name:	  "component", 
	//	component: component,
	//});
	//component_get_owner();
	
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
