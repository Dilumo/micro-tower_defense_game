extends Node

@export var construction_controller: Node
@export var ui_controller: Node

func _ready():
	ui_controller.tower_selected.connect(_on_tower_selected)
	construction_controller.tower_placed.connect(_on_tower_placed)

func _on_tower_selected(tower_data):
	# Envia o comando para o controlador de construção
	construction_controller.start_construction(tower_data)
	
func _on_tower_placed(cell_position: Vector2, cost: int):
	if GameState.has_enough_funds(cost):
		GameState.modify_funds(-cost)
		print("Torre colocada em:", cell_position, "Custo:", cost)
	else:
		push_error("Erro: Tentativa de colocar torre sem fundos suficientes!")
