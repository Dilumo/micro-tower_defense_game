extends Area2D

signal took_damage

func _ready():
	add_to_group("targets")

func take_damage(amount: float):
	# Aumenta a Consciência Coletiva
	emit_signal("took_damage", amount)
