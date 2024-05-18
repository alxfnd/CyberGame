extends VBoxContainer

signal item_bought_signal
signal viewing_category_signal
signal updated_view

@export var item:PackedScene

var this_itemDB:Dictionary
var category:String

@onready var viewing:bool = false
@onready var total_items:int = 0
@onready var total_bought:int = 0

func set_category(this_category:String):
	category = this_category
	this_itemDB = CyberRepo.ItemDB.get(category)
	populate_items()
	update_item_count()
	$MarginContainer/HBoxContainer/Title.text = category

func populate_items():
	for each_item in this_itemDB:
		var new_item = item.instantiate()
		new_item.set_item(this_itemDB[each_item].id, this_itemDB[each_item].name, int(this_itemDB[each_item].cost))
		new_item.add_to_group(category)
		new_item.item_bought_signal.connect(item_bought)
		%ItemBox.add_child(new_item)
		total_items = total_items + 1
	%ScrollContainer.custom_minimum_size = Vector2(0,200)
	%ScrollContainer.hide()
	
func update_item_count():
	$MarginContainer/HBoxContainer/Items.text = " " + str(total_bought) + "/" + str(total_items) + " "


func _on_view_button_pressed():
	if viewing:
		viewing = false
		$MarginContainer/HBoxContainer/ViewButton.text = " View "
	else:
		viewing = true
		$MarginContainer/HBoxContainer/ViewButton.text = " Hide "
	change_controls()
	viewing_category_signal.emit(category)

func change_controls():
	if viewing:
		%ScrollContainer.show()
	else:
		%ScrollContainer.hide()
	pass

func view_items():
	for node_item in %ItemBox.get_children():
	#for node_item in get_children():
		if node_item.is_in_group(category):
			if viewing:
				node_item.show()
			else:
				node_item.hide()
	#await call_deferred("set_view_size")

func item_bought(item_id):
	item_bought_signal.emit(item_id)
