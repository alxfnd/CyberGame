extends Control

signal item_bought_signal

@export var control_box:PackedScene
var itemCategory = CyberRepo.Item_Categories

@onready var is_ready:bool = false
@onready var control_menu = %MasterContainer
@onready var preview_box = %LocationPreview
@onready var total_items = 0

# For positioning > determine_controls_position()
@onready var bottom_line = (get_viewport().size.y - 260)

var hide_control_position = Vector2(2000,2000)

# Called when the node enters the scene tree for the first time.
func _ready():
	determine_controls_position()
	for category in itemCategory:
		var new_control_box = control_box.instantiate()
		new_control_box.set_category(category)
		new_control_box.add_to_group("category")
		new_control_box.viewing_category_signal.connect(hide_non_focused_categories)
		new_control_box.updated_view.connect(determine_controls_position)
		new_control_box.item_bought_signal.connect(item_bought)
		control_menu.add_child(new_control_box)
	hide()


# When a category control is viewed, it emits a signal with its category name
# This is used to locate child nodes which are not focussed to hide them
func hide_non_focused_categories(category:String):
	for child_node in control_menu.get_children():
		if child_node.is_in_group("category") and child_node.category != category:
				child_node.viewing = false
				child_node.change_controls()

func determine_controls_position():
	set_position(Vector2(0,0)) # I don't know why this is required, but it just is.
	var new_x = 50 if get_global_rect().position.x < (get_viewport().size.x / 2) else -550
	var new_y = min(0, bottom_line - control_menu.get_global_rect().size.y - get_global_rect().position.y)
	set_position(Vector2(new_x,new_y))

func hide_control():
	position = hide_control_position

func _on_master_container_resized():
	if control_menu == null:
		return
	determine_controls_position()

func set_context_info(this_info:Dictionary, this_image:Texture2D):
	%LocationPreview.set_context_info(this_info,this_image)
	pass

func item_bought(item_id):
	item_bought_signal.emit(item_id)

func update_control_strengths(cat:String, value:int):
	%LocationPreview.update_control_strength(cat,value)

func update_reputation(value:int):
	%LocationPreview.update_reputation(value)

func update_service_states(service_states):
	%LocationPreview.update_service_states(service_states)
