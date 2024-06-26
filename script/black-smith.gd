extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@onready var shopMenu = $"Black-smithShop"
@onready var CardManager = preload("res://script/cardsManager.gd")
@onready var cardManager = CardManager.new()
var player_in_chat_zone = false
var shopOpen = false
var shop: Dictionary
var player

func _ready():
	animatedSprite.play("idle")
	
func _process(delta):
	if Input.is_action_just_pressed("Interact") and player_in_chat_zone:
		if animatedSprite.animation == "idle":
			animatedSprite.play("talk")
		else:
			animatedSprite.play("idle")
		displayShop()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_in_chat_zone = true
		$Control.visible = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_in_chat_zone = false
		$Control.visible = false
		
func generate_shop():
	for i in 3:
		var card = cardManager.generate_random_card(Global.allCards)
		while shop.has(card.name):
			card = cardManager.generate_random_card(Global.allCards)
		shop[card.name] = card
		
func displayShop():
	#if shop.is_empty():
		#generate_shop()
	if shopOpen:
		shopMenu.hide()
		shopMenu.close()
		shopOpen = false
		Global.playerIsInForge = false
	else:
		shopMenu.show()
		shopMenu.open(Global.player.cards)
		shopOpen = true
		Global.playerIsInForge = true
	Global.pause = shopOpen
