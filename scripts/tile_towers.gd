extends TileMapLayer

@export var tower_scene: PackedScene  # Cena da torre para instanciar
var is_placing_tower: bool = true  # Recebe da interface o estado de colocação de torre

@export var player_verb = 100

func _process(event):
	if is_placing_tower and Input.is_action_just_pressed("click"):
		if player_verb < tower_scene.tower_data.cost:
			return
		var world_position = get_global_mouse_position()
		var cell_position = map_to_local(world_position)
		
		# Verifica se o tile é válido
		if is_tile_valid(cell_position):
			place_tower(cell_position)
			is_placing_tower = false  # Desativa o modo de colocar torre

func place_tower(cell_position: Vector2):
	# Converte para posição mundial e instancia a torre
	var tower = tower_scene.instantiate() as Node2D
	var world_position = (cell_position)
	tower.position = world_position
	player_verb -= tower_scene.tower_data.cost
	add_child(tower)

func is_tile_valid(cell_position: Vector2i) -> bool:
	# Verifica se a posição da célula está dentro dos limites do TileMap
	if not is_position_in_bounds(cell_position):
		return false

	# Obtém o valor da célula na posição especificada
	var tile_data = get_cell_tile_data(cell_position)

	# Supondo que 1 seja um tile de construção válido
	return tile_data == tile_data.get_custom_data("placebel")

func is_position_in_bounds(cell_position: Vector2i) -> bool:
	# Verifica se a posição da célula está dentro dos limites do TileMap
	return cell_position.x >= 0 and cell_position.y >= 0 and cell_position.x < get_used_rect().size.x and cell_position.y < get_used_rect().size.y
