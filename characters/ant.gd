class_name Ant
extends CharacterBody2D

@export var move_speed = 10
@export var agro_distance = 50

@onready var state_machine = $StateMachine

var target_node: CharacterBody2D
var hp : int = 1

func _ready():
	hide()
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	
func spawn(pos):
	position = pos
	show()
					
func add_hp(amount: int):
	hp += amount
	if hp <= 0:
		die()
	scale += Vector2(amount * .1, amount * .1)
	
func die():
	queue_free()
