class_name OrgRepo
extends Node

const OrganisationNames = ["Atwell Co.","Fast Trains","Here's a Box Ltd.","Secure Prints","Fair News"]

const OrganisationDB = {
	"Atwell Co." = {
		name = "Atwell Co.",
		funds = 30000,
		revenue = 200000,
		revenue_growth_rate = 1.1,
		additional_starting_funds = 0,
		reputation = 15,
		cyber_budget = 0.15,
		budget_incremental = 0.1,
		threat_actors = [ ThreatRepo.Threat_Rating.LOW, ThreatRepo.Threat_Rating.MEDIUM ]
	},
	"Fast Trains" = {
		name = "Fast Trains",
		funds = 200000,
		reputation = 20,
		revenue = 2000000,
		revenue_growth_rate = 1.2,
		additional_starting_funds = 0,
		cyber_budget = 0.10,
		budget_incremental = 0.1,
		threat_actors = [ ThreatRepo.Threat_Rating.LOW, ThreatRepo.Threat_Rating.MEDIUM, ThreatRepo.Threat_Rating.HIGH ]
	},
	"Here's a Box Ltd." = {
		name = "Here's a Box Ltd.",
		funds = 150000,
		reputation = 35,
		revenue = 5000000,
		revenue_growth_rate = 1.3,
		additional_starting_funds = 0,
		cyber_budget = 0.03,
		budget_incremental = 0.1,
		threat_actors = [ ThreatRepo.Threat_Rating.LOW, ThreatRepo.Threat_Rating.MEDIUM, ThreatRepo.Threat_Rating.HIGH ]
	},
	"Secure Prints" = {
		name = "Secure Prints",
		funds = 100000,
		reputation = 30,
		revenue = 400000,
		revenue_growth_rate = 1.1,
		additional_starting_funds = 0,
		cyber_budget = 0.025,
		budget_incremental = 0.1,
		threat_actors = [ ThreatRepo.Threat_Rating.LOW, ThreatRepo.Threat_Rating.MEDIUM, ThreatRepo.Threat_Rating.HIGH, ThreatRepo.Threat_Rating.CRITICAL ]
	},
	"Fair News" = {
		name = "Fair News",
		funds = 100000,
		reputation = 60,
		revenue = 2500000,
		revenue_growth_rate = 1.05,
		additional_starting_funds = 0,
		cyber_budget = 0.04,
		budget_incremental = 0.1,
		threat_actors = [ ThreatRepo.Threat_Rating.LOW, ThreatRepo.Threat_Rating.MEDIUM, ThreatRepo.Threat_Rating.HIGH, ThreatRepo.Threat_Rating.CRITICAL ]
	}
}

const Objectives = {
	"0" = {
		description = "Achieve reputation score 50",
		type = "REPUTATION",
		value = 50
	}
}

const Failures = {
	"0" = {
		description = "Fall below reputation 10",
		type = "REPUTATION",
		value = 9
	}
}
