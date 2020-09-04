Config = {}
Config.Locale = 'en'

Config.DoorList = {

	--
	-- Mission Row First Floor
	--

	-- Entrance Doors
	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = {'police'},
		locked = false,
		maxDistance = 2.5,
		doors = {
			{objHash = GetHashKey('v_ilev_ph_door01'), objHeading = 270.0, objCoords = vector3(434.7, -980.6, 30.8)},
			{objHash = GetHashKey('v_ilev_ph_door002'), objHeading = 270.0, objCoords = vector3(434.7, -983.2, 30.8)}
		}
	},

	--Hospital
	{
		objHash = GetHashKey('v_ilev_cor_firedoorwide'),
		objCoords = vector3(272.21, -1361.56, 24.55),
		textCoords = vector3(271.96, -1360.82, 24.54),
		authorizedJobs = {'ambulance', 'offambulance'},
		locked = true,
		objHeading = -39.99,
		maxDistance = 2.0
	},

	{
		objHash = GetHashKey('v_ilev_cor_firedoorwide'),
		objCoords = vector3(265.06, -1363.31, 24.55),
		textCoords = vector3(265.14, -1362.55, 24.54),
		authorizedJobs = {'ambulance'},
		locked = true,
		objHeading = -129.99,
		maxDistance = 2.0
	},
	--Bighouse
	{
		textCoords = vector3(-1477.92, 884.67, 183.5),
		authorizedJobs = {'Michelson'},
		locked = true,
		maxDistance = 7.0,
		doors = {
			{objHash = GetHashKey('prop_lrggate_01_l'), objHeading = 79.0, objCoords = vector3(-1477.81, 882.28, 182.9)},
			{objHash = GetHashKey('prop_lrggate_01_r'), objHeading = 79.0, objCoords = vector3(-1476.77, 887.54, 182.83)}
		}
	},
	{
		objHash = GetHashKey('e2_fightcagegate'),
		objHeading = 240.0,
		objCoords = vector3(907.85, -1813.8, 24.97),
		textCoords = vector3(907.56, -1814.05, 25.5),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 1.25
	},


	-- To locker room & roof
	{
		objHash = GetHashKey('v_ilev_ph_gendoor004'),
		objHeading = 90.0,
		objCoords = vector3(449.6, -986.4, 30.6),
		textCoords = vector3(450.1, -986.3, 31.7),
		authorizedJobs = {'police', 'offpolice'},
		locked = true,
		maxDistance = 1.25
	},

	-- Rooftop
	{
		objHash = GetHashKey('v_ilev_gtdoor02'),
		objHeading = 90.0,
		objCoords = vector3(464.3, -984.6, 43.8),
		textCoords = vector3(464.3, -984.0, 44.8),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 1.25
	},

	-- Hallway to roof
	{
		objHash = GetHashKey('v_ilev_arm_secdoor'),
		objHeading = 90.0,
		objCoords = vector3(461.2, -985.3, 30.8),
		textCoords = vector3(461.5, -986.0, 31.5),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 1.25
	},

	{
		objHash = GetHashKey('v_ilev_j2_door'),
		objHeading = 355.0,
		objCoords = vector3(-400.79, 4707.29, 264.56),
		textCoords = vector3(-400.42, 4707.54, 265.0),
		authorizedJobs = {'Michelson','DaniSara'},
		locked = true,
		maxDistance = 2.0
	},

	-- Captain Office
	{
		objHash = GetHashKey('v_ilev_ph_gendoor002'),
		objHeading = 180.0,
		objCoords = vector3(447.2, -980.6, 30.6),
		textCoords = vector3(447.2, -980.0, 31.7),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 1.25
	},

	--Michelson

	{
		objHash = GetHashKey('apa_p_mp_yacht_door_01'),
		objHeading = 90.0,
		objCoords = vector3(-2667.60, 1326.95, 147.59),
		textCoords = vector3(-2667.12, 1326.23, 148.0),
		authorizedJobs = {'Michelson'},
		locked = true,
		maxDistance = 2.25
	},

	{
		objHash = GetHashKey('prop_lrggate_01c_r'),
		objHeading = 90.0,
		objCoords = vector3(-2652.3, 1327.25, 147.05),
		textCoords = vector3(-2652.68, 1325.7, 148.0),
		authorizedJobs = {'Michelson'},
		locked = true,
		maxDistance = 2.25
	},

	{
		objHash = GetHashKey('apa_prop_ss1_mpint_garage2'),
		objCoords = vector3(-2652.43, 1307.36, 147.72),
		textCoords = vector3(-2652.77, 1306.93, 147.5),
		authorizedJobs = {'Michelson'},
		locked = true,
		maxDistance = 8
	},

	--blade
	{
		objHash = GetHashKey('prop_facgate_07b'),
		objCoords = vector3(-2603.06, 1671.26, 140.90),
		textCoords = vector3(-2599.17, 1672.4, 142.0),
		authorizedJobs = {'DaniSara'},
		locked = true,
		maxDistance = 7.0
	},


	-- To downstairs (double doors)
	{
		textCoords = vector3(444.6, -989.4, 31.7),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 4,
		doors = {
			{objHash = GetHashKey('v_ilev_ph_gendoor005'), objHeading = 180.0, objCoords = vector3(443.9, -989.0, 30.6)},
			{objHash = GetHashKey('v_ilev_ph_gendoor005'), objHeading = 0.0, objCoords = vector3(445.3, -988.7, 30.6)}
		}
	},

	--
	-- Mission Row Cells
	--

	-- Main Cells
	{
		objHash = GetHashKey('v_ilev_ph_cellgate'),
		objHeading = 0.0,
		objCoords = vector3(463.8, -992.6, 24.9),
		textCoords = vector3(463.3, -992.6, 25.1),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 1.25
	},

	-- Cell 1
	{
		objHash = GetHashKey('v_ilev_ph_cellgate'),
		objHeading = 270.0,
		objCoords = vector3(462.3, -993.6, 24.9),
		textCoords = vector3(461.8, -993.3, 25.0),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 1.25
	},

	-- Cell 2
	{
		objHash = GetHashKey('v_ilev_ph_cellgate'),
		objHeading = 90.0,
		objCoords = vector3(462.3, -998.1, 24.9),
		textCoords = vector3(461.8, -998.8, 25.0),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 1.25
	},

	-- Cell 3
	{
		objHash = GetHashKey('v_ilev_ph_cellgate'),
		objHeading = 90.0,
		objCoords = vector3(462.7, -1001.9, 24.9),
		textCoords = vector3(461.8, -1002.4, 25.0),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 1.25
	},

	-- To Back
	{
		objHash = GetHashKey('v_ilev_gtdoor'),
		objHeading = 0.0,
		objCoords = vector3(463.4, -1003.5, 25.0),
		textCoords = vector3(464.0, -1003.5, 25.5),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 1.25
	},

	-- Armory
	{
		objHash = GetHashKey('v_ilev_arm_secdoor'),
		objHeading = 270.0,
		objCoords = vector3(452.65, -983.0, 30.69),
		textCoords = vector3(452.58, 982.55, 31.0),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 2.0
	},

	-- Dare poshte pd
	{
		textCoords = vector3(445.92, -999.07, 30.72),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 2,
		doors = {
			{objHash = GetHashKey('v_ilev_gtdoor'), objHeading = 180.0, objCoords  = vector3(447.21, -999.00, 30.78)},
			{objHash = GetHashKey('v_ilev_gtdoor'), objHeading = 0.0, objCoords  = vector3(444.62, -999.00, 30.78)}
		}
	},

	-- Dare armory
	{
		objHash = GetHashKey('v_ilev_gtdoor'),
		objHeading = 90.0,
		objCoords = vector3(453.09, -983.22, 30.83),
		textCoords = vector3(452.77, -982.46, 30.69),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 1.25
	},

	--
	-- Mission Row Back
	--

	-- Back (double doors)
	{
		textCoords = vector3(468.6, -1014.4, 27.1),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 4,
		doors = {
			{objHash = GetHashKey('v_ilev_rc_door2'), objHeading = 0.0, objCoords  = vector3(467.3, -1014.4, 26.5)},
			{objHash = GetHashKey('v_ilev_rc_door2'), objHeading = 180.0, objCoords  = vector3(469.9, -1014.4, 26.5)}
		}
	},

	-- Back Gate
	{
		objHash = GetHashKey('hei_prop_station_gate'),
		objHeading = 90.0,
		objCoords = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = {'police'},
		locked = true,
		maxDistance = 14,
		size = 2
	},

	--
	-- Sandy Shores
	--

	-- Entrance
	{
		objHash = GetHashKey('v_ilev_shrfdoor'),
		objHeading = 30.0,
		objCoords = vector3(1855.1, 3683.5, 34.2),
		textCoords = vector3(1855.1, 3683.5, 35.0),
		authorizedJobs = {'police'},
		locked = false,
		maxDistance = 1.25
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		textCoords = vector3(-443.5, 6016.3, 32.0),
		authorizedJobs = {'police', 'offpolice'},
		locked = false,
		maxDistance = 2.5,
		doors = {
			{objHash = GetHashKey('v_ilev_shrf2door'), objHeading = 315.0, objCoords  = vector3(-443.1, 6015.6, 31.7)},
			{objHash = GetHashKey('v_ilev_shrf2door'), objHeading = 135.0, objCoords  = vector3(-443.9, 6016.6, 31.7)}
		}
	},


	--DutyFamily family
	-- {
	-- 	textCoords = vector3(-1886.46, 2050.4, 142.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 340.0, objCoords  = vector3(-1885.4, 2049.98, 141.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 160.0, objCoords  = vector3(-1887.13, 2051.55, 141.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1889.13, 2051.39, 142.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 340.0, objCoords  = vector3(-1888.28, 2051.06, 141.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 160.0, objCoords  = vector3(-1889.81, 2052.55, 141.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1874.42, 2069.92, 142.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 340.0, objCoords  = vector3(-1873.32, 2069.69, 141.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 160.0, objCoords  = vector3(-1875.39, 2070.45, 141.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1886.06, 2074.3, 142.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 340.0, objCoords  = vector3(-1884.9, 2073.94, 141.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 160.0, objCoords  = vector3(-1887.03, 2074.74, 141.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1860.36, 2053.7, 142.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 360.0, objCoords  = vector3(-1859.33, 2053.67, 141.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 180.0, objCoords  = vector3(-1861.54, 2053.62, 141.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1893.45, 2075.45, 142.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 320.0, objCoords  = vector3(-1892.73, 2074.92, 141.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy2'), objHeading = 140.0, objCoords  = vector3(-1894.24, 2076.18, 141.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1908.96, 2072.43, 141.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 320.0, objCoords  = vector3(-1908.15, 2071.67, 140.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 140.0, objCoords  = vector3(-1909.78, 2072.99, 140.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1911.41, 2074.51, 141.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 320.0, objCoords  = vector3(-1910.66, 2073.73, 140.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 140.0, objCoords  = vector3(-1912.07, 2074.98, 140.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1899.66, 2083.31, 141.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 320.0, objCoords  = vector3(-1899.02, 2082.68, 140.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 140.0, objCoords  = vector3(-1900.64, 2084.07, 140.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1902.16, 2085.49, 141.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 320.0, objCoords  = vector3(-1901.36, 2084.64, 140.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 140.0, objCoords  = vector3(-1902.98, 2086.06, 140.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1910.72, 2079.49, 141.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 50.0, objCoords  = vector3(-1909.93, 2080.26, 140.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 230.0, objCoords  = vector3(-1911.41, 2078.54, 140.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1906.53, 2084.46, 141.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 50.0, objCoords  = vector3(-1905.66, 2085.4, 140.01)},
	-- 		{objHash = GetHashKey('ball_prop_italy3'), objHeading = 230.0, objCoords  = vector3(-1907.09, 2083.67, 140.0)}
	-- 	}
	-- },

	-- {
	-- 	textCoords = vector3(-1884.53, 2059.92, 146.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	doors = {
	-- 		{objHash = GetHashKey('ball_prop_italy1'), objHeading = 340.0, objCoords  = vector3(-1883.59, 2059.54, 145.57)},
	-- 		{objHash = GetHashKey('ball_prop_italy1'), objHeading = 160.0, objCoords  = vector3(-1885.63, 2060.28, 145.57)}
	-- 	}
	-- },

	-- {
	-- 	objHash = GetHashKey('prop_facgate_07b'),
	-- 	objCoords = vector3(-1879.01, 2036.11, 139.4),
	-- 	textCoords = vector3(-1877.76, 2040.40, 140.5),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 12,
	-- 	size = 2
	-- },

	-- {
	-- 	objHash = GetHashKey('prop_facgate_07b'),
	-- 	objCoords = vector3(-1926.71, 2080.79, 137.50),
	-- 	textCoords = vector3(-1922.98, 2080.05, 138.73),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 12,
	-- 	size = 2
	-- },

	-- {
	-- 	objHash = GetHashKey('prop_lrggate_06a'),
	-- 	objCoords = vector3(-1883.09, 2009.86, 140.65),
	-- 	textCoords = vector3(-1883.67, 2007.29, 141.68),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	locked = true,
	-- 	maxDistance = 12,
	-- 	size = 2
	-- },

	-- {
	-- 	objHash = GetHashKey('v_ilev_cm_door1'),
	-- 	objCoords = vector3(-1860.67, 2057.72, 135.68),
	-- 	textCoords = vector3(-1860.78, 2058.37, 136.0),
	-- 	authorizedJobs = {'DutyFamily'},
	-- 	objHeading = 270.0,
	-- 	locked = true,
	-- 	maxDistance = 2.0,
	-- 	size = 1
	-- },

	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objHash = GetHashKey('prop_gate_prison_01'),
		objCoords = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 12,
		size = 2
	},

	{
		objHash = GetHashKey('prop_gate_prison_01'),
		objCoords = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 12,
		size = 2
	},

	-- Vorudi lobby zendan
	{
		objHash = GetHashKey('v_ilev_gtdoor'),
		objCoords = vector3(1838.27, 2585.46, 45.95),
		textCoords = vector3(1837.5, 2585.93, 46.5),
		objHeading = 90.0,
		authorizedJobs = {'police', 'doc', 'offdoc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	{
		objHash = GetHashKey('v_ilev_gtdoor'),
		objCoords = vector3(1827.72, 2584.59, 46.09),
		textCoords = vector3(1828.45, 2584.5, 46.5),
		objHeading = 0.0,
		authorizedJobs = {'police', 'doc', 'offdoc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	{
		objHash = GetHashKey('v_ilev_gtdoor'),
		objCoords = vector3(1827.02, 2585.42, 45.95),
		textCoords = vector3(1826.86, 2586.03, 46.5),
		objHeading = 90.0,
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 1,
		size = 1
	},

	{
		objHash = GetHashKey('v_ilev_gtdoor'),
		objCoords = vector3(1819.56, 2593.59, 45.95),
		textCoords = vector3(1819.73, 2594.35, 46.5),
		objHeading = 90.0,
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	 -- jail inside

	 -- Jail Green screen room

	 {
		objHash = GetHashKey('v_ilev_ss_door_03'),
		objCoords = vector3(1685.722998046875, 2591.01013916015625, -49.59),
		textCoords = vector3(1686.44, 2591.56, -49.0),
		authorizedJobs = {'police', 'doc', },
		objHeading = 270.0,
		locked = true,
		maxDistance = 2,
		size = 1
	},
	-- Jail DOC Locker
	{
		objHash = GetHashKey('prop_police_door_l'),
		objCoords = vector3(1690.59, 2592.06, -49.59),
		textCoords = vector3(1690.15, 2592.56, -49.0),
		objHeading = 90.0,
		authorizedJobs = {'police', 'doc',},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	-- Lobby Door
	{
		objHash = GetHashKey('v_ilev_arm_secdoor'),
		objCoords = vector3(1831.93, 2593.38, -26.28),
		textCoords = vector3(1832.92, 2593.61, -25.5),
		objHeading = 270.0,
		authorizedJobs = {'police', 'doc', 'offdoc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},
	-- Enterance to medward
	{
		objHash = GetHashKey('prop_police_door_l'),
		objCoords = vector3(1688.29, 2584.59, -49.59),
		textCoords = vector3(1688.94, 2585.08, -49.0),
		objHeading = 0.0,
		authorizedJobs = {'police', 'doc',},
		locked = true,
		maxDistance = 2,
		size = 1
	},
	-- to prisoner suit room
	{
		objHash = GetHashKey('v_ilev_ss_door03'),
		objCoords = vector3(1690.91, 2589.74, -49.59),
		textCoords = vector3(1690.21, 2589.4, -49.0),
		objHeading = 90.0,
		authorizedJobs = {'police', 'doc',},
		locked = true,
		maxDistance = 2,
		size = 1
	},
	-- prisoner suit room
	{
		objHash = GetHashKey('v_ilev_ss_door03'),
		objCoords = vector3(1692.24, 2587.01, -49.59),
		textCoords = vector3(1691.69, 2587.89, -49.0),
		objHeading = 0.0,
		authorizedJobs = {'police', 'doc',},
		locked = true,
		maxDistance = 2,
		size = 1
	},
	--prison to backdoor
	{
		objHash = GetHashKey('v_ilev_ph_cellgate'),
		objCoords = vector3(1709.49, 2589.94, -49.59),
		textCoords = vector3(1709.67, 2590.32, -49.71),
		objHeading = 270.0,
		authorizedJobs = {'police', 'doc',},
		locked = true,
		maxDistance = 1.2,
		size = 1
	},
	--prison to foodshop
	{
		objHash = GetHashKey('prop_gate_bridge_ld'),
		objCoords = vector3(1741.81, 2591.94, -49.59),
		textCoords = vector3(1742.4, 2592.48, -49.0),
		objHeading = 270.0,
		authorizedJobs = {'police', 'doc',},
		locked = true,
		maxDistance = 2,
		size = 1
	},
	--prison to office
	{
		objHash = GetHashKey('v_ilev_ph_cellgate'),
		objCoords = vector3(1748.51, 2572.47, -49.59),
		textCoords = vector3(1748.78, 2572.94, -49.71),
		objHeading = 270.0,
		authorizedJobs = {'police', 'doc',},
		locked = true,
		maxDistance = 2,
		size = 1
	},
	--prison second door to jail
	{
		objHash = GetHashKey('v_ilev_ph_cellgate'),
		objCoords = vector3(1706.23, 2589.63, -49.56),
		textCoords = vector3(1706.03, 2590.38, -49.71),
		objHeading = -87.07,
		authorizedJobs = {'police', 'doc',},
		locked = true,
		maxDistance = 1.2,
		size = 1
	},
	--to yard doors
{
		objHash = GetHashKey('v_ilev_ph_cellgate'),
		objCoords = vector3(1706.09, 2573.32, -49.58),
		textCoords = vector3(1705.43, 2572.71, -49.71),
		objHeading = -0.48,
		authorizedJobs = {'police', 'doc',},
		locked = true,
		maxDistance = 1.2,
		size = 1
	},

	{
		objHash = GetHashKey('prop_police_door_l'),
		objCoords = vector3(1703.47, 2569.94, -49.59),
		textCoords = vector3(1704.12, 2570.45, -49.71),
		objHeading = 0,
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	{
		objHash = GetHashKey('prop_police_door_l'),
		objCoords = vector3(1634.35, 2569.08, -49.59),
		textCoords = vector3(1633.86, 2568.52, -49.7),
		objHeading = -89.24,
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	--to yard doors end
	{
		objHash = GetHashKey('prison_prop_door2'),
		objCoords = vector3(1787.22, 2606.13, 50.55),
		textCoords = vector3(1787.5, 2606.74, 51.0),
		objHeading = 270.0,
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	{
		objHash = GetHashKey('xm_cellgate'),
		objCoords = vector3(1767.46, 2607.12, 50.55),
		textCoords = vector3(1767.5, 2606.81, 51.0),
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 3,
		size = 1
	},

	{
		objHash = GetHashKey('prison_prop_door2'),
		objCoords = vector3(1785.88, 2566.42, 45.8),
		textCoords = vector3(1785.3, 2567.0, 46.3),
		objHeading = 0.0,
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	{
		objHash = GetHashKey('prison_prop_door1a'),
		objCoords = vector3(1776.61, 2551.47, 45.8),
		textCoords = vector3(1776.38, 2552.03, 46.3),
		objHeading = 270.0,
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	{
		objHash = GetHashKey('prison_prop_door2'),
		objCoords = vector3(1775.4, 2593.64, 45.8),
		textCoords = vector3(1775.0, 2593.2, 46.3),
		objHeading = 90.0,
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	{
		objHash = GetHashKey('prison_prop_door2'),
		objCoords = vector3(1772.06, 2571.44, 50.55),
		textCoords = vector3(1771.6, 2570.83, 51.0),
		objHeading = 90.0,
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	{
		objHash = GetHashKey('prison_prop_door1'),
		objCoords = vector3(1791.18, 2551.51, 45.8),
		textCoords = vector3(1791.29, 2552.08, 46.3),
		objHeading = 270.0,
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},

	{
		objHash = GetHashKey('prison_prop_door2'),
		objCoords = vector3(1784.69, 2550.78, 45.8),
		textCoords = vector3(1785.41, 2550.3, 46.3),
		objHeading = 180.0,
		authorizedJobs = {'police', 'doc'},
		locked = true,
		maxDistance = 2,
		size = 1
	},
}