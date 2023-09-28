extends State
class_name Wander

var direction : Vector2
var time_to_change_direction : float = 0

func enter():
	time_to_change_direction = randf_range(2, 5)
	calculate_direction()

func exit(): 
	pass
	
func physics_process(delta):
	owner.velocity = direction * owner.move_speed
	owner.rotation = lerp_angle(owner.rotation, direction.angle(), delta * owner.move_speed)
	var collision = owner.move_and_collide(owner.velocity * delta)
	if collision:
		calculate_direction()
	if time_to_change_direction < 0:
		time_to_change_direction = randf_range(2, 5)
		calculate_direction()
	detect_target()
	time_to_change_direction -= delta

func calculate_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func detect_target():
	var ants = get_tree().get_nodes_in_group("ants")
	for other in ants:
		if other == owner:
			continue
		var distance = owner.position.distance_to(other.position)
		if distance < owner.agro_distance:
			owner.target_node = other
			state_machine.transition_to("FollowTarget")
			break
