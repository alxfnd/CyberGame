extends Control

signal prompt_closed

func set_title(title:String):
	%Title.text = title

func set_body(body:String):
	%Body.text = body

func _on_ok_pressed():
	queue_free()
	prompt_closed.emit()
