extends Control
class_name Console



func console():
	$text_onfloor.add_text("false")
	$text_fps.set_text("FPS: " + str(Engine.get_frames_per_second()))
	
	var playerMove = get_owner().get_node("PlayerMovement/Movement")
	var playerFly = get_owner().get_node("Playermovement/Fly")

	if playerFly.flying == false:
		if playerMove.running == true:
			$text_movement.set_text("Movement: Running")
		else:
			if playerMove.standing == false: 
				$text_movement.set_text("Movement: Walking")
			else:
				$text_movement.set_text("Movement: Standing")
	else:
		$text_movement.set_text("Movement: Flying")
		
	$text_fov.set_text("FOV: " + str(get_owner().get_node("PlayerCamera").fov))
	$text_contact.set_text("Has contact(RayCast): " + str(playerMove.rayCast))
	$text_onfloor.set_text("Is on floor: " + str(playerMove.on_floor))
	$text_speed.set_text("Speed: " + str(playerMove.speed))
	