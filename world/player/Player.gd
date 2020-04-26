extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
export(float) var WALKING_SPEED = 1
export(float) var SPRINTING_SPEED = 2
export(float) var EXHAUSTED_SPEED = 0.5
export(float) var STAMINA_REGEN_EXHAUSTED = 0.1
export(float) var STAMINA_REGEN = 0.25
export(float) var SPRINT_STAMINA_COST = 0.2
export(float) var MAX_STAMINA = 1
export(float) var GRAVITY = 1

var velocity = Vector3()
var exhausted = false
var stamina = MAX_STAMINA

func _physics_process(delta):
	handle_player_input(delta)
	velocity += Vector3.DOWN * GRAVITY
	velocity = move_and_slide(velocity, Vector3.UP)
	
	
func handle_player_input(delta):	
	var dir = Vector3()
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	dir.y = 0
	
	# Get the camera's transform basis, but remove the X rotation such
	# that the Y axis is up and Z is horizontal.
	var cam_basis = $ClippedCamera.global_transform.basis
	var basis = cam_basis.rotated(cam_basis.x, -cam_basis.get_euler().x)
	dir = basis.xform(dir)
		
	var speed = WALKING_SPEED
	var stamina_cost = -STAMINA_REGEN
	
	if Input.is_action_pressed("sprint"):
		speed = SPRINTING_SPEED
		stamina_cost = SPRINT_STAMINA_COST
		
	if exhausted:
		speed = EXHAUSTED_SPEED
		stamina_cost = -STAMINA_REGEN_EXHAUSTED
		
	stamina -= stamina_cost * delta
	
	if stamina <= 0:
		exhausted = true
	elif stamina >= MAX_STAMINA:
		stamina = MAX_STAMINA
		exhausted = false

	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	velocity.y = 0

func on_collision_with_enemy(_enemy):
	print('dead')
