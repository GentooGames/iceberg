#macro RUN_TESTS 0 

global.___system_unit_test = {
    test_suites: {
        object_onCreate: {
            run:      true,
            setup:    function() {
				object = instance_create_depth(0, 0, 0, objp_object);
			},
            teardown: function() {
				instance_destroy(object);
				object = null;
			},
            tests: [
				ut_object_onCreate_setEventId,
            ],
        },
    },
    run_tests: test_builder,
};
#macro UNIT_TEST global.___system_unit_test

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
