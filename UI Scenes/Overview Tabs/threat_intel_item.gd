extends VBoxContainer

signal show_clicked
signal threat_researched
signal active_research

var researched:bool = false
var viewing:bool = false
var research_timer_increment:float
var research_timer_counter:float = 0
var research_cost:int

var display_name:String
var threat_rating
var successful_attacks:int = 0

func initiate_item(threat_information:ThreatActor):
	display_name = threat_information.name
	var sum:float = float(100 / threat_information.research_time) / 10.0
	research_timer_increment = sum #threat_information.research_time / 100
	$ResearchTimer.add_to_group("timer")
	threat_rating = threat_information.rating
	%Attacks.text = "Attacks: " + str(successful_attacks)
	#Set description
	pass

func _on_info_button_pressed():
	if !researched:
		%InfoButton.disabled = true
		$ResearchTimer.start()
		$ProgressBar.show()
		active_research.emit()
		return
	if !viewing:
		show_clicked.emit(self)
		%DescriptionBox.show()
		viewing = true
	else:
		viewing = false
		%DescriptionBox.hide()

func hide_description():
	viewing = false
	%DescriptionBox.hide()

func _on_timer_timeout():
	if research_timer_counter >= 100:
		researched = true
		$ProgressBar.hide()
		%InfoButton.text = "  Show  "
		%InfoButton.disabled = false
		%ThreatName.text = display_name
		%ThreatRisk.text = "Threat Level: " + str(threat_rating)
		threat_researched.emit(display_name)
		$ResearchTimer.stop()
	research_timer_counter += research_timer_increment
	$ProgressBar.value = research_timer_counter

func toggle_research_button(research_toggle):
	%InfoButton.disabled = research_toggle

func update_successful_attacks():
	successful_attacks += 1
	%Attacks.text = "Attacks: " + str(successful_attacks)
