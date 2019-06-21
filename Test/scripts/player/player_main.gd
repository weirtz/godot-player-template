		extends KinematicBody
var FLY = load("res://scripts/player/fly.gd").new()
var MOVEMENT = load("res://scripts/player/movement.gd").new()
var CONSOLE = load("res://scripts/player/console.gd").new()


#--------------------
# General Variables


var camera_change = Vector2()
#--------------------
# Mouse
var mouse_sensitivity = 0.2
var camera_angle = 0


func _ready():
	pass
func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative
func aim():
	if camera_change.length() > 0 :
		#$Player_Camera.rotate_y
		rotate_y(deg2rad(-camera_change.x * mouse_sensitivity))
	
		var change = -camera_change.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Player_Camera.rotate_x(deg2rad(change))
			camera_angle += change
		camera_change = Vector2()
		
func _physics_process(delta):
	CONSOLE.console()
	aim()
	
	if Input.is_action_just_pressed("fly"):
		FLY.flying = !FLY.flying
	if FLY.flying:
		MOVEMENT.speed = MOVEMENT.MAX_SPEED
		$Player_Camera.fov = 64
		FLY.fly(delta)
	else:
		MOVEMENT.walk(delta)

