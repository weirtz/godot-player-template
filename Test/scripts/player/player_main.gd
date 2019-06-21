extends KinematicBody
class_name PlayerMain

onready var Movement = $movement/movement
onready var Fly = $movement/fly

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
	$"GUI/console".console()
	aim()
	var flyer = $movement/fly
	var mover = $movement/movement
	if Input.is_action_just_pressed("fly"):
		flyer.flying = !flyer.flying
	if flyer.fly(delta):
		Movement.speed = Movement.MAX_SPEED
		$Player_Camera.fov = 64
		flyer.fly(delta)
	else:
		mover.walk(delta)

