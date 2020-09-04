Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 21
Config.MarkerTypeboss             = 22
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }


Config.nightclubShops = {
	Parking = {

		Blips = {
			{
				Pos     = { x = 261.54, y = -763.29, z = 31.09 },
				Sprite  = 93,
				Display = 4,
				Scale   = 1.0,
				Name    = "CoffeShop",
				Colour  = 67,
			},
			
		},

		Cloakrooms = {
			{ x = -1619.82, y = -3020.23, z =-75.21 },
		},

		Refrigerators = {
			{ x = -1580.1, y = -3018.27, z = -79.01 },
			{ x = -1582.93, y = -3014.04, z = -76.01 },
		},

		Bars = {
			{ x = -561.7, y = 289.5, z = 82.18 },
		},

		BossActions = {
			{ x = -1619.63, y = -3010.93, z = -75.21 }
		},

	}
}

Config.AuthorizedFoods = {
	{ name = 'coffee', label = "Ghave", price = 250 },
	{ name = 'tea', label = "Chaee", price = 150 },
	{ name = 'donut', label = "Donut", price = 250 },
	{ name = 'wine', label = "Sharab", price = 500 },
	{ name = 'beer', label = "Abjoo", price = 400 },
	{ name = 'sandwich', label = "Sandwich", price = 300 },
	{ name = 'cigar', label = "Cigar", price = 100 },
	{ name = 'jager',      label = 'Jager',   price = 300 },
    { name = 'vodka',      label = 'Vodka',   price = 300 },
    { name = 'rhum',       label = 'Rhum',    price = 300 },
    { name = 'whisky',     label = 'Whisky',  price = 300 },
    { name = 'tequila',    label = 'Tquila', price = 300 },
    { name = 'martini',    label = 'Martini', price = 300 }
}

Config.AuthorizedDrinks= {
	{ name = 'whiskey', label = "Whiskey", price = 500 },
	{ name = 'wine', label = "Sharab", price = 500 },
	{ name = 'beer', label = "Abjoo", price = 400 },
	{ name = 'cigar', label = "Cigar", price = 100 },
	{ name = 'soda',        label = 'Soda',     price = 4 },
    { name = 'jusfruit',    label = 'Juice', price = 3 },
    { name = 'icetea',      label = 'Icetea',   price = 4 },
    { name = 'energy',      label = 'Energy Dring',   price = 7 },
    { name = 'drpepper',    label = 'DR. Pepper', price = 2 },
    { name = 'limonade',    label = 'Lemonade', price = 1 }
}

Config.Uniforms = {
	baeman_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 40,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 40,
			['pants_1'] = 28,   ['pants_2'] = 2,
			['shoes_1'] = 38,   ['shoes_2'] = 4,
			['chain_1'] = 118,  ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1'] = 8,    ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 5,
			['pants_1'] = 44,   ['pants_2'] = 4,
			['shoes_1'] = 0,    ['shoes_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 2
		}
	},
	dancer_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 40,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 40,
			['pants_1'] = 28,   ['pants_2'] = 2,
			['shoes_1'] = 38,   ['shoes_2'] = 4,
			['chain_1'] = 118,  ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1'] = 8,    ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 5,
			['pants_1'] = 44,   ['pants_2'] = 4,
			['shoes_1'] = 0,    ['shoes_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 2
		}
	},
	viceboss_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 40,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 40,
			['pants_1'] = 28,   ['pants_2'] = 2,
			['shoes_1'] = 38,   ['shoes_2'] = 4,
			['chain_1'] = 118,  ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1'] = 8,    ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 5,
			['pants_1'] = 44,   ['pants_2'] = 4,
			['shoes_1'] = 0,    ['shoes_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 2
		}
	},
	boss_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 40,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 40,
			['pants_1'] = 28,   ['pants_2'] = 2,
			['shoes_1'] = 38,   ['shoes_2'] = 4,
			['chain_1'] = 118,  ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1'] = 8,    ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 5,
			['pants_1'] = 44,   ['pants_2'] = 4,
			['shoes_1'] = 0,    ['shoes_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 2
		}
	},
}