function EventObject(_name = "") {
	/// @func	EventObject(name*)
	/// @param	{string} name=""
	/// @return	{struct} event_instance
	///
	__event_instance  =  self;
	__event_publisher =  new Publisher();
	__event_name	  = _name;

	event_setup				= method(__event_instance, function() {
		/// @func	event_setup()
		/// @return	{struct} event_instance
		///
		return __event_instance;
	});
	event_update			= method(__event_instance, function() {
		/// @func	event_update()
		/// @return	{struct} event_instance
		///
		return __event_instance;
	});
	event_teardown			= method(__event_instance, function() {
		/// @func	event_teardown()
		/// @return	{struct} event_instance
		///
		return __event_instance;
	});
	////////////////////////////////////////////////////
	event_get_instance		= method(__event_instance, function() {
		/// @func	event_get_instance()
		/// @return	{struct} event_instance
		///
		return __event_instance;
	});
	event_get_publisher		= method(__event_instance, function() {
		/// @func	event_get_publisher()
		/// @return {Publisher} event_publisher
		///
		return __event_publisher;
	});
	event_get_context_name	= method(__event_instance, function() {
		/// @func	event_get_context_name()
		/// @return {string} event_name
		///
		return __event_name;
	});
	event_register			= method(__event_instance, function(_event_array, _push_to_global = false) {
		/// @func	event_register(event_array, push_to_global?)
		/// @param	{array}	 event_array
		/// @parma	{bool}	 push_to_global=false
		/// @return	{struct} event_instance
		///
		/// Cast And Normalize Argument To Array
		if (!is_array(_event_array)) {
			_event_array = [_event_array];	
		}
		/// Register Each Channel
		var _publisher = event_get_publisher();
		for (var _i = 0, _len = array_length(_event_array); _i < _len; _i++) {
			_publisher.register_channel(_event_array[_i]);
		}
		/// Send To Global?
		if (_push_to_global) {
			PUBLISHER.register(_event_array, false);
		}
		return __event_instance;
	});
	event_registered		= method(__event_instance, function(_event_name) {
		/// @func	event_registered(event_name)
		/// @param	{string}  event_name
		/// @return {boolean} event_is_registered?
		///
		var _publisher = event_get_publisher();
		return _publisher.has_registered_channel(_event_name);
	});
	event_publish			= method(__event_instance, function(_event_name, _payload = undefined, _push_to_global = false) {
		/// @func	 event_publish(event_name, payload*, push_to_global?*)
		/// @param	{string} event_name
		/// @param	{any}	 payload=undefined
		/// @param	{bool}	 push_to_global=false
		/// @return	{struct} event_instance
		///
		/*	<data_struct>: {
				id:		 self,
				payload: any,
			}
		*/
		var _publisher   = event_get_publisher();
		var _data_struct = {
			self:	  event_get_instance(),
			payload: _payload,
		}
		_publisher.publish(_event_name, _data_struct);
			
		if (_push_to_global) {
			PUBLISHER.publish(get_event_context_name() + "_" + _event_name, _data_struct, false);
		}
		return __event_instance;
	});
	event_subscribe			= method(__event_instance, function(_event_name, _callback, _weak_reference = false) {
		/// @func	event_subscribe(event_name, callback, weak_reference?)
		/// @param	{string}  event_name
		/// @param	{method}  callback_method
		/// @param	{boolean} weak_reference=false
		/// @return	{struct}  event_instance
		///
		var _publisher = event_get_publisher();
		_publisher.subscribe(_event_name, _callback, _weak_reference);
		return __event_instance;
	});
	event_unsubscribe		= method(__event_instance, function(_event_name, _force = false) {
		/// @func	event_unsubscribe(event_name, force?*)
		/// @param	{string}  event_name
		/// @parma	{boolean} force=false
		/// @return	{struct}  event_instance
		///
		var _publisher = event_get_publisher();
		_publisher.unsubscribe(_event_name, _force);
		return __event_instance;
	});
	event_clear_subscribers = method(__event_instance, function(_event_name) {
		/// @func	event_clear_subscribers(event_name)
		/// @param	{string} event_name
		/// @return	{struct} event_instance
		///
		var _publisher = event_get_publisher();
		_publisher.clear_channel(_event_name);
		return __event_instance;
	});	
	////////////////////////////////////////////////////
	event_setup(); /// <-- automatically invoke setup
	
	return __event_instance;
};
