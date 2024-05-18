extends Control

func new_message(message:String):
	var this_message = Label.new()
	this_message.text = message
	%MessageFeed.add_child(this_message)
	call_deferred("scroll_down")

func scroll_down():
	%Scroll.scroll_vertical = %Scroll.get_v_scroll_bar().max_value
