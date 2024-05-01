extends Node

const ICON_PATH = "res://sprites/"

const UPGRADES = {
	"food": {
		"icon": ICON_PATH + "icon.svg",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	},
	"fireball1": {
		"icon": ICON_PATH + "icon.svg",
		"displayname": "Fire Ball",
		"details": "A fire ball is thrown at the closest enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	}
}
