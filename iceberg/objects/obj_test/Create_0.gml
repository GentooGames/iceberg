/// @desc obj_test : Create
event_inherited();

/*	
	ToDo:
		-	test that move multiplier is limiting movement speet appropriately
		-	snap-to : way to define other Moveables to have hspd & vspd get values from
		-	entities weight
		-	general multiplier
		-	have component system process components
				-	if component system processing, do not check for is_active() within component, 
					checkout from outside from system
						// give each component a defined "loop" logic behavior 
						// establishing where to get processed in the component system
						// static __cycle	 = LIFE_CYCLE.STEP_BEGIN;
						// static __priority = 1;	
						// -- cycle defines where, priority defines when 
		-	freezing/locking components?
		-	how to handle conflicting MoveSet/MoveSpeed triggers happening at the same time?
			-	if MoveSpeed run is bound to vk_enter, and crouch is bound to vk_control, what happens when both are pressed?
*/

setup	 = method_inherit(setup,  function() {
	/// @func setup()
	///
	form = "human";
	new_component(MoveableTopDown);
	moveable = get_component(MoveableTopDown);
	
	/// MoveSpeeds
	moveable
		.set_movespeed("walk",   4.0)
		.set_movespeed("run",    8.0, function() {
			return keyboard_check(vk_enter);
		})
		.set_movespeed("crouch", 2.0, function() {
			return keyboard_check(vk_tab);
		})
		.set_movespeed_default("walk")
		.change_movespeed("walk")
	
	/// MoveSets
	moveable
		.set_moveset("dirt",  MOVESETS[$ MOVESET.DIRT ])
		.set_moveset("grass", MOVESETS[$ MOVESET.GRASS], function() {
			return collision_point(x, y, obj_terrain_grass, false, true) != noone;
		})
		.set_moveset("sand",  MOVESETS[$ MOVESET.SAND ], function() {
			return collision_point(x, y, obj_terrain_sand, false, true) != noone;
		})
		.set_moveset("ice",   MOVESETS[$ MOVESET.ICE  ], function() {
			return collision_point(x, y, obj_terrain_ice, false, true) != noone;
		})
		.set_moveset_default("dirt")
		.change_moveset("dirt")
	
})();
teardown = method_inherit(teardown, function() {
	/// @func teardown()
	///
});
update	 = method_inherit(update, function() {
	/// @func update()
	///
	static _speed = 5;
	if (INPUT.keyboard.button(vk_right)) x += _speed;
	if (INPUT.keyboard.button(vk_left))  x -= _speed;
	if (INPUT.keyboard.button(vk_down))  y += _speed;
	if (INPUT.keyboard.button(vk_up))    y -= _speed;
	
	moveable.update();
});
render	 = method_inherit(render, function() {
	/// @func render()
	///
	draw_circle_color(x, y, 20, c_red, c_red, false);
	
	var _current_name = moveable.has_moveset_current()
		? moveable.get_moveset_current().get_name()
		: "";
	draw_text_transformed(x, y, "set: " + _current_name, 0.8, 0.8, 0);
	draw_text_transformed(x, y + 15, "speed: " + moveable.get_movespeed().get_name(), 0.8, 0.8, 0);
});
	
