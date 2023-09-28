extends State
class_name FollowTarget

func enter():
	pass

func exit():
	pass

func physics_process(delta):
	var collision = owner.move_and_collide(owner.velocity * delta)
	if collision and not collision.get_collider().is_queued_for_deletion():
		var collider_shape = collision.get_collider_shape()
		var collider = collision.get_collider()
		if collider.name == 'StaticBody2D':
			pass
		if collider_shape.name == 'MouthCollisionShape2D':
			if collider.hp >= owner.hp:
				collider.add_hp(2)
				owner.add_hp(-1)
		elif collider_shape.name == 'BodyCollisionShape2D':
			collider.add_hp(-2)
			owner.add_hp(-2)
	
	if had_valid_target():
		var direction = (owner.target_node.position - owner.position).normalized()
		owner.velocity = direction * owner.move_speed
		var amount = max(delta, delta * (owner.move_speed - owner.hp * 1.5))
		owner.rotation = lerp_angle(owner.rotation, direction.angle(), amount)
	else:
		state_machine.transition_to('Wander')
	
func had_valid_target():
	if is_instance_valid(owner.target_node) and owner.target_node and owner.target_node.is_inside_tree():
		return true
	else:
		return false

#func get_distance_to_target(ctx):
#	var ant = ctx['ant']
#	var distance = ant.position.distance_to(ant.target_node.position)
#	return distance	


