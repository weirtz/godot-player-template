extends Control
class_name Console

func console():
	$text_onfloor.add_text("false")
	$text_fps.set_text("FPS: " + str(Engine.get_frames_per_second()))
	
	if $"../../PlayerMovement/Fly".flying == false:
		if $"../../PlayerMovement/Movement".running == true:
			$text_movement.set_text("Movement: Running")
		else:
			if $"../../PlayerMovement/Movement".standing == false: 
				$text_movement.set_text("Movement: Walking")
			else:
				$text_movement.set_text("Movement: Standing")
	else:
		$text_movement.set_text("Movement: Flying")
		
	$text_fov.set_text("FOV: " + str($"../../PlayerCamera".fov))
	$text_contact.set_text("Has contact(RayCast): " + str($"../../PlayerMovement/Movement".rayCast))
	$text_onfloor.set_text("Is on floor: " + str($"../../PlayerMovement/Movement".on_floor))
	$text_speed.set_text("Speed: " + str($"../../PlayerMovement/Movement".speed))
	