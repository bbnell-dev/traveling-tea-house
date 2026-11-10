extends Area2D

var player_nearby: bool = false

@onready var prompt: Label = $InteractionPrompt

func _ready() -> void:
	prompt.hide()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_nearby = true
		prompt.show()
		
func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_nearby = false
		prompt.hide()
		
func _unhandled_input(event: InputEvent) -> void:
	if player_nearby and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		get_tree().change_scene_to_file(
			"res://bed_and_breakfast_interior.tscn"
		)
