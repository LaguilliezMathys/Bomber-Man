extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 4.5
@export var gravity := 9.8
@onready var BombScene = preload("res://models/bomb.tscn")

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if Input.is_action_just_pressed("place"):
		var bomb = BombScene.instantiate()
		get_parent().add_child(bomb)
		bomb.global_transform.origin = global_transform.origin

	# Movement
	var input_dir = Input.get_vector(
		"left",
		"right",
		"forward",
		"backward",
	)

	var direction = Vector3(input_dir.x, 0, input_dir.y)
	direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Rotate character toward movement
	if direction != Vector3.ZERO:
		look_at(global_position - direction, Vector3.UP)

	move_and_slide()
