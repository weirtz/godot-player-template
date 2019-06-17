		extends KinematicBody
#--------------------
# General Variables
var velocity = Vector3()
var direction = Vector3()
var camera_change = Vector2()
#--------------------
# Mouse
var mouse_sensitivity = 0.1
var camera_angle = 0
#--------------------
# Walking
var gravity = -9.8 * 2
const MAX_SPEED = 4
const MAX_RUNNING_SPEED = 8
const ACCELERATION = 2
const DEACCELERATION = 20
var speed = MAX_SPEED
#--------------------
# Movement
var current_jumps = 0
#max jumps of 0 will give you 2 jumps aka double jump
var max_jumps = 0
const JUMP_HEIGHT = 6
var crouch
var has_contact = false
#--------------------
# Flying
const FLY_SPEED = 10
const FLY_ACCELERATION = 4
const FLY_DEACCELERATION = 10
var flying = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _process(delta):
	console()
func _physics_process(delta):
#Fly Mode Toggle
	aim()
	if Input.is_action_just_pressed("fly"):
		flying = !flying
	if flying:
		speed = MAX_SPEED
		$Player_Camera.fov = 64
		fly(delta)
	else:
		walk(delta)
		
func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative
#-------------------------------------------
#Walking Function---------------------------
#-------------------------------------------
func walk(delta):
	#Reset the direction of the player
	direction = Vector3()
	#Get rotation of camera
	var aim = $Player_Camera.get_global_transform().basis
	
	if(Input.is_action_pressed("move_fw")):
		direction -= aim.z
		if(Input.is_action_just_pressed("move_fw")):
			$audio/walking._set_playing(true)
	else:
		$audio/walking.stop()
	if(Input.is_action_pressed("move_bw")):
		direction += aim.z
	if(Input.is_action_pressed("move_l")):
		direction -= aim.x
	if(Input.is_action_pressed("move_r")):
		direction += aim.x
		
	direction = direction.normalized()
	
	#Double Verification if on floor, handles walking on slopes
	if is_on_floor():
		has_contact = true
	else:
		if !$RayCast.is_colliding():
			has_contact = false
	if has_contact and !is_on_floor():
		move_and_collide(Vector3(0,-1, 0))
	
	velocity.y += gravity * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	
	
	var fov = $Player_Camera.fov

	#if Input.is_action_just_pressed("move_sprint"):
	#	
		
	#if Input.is_action_just_released("move_sprint"):
	#	$Player_Camera.fov = fov - 5
	
	if Input.is_action_just_pressed("move_sprint"):
		speed = MAX_RUNNING_SPEED
		$Player_Camera.fov = 68
	if Input.is_action_just_released("move_fw"):
		speed = MAX_SPEED
		$Player_Camera.fov = 64
#	if Input.is_action_just_released("move_sprint"):
#		speed = MAX_RUNNING_SPEED
#		$Player_Camera.fov = fov + 5
	
	#Where would the player go at max speed
	var target = direction * speed
	
	var acceleration
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCELERATION
	else:
		acceleration = DEACCELERATION
	#calculate a portion of the disatance to go	
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	if has_contact and Input.is_action_just_pressed("move_jump") && max_jumps >= current_jumps:
		velocity.y = JUMP_HEIGHT
		$audio/jump.play() 
		current_jumps = current_jumps + 1
		
		has_contact = false
	
	if is_on_floor() == true:
		current_jumps = 0
	
	
	#move
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	

	

		
	if Input.is_action_pressed("move_squat"):
		crouch = $Player_Camera.get_global_transform().basis
		direction -= crouch.y
		
	
func fly(delta):
			#Reset the direction of the player
	direction = Vector3()
	#Get rotation of camera
	var aim = $Positioning.get_global_transform().basis

	if(Input.is_action_pressed("move_fw")):
		direction -= aim.z
	if(Input.is_action_pressed("move_bw")):
		direction += aim.z
	if(Input.is_action_pressed("move_l")):
		direction -= aim.x
	if(Input.is_action_pressed("move_r")):
		direction += aim.x
	if(Input.is_action_pressed("move_squat")):
		direction -= aim.y * 1.5
	if(Input.is_action_pressed("move_jump")):
		direction += aim.y * 1.5
		
	direction = direction.normalized()
	#Where would the player go at max speed
	var target = direction * FLY_SPEED
	#calculate a portion of the disatance to go	


	
	var fly_acceleration
	var temp_velocity = velocity
	if direction.dot(temp_velocity) > 0:
		fly_acceleration = FLY_ACCELERATION
	else:
		fly_acceleration = FLY_DEACCELERATION
	#calculate a portion of the disatance to go	
	velocity = velocity.linear_interpolate(target, fly_acceleration * delta)
	
	#move
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	
func aim():
	if camera_change.length() > 0 :
		#$Player_Camera.rotate_y
		rotate_y(deg2rad(-camera_change.x * mouse_sensitivity))
	
		var change = -camera_change.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Player_Camera.rotate_x(deg2rad(change))
			camera_angle += change
		camera_change = Vector2()

func console():
	$GUI/console/text_fps.set_text("FPS: " + str(Engine.get_frames_per_second()))
	if flying == false:
		if Input.is_action_pressed("move_sprint"):
			$GUI/console/text_movement.set_text("Movement: Running")
		else:
			$GUI/console/text_movement.set_text("Movement: Walking")
	else:
		$GUI/console/text_movement.set_text("Movement: Flying")
	$GUI/console/text_fov.set_text("FOV: " + str($Player_Camera.fov))
	$GUI/console/text_contact.set_text("Has contact(RayCast): " + str(has_contact))
	$GUI/console/text_onfloor.set_text("Is on floor: " + str(is_on_floor()))
	$GUI/console/text_speed.set_text("Speed: " + str(speed))
	