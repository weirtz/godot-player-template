		extends Control
var MOVEMENT = load("res://scripts/player/movement.gd").new()
var FLY = load("res://scripts/player/fly.gd").new()


func console():

	$text_fps.set_text("FPS: " + str(Engine.get_frames_per_second()))
	if FLY.flying == false:
		if Input.is_action_pressed("move_sprint"):
			$GUI/console/text_movement.set_text("Movement: Running")
		else:
			$GUI/console/text_movement.set_text("Movement: Walking")
	else:
		$GUI/console/text_movement.set_text("Movement: Flying")
	$GUI/console/text_fov.set_text("FOV: " + str($Player_Camera.fov))
	$GUI/console/text_contact.set_text("Has contact(RayCast): " + str(MOVEMENT.has_contact))
	$GUI/console/text_onfloor.set_text("Is on floor: " + str(MOVEMENT.on_floor))
	$GUI/console/text_speed.set_text("Speed: " + str(MOVEMENT.speed))
	