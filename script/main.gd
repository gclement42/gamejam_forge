extends Node2D

@onready var inventory_menu = $Player/Camera2D/InventoryMenu
@onready var Player = $Player.player
@onready var animation_go_to = $GoTo/Animation
var card_manager_scene = preload("res://cardsManager.tscn")
var pause = false
var card_manager

func _ready():
	inventory_menu.hide()
	if not Global.gameIsStart:
		self.start_the_game()
	else:
		Player = Global.player
		if self.name != "Forge":
			$Player.position = Global.lastPosition 

func start_the_game():
	animation_go_to.play("go_to_animation")
	card_manager = card_manager_scene.instantiate()
	add_child(card_manager)
	Player.add_card(card_manager.generate_random_card(card_manager.cards))
	Player.add_card(card_manager.generate_random_card(card_manager.cards))
	Player.add_card(card_manager.generate_random_card(card_manager.cards))
	Player.add_card(card_manager.generate_random_card(card_manager.cards))
	Player.add_card(card_manager.generate_random_card(card_manager.cards))
	Player.add_card(card_manager.generate_random_card(card_manager.cards))
	inventory_menu.hide()
	Global.gameIsStart = true
	
	
func _process(_delta):
	if Input.is_action_just_pressed("Inventory"):
		inventoryMenu()
		
func inventoryMenu():
	if pause:
		inventory_menu.hide()
		inventory_menu.close()
		Engine.time_scale = 1
		pause = false
	else:
		inventory_menu.show()
		inventory_menu.open(Player)
		Engine.time_scale = 0
		pause = true
	Global.pause = pause
