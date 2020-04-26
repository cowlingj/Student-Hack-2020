extends Camera
	
export(float) var MOUSE_SPEED_THRESHOLD = 0
export(float) var MOUSE_SPEED_LIMIT = 500
export(float) var MOUSE_MOVEMENT_STOP = 0.1
export(float) var MOUSE_SENSITIVITY = 1

var mouse_still_for = 0
var mouse_stopped = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if (
		event is InputEventMouseMotion &&
		event.relative.length_squared() >= pow(MOUSE_SPEED_THRESHOLD, 2)
	):
		mouse_stopped = false
		mouse_still_for = 0

		var speed = event.relative.clamped(MOUSE_SPEED_LIMIT)
		var rel_speed = speed / MOUSE_SPEED_LIMIT
		
		var x_action = InputEventAction.new()
		x_action.action = "look_right" if rel_speed.x > 0 else "look_left"
		x_action.pressed = true
		x_action.strength = abs(rel_speed.x)
		Input.parse_input_event(x_action)
		
		var y_action = InputEventAction.new()
		y_action.action = "look_down" if rel_speed.y > 0 else "look_up"
		y_action.pressed = true
		y_action.strength = abs(rel_speed.y)
		Input.parse_input_event(y_action)

func _process(delta):
	mouse_still_for += delta
	
	if not mouse_stopped and mouse_still_for > MOUSE_MOVEMENT_STOP:
		
		var x_stop_left= InputEventAction.new()
		x_stop_left.action = "look_left"
		x_stop_left.pressed = false
		x_stop_left.strength = 0
		Input.parse_input_event(x_stop_left)
		
		var x_stop_right = InputEventAction.new()
		x_stop_right.action = "look_right"
		x_stop_right.pressed = false
		x_stop_right.strength = 0
		Input.parse_input_event(x_stop_right)
		
		var y_stop_up = InputEventAction.new()
		y_stop_up.action = "look_up"
		y_stop_up.pressed = false
		y_stop_up.strength = 0
		Input.parse_input_event(y_stop_up)
		
		var y_stop_down = InputEventAction.new()
		y_stop_down.action = "look_down"
		y_stop_down.pressed = false
		y_stop_down.strength = 0
		Input.parse_input_event(y_stop_down)
		

func _physics_process(_delta):
	
	var dir = Vector3()
	dir.x = (
		Input.get_action_strength("look_right")
		- Input.get_action_strength("look_left")
	) * MOUSE_SENSITIVITY
	dir.y = (
		Input.get_action_strength("look_down")
		- Input.get_action_strength("look_up")
	) * MOUSE_SENSITIVITY
	dir.z = -1
	
	look_at(global_transform.xform(dir), Vector3.UP)

	# Turn a little up or down
	# var t = transform
	# t.basis = Basis(t.basis[0], deg2rad(angle_v_adjust)) * t.basis
	# transform = t
