extends Node
class_name Fly

#--------------------
# General 
var velocity = Vector3()
var direction = Vector3()
#--------------------
# Flying
const FLY_SPEED = 10
const FLY_ACCELERATION = 4
const FLY_DEACCELERATION = 10
var flying = false

func fly(delta):
	#Reset the direction of the player
	direction = Vector3()
	#Get rotation of camera
	var aim = $"../../PlayerMovement".get_global_transform().basis

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
	velocity = $"../../../KinematicBody".move_and_slide(velocity, Vector3(0,1,0))