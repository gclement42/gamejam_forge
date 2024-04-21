extends Area2D

var rng = RandomNumberGenerator.new()

func _ready():
	$Timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		$GoldSound.play()
		$Gold.modulate.a = 0
		$Timer.start()
		$CollisionShape2D.disabled = true
		
func _on_Timer_timeout():
	Global.playerMoney += rng.randi_range(1, 10)
	print(Global.playerMoney)
	queue_free()
	

