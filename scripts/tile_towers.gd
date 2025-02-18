extends TileMapLayer

@export var tower_scene: PackedScene  

signal tower_placed(cell_position: Vector2, cost: int)

var is_placing_tower: bool = false  
var current_tower_instance: Node
var current_tower_data: TowerData  # Armazena os dados da torre selecionada

func start_placing_tower(tower_data: TowerData):
	current_tower_data = tower_data
	is_placing_tower = true

func cancel_placing_tower():
	is_placing_tower = false
	if current_tower_instance:
		current_tower_instance.queue_free()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_placing_tower:
			handle_tower_placement()

func handle_tower_placement():
	if not current_tower_data:
		push_error("Nenhuma torre selecionada para construir!")
		return

	# Verifica o custo pelo GameState
	if GameState.player_funds < current_tower_data.cost:
		push_error("Funds insuficientes!")
		return

	var world_position = get_global_mouse_position()
	var cell_position = local_to_map(world_position)

	# Verifica se o tile é válido
	if is_tile_valid(cell_position):
		place_tower(cell_position)
		is_placing_tower = false
	else:
		push_error("Posição inválida!")

func place_tower(cell_position: Vector2):
	# Instancia a torre
	current_tower_instance = tower_scene.instantiate()
	current_tower_instance.tower_data = current_tower_data  # Passa os dados
	current_tower_instance.setup_tower()

	var world_position = map_to_local(cell_position)
	var sprite_height = current_tower_instance.sprite_node.texture.get_height() if current_tower_instance.sprite_node and current_tower_instance.sprite_node.texture else 0
	world_position.y -= sprite_height / 2  

	current_tower_instance.global_position = world_position
	add_child(current_tower_instance)

	# Atualiza recursos do jogador
	GameState.player_funds -= current_tower_data.cost

	# Notifica outros sistemas
	emit_signal("tower_placed", cell_position, current_tower_data.cost)
	
func is_tile_valid(cell_position: Vector2i) -> bool:
	# Centraliza a lógica de validação em outro sistema, se possível
	if not is_position_in_bounds(cell_position):
		return false

	var tile_data = get_cell_tile_data(cell_position)
	return tile_data and tile_data.get_custom_data("placeable")

func is_position_in_bounds(cell_position: Vector2i) -> bool:
	var used_rect = get_used_rect()
	return cell_position.x >= used_rect.position.x and cell_position.y >= used_rect.position.y and cell_position.x < (used_rect.position.x + used_rect.size.x) and cell_position.y < (used_rect.position.y + used_rect.size.y)
