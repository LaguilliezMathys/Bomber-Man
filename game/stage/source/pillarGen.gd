extends Node

@export var destructible_wall_scene: PackedScene
@export var indestructible_wall_scene: PackedScene

var level_width: int = 44
var level_length: int = 44
var tile_size: int = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	for i in 15:
		for j in 15:
			if(i%2==0 and j%2==0 and chance(75)):
				spawn_indestructible_wall(i,j)
			elif ((i<6 or i>8 or j<6 or j>8) and chance(50)):
				spawn_wall(i,j)


func chance(chance: int) -> bool:
	return randi_range(1, 100) <= chance


func spawn_indestructible_wall(x: int, z: int) -> void:
	"""Instancie un mur indestructible à une position de grille."""
	if indestructible_wall_scene == null:
		indestructible_wall_scene = load("res://models/pillar.tscn")

	if indestructible_wall_scene == null:
		return

	var wall = indestructible_wall_scene.instantiate()
	var world_x = (x - 7) * tile_size
	var world_z = (z - 7) * tile_size
	wall.position = Vector3(world_x, 0, world_z)
	add_child(wall)


func spawn_wall(x: int, z: int) -> void:
	"""Instancie un mur à une position de grille."""
	if destructible_wall_scene == null:
		destructible_wall_scene = load("res://models/crate.tscn")
	
	var wall = destructible_wall_scene.instantiate()
	# Position mondiale : chaque index = 1 case de 2m
	# Centrer la grille: (0,0) est au centre
	var world_x = (x - 7) * tile_size
	var world_z = (z - 7) * tile_size
	wall.position = Vector3(world_x, 0.5, world_z)
	wall.scale=Vector3(2,2,2)
	add_child(wall)
	# Marquer les crates pour qu'elles puissent être rapidement trouvées par l'explosion
	# (le groupe 'crates' est utilisé par bomb.gd)
	wall.add_to_group("crates")
