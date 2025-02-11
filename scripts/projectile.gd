extends Node2D

@export var speed: float = 300.0
@export var damage: float = 10.0
@export var is_aoe: bool = false # Se for verdadeiro, dano em área
@export var aoe_radius: float = 50.0 # Raio da explosão (se for AOE)

var target: Node2D = null

func set_target(new_target):
	target = new_target

func _process(delta):
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta

		# Se estiver perto do alvo, explode
		if global_position.distance_to(target.global_position) < 5:
			hit_target()

func hit_target():
	if is_aoe:
		# Aplica dano a todos inimigos na área
		for body in get_tree().get_nodes_in_group("enemies"):
			if body.global_position.distance_to(global_position) <= aoe_radius:
				body.take_damage(damage)
	else:
		if target and is_instance_valid(target):
			target.take_damage(damage)

	queue_free()
