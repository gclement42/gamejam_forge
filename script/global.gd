extends Node

var gameIsStart = false
var playerPos = Vector2(0,0)
var lastPosition = Vector2(0, 0)
var allCards = null
var player = null
var pause = false
var playerIsDead = false
var playerIsInForge = false
var allKeys = 4
var playerKeys = 0

#Array of ennemies
const ennemies = {
	"octopus": {
		"health": 50,
		"damage": 0.5,
		"speed": 20,
		"shootFrame": 3,
		"bulletSpeed": 200.0,
	},
	"human": {
		"health": 25,
		"damage": 0.5,
		"speed": 50,
		"shootFrame": 1,
		"bulletSpeed": 200.0,
	},
	"mech": {
		"health": 100,
		"damage": 0.5,
		"speed": 20,
		"shootFrame": 3,
		"bulletSpeed": 200.0,
	},	
}
