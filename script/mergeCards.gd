class_name Merge

extends Node


var abilities1: String
var abilities2: String
var Card = preload("res://script/Cards.gd").Card

func get_card_abilities(card):
	var size = card.effects.size()
	var random_key = card.effects.keys()[randi() % size]
	return random_key
	
#var firstOne = Card.new("FirstOne", "This is the First one", "stats", {"strength": 10,"attack_speed": 10, "pv_max": 1 })

func merge_cards(card1, card2):
	var mergedCard
	abilities1 = get_card_abilities(card1)
	abilities2 = get_card_abilities(card2)
	mergedCard = Card.new(card1.name + card2.name, "This is a merge card", "merged", {abilities1: card1.effects[abilities1], abilities2: card2.effects[abilities2]})
	return mergedCard