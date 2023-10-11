class_name WanderState
extends State

@export var follow_target_state : State

var direction : Vector2
var time_to_change_direction : float = 0

func enter():
	time_to_change_direction = randf_range(2, 5)
	calculate_direction()
	return null

func exit(): 
	return null
	
func process_physics(delta):
	parent.velocity = direction * parent.move_speed
	parent.rotation = lerp_angle(parent.rotation, direction.angle(), delta * parent.move_speed)
	var collision = parent.move_and_collide(parent.velocity * delta)
	if collision:
		calculate_direction()
	if time_to_change_direction < 0:
		time_to_change_direction = randf_range(2, 5)
		calculate_direction()
	if detect_target():
		return follow_target_state
	time_to_change_direction -= delta
	return null

func calculate_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func detect_target() -> bool: 
	var ants = get_tree().get_nodes_in_group("ants")
	for other in ants:
		if other == parent:
			continue
		var distance = parent.position.distance_to(other.position)
		if distance < parent.agro_distance:
			parent.target_node = other
			return true
	return false
