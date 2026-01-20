extends Node3D

@export var stage_mesh_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var temp=stage_mesh_scene.instantiate()
	add_child(temp)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
