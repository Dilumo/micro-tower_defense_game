extends Node2D

@export var enemy_spawner: Node2D
@export var waves: Array = []  # Lista de ondas contendo grupos de inimigos e suas propriedades

var current_wave_index: int = 0
var wave_timer: Timer

func _ready():
	wave_timer = Timer.new()
	add_child(wave_timer)
	wave_timer.timeout.connect(spawn_next_wave)
	start_phase()

func start_phase():
	current_wave_index = 0
	spawn_next_wave()

func spawn_next_wave():
	if current_wave_index >= waves.size():
		print("Fase completa!")
		return

	var wave = waves[current_wave_index]
	spawn_wave(wave)
	current_wave_index += 1

func spawn_wave(wave: WaveData):
	for group in wave.groups:
		await get_tree().create_timer(group.group_delay).timeout
		spawn_group(group)

func spawn_group(group: GroupData):
	for i in range(group.count):
		enemy_spawner.spawn_enemy(group.enemy_scene, group.speed)
		await get_tree().create_timer(group.interval).timeout
