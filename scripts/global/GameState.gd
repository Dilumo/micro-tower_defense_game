extends Node

@export var player_funds: int = 100
@export var population_awareness: float = 0.0
@export var is_paused: bool = false

signal funds_changed(new_funds)
signal awareness_changed(new_awareness)

func modify_funds(amount: int):
	player_funds += amount
	emit_signal("funds_changed", player_funds)
	
func deduct_funds(amount: int):
	if has_enough_funds(amount):
		player_funds -= amount
		emit_signal("funds_changed", player_funds)
	else:
		push_error("Funds insuficientes!")

func modify_awareness(amount: float):
	population_awareness += amount
	emit_signal("awareness_changed", population_awareness)

func toggle_pause():
	is_paused = not is_paused
	get_tree().paused = is_paused
	
func has_enough_funds(amount: int) -> bool:
	return player_funds >= amount
