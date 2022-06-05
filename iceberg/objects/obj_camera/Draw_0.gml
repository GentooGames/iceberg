
var _z_from			= MAX_DEPTH - 1;
var _z_to			= _z_from * -1;
viewmat				= matrix_build_lookat(iota_pos_x, iota_pos_y, _z_from, iota_pos_x, iota_pos_y, _z_to, 0, 1, 0);
camera_set_view_mat	(cam, viewmat);
projmat				= matrix_build_projection_ortho(width * iota_zoom, height * iota_zoom, 1.0, 32000.0);
camera_set_proj_mat	(cam, projmat);
camera_apply		(cam);
view_camera[0]		= cam;