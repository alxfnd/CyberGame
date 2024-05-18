extends HBoxContainer

signal item_bought_signal

var item_id:int
var item_name:String
var item_cost:int
var item_bought:bool = false

func set_item(this_id:int, this_name:String, this_cost:int):
	item_id = this_id
	item_name = this_name
	item_cost = this_cost
	$Name.text = item_name
	$Cost.text = " £" + str(item_cost) + " "
	$Buy.text = " Buy "

func have_cost(resources:int):
	if resources >= item_cost and item_bought == false:
		$Buy.disabled = false
	else:
		$Buy.disabled = true

func _on_buy_pressed():
	item_bought_signal.emit(item_id)
	item_bought = true
	$Buy.disabled = true
