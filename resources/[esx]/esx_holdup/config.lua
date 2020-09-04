Config = {}
Config.Locale = 'en'

Config.PoliceNumberRequired = 3
Config.TimerBeforeNewRob = 3600 -- seconds

Config.MaxDistance    = 5 -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = false -- give black money? If disabled it will give cash instead.

Stores = {
	["paleto_twentyfourseven"] = {
		position = { x = 1736.32, y = 6419.47, z = 35.03 },
		reward = math.random(40000, 50000),
		number = 20,
		nameofstore = "(Paleto Bay)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["sandyshores_twentyfoursever"] = {
		position = { x = 1961.24, y = 3749.46, z = 32.34 },
		reward = math.random(40000, 50000),
		number = 17,
		nameofstore = "(Sandy Shores)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["littleseoul_twentyfourseven"] = {
		position = { x = -709.17, y = -904.21, z = 19.21 },
		reward = math.random(40000, 50000),
		number = 5,
		nameofstore = "(Little Seoul)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["ocean_liquor"] = {
		position = { x = -2959.33, y = 388.21, z = 14.00 },
		reward = math.random(40000, 50000),
		number = 12,
		nameofstore = "(Great Ocean Highway)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["rancho_liquor"] = {
		position = { x = 1126.80, y = -980.40, z = 45.41 },
		reward = math.random(40000, 50000),
		number = 6,
		nameofstore = "(El Rancho Blvd)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["sanandreas_liquor"] = {
		position = { x = -1219.85, y = -916.27, z = 11.32 },
		reward = math.random(40000, 50000),
		number = 3,
		nameofstore = "(San Andreas Avenue)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["grove_ltd"] = {
		position = { x = -43.40, y = -1749.20, z = 29.42 },
		reward = math.random(40000, 50000),
		number = 2,
		nameofstore = "(Grove Street)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["mirror_ltd"] = {
		position = { x = 1160.67, y = -314.40, z = 69.20 },
		reward = math.random(40000, 50000),
		number = 8,
		nameofstore = "(Mirror Park Boulevard)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["elgin_avn"] = {
		position = { x = 28.06, y = -1339.49, z = 29.5 },
		reward = math.random(40000, 50000),
		number = 1,
		nameofstore = "(Elgin Avn)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["vinewood_dwntwn"] = {
		position = { x = 378.08, y = 333.09, z = 103.57 },
		reward = math.random(40000, 50000),
		number = 7,
		nameofstore = "(Downtown Vinewood)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["banham_canyon"] = {
		position = { x = -3047.51, y = 585.64, z = 7.91 },
		reward = math.random(40000, 50000),
		number = 10,
		nameofstore = "(Banham Canyon)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["chumash"] = {
		position = { x = -3249.7, y = 1004.43, z = 12.83 },
		reward = math.random(40000, 50000),
		number = 11,
		nameofstore = "(Chumash store)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["richman_glen"] = {
		position = { x = -1829.21, y = 798.84, z = 138.19 },
		reward = math.random(40000, 50000),
		number = 13,
		nameofstore = "(Richman Glen)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["route68_harmony"] = {
		position = { x = 546.31, y = 2663.34, z = 42.16 },
		reward = math.random(40000, 50000),
		number = 14,
		nameofstore = "(Route 68, Harmony)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["route68_senora"] = {
		position = { x = 1169.24, y = 2717.8, z = 37.16 },
		reward = math.random(40000, 50000),
		number = 15,
		nameofstore = "(Route 68, Grand Senora Desert)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["sandy_shores2"] = {
		position = { x = 1387.88, y = 3607.52, z = 34.98 },
		reward = math.random(40000, 50000),
		number = 18,
		nameofstore = "(Sandy Shores)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["sa_freeway"] = {
		position = { x = 2673.1, y = 3286.42, z = 55.24 },
		reward = math.random(40000, 50000),
		number = 16,
		nameofstore = "(San Andreas Freeway)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["grapeseed"] = {
		position = { x = 1707.93, y = 4920.35, z = 42.06 },
		reward = math.random(40000, 50000),
		number = 19,
		nameofstore = "(Grapeseed Store)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["morningwood"] = {
		position = { x = -1478.93, y = -375.38, z = 39.16 },
		reward = math.random(40000, 50000),
		number = 4,
		nameofstore = "(Morningwood Store)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	},
	["palomino_fwy"] = {
		position = { x = 2549.38, y = 384.93, z = 108.62 },
		reward = math.random(40000, 50000),
		number = 9,
		nameofstore = "(Palomino Freeway)",
		secondsRemaining = 350, -- seconds
		lastrobbed = 0
	}
}
