extends CharacterBody2D

@export var attack_damage: float = 5.0
@export var attack_interval: float = 2.0

@export var speed: float = 20.0  # Velocidade do inimigo
@export var health: float = 100.0  # Determinação do inimigo
@export var highlight_sprite: Sprite2D  # Referência ao efeito visual

@export var attack_area: Area2D
@export var animation: AnimatedSprite2D

var path_follow: PathFollow2D  # Referência ao PathFollow2D
var is_being_attacked: bool = false  # Indica se o inimigo está sendo atacado

var current_target: Node = null  # Referência ao alvo atual
var attack_timer: Timer

signal defeated  # Novo sinal emitido quando o inimigo é derrotado

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_interval
	attack_timer.one_shot = false
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	attack_area.area_entered.connect(attack_area_entered)
	attack_area.area_exited.connect(attack_area_exited)
	add_child(attack_timer)
	animation.play("walking")

	# O inimigo deve ser filho de um PathFollow2D
	path_follow = get_parent()
	if not path_follow is PathFollow2D:
		push_error("O inimigo deve ser filho de um PathFollow2D!")
		return
	path_follow.rotates = false

func _process(delta):
	move(delta)

func move(delta: float):
	if path_follow:
		# Move o PathFollow2D ao longo do caminho
		path_follow.progress += speed * delta
		# Atualiza a posição do inimigo para a posição do PathFollow2D
		global_position = path_follow.global_position

func _on_attack_timer_timeout():
	if current_target and current_target.is_in_group("targets") and is_instance_valid(current_target):
		if current_target.has_method("take_damage"):
			current_target.take_damage(attack_damage)  # Causa dano ao alvo
			disappear()  # Remove o inimigo após atacar
	else:
		# Se o alvo não for mais válido, para o timer
		attack_timer.stop()
		current_target = null

func disappear():
	emit_signal("defeated")  # Informa ao PhaseManager ou outro sistema que o inimigo foi derrotado
	get_parent().queue_free()  # Remove o PathFollow2D (e o inimigo junto)


func take_damage(amount: float):
	health -= amount
	if health <= 0:
		die()
	else:
		set_being_attacked(true)  # Ativa o efeito visual

func set_being_attacked(value: bool):
	is_being_attacked = value
	highlight_sprite.visible = value  # Mostra ou esconde o efeito visual

func die():
	emit_signal("defeated")  # Informa ao PhaseManager que o inimigo foi derrotado
	queue_free()  # Remove o inimigo da cena

func attack_area_entered(body):
	if body.is_in_group("targets") and current_target == null:
		print("Inimigo encontrou o alvo:", body.name)
		current_target = body
		attack_timer.start()
		speed = 0  # Para o movimento

func attack_area_exited(body):
	if body == current_target:
		current_target = null
		attack_timer.stop()
		speed = 20  # Restaura o movimento
