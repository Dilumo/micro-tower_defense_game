extends Node2D

@export var phase_data: Resource
@export var spawn_point: Node2D

var current_wave_index: int = 0
var current_group_index: int = 0
var spawn_timer: Timer

func _ready():
	# Configura o timer para controlar o spawn
	spawn_timer = Timer.new()
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

	# Começa a primeira wave
	start_wave(current_wave_index)

func start_wave(wave_index: int):
	if wave_index >= phase_data.waves.size():
		print("Todas as waves foram concluídas!")
		return

	var wave_data: WaveData = phase_data.waves[wave_index]
	current_group_index = 0
	start_group(wave_data.groups[current_group_index])

func start_group(group_data: GroupData):
	spawn_timer.stop()

	# Spawna inimigos do grupo de acordo com o intervalo
	for i in range(group_data.count):
		await get_tree().create_timer(group_data.spawn_interval).timeout
		spawn_enemy(group_data.enemy_scene, group_data.path_variation)

	# Passa para o próximo grupo ou para a próxima wave
	current_group_index += 1
	var wave_data: WaveData = phase_data.waves[current_wave_index]

	if current_group_index < wave_data.groups.size():
		# Se houver mais grupos na wave, espera o tempo do delay
		await get_tree().create_timer(wave_data.spawn_delay).timeout
		start_group(wave_data.groups[current_group_index])
	else:
		# Passa para a próxima wave
		current_wave_index += 1
		start_wave(current_wave_index)

func spawn_enemy(enemy_scene: PackedScene, path_variation: float):
	var enemy = enemy_scene.instantiate()
	var pathFollow = PathFollow2D.new()
	pathFollow.add_child(enemy)
	spawn_point.add_child(pathFollow)

	# Aplica variação ao caminho inicial
	if path_variation > 0.0:
		enemy.global_position += Vector2(
			randf_range(-path_variation, path_variation),
			randf_range(-path_variation, path_variation)
		)

func _on_spawn_timer_timeout():
	pass
