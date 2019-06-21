extends Control
class_name Console


func console():
	$text_onfloor.add_text("false")
	$text_fps.set_text("FPS: " + str(Engine.get_frames_per_second()))
	if $"../../movement/fly".flying == false:
		if Input.is_action_pressed("move_sprint"):
			$text_movement.set_text("Movement: Running")
		else:
			$text_movement.set_text("Movement: Walking")
	else:
		$text_movement.set_text("Movement: Flying")
	$text_fov.set_text("FOV: " + str($"../../Player_Camera".fov))
	$text_contact.set_text("Has contact(RayCast): " + str($"../../movement/movement".has_contact))
	$text_onfloor.set_text("Is on floor: " + str($"../../movement/movement".on_floor))
	$text_speed.set_text("Speed: " + str($"../../movement/movement".speed))
	