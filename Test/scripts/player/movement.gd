extends Node
class_name Movement

#--------------------
# General Variables
var velocity = Vector3()
var direction = Vector3()

#--------------------
# Mouse
var mouse_sensitivity = 0.2
var camera_angle = 0
#--------------------
# Walking
var gravity = -9.8
const MAX_SPEED = 4
const MAX_RUNNING_SPEED = 8
const ACCELERATION = 2
const DEACCELERATION = 20
var speed = MAX_SPEED
#--------------------
# Movement

#max jumps of 0 will give you 2 jumps aka double jump

const JUMP_HEIGHT = 6
var crouch
var on_floor 
var has_contact = false
# Slope Variables
const MAX_SLOPE_ANGLE = 10
#--------------------
# Flying
const FLY_SPEED = 10
const FLY_ACCELERATION = 4
const FLY_DEACCELERATION = 10
var flying = false

func _ready():
	on_floor = $"../../../KinematicBody".is_on_floor()
#-------------------------------------------
#Walking Function---------------------------
#-------------------------------------------
func walk(delta):
	#Reset the direction of the player
	direction = Vector3()
	#Get rotation of camera
	
	var aim = $"../../Player_Camera".get_global_transform().basis

	if(Input.is_action_pressed("move_fw")):
		direction -= aim.z
		#if(Input.is_action_just_pressed("move_fw")):
			#$audio/walking._set_playing(true)
		#else:
			#$audio/walking.stop()
	if(Input.is_action_pressed("move_bw")):
		direction += aim.z
	if(Input.is_action_pressed("move_l")):
		direction -= aim.x
	if(Input.is_action_pressed("move_r")):
		direction += aim.x
		
	direction.y = 0
	direction = direction.normalized()
	
	#Double Verification if on floor, handles walking on slopes
	if $"../../../KinematicBody".is_on_floor():
		has_contact = true
		var n = $"../../RayCast".get_collision_normal()
		var floor_angle = rad2deg(acos(n.dot(Vector3(0,1,0))))
		if floor_angle > MAX_SLOPE_ANGLE:
			velocity.y += (gravity + (gravity * floor_angle) / 5) * delta
		print("fuck")
	else:
		if !$"../../RayCast".is_colliding(): # if raycast is NOT colliding
			has_contact = false # raycast = false
		#CREATES ERROR WITH IS_ON_FLOOR_VAR_FLOPPING \/
		velocity.y += gravity * delta #removing makes is on floor false, but keeping it makes it flipflop
		print("ASDASDASD")
		
	if has_contact and !$"../../../KinematicBody".is_on_floor():
		print("you")
		$"../../../KinematicBody".move_and_collide(Vector3(0,-1, 0))
	
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	
	


	#if Input.is_action_just_pressed("move_sprint"):
	#	
		
	#if Input.is_action_just_released("move_sprint"):
	#	$Player_Camera.fov = fov - 5
	
	if Input.is_action_just_pressed("move_sprint"):
		speed = MAX_RUNNING_SPEED
		$"../../Player_Camera".fov = 68
	if Input.is_action_just_released("move_fw"):
		speed = MAX_SPEED
		$"../../Player_Camera".fov = 64
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
	
	if has_contact and Input.is_action_just_pressed("move_jump"):
		has_contact = false
		velocity.y = JUMP_HEIGHT
		#$audio/jump.play() 
		

	
	
	#move
	velocity = $"../../../KinematicBody".move_and_slide(velocity, Vector3(0,1,0))
	

	

		
	if Input.is_action_pressed("move_squat"):
		crouch = $Player_Camera.get_global_transform().basis
		direction -= crouch.y
		
		