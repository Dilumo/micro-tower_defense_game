extends Node2D

@export var money_label : Label 
@export var collective_consciousness_label : Label 
@export var goal_point : Area2D

var money: int = 100
var collective_consciousness: float = 0.0

func _ready():
	update_ui()
	goal_point.took_damage.connect(increase_consciousness)

func update_ui():
	money_label.text = "Verba: $" + str(money)
	collective_consciousness_label.text = "Consciência: " + str(collective_consciousness) + "%"

func add_money(amount: int):
	money += amount
	update_ui()

func increase_consciousness(amount: float):
	collective_consciousness += amount
	if collective_consciousness >= 100:
		game_over()
	update_ui()

func game_over():
	print("Fim de jogo! A população se revoltou.")
	
