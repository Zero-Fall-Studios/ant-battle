extends Node2D

@export var template: PackedScene

func _unhandled_input(event: InputEvent):
	if event.is_action_released("ui_left_click"):
		# Get the mouse position in world coordinates
		var mouse_pos = get_global_mouse_position()

		# Spawn the exported node at the mouse position
		var node = template.instantiate()
		add_child(node)
		node.position = mouse_pos
