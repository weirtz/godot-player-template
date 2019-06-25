extends Node
class_name Movement

#--------------------
# General Variables
var velocity = Vector3()
var direction = Vector3()

#--------------------
# Camera
var tween
var fovDefault : = 64
var fovRunning : = 68
#--------------------
# Walking
var gravity : = -9.8 * 2
const MAX_SPEED : = 4
const MAX_RUNNING_SPEED : = 8
const ACCELERATION : = 2
const DEACCELERATION : = 20
var speed = MAX_SPEED
#--------------------
# Movement
const JUMP_HEIGHT : = 6
var crouch
var on_floor
var rayCast : = false
var running : = false
var standing : = false
#--------------------
# Slope
const MAX_SLOPE_ANGLE = 10

func _ready():
	on_floor = $"../../../KinematicBody".is_on_floor()

func walk(delta):
	#Reset the direction of the player
	direction = Vector3()
	#Get rotation of camera
	var aim = $"../../PlayerCamera".get_global_transform().basis
	#Grab tween node
	tween = $"../../PlayerCamera/FovTween"
	
	# MOVEMENT INPUT [W,A,S,D] ------------------------------------------------------------
	if(Input.is_action_pressed("move_fw")):
		direction -= aim.z
		standing = false
		if Input.is_action_just_pressed("move_sprint"):
			speed = MAX_RUNNING_SPEED
			tween.interpolate_property($"../../PlayerCamera", "fov", $"../../PlayerCamera".fov, fovRunning, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()
			running = true
	if Input.is_action_just_released("move_fw"):
		speed = MAX_SPEED
		tween.interpolate_property($"../../PlayerCamera", "fov", $"../../PlayerCamera".fov, fovDefault, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		running = false
		standing = true
		
	if(Input.is_action_pressed("move_bw")):
		direction += aim.z
		standing = false
		
	if(Input.is_action_pressed("move_l")):
		direction -= aim.x
		standing = false
	
	if(Input.is_action_pressed("move_r")):
		direction += aim.x
		standing = false
		
	# END MOVEMENT INPUT ------------------------------------------------------------
	
	direction.y = 0
	direction = direction.normalized()
	
	#Double Verification if on floor, handles walking on slopes (RayCast)
	if $"../../../KinematicBody".is_on_floor():
		rayCast = true
		on_floor = $"../../../KinematicBody".is_on_floor()
		var n = $"../../RayCast".get_collision_normal()
		var floor_angle = rad2deg(acos(n.dot(Vector3(0,1,0))))
		if floor_angle > MAX_SLOPE_ANGLE:
			velocity.y += (gravity + (gravity * floor_angle) / 5) * delta
		print("KinematicBody is_on_floor")
	else:
		if !$"../../RayCast".is_colliding(): # if raycast is NOT colliding
			rayCast = false # raycast = false
			on_floor = $"../../../KinematicBody".is_on_floor()
			print("RayCast NOT COLLIDING")
		#CREATES ERROR WITH IS_ON_FLOOR_VAR_FLOPPING \/
		velocity.y += gravity * delta #removing makes is on floor false, but keeping it makes it flipflop
		print("KinematicBody NOT ON FLOOR")
		
	if rayCast and !$"../../../KinematicBody".is_on_floor():
		print("RayCast Colliding and NOT is_on_floor (MOVING PLAYER DOWN)")
		$"../../../KinematicBody".move_and_collide(Vector3(0,-1, 0))
	
	var temp_velocity = velocity
	temp_velocity.y = 0

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
	
	if rayCast and Input.is_action_pressed("move_jump"):
		rayCast = false
		velocity.y = JUMP_HEIGHT
		
	#move
	velocity = $"../../../KinematicBody".move_and_slide(velocity, Vector3(0,1,0))
		
	if Input.is_action_pressed("move_squat"):
		$"../../PlayerCamera".transform(0, -2, 0)
		$"../../PlayerCamera".translate(0, -2, 0)
		
		