extends CharacterBody2D
const bulletPath = preload("res://bullet.tscn")

@onready var animation = $AnimatedSprite2D
@onready var playerAnimation =  $AnimationPlayer
@onready var Card = "res://Cards.gd"
var player: Player

class Player:
	var cards: Dictionary
	var shootSide: Dictionary
	var pv: int
	var pv_max: int
	var speed: int
	var attack_speed: int
	var strength: int
	var playerAnimation
		
	func _init(playerAnimation):
		pv = 100
		pv_max = 100
		speed = 75
		attack_speed = 4
		strength = 25
		shootSide = {
			"forward": true,
			"back": false,
			"top": false,
			"bottom": false,
			"topBack": false,
			"topForward": false,
			"bottomBack": false,
			"bottomForward": false,
		}
		self.playerAnimation = playerAnimation
	
	func add_card(newCard):
		newCard.applyEffects(self)
		cards[newCard.name] = newCard
		print("new card:", newCard.name)
		
	func take_damage(bullet):
		self.pv -= bullet.damage
		if self.pv <= 0:
			self.player_death()
		playerAnimation.play("damage")

	func player_death():
		pass
		
	func shoot(parent, marker2d, lookLeft):
		for side in shootSide:
			if shootSide[side]:
				self.bulletDirection(parent, marker2d, lookLeft, side)
				
	func bulletDirection(parent, marker2d, lookLeft, side):
		var direction = Vector2(1, 0)
		var rotate = 0
		if lookLeft:
			direction.x = -1
		match side:
			"forward":
				createBulletInstance(parent, marker2d, direction, rotate)
			"back":
				direction.x = -direction.x
				createBulletInstance(parent, marker2d, direction, rotate)
			"top":
				direction = Vector2(0, -1)
				rotate = 90
				createBulletInstance(parent, marker2d, direction, rotate)
			"bottom":
				rotate = 90
				direction = Vector2(0, 1)
				createBulletInstance(parent, marker2d, direction, rotate)
			"topBack":
				rotate = 45
				if direction.x < 0:
					rotate = -45
				direction = Vector2(-direction.x, -1)
				createBulletInstance(parent, marker2d, direction, rotate)
			"topForward":
				rotate = 135
				if direction.x < 0:
					rotate = -135
				direction = Vector2(direction.x, -1)
				createBulletInstance(parent, marker2d, direction, rotate)
			"bottomBack":
				rotate = 45
				if direction.x > 0:
					rotate = -45
				direction = Vector2(-direction.x, 1)
				createBulletInstance(parent, marker2d, direction, rotate)
			"bottomForward":
				rotate = 135
				if direction.x > 0:
					rotate = -135
				direction = Vector2(direction.x, 1)
				createBulletInstance(parent, marker2d, direction, rotate)
		
				
	func createBulletInstance(parent, marker2d, direction, angleRotate):
		var bullet = bulletPath.instantiate()
		parent.add_child(bullet)
		bullet.position = marker2d.global_position
		bullet.velocity = direction
		bullet.rotation_degrees = angleRotate


func _ready():
	player = Player.new(playerAnimation)
	$Timer.wait_time = player.attack_speed
	$Timer.start()
	
func _process(_delta):
	Global.playerPos = self.global_position
	$Node2D.look_at(get_global_mouse_position())
	if $Timer.is_stopped():
		animation.play("shoot")
		player.shoot(self.get_parent(), $Node2D/Marker2D, animation.flip_h )
		if player.attack_speed > 0:
			$Timer.wait_time = player.attack_speed
		$Timer.start()
	
func _physics_process(_delta):
	var mouseOffset = get_global_mouse_position() - self.position;
	var direction = mouseOffset.normalized() * player.speed
	if mouseOffset.x < 5 and mouseOffset.x > -5:
		animation.play("idle")
		return
	if direction.x > 0:
		animation.flip_h = false
	else:
		animation.flip_h = true
	if !animation.is_playing() or animation.animation == "run" or animation.animation == "idle" :
		animation.play("run")
	velocity = direction * _delta * player.speed
	move_and_slide()
	
		

func _on_area_2d_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	print(_area.name)
	#if (_area.name == "Area2D" and _area.get_parent().is_in_group("enemy")):
		#player.take_damage(_area.get_parent())


func _on_area_2d_area_entered(area):
	print(area.name)
