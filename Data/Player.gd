class_name Player
extends Resource

signal funds_updated

var organisation: Dictionary
var reputation: int
var yearly_revenue: int
var current_funds: int
var monthly_funds: int

func create_player(organisation_name: String = ""):
	if organisation_name == "":
		organisation_name = OrgRepo.OrganisationNames.pick_random()
	organisation = OrgRepo.OrganisationDB[organisation_name].duplicate()
	yearly_revenue = organisation.revenue
	current_funds = organisation.revenue * organisation.cyber_budget
	monthly_funds = current_funds * organisation.budget_incremental

func item_bought(item_cost: int):
	current_funds -= item_cost
	funds_updated.emit()

func monthly_checks():
	yearly_revenue *= organisation.revenue_growth_rate
	monthly_funds = (yearly_revenue * organisation.cyber_budget) * organisation.budget_incremental
	current_funds += monthly_funds
	funds_updated.emit()

func update_reputation(new_reputation: int):
	reputation = new_reputation
