extends Control

@onready var cards = preload("res://Scene/cards.tscn")
@onready var CardManager = preload("res://script/cardsManager.gd")
@onready var animatedSprite = $AnimatedSprite2D2
@onready var cardManager = CardManager.new()
@onready var dropable1 = $Control/Dropable
@onready var dropable2 = $Control/Dropable2
@onready var priceLabel = $Control/price
@onready var control = $Control
var price = 0
var Instance = preload("res://script/createInstance.gd").new()
var Merge = preload("res://script/mergeCards.gd").new()

var shop
var cardsInstance: Array

func displayShop():
	control.visible = true
		
func add_to_dropable(card):
	if not card.isStored:
		if not dropable1.cardIsOn:
			price += card.card.level * 5
			dropable1.add_card(card, dropable1.position)
		elif not dropable2.cardIsOn:
			price += card.card.level * 5
			dropable2.add_card(card, dropable2.position)
	else:
		if card.dropableZoneName == "Dropable":
			price -= card.card.level * 5
			dropable1.remove_card()
		else:
			price -= card.card.level * 5
			dropable2.remove_card()
	priceLabel.text = str(price)

func open(shopCards):
	shop = shopCards
	animatedSprite.play("default")
	
func _process(_delta):
	priceLabel.text = str(price)

func _on_animated_sprite_2d_2_animation_finished():
	displayShop()
	
func animate_forge_success(pos: Vector2, card_instance):
	card_instance.position = Vector2(pos.x + 150, pos.y + 75)
	card_instance.forge_animation(dropable1.initialPosCard)
	
func forge():
	if Global.player.money < self.price:
		return
	Global.player.money -= self.price
	price = 0
	var mergeCard = Merge.merge_cards(dropable1.cardOn.card, dropable2.cardOn.card)
	Global.player.add_card(mergeCard)
	var card_instance = Instance.create_card(self, mergeCard, dropable1.position, true)
	animate_forge_success(dropable1.position, card_instance)
	dropable1.cardIsOn = false
	dropable2.cardIsOn = false
	dropable1.cardOn.queue_free()
	dropable2.cardOn.queue_free()
	
func _on_button_pressed():
	if dropable1.cardIsOn and dropable2.cardIsOn:
		forge()

func close():
	price = 0
	dropable1.remove_card()
	dropable2.remove_card()
