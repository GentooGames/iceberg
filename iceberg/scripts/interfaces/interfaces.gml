function SaveObject(_save_id = undefined, _save_vars, _on_init = undefined) constructor {
	/// @func  SaveObject(save_id*, save_vars, on_init*)
	/// @param {string}   save_id=undefined
	/// @param {array}	  save_vars
	/// @param {Callback} on_init=undefined
	///
	__save_object_owner		= other;
	__save_object_save_id	= _save_id ?? __save_object_generate_id();
	__save_object_callbacks = {
		on_init: _on_init,
		on_load:  undefined,
	};
		
	#region Initialize Serializer
	
	__save_object_serializer = new Serializer(__save_object_owner, _save_vars)
		.add_lookup("state", 
			function(_id) {			// write translation
				return script_get_name(_id.state);
			},
			function(_asset_name) { // read  translation
				return asset_get_index(_asset_name);	
			})	
		
	#endregion
		
	/// Private Class Methods
	static __save_object_generate_id   = function() {
		static _delineator = __SC_SAVE_ID_DELINEATOR;
		with (__save_object_owner) {
			return (object_get_name(object_index) + _delineator
				+	string(x) + _delineator
				+	string(y) + _delineator
				+	string(depth) + _delineator
				+	string(layer_get_name(layer))
			);
		}
	};
	static __save_object_parse_id	   = function() {
		return string_parse_into_struct(
			__save_object_save_id,
			__SC_SAVE_ID_SUBSTRINGS,
			__SC_SAVE_ID_DELINEATOR,
		);
	};
	static __save_object_on_init	   = function() {
		if (__save_object_callbacks.on_init != undefined) {
			__save_object_callbacks.on_init();
		}
	};
	static __save_object_load		   = function(_load_data) {
		/// Search For Load Data Ourselves
		if (_load_data == undefined) {
			var _room_name	= room_get_name(room);
			var _room_data  = __SC_CONTROLLER.load_data.room_data[$ _room_name];
			var _save_id    = __save_object_get_save_id();
				_load_data  = _room_data[$ _save_id];
				
			if (_load_data == undefined) {
				log("ERROR loading for instance " 
					+ object_get_name(__save_object_owner.object_index) 
					+ ", unable to find associated load_data for save_id: " 
					+ string(__save_object_save_id)
					+ ", in the given room: "
					+ _room_name
				);
				exit;
			}
		}
		/// Cast Data To String If Necessary
		if (!is_string(_load_data)) {
			_load_data = json_stringify(_load_data);	
		}
		return __save_object_serializer.deserialize(_load_data);
	};
	static __save_object_get_save_id   = function() {
		return __save_object_save_id;
	};
	static __save_object_get_save_data = function() {
		return __save_object_serializer.serialize();
	};
	
	/// Public Class Methods
	static load		   = function(_load_data) {
		/// @func	load(load_data*)
		/// @param  {struct}	 load_data
		/// @return {SaveObject} self
		/// 
		return __save_object_load(_load_data);
	};
	static set_on_load = function(_on_load) {
		/// @func	set_on_load(on_load)
		/// @param	{method/function} on_load
		/// @return {SaveObject}	  self
		///
		__save_object_callbacks.on_load = _on_load;
		
		/// Bind on_load To Execute On Serializer.deserialize()
		__save_object_serializer.set_on_deserialize(
			method(__save_object_owner, _on_load)
		);
		return self;
	}
		
	/// Instance Methods
	__save_object_owner.load		  = method(self, function(_load_data) {
		return __save_object_load(_load_data);
	});
	__save_object_owner.get_save_id   = method(self, function() {
		return __save_object_get_save_id();
	});
	__save_object_owner.get_save_data = method(self, function() {
		return __save_object_get_save_data();
	});
	
	__save_object_on_init();
};
function EventObject(_context = self) {
	/// @func	EventObject(context*)
	/// @param	{struct/instance} context=self
	/// @return {struct/instance} context
	///
	with (_context) {
		/// Create A Publisher Instance
		__publisher = new Publisher();
		
		/// Associated Event Methods
		get_event_publisher		= method(self, function() {
			/// @func	get_event_publisher()
			/// @return {Publisher} publisher
			///
			return __publisher;
		});
		event_register			= method(self, function() {
			/// @func	event_register(event_name_1, ..., event_name_n)
			/// @param	{string} event_name
			/// @return	{Ui} self
			///
			for (var _i = 0; _i < argument_count; _i++) {
				get_event_publisher().register_channel(argument[_i]);
			}
			return self;
		});
		event_registered		= method(self, function(_event_name) {
			/// @func	event_registered(event_name)
			/// @param	{string}  event_name
			/// @return {boolean} event_is_registered?
			///
			return get_event_publisher().has_registered_channel(_event_name);
		});
		event_publish			= method(self, function(_event_name, _data = undefined) {
			/// @func	 event_publish(event_name, data*)
			/// @param	{string} event_name
			/// @param	{any}    data=undefined
			/// @return {Ui}	 self
			///
			get_event_publisher().publish(_event_name, _data);
			return self;
		});
		event_subscribe			= method(self, function(_event_name, _callback, _weak_reference = false) {
			/// @func	event_subscribe(event_name, callback, weak_reference?)
			/// @param	{string}  event_name
			/// @param	{method}  callback_method
			/// @param	{boolean} weak_reference?=false
			/// @return {Ui}	  self
			///
			get_event_publisher().subscribe(_event_name, _callback, _weak_reference);
			return self;
		});
		event_unsubscribe		= method(self, function(_event_name, _force = false) {
			/// @func	event_unsubscribe(event_name, force?*)
			/// @param	{string}  event_name
			/// @parma	{boolean} force?=false
			/// @return {Ui} self
			///
			get_event_publisher().unsubscribe(_event_name, _force);
			return self;
		});
		event_clear_subscribers = method(self, function(_event_name) {
			/// @func	event_clear_subscribers(event_name)
			/// @param	{string} event_name
			/// @return {Ui} self
			///
			get_event_publisher().clear_channel(_event_name);
			return self;
		});	
	}
	return _context;
};
