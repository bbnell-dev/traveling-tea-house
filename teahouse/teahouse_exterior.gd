
extends Node2D

@export var region_id: String = "wrenwood"

@onready var entrance: Area2D = $Entrance
@onready var prompt: Label = $Entrance/InteractionPrompt

var player_nearby: bool = false


func _ready() -> void:
	prompt.hide()

	entrance.body_entered.connect(_on_body_entered)
	entrance.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_nearby = true
		prompt.show()


func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_nearby = false
		prompt.hide()


func _unhandled_input(event: InputEvent) -> void:
	if not player_nearby:
		return

	if event.is_action_pressed("interact"):
		if event is InputEventKey and event.echo:
			return

		get_viewport().set_input_as_handled()

		TeahouseData.current_region = region_id
		TeahouseData.return_scene = (
			get_tree().current_scene.scene_file_path
		)

		get_tree().change_scene_to_file(
            "res://teahouse/tea_house_interior.tscn"
		)
