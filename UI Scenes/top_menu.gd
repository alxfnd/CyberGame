extends Control

signal pause_game

func set_org(this_name:String, value:int):
	%OrgName.set_text(this_name)
	%Funds.set_text("£" + str(value))
	pass

func update_funds(value:int):
	%Funds.set_text("£" + str(value))
	pass

func _on_exit_button_pressed():
	get_tree().quit()

func update_time(time:String):
	%Time.set_text("Date: " + time)

func update_dormant(total:int):
	%Dormant.set_text("Dormant Threats: " + str(total))

func update_active(total:int):
	%Active.set_text("Active Threats: " + str(total))

func _on_pause_button_pressed():
	pause_game.emit()
