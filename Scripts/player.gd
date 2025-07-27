class_name Player

extends RigidBody3D

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

# current position of the player
var current_position:Vector3

@onready var twist_pivot: Node3D = $TwistPivot
@onready var pitch_pivot: Node3D = $TwistPivot/PitchPivot


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Vector3.ZERO
	input.x = Input.get_axis("left", "right")
	input.z = Input.get_axis("walk","back")
	if Input.is_action_just_pressed("jump"):
		input.y = 14
	
	#twist_pivot.basis changes the y axis for apply force
	apply_central_force(twist_pivot.basis * input * 1200 * delta)
	#if escape is pressed unlock mouse
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	#camera controls, set in _unhandled_input function
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	#to prevent the camera from pitching over the player, clamp it.  Negative = top, positive = bottom
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		deg_to_rad(-35),
		deg_to_rad(20)
	)
	twist_input = 0.0
	pitch_input = 0.0
	current_position = twist_pivot.global_position
	#print (str(current_position))

func _unhandled_input(event: InputEvent) -> void:
	#camera functions, set negative value on mouse input to go in the same direction as the mouse movement
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
