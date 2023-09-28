extends Node2D

@export var template: PackedScene

func _unhandled_input(event: InputEvent):
	if event.is_action_released("ui_left_click"):
		var mouse_pos = get_global_mouse_position()
		var ant: Ant = template.instantiate()
		add_child(ant)
		ant.spawn(mouse_pos)
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
