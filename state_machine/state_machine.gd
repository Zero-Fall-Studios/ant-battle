extends Node
class_name StateMachine

signal transitioned(state_name)

@export var initial_state : String

var current_state
var states : Dictionary = {}

func _ready():
	await owner.ready
	for child in get_children():
		if child is State:
			child.state_machine = self
			states[child.name] = child
	if initial_state:
		transition_to(initial_state)
		
func _unhandled_input(event: InputEvent) -> void:
	current_state.unhandled_input(event)

func _process(delta: float) -> void:
	current_state.process(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_process(delta)
		
func transition_to(new_state: String):
	if current_state:
		current_state.exit()
	current_state = states[new_state]
	current_state.enter()
	emit_signal("transitioned", current_state.name)
