extends Control

@onready var exit_button : TextureButton = $MarginContainer5/TextureButton

@export var buy_manager_btn : TextureButton
@export var buy_ceo_btn : TextureButton

@export var manager_checkmark : TextureButton
@export var ceo_checkmark : TextureButton

@export var rows : Control

var manager : bool = false
var ceo : bool = false

var once_ : bool = false

func _ready():
	exit_button.button_up.connect(_exit_button)
	
	buy_manager_btn.button_up.connect(_buy_manager_btn)
	buy_ceo_btn.button_up.connect(_buy_ceo_btn)

func _process(_delta):
	if get_parent().joystick and visible:
		get_parent().joystick.disabled = visible

func _exit_button():
	if not once_:
		once_ = true
		get_parent().get_node("notice/notice_expand").show()
	hide();
	get_parent().joystick.disabled = visible

func _buy_manager_btn():
	pass
	# ANDROID BUY PRODUCT
	buy_manager_btn.hide();
	manager_checkmark.show()
	
	manager = true

func _buy_ceo_btn():
	pass
	# ANDROID BUY PRODUCT
	buy_ceo_btn.hide();
	ceo_checkmark.show();
	
	ceo = true

func update_level(row):
	var row_ = rows.get_node_or_null(str(row+1))
	if not row_: return
	if manager:
		row_.get_node("NinePatchRect3/NinePatchRect5").enabled = true
	if ceo:
		row_.get_node("NinePatchRect4/NinePatchRect3").enabled = true
	
	row_.get_node("NinePatchRect2/NinePatchRect3").enabled = true
	var section = row_.get_node("NinePatchRect")
	section.get_node("active_top").show();
	section.get_node("hidden_bottom").show();
	section.get_node("active_bottom").hide();
	section.get_node("active_dot").show();
	section.get_node("hidden_top").hide();
	section.get_node("hidden_dot").hide();

	var previous_row = rows.get_node_or_null(str(row))
	if not previous_row: return
	var section2 = previous_row.get_node("NinePatchRect")
	section2.get_node("active_bottom").show();

#func 
