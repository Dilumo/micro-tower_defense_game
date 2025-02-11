extends Node2D

@export var resident_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var timer: Timer
@export var path: Path2D  # Referência ao Path2D

func _ready():
	if not timer:
		timer = Timer.new()
		add_child(timer)
	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	if resident_scene and path:
		# Cria um novo PathFollow2D para o inimigo
		var path_follow = PathFollow2D.new()
		path.add_child(path_follow)  # Adiciona o PathFollow2D ao Path2D

		# Instancia o inimigo e o adiciona como filho do PathFollow2D
		var resident = resident_scene.instantiate()
		path_follow.add_child(resident)
	else:
		push_error("Cena do residente ou Path2D não configurados!")
