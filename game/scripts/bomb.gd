extends Node3D

@export var flash_duration := 5.0
@export var explosion_radius := 4.0
@export var explosion_effect_scene: PackedScene = preload("res://effects/explosion_effect.tscn")

var timer := 0.0
var exploded := false
var bomb_mesh: MeshInstance3D

func _ready():
	bomb_mesh = $Bomb_Mt_bombs_0 as MeshInstance3D
	if bomb_mesh == null:
		push_error("Bomb mesh not found!")
		return

	# Duplicate material so flashing doesn't affect other bombs
	if bomb_mesh.material_override:
		bomb_mesh.material_override = bomb_mesh.material_override.duplicate()
	else:
		bomb_mesh.material_override = StandardMaterial3D.new()

func _process(delta):
	if exploded:
		return

	timer += delta
	if timer < flash_duration:
		var t = timer / flash_duration
		var flash_speed = lerp(2.0, 10.0, t)
		var intensity = 0.5 + 0.5 * sin(TAU * flash_speed * timer)

		var mat := bomb_mesh.material_override as StandardMaterial3D
		mat.albedo_color = Color(1, 1 - intensity, 1 - intensity)
	else:
		explode()

func explode():
	exploded = true
	var explosion = explosion_effect_scene.instantiate()
	explosion.global_transform = global_transform
	get_parent().add_child(explosion)

	# Détruire les crates dans un rayon aligné sur les axes X et Z
	# On utilise un groupe 'crates' (ajouté lors de l'instanciation des murs destructibles).
	var bomb_pos: Vector3 = global_transform.origin
	for crate in get_tree().get_nodes_in_group("crates"):
		if not crate is Node3D:
			continue
		var pos: Vector3 = crate.global_transform.origin
		# Rayon axis-aligned : vérifier séparément X et Z
		if abs(pos.x - bomb_pos.x) <= explosion_radius and abs(pos.z - bomb_pos.z) <= explosion_radius:
			crate.queue_free()

	queue_free()
