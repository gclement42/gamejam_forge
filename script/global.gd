extends Node

var playerPos = Vector2(0,0)
var player = null

#Array of ennemies
const ennemies = {
	"octopus": {
		"damage": 0.5,
		"speed": 50,
		"shootFrame": 3,
		"bulletSpeed": 200.0,
	},
	"human": {
		"damage": 0.5,
		"speed": 50,
		"shootFrame": 3,
		"bulletSpeed": 200.0,
	},
	"mech": {
		"damage": 0.5,
		"speed": 50,
		"shootFrame": 3,
		"bulletSpeed": 200.0,
	},	
}
