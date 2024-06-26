extends Area2D

var is_active = true
@export var nb_enemies:int

func active_spawner():
	is_active = true

func _on_body_entered(body):
	if body.name == "Player" and is_active:
		spawn_enemies()
		is_active = false
		
func check_if_spawner(node):
	var groups = node.get_groups()
	if not groups.has("SpawnZone"):
		return false
	return true

func spawn_enemies():
	var spawners_count = self.get_child_count()
	for i in spawners_count:
		var spawner = self.get_child(i)
		if check_if_spawner(spawner):
			for x in nb_enemies:
				var size = Global.enemies_scene.size()
				var random_key = Global.enemies_scene.keys()[randi() % size]
				call_deferred("create_enemy_instance", random_key, spawner)
		
func create_enemy_instance(enemy_name, spawnerZone):
	var enemy = Global.enemies_scene[enemy_name].duplicate()
	var enemyInstance = enemy.instantiate()
	enemyInstance.enemy_name = enemy_name
	enemyInstance.global_position = get_spawn_position(spawnerZone)
	self.add_child(enemyInstance)
	
func get_spawn_position(spawnerZone):
	var rng = RandomNumberGenerator.new()
	var randomPos = Vector2(0, 0)
	var collision_shape = spawnerZone.get_child(0)
	var centerpos = collision_shape.position + spawnerZone.position
	var size = collision_shape.shape.extents

	randomPos.x = (randi() % int(size.x)) - (size.x/2) + centerpos.x
	randomPos.y = (randi() % int(size.y)) - (size.y/2) + centerpos.y
	return randomPos

