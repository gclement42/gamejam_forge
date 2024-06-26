extends CharacterBody2D

const moneyPath = preload("res://Scene/money.tscn")
const pieces_of_cards_scene = preload("res://Scene/piecesOfCards.tscn")
@onready var animations = $animations
@onready var timer = $Timer
var enemy_name
var stats
var bulletPath
var bullet_instance
var player_in = false
var is_dead = false
var is_shooting = false

func _ready():
	stats = Global.ennemies[enemy_name].duplicate()
	bulletPath = load("res://AnimatedCharacters/Enemies/" + enemy_name + "/Bullet.tscn")
	timer.wait_time = stats.attack_speed
	create_ray()
	
func create_ray():
	var ray = RayCast2D.new()
	ray.set_collision_mask_value(4, true)
	ray.set_collision_mask_value(1, false)
	add_child(ray)
	
func _process(delta):
	if stats.health <= 0:
		death()
	
func _physics_process(delta):
	self.move(delta)
	
func move(delta):
	if self.velocity == Vector2(0, 0):
		animations.play("move")
		return
	if self.velocity.x > 0:
		animations.set_flip_h(false)
	else:
		animations.set_flip_h(true)
	if not animations.is_playing():
		animations.play("move")
	if animations.animation != "shoot" and animations.animation != "death":
		move_and_slide()
	
func takeDamage():
	if animations.animation == "hit" || animations.animation == "death":
		return

	stats.health -= Global.player.strength
	animations.play("hit")
	
func death():
	animations.play("death")

func increase_level():
	stats["level"] += 1
	stats["health"] *= stats["level"]
	stats["damage"] *= stats["level"]
	stats["speed"] *= stats["level"]
	stats["health"] *= stats["level"]
	stats["bulletSpeed"] *= stats["level"]
		
#func _process(delta):
	#enemy.check_death(self)
	#enemy.process(delta, self)
#
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_in = true
		timer.start()
#
func _on_area_2d_body_exited(body):
	if body.name == 'Player':
		player_in = false
		timer.stop()

#func chooseRandomEnemy():
	#var ennemies = Global.ennemies.keys()
	#var enemy = ennemies[randi() % ennemies.size()]
	#return Global.ennemies[enemy]
#
func _on_animations_animation_finished():
	if $animations.animation == "death":
		dropMoney()
		is_dead = true
		queue_free()
	if $animations.animation == "shoot":
		is_shooting = false
		timer.start()
	if $animations.animation == "hit":
		$animations.play("move")
#
func dropMoney():
	var pieces_of_cards_droped = pieces_of_cards_scene.instantiate()
	var moneyDroped = moneyPath.instantiate()
	
	moneyDroped.goldAmount = stats.goldAmount
	moneyDroped.value = stats.goldValue
	moneyDroped.position = position
	pieces_of_cards_droped.position = position
	get_parent().add_child(moneyDroped)
	get_parent().add_child(pieces_of_cards_droped)

func _on_animations_frame_changed():
	if bullet_instance != null and animations.animation == "shoot" and animations.frame == stats.shootFrame:
		self.add_child(bullet_instance)

