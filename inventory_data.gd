extends Node

const HOTBAR_SIZE: int = 8
const BACKPACK_SIZE: int = 20

var hotbar: Array = []
var backpack: Array = []

var selected_hotbar_slot: int = 0

func _ready() -> void:
	hotbar.resize(HOTBAR_SIZE)
	backpack.resize(BACKPACK_SIZE)
	
