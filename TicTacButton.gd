extends TextureButton

const otex = preload("res://OGlow.png")
const xtex = preload("res://XGlow.png")
const hover = preload("res://Hover.png")

var value = 0
export(int) var row = -1
export(int) var col = -1

signal custom_pressed(button)

func _ready():
	reset()

func setX( val=1 ):
	value = val;
	texture_normal = xtex
	texture_hover = xtex

func setO( val=10 ):
	value = val
	texture_normal = otex
	texture_hover = otex

func reset():
	value = 0
	texture_normal = null
	texture_hover = hover

func _on_TicTacButton_pressed():
	emit_signal( "custom_pressed", self )
