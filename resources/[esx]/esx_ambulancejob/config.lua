Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1,  x = 1.5, y = 1.5, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = false }

Config.ReviveReward               = 5000  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = false -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 20 * minute  -- Time til respawn is available
Config.BleedoutTimer              = 15 * minute -- Time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = true
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = { coords = vector3(299.87, -578.79, 43.26), heading = 69.85 }

Config.Hospitals = {

	CentralLosSantos = {

		Blips = {

			{
				coords = vector3(308.75, -595.33, 43.28),
				sprite = 61,
				scale  = 1.0,
				color  = 1
			},

			{
				coords = vector3(338.84, -1394.66, 32.51),
				sprite = 61,
				scale  = 1.0,
				color  = 1
			},

			{
				coords = vector3(1839.07, 3673.22, 34.28),
				sprite = 61,
				scale  = 1.0,
				color  = 1
			},

			{
				coords = vector3(-247.98, 6331.68, 32.43),
				sprite = 61,
				scale  = 1.0,
				color  = 1
			}
			
		},

		AmbulanceActions = {
			vector3(270.18, -1363.27, 24.54)
		},

		Pharmacies = {
			vector3(268.0, -1365.27, 24.54)
		},

		Vehicles = {
			{
				Spawner = vector3(294.43, -1448.43, 29.97),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(322.43, -1478.23, 29.81), heading = 227.14, radius = 4.0 },
					{ coords = vector3(324.95, -1474.63, 29.81), heading = 227.8, radius = 4.0 },
					{ coords = vector3(328.2, -1471.52, 28.77), heading = 230.99, radius = 4.0 },
					{ coords = vector3(331.19, -1467.88, 29.72), heading = 226.54, radius = 4.0 }
				}
			}
		},

		VehiclesDeleter = {
			{
				Marker = { type = 24, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(312.21, -1446.61, 29.8)
			},
			{
				Marker = { type = 24, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(313.4, -1465.01, 46.51)
			},
			{
				Marker = { type = 24, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(299.43, -1453.34, 46.51)
			},
		},

		Helicopters = {
			{
				Spawner = vector3(305.98, -1459.73, 46.51),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(313.43, -1465, 46.51), heading = 142.47, radius = 5.0 },
					{ coords = vector3(299.99, -1453.41, 46.41), heading = 143.02, radius = 5.0 },
				}
			}
		},

	}
}

Config.AuthorizedVehicles = {

	ambulance = {
		{ model = 'lsambulance', label = 'Ambulance Van', price = 35000}
	},

	emr = {
		{ model = 'lsambulance', label = 'Ambulance Van', price = 35000},
	},

	emtb = {
		{ model = 'lsambulance', label = 'Ambulance Van', price = 35000},
	},

	emti = {
		{ model = 'lsambulance', label = 'Ambulance Van', price = 35000},
		{ model = 'ems', label = 'Forde', price = 50000}
	},

	emta = {
		{ model = 'lsambulance', label = 'Ambulance Van', price = 35000},
		{ model = 'ems', label = 'Forde', price = 50000}
	},

	paramedic = {
		{ model = 'lsambulance', label = 'Ambulance Van', price = 35000},
		{ model = 'ems', label = 'Forde', price = 50000},
		{ model = 'polchgr', label = 'Medic Charger', price = 50000},
		{ model = "fibc", label = "EMS Ford", price = 5000},
		{ model = "fbi2", label = "EMS Granger", price = 5000}
	},

	lparamedic = {
		{ model = 'lsambulance', label = 'Ambulance Van', price = 35000},
		{ model = 'ems', label = 'Forde', price = 50000},
		{ model = 'polchgr', label = 'Medic Charger', price = 50000},
		{ model = "fibc", label = "EMS Ford", price = 5000},
		{ model = "fbi2", label = "EMS Granger", price = 5000}
	},

	commander = {
		{ model = 'lsambulance', label = 'Ambulance Van', price = 35000},
		{ model = 'ems', label = 'Forde', price = 50000},
		{ model = 'polchgr', label = 'Medic Charger', price = 50000},
		{ model = "fibc", label = "EMS Ford", price = 5000},
		{ model = "fbi2", label = "EMS Granger", price = 5000}
	},
	
	boss = {
		{ model = 'lsambulance', label = 'Ambulance Van', price = 35000},
		{ model = 'ems', label = 'Forde', price = 50000},
		{ model = 'polchgr', label = 'Medic Charger', price = 50000},
		{ model = "fibc", label = "EMS Ford", price = 5000},
		{ model = "fbi2", label = "EMS Granger", price = 5000}
	}

}

Config.AuthorizedHelicopters = {

	ambulance = {},


	emti = {
		{ model = 'polmav', label = 'Emergecny Maverick', price = 150000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 300000 }
	},

	emta = {
		{ model = 'polmav', label = 'Emergecny Maverick', price = 150000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 300000 }
	},

	paramedic = {
		{ model = 'polmav', label = 'Emergecny Maverick', price = 150000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 300000 }
	},

	sparamedic = {
		{ model = 'polmav', label = 'Emergecny Maverick', price = 150000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 300000 }
	},

	lparamedic = {
		{ model = 'polmav', label = 'Emergecny Maverick', price = 150000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 300000 }
	},

	commander = {
		{ model = 'polmav', label = 'Emergecny Maverick', price = 150000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 300000 }
	},

	boss = {
		{ model = 'polmav', label = 'Emergecny Maverick', price = 150000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 300000 }
	}

}
