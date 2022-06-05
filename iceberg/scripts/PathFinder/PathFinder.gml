/// @func PathNode({finder, i, j, k, weight}) constructor
function PathNode(_data) constructor {
    /// @param	finder {PathFinder}
    /// @param	i      {real}
    /// @param	j      {real}
    /// @param	k      {real}
    /// @param	weight {real}
	/// @desc	DO NOT MANUALLY INSTANTIATE. INVOKE THROUGH PathFinder.new_node()
	/// @return self  {PathNode}
    ///
	path_finder = _data.finder;
	i			= _data.i;
	j			= _data.j;
	k			= _data.k;
	g_cost		= 0;
	h_cost		= 0;
	cell		= null;
	parent		= null;
	walkable	= true;
	weight		= _data.weight;
	
	static get_f_cost = function() {
		return g_cost + h_cost;
	};
};

/// @func PathFinder(width, height) constructor
function PathFinder(_width, _height) constructor {
    /// @param	width  {real}
    /// @param	height {real}
    /// @credit original Unity code written by Sebastian Lague
    ///			https://github.com/SebLague/Pathfinding.
	///			Ported to GameMaker by _gentoo_
	/// @return self {PathFinder}
    ///
    width      = _width;
    height     = _height;
	nodes	   = [];
	nodes_grid = array_create_nd(width, height);
	open_set   = [];
	closed_set = [];
	
	// Public
	static pathfind    = function(_instance, _node_start, _node_target) {
	    /// @func   pathfind(instance, node_start, node_target)
	    /// @param  instance    {instance}
	    /// @param  node_start  {PathNode}
	    /// @param  node_target {PathNode}
		/// @desc	...
	    /// @return nodes       {[PathNode]}
	    ///
		open_set   = [];
		closed_set = [];
		array_push(open_set, _node_start);
		while (array_length(open_set) > 0) {
			var _current_node = open_set[0];
			for (var _i = 1, _len = array_length(open_set); _i < _len; _i++) {
				if (open_set[_i].get_f_cost() < _current_node.get_f_cost() 
				|| (open_set[_i].get_f_cost() == _current_node.get_f_cost() 
					&& open_set[_i].h_cost < _current_node.h_cost)) {
						_current_node = open_set[_i];
				}	
			}
			array_find_delete(open_set, _current_node);
			array_push(closed_set, _current_node);
			
			if (_current_node == _node_target) {
				return _retrace_path(_node_start, _node_target);
			}
			var _neighbors = _get_neighbors(_current_node, false);
			for (var _i = 0, _len = array_length(_neighbors); _i < _len; _i++) {
				var _neighbor = _neighbors[_i];
				if (!_is_traversable(_instance, _current_node, _neighbor)) continue;
				if (array_contains(closed_set, _neighbor))				  continue;
				var _neighbor_dist			   = _get_distance(_current_node, _neighbor);
				var _new_move_cost_to_neighbor = _current_node.g_cost + _neighbor_dist + _neighbor.weight;
				if (_new_move_cost_to_neighbor < _neighbor.g_cost || !array_contains(open_set, _neighbor)) {
					_neighbor.g_cost = _new_move_cost_to_neighbor;
					_neighbor.h_cost = _get_distance(_neighbor, _node_target);
					_neighbor.parent = _current_node;
					if (!array_contains(open_set, _neighbor)) {
						array_push(open_set, _neighbor);	
					}
				}
			}
		}
	};
	static new_node    = function(_i, _j, _k, _weight) {
	    /// @func   new_node(i, j, k)
	    /// @param  i      {real}
	    /// @param  j      {real}
	    /// @param  k      {real}
	    /// @param  weight {real}
		/// @desc	...
	    /// @return node   {PathNode}
	    ///
	    return _add_node(new PathNode({
            finder: self, 
            i:      _i, 
            j:      _j, 
            k:      _k, 
            weight: _weight,
	    }));
	};
	static remove_index = function(_i, _j, _k) {
	    /// @func   remove_index(i, j, k)
	    /// @param  i {real}
	    /// @param  j {real}
	    /// @param  k {real}
		/// @desc	...
	    /// @return NA
	    ///
	    for (var _ii = 0, _len = array_length(nodes); _ii < _len; _ii++) {
	        var _node = nodes[_ii];
	        if (_node.i == _i && _node.j == _j && _node.k == _k) {
	            array_delete(nodes, _ii, 1);
	            nodes_grid[_i][_j] = EMPTY;
	            return;
	        }
	    }
	};
	static remove_node  = function(_node) {
	    /// @func   remove_node(node)
	    /// @param  node {PathNode}
		/// @desc	...
	    /// @return NA
	    ///
	    var _i = _node.i;
	    var _j = _node.j;
	    if (array_find_delete(nodes, _node)) {
	        nodes_grid[_i][_j] = EMPTY;
	    }
	};
	
	// Private
	static _is_traversable = function(_instance, _node_from, _node_to) {
	    /// @func   _is_traversable(instance, node_from, node_to)
	    /// @param  instance        {instance}
	    /// @param  node_from       {PathNode}
	    /// @param  node_to         {PathNode}
		/// @desc	...
	    /// @return is_traversable? {bool}
	    ///
		if (!_node_to.walkable) return false;
		//var _climb	  = _instance.get_climb();
		//var _movement = _instance.get_movement();
		//if (_movement != MOVE.FLY && (abs(_node_to.k - _node_from.k) > _climb)) {
		//	return false;
		//}
		return true;
	};
	static _get_neighbors  = function(_node, _diagonals = false) {
	    /// @func   _get_neighbors(node, diagonals?*<f>)
	    /// @param  node       {PathNode}
	    /// @param  diagonals? {bool}*<f>
		/// @desc	...
	    /// @return neighbors  {[PathNode]}
	    ///
		var _neighbors = [];
		var _coords    = (_diagonals)
			? [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, 1], [1, -1], [-1, -1], [1, 1]]
			: [[-1, 0], [1, 0], [0, -1], [0, 1]];
		
		for (var _i = 0, _len = array_length(_coords); _i < _len; _i++) {
			var _coord  = _coords[_i];
			var _node_i = _node.i + _coord[0];
			var _node_j = _node.j + _coord[1];
			if (_node_i >= 0 && _node_i < width && _node_j >= 0 && _node_j < height) {
			    var _node_adjacent  = nodes_grid[_node_i][_node_j];
			    if (_node_adjacent != EMPTY) {
				    array_push(_neighbors, _node_adjacent);
			    }
			}
		}
		return _neighbors;
	};
	static _get_distance   = function(_node1, _node2) {
	    /// @func   get_distance(node1, node2)
	    /// @param  node1 {PathNode}
	    /// @param  node2 {PathNode}
		/// @desc	...
	    /// @return dist  {real}
	    ///
		var _dist_i = abs(_node1.i - _node2.i);
		var _dist_j = abs(_node1.j - _node2.j);
		if (_dist_i > _dist_j) {
			return 14 * _dist_j + 10 * (_dist_i - _dist_j);	
		}
		return 14 * _dist_i + 10 * (_dist_j - _dist_i);
	};
	static _retrace_path   = function(_node_start, _node_target) {
	    /// @func   _retrace_path(node_start, node_target)
	    /// @param  node_start  {PathNode}
	    /// @param  node_target {PathNode}
		/// @desc	...
	    /// @return dist  {real}
	    ///
		var _path		  =  [];
		var _node_current = _node_target;
		
		while (_node_current != _node_start) {
			array_push(_path, _node_current);	
			_node_current = _node_current.parent;
		}
		_path = array_reverse(_path);
		return _path;
	};
	static _add_node       = function(_node) {
	    /// @func   add_node(node)
	    /// @param  node {PathNode}
		/// @desc	...
	    /// @return node {PathNode}
	    ///
		array_push(nodes, _node);
		nodes_grid[_node.i][_node.j] = _node;
		return _node;
	};
}
