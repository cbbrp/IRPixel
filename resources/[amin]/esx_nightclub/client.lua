	local Keys = {
		["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
		["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
		["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
		["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
		["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
		["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
		["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
		["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
		["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
	}

	ESX                           = nil
	local PlayerData              = {}
	local HasAlreadyEnteredMarker = false
	local LastStation             = nil
	local LastPart                = nil
	local LastPartNum             = nil
	local CurrentAction           = nil
	local CurrentActionMsg        = ''
	local CurrentActionData       = {}
	local gangName                = "VX"


	Citizen.CreateThread(function()
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(0)
		end
		
		while ESX.GetPlayerData().job == nil do
			Citizen.Wait(10)
		end

		while ESX.GetPlayerData().gang == nil do
			Citizen.Wait(10)
		end

		PlayerData = ESX.GetPlayerData()
	end)

	RegisterNetEvent('esx:setJob')
	AddEventHandler('esx:setJob', function(job)
		PlayerData.job = job
	end)

	RegisterNetEvent('esx:setGang')
	AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
	end)

	-- // Creating Blips
	Citizen.CreateThread(function()
	
		for k,v in pairs(Config.nightclubShops.Parking.Blips) do
	
		local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
	
		SetBlipSprite (blip, v.Sprite)
		SetBlipDisplay(blip, v.Display)
		SetBlipScale  (blip, v.Scale)
		SetBlipColour (blip, v.Colour)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.Name)
		EndTextCommandSetBlipName(blip)
	
		end
	
	end)

	-- Display markers
	Citizen.CreateThread(function()
		while true do
	
		Wait(1)
	
		while PlayerData.gang == nil do
			Citizen.Wait(10)
		end

		if PlayerData.job ~= nil and PlayerData.gang ~= nil and PlayerData.job.name == 'nightclub' or PlayerData.gang.name == gangName then
	
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
	
			for k,v in pairs(Config.nightclubShops) do
	
			if PlayerData.gang.name ~= gangName then
			for i=1, #v.Cloakrooms, 1 do
				if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 64, 123, 174, 100, true, true, 2, true, false, false, false)
				end
			end
			end
	
			if PlayerData.job.grade >= 1 and PlayerData.gang.name ~= gangName then
				for i=1, #v.Refrigerators, 1 do
					if GetDistanceBetweenCoords(coords,  v.Refrigerators[i].x,  v.Refrigerators[i].y,  v.Refrigerators[i].z,  true) < Config.DrawDistance then
					DrawMarker(Config.MarkerType, v.Refrigerators[i].x, v.Refrigerators[i].y, v.Refrigerators[i].z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 64, 123, 174, 100, true, true, 2, true, false, false, false)
					end
				end
			end
	
			if PlayerData.gang.name == gangName then
				for i=1, #v.Bars, 1 do
					if GetDistanceBetweenCoords(coords,  v.Bars[i].x,  v.Bars[i].y,  v.Bars[i].z,  true) < Config.DrawDistance then
					DrawMarker(Config.MarkerType, v.Bars[i].x, v.Bars[i].y, v.Bars[i].z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 64, 123, 174, 100, true, true, 2, true, false, false, false)
					end
				end
			end
	
			if PlayerData.job ~= nil and PlayerData.job.name == 'nightclub' and PlayerData.job.grade_name == 'boss' and PlayerData.gang.name ~= gangName then
	
				for i=1, #v.BossActions, 1 do
				if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
					DrawMarker(Config.MarkerTypeboss, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 64, 123, 174, 100, true, true, 2, true, false, false, false)
				end
				end
	
			end
	
			end
			
		else
			Citizen.Wait(1000)
		end
	
		end
	end)

	-- // Exiter and Enter
	Citizen.CreateThread(function()
	
		while true do
	
		Wait(1)
	
		while PlayerData.gang == nil do
			Citizen.Wait(10)
		end

		if PlayerData.job ~= nil and PlayerData.gang ~= nil and PlayerData.job.name == 'nightclub' or PlayerData.gang.name == gangName then
			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local isInMarker     = false
			local currentStation = nil
			local currentPart    = nil
			local currentPartNum = nil
	
			for k,v in pairs(Config.nightclubShops) do
	
			if PlayerData.gang.name ~= gangName then
			for i=1, #v.Cloakrooms, 1 do
				if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'Cloakroom'
				currentPartNum = i
				end
			end
			end
	
			if PlayerData.job.grade >= 1 and PlayerData.gang.name ~= gangName then
				for i=1, #v.Refrigerators, 1 do
					if GetDistanceBetweenCoords(coords,  v.Refrigerators[i].x,  v.Refrigerators[i].y,  v.Refrigerators[i].z,  true) < Config.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'Refrigerator'
					currentPartNum = i
					end
				end
			end

			if PlayerData.gang.name == gangName then
				for i=1, #v.Bars, 1 do
					if GetDistanceBetweenCoords(coords,  v.Bars[i].x,  v.Bars[i].y,  v.Bars[i].z,  true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Bar'
						currentPartNum = i
					end
				end
			end
	
			if PlayerData.job ~= nil and PlayerData.job.name == 'nightclub' and PlayerData.job.grade_name == 'boss' and PlayerData.gang.name ~= gangName then
	
				for i=1, #v.BossActions, 1 do
				if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'BossActions'
					currentPartNum = i
				end
				end
	
			end
	
			end
	
			local hasExited = false
	
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
	
			if
				(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('esx_nightclub:hasExitedMarker', LastStation, LastPart, LastPartNum)
				hasExited = true
			end
	
			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum
	
			TriggerEvent('esx_nightclub:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end
	
			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
	
			HasAlreadyEnteredMarker = false
	
			TriggerEvent('esx_nightclub:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end
			
		else
			Citizen.Wait(1000)
		end
	
		end
	end)


	AddEventHandler('esx_nightclub:hasExitedMarker', function(station, part, partNum)
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end)

	AddEventHandler('esx_nightclub:hasEnteredMarker', function(station, part, partNum)

	
		if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta Locker baz she"
		CurrentActionData = {}
		end
	
		if part == 'Refrigerator' then
		CurrentAction     = 'menu_refrigrator'
		CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta Yakhchal baz she"
		CurrentActionData = {station = station}
		end
	
		if part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta BossAction baz she"
		CurrentActionData = {}
		end

		if part == 'Bar' then
			CurrentAction     = 'menu_bar_actions'
			CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta BAR baz she"
			CurrentActionData = {}
		end
	
	end)

	-- Key Controls
	Citizen.CreateThread(function()
		while true do
	
			Citizen.Wait(1)
	
			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	
				if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'nightclub' then
						if CurrentAction == "menu_refrigrator" then
							OpenGetRefrigrator()
						elseif CurrentAction == "menu_boss_actions" then

							TriggerEvent('esx_society:openBosirpixelsMenu', 'nightclub', function(data, menu)
								menu.close()
							end, { wash = false }) -- disable washing money

						elseif CurrentAction == "menu_cloakroom" then
							OpenCloakroomMenu()
						end
					
					CurrentAction = nil
				end
			end

			if IsControlJustReleased(0, Keys['E']) and PlayerData.gang ~= nil and PlayerData.gang.name == gangName then
				if CurrentAction == "menu_bar_actions" then
					OpenBar()
				end
	
			CurrentAction = nil
			end

		end
	end)


	-- // Yakhchal
	function OpenGetRefrigrator()
	
		local elements = {}
		local items = Config.AuthorizedFoods
		
		for i=1, #items, 1 do
			table.insert(elements, {label = items[i].label .. " $" .. items[i].price, value = items[i].name})
		end
	
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'refrigrator_get_food',
			{
			title    = "Bardashtan az yakhchal",
			align    = 'top-left',
			elements = elements
			},
			function(data, menu)
			
				local itemName = data.current.value
				TriggerServerEvent("esx_nightclub:giveItem", itemName)
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	
			end,
			function(data, menu)
			menu.close()
			CurrentAction = "menu_refrigator"
		end)  
	end

	-- // Bars
	function OpenBar()
	
		local elements = {}
		local items = Config.AuthorizedDrinks
		
		for i=1, #items, 1 do
		table.insert(elements, {label = items[i].label .. " $" .. items[i].price, value = items[i].name})
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'refrigrator_get_drinks',
		{
			title    = "Bardashtan az bar",
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
		
			local itemName = data.current.value
			TriggerServerEvent("esx_nightclub:giveItem", itemName)
			PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

		end,
		function(data, menu)
			menu.close()
			CurrentAction = "menu_bar_actions"
		end)  
	end

	--// Uniforms

	function OpenCloakroomMenu()
	
		local playerPed = PlayerPedId()
		local grade = PlayerData.job.grade_name

		local elements = {
			{ label = "Lebas Shahrvandi", value = 'citizen_wear' },
		}

		if grade == 'nezafat' then
			table.insert(elements, {label = "Lebas Kar", value = 'nezafat_wear'})
		elseif grade == 'garson' then
			table.insert(elements, {label = "Lebas Kar", value = 'garson_wear'})
		elseif grade == 'ashpaz' then
			table.insert(elements, {label = "Lebas Kar", value = 'ashpaz_wear'})
		elseif grade == 'sandoghdar' then
			table.insert(elements, {label = "Lebas Kar", value = 'sandoghdar_wear'})
		elseif grade == 'boss' then
			table.insert(elements, {label = "Lebas Kar", value = 'boss_wear'})
		end 

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = "Avaz kardan lebas",
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			cleanPlayer(playerPed)

			if data.current.value == 'citizen_wear' then
				
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)

			end

			if
				data.current.value == 'nezafat_wear' or
				data.current.value == 'garson_wear' or
				data.current.value == 'ashpaz_wear' or
				data.current.value == 'sandoghdar_wear' or
				data.current.value == 'boss_wear'

			then
				setUniform(data.current.value, playerPed)
			end

		end, function(data, menu)
			menu.close()
			CurrentAction = "menu_cloakroom"
		end)
	end

	function setUniform(job, playerPed)
	
		TriggerEvent('skinchanger:getSkin', function(skin)
		if tonumber(skin.sex) == 0 then

				if Config.Uniforms[job].male ~= nil then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
				else
					ESX.ShowNotification("~h~Lebasi baraye in rank vojod nadarad")
				end

		elseif tonumber(skin.sex) == 1 then

				-- if Config.Uniforms[job].female ~= nil then
				--     TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
				-- else
				--     ESX.ShowNotification(_U('no_outfit'))
				-- end
				ESX.ShowNotification("~h~Lebasi baraye kar konan zan tarif nashode ast")

			end

		end)
	end

	function cleanPlayer(playerPed)
		SetPedArmour(playerPed, 0)
		ClearPedBloodDamage(playerPed)
		ResetPedVisibleDamage(playerPed)
		ClearPedLastWeaponDamage(playerPed)
		ResetPedMovementClipset(playerPed, 0)
	end