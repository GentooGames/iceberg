	
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	//  ______   ______   ______   ______    //
	// /\  == \ /\  __ \ /\  ___\ /\  ___\   //
	// \ \  __< \ \  __ \\ \___  \\ \  __\   //
	//  \ \_____\\ \_\ \_\\/\_____\\ \_____\ //
	//   \/_____/ \/_/\/_/ \/_____/ \/_____/ //
	//                                       //
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
	
	// search tags
	// ---- @IB_Docs.IB_Base
	// ---- @IB_Docs.Base
	// ---- @IB_Docs.Base_Constructor
		
	//	config = {
	//		owner:	 <ref>    default=other,
	//		guid:	 <string> default=generate_guid(),
	//		name:	 <string> default=generate_name(),
	//		uid:	 <string> default=generate_uid(),
	//		active:  <bool>	  default=true,
	//		visible: <bool>	  default=true,
	//	};
		
	// getters
	#region get_guid();
	#endregion
	#region get_name();
	#endregion
	#region get_owner();
	#endregion
	#region get_uid();
	#endregion
			
	// setters
	#region set_name(name);
	/*
		search tags
		--- @IB_Docs.IB_Base.set_name()
		--- @IB_Docs.Base.set_name()
		--- @IB_Docs.set_name()
	
		this method assigns a given name string to
		the constructor class instance. this name
		can be used for any desired functionality,
		typically it would be used for generating 
		a unique id to handle storing this instance
		within a data structure ( see .set_uid(); ),
		or to have a name string that can be easily
		displayed during rendering.
			
		param:	name
		type:	string
		desc:	name identifier string to assign
				to this class instance. if name
				was not set in the config struct,
				then the name will automatically
				be generated using the function:
					name = instanceof(self);
							
		example:
			var _panel = new GuiPanel();
			_panel.set_name("main_frame_1");
	*/
	#endregion
	#region set_owner(owner);
	/*
		search tags
		--- @IB_Docs.IB_Base.set_owner()
		--- @IB_Docs.Base.set_owner()
		--- @IB_Docs.set_owner()
		
		this method assigns a given owner reference
		to the constructor class instance. this owner
		reference is typically used for tracking 
		inheritance and association relationships, 
		and to delegate ownership.
			
		param:	owner
		type:	reference
		desc:	owner reference to assign to this
				class instance. if owner was not 
				set in the config struct, the the
				owner will be automatically assigned
				to the object that instantiated this
				class instance:
					owner = other;
							
		example:
			var _frame = new GuiFrame();
			var _panel = new GuiPanel();
			_panel.set_owner(_frame);
	*/
	#endregion
	#region set_uid(uid);
	#endregion
			
	// events
	#region activate(active);
	#endregion
	#region cleanup();
	#endregion
	#region deactivate();
	#endregion
	#region destroy();
	#endregion
	#region hide();
	#endregion
	#region initialize();
	#endregion
	#region render(visible);
	#endregion
	#region render_gui(visible);
	#endregion
	#region show(visible);
	#endregion
	#region update_begin(active);
	#endregion
	#region update(active);
	#endregion
	#region update_end(active);
	#endregion
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	