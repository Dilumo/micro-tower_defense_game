extends Button

# Define o sinal que será emitido
signal tower_selected(tower_data)

@export var tower_data: TowerData  # Dados da torre associados a este botão

# Referências aos nós internos
@export var icon_node : TextureRect
@export var cost_label : Label

func _ready():
	if not tower_data:
		push_error("TowerData não configurado no botão de seleção!")
		return
	
	# Configura a aparência do botão
	setup_button()

	# Conecta o clique ao envio do sinal
	self.pressed.connect(_on_button_pressed)

func setup_button():
	# Define o ícone
	if tower_data.icon:
		icon_node.texture = tower_data.icon
	else:
		icon_node.visible = false  # Oculta o ícone se não for configurado

	# Define o custo
	cost_label.text = "$ " + str(tower_data.cost)

func _on_button_pressed():
	# Emite o sinal com os dados da torre ao clicar no botão
	emit_signal("tower_selected", tower_data)
