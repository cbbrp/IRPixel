ESX          = nil
CheckVehicle = false
local PlayerHasProp = false
local drunkMuliplier = 0
local weapons = {
	[GetHashKey("WEAPON_PISTOL")] = "WEAPON_PISTOL",
	[GetHashKey("WEAPON_PISTOL50")] = "WEAPON_PISTOL50",
	[GetHashKey("WEAPON_SNSPISTOL")] = "WEAPON_PISTOL50",
	[GetHashKey("WEAPON_COMBATPISTOL")] = "WEAPON_COMBATPISTOL",
	[GetHashKey("WEAPON_SMG")] = "WEAPON_SMG",
	[GetHashKey("WEAPON_ASSAULTRIFLE")] = "WEAPON_ASSAULTRIFLE",
	[GetHashKey("WEAPON_CARBINERIFLE")] = "WEAPON_CARBINERIFLE",
	[GetHashKey("WEAPON_SPECIALCARBINE")] = "WEAPON_SPECIALCARBINE",
	[GetHashKey("WEAPON_ADVANCEDRIFLE")] = "WEAPON_ADVANCEDRIFLE",
	[GetHashKey("WEAPON_COMBATPDW")] = "WEAPON_COMBATPDW",
	[GetHashKey("WEAPON_PUMPSHOTGUN")] = "WEAPON_PUMPSHOTGUN",
	[GetHashKey("WEAPON_MICROSMG")] = "WEAPON_MICROSMG",
	[GetHashKey("WEAPON_HEAVYPISTOL")] = "WEAPON_HEAVYPISTOL",
	[GetHashKey("WEAPON_ASSAULTSMG")] = "WEAPON_ASSAULTSMG",
	[GetHashKey("WEAPON_GUSENBERG")] = "WEAPON_GUSENBERG"
}

local extendedClips = {
  [GetHashKey("WEAPON_PISTOL")] = { id = "clip_extended", weapon = "WEAPON_PISTOL", item = "eclip"},
  [GetHashKey("WEAPON_PISTOL50")] = { id = "clip_extended", weapon = "WEAPON_PISTOL50", item = "eclip"},
  [GetHashKey("WEAPON_SNSPISTOL")] = { id = "clip_extended", weapon = "WEAPON_PISTOL50", item = "eclip"},
  [GetHashKey("WEAPON_COMBATPISTOL")] = { id = "clip_extended", weapon = "WEAPON_COMBATPISTOL", item = "eclip"},
  [GetHashKey("WEAPON_SMG")] = { id = "clip_extended", weapon = "WEAPON_SMG", item = "eclip"},
  [GetHashKey("WEAPON_ASSAULTRIFLE")] = { id = "clip_extended", weapon = "WEAPON_ASSAULTRIFLE", item = "eclip"},
  [GetHashKey("WEAPON_CARBINERIFLE")] = { id = "clip_extended", weapon = "WEAPON_CARBINERIFLE", item = "eclip"},
  [GetHashKey("WEAPON_COMBATPDW")] = { id = "clip_extended", weapon = "WEAPON_COMBATPDW", item = "eclip"},
  [GetHashKey("WEAPON_MICROSMG")] = { id = "clip_extended", weapon = "WEAPON_MICROSMG", item = "eclip"},
  [GetHashKey("WEAPON_HEAVYPISTOL")] = { id = "clip_extended", weapon = "WEAPON_HEAVYPISTOL", item = "eclip"},
  [GetHashKey("WEAPON_ASSAULTSMG")] = { id = "clip_extended", weapon = "WEAPON_ASSAULTSMG", item = "eclip"},
  [GetHashKey("WEAPON_GUSENBERG")] = { id = "clip_extended", weapon = "WEAPON_GUSENBERG", item = "eclip"},
  [GetHashKey("WEAPON_SPECIALCARBINE")] = { id = "clip_extended", weapon = "WEAPON_SPECIALCARBINE", item = "eclip"},
  [GetHashKey("WEAPON_ADVANCEDRIFLE")] = { id = "clip_extended", weapon = "WEAPON_ADVANCEDRIFLE", item = "eclip"}
}

local silencers = {
  [GetHashKey("WEAPON_PISTOL")] = { id = "suppressor", weapon = "WEAPON_PISTOL", item = "silencer"},
  [GetHashKey("WEAPON_PISTOL50")] = { id = "suppressor", weapon = "WEAPON_PISTOL50", item = "silencer"},
  [GetHashKey("WEAPON_COMBATPISTOL")] = { id = "suppressor", weapon = "WEAPON_COMBATPISTOL", item = "silencer"},
  [GetHashKey("WEAPON_SMG")] = { id = "suppressor", weapon = "WEAPON_SMG", item = "silencer"},
  [GetHashKey("WEAPON_ASSAULTRIFLE")] = { id = "suppressor", weapon = "WEAPON_ASSAULTRIFLE", item = "silencer"},
  [GetHashKey("WEAPON_CARBINERIFLE")] = { id = "suppressor", weapon = "WEAPON_CARBINERIFLE", item = "silencer"},
  [GetHashKey("WEAPON_PUMPSHOTGUN")] = { id = "suppressor", weapon = "WEAPON_PUMPSHOTGUN", item = "silencer"},
  [GetHashKey("WEAPON_MICROSMG")] = { id = "suppressor", weapon = "WEAPON_MICROSMG", item = "silencer"},
  [GetHashKey("WEAPON_HEAVYPISTOL")] = { id = "suppressor", weapon = "WEAPON_HEAVYPISTOL", item = "silencer"},
  [GetHashKey("WEAPON_ASSAULTSMG")] = { id = "suppressor", weapon = "WEAPON_ASSAULTSMG", item = "silencer"},
  [GetHashKey("WEAPON_SPECIALCARBINE")] = { id = "suppressor", weapon = "WEAPON_SPECIALCARBINE", item = "silencer"},
  [GetHashKey("WEAPON_ADVANCEDRIFLE")] = { id = "suppressor", weapon = "WEAPON_ADVANCEDRIFLE", item = "silencer"}
}

local flashlights = {
  [GetHashKey("WEAPON_PISTOL")] = { id = "flashlight", weapon = "WEAPON_PISTOL", item = "flashlight"},
  [GetHashKey("WEAPON_PISTOL50")] = { id = "flashlight", weapon = "WEAPON_PISTOL50", item = "flashlight"},
  [GetHashKey("WEAPON_COMBATPISTOL")] = { id = "flashlight", weapon = "WEAPON_COMBATPISTOL", item = "flashlight"},
  [GetHashKey("WEAPON_SMG")] = { id = "flashlight", weapon = "WEAPON_SMG", item = "flashlight"},
  [GetHashKey("WEAPON_ASSAULTRIFLE")] = { id = "flashlight", weapon = "WEAPON_ASSAULTRIFLE", item = "flashlight"},
  [GetHashKey("WEAPON_CARBINERIFLE")] = { id = "flashlight", weapon = "WEAPON_CARBINERIFLE", item = "flashlight"},
  [GetHashKey("WEAPON_COMBATPDW")] = { id = "flashlight", weapon = "WEAPON_COMBATPDW", item = "flashlight"},
  [GetHashKey("WEAPON_PUMPSHOTGUN")] = { id = "flashlight", weapon = "WEAPON_PUMPSHOTGUN", item = "flashlight"},
  [GetHashKey("WEAPON_MICROSMG")] = { id = "flashlight", weapon = "WEAPON_MICROSMG", item = "flashlight"},
  [GetHashKey("WEAPON_HEAVYPISTOL")] = { id = "flashlight", weapon = "WEAPON_HEAVYPISTOL", item = "flashlight"},
  [GetHashKey("WEAPON_ASSAULTSMG")] = { id = "flashlight", weapon = "WEAPON_ASSAULTSMG", item = "flashlight"},
  [GetHashKey("WEAPON_SPECIALCARBINE")] = { id = "flashlight", weapon = "WEAPON_SPECIALCARBINE", item = "flashlight"},
  [GetHashKey("WEAPON_ADVANCEDRIFLE")] = { id = "flashlight", weapon = "WEAPON_ADVANCEDRIFLE", item = "flashlight"}
}

local grips = {
  [GetHashKey("WEAPON_ASSAULTRIFLE")] = { id = "grip", weapon = "WEAPON_ASSAULTRIFLE", item = "grip"},
  [GetHashKey("WEAPON_CARBINERIFLE")] = { id = "grip", weapon = "WEAPON_CARBINERIFLE", item = "grip"},
  [GetHashKey("WEAPON_COMBATPDW")] = { id = "grip", weapon = "WEAPON_COMBATPDW", item = "grip"},
  [GetHashKey("WEAPON_SPECIALCARBINE")] = { id = "grip", weapon = "WEAPON_SPECIALCARBINE", item = "grip"}
}

local drumMagazines = {
	[GetHashKey("WEAPON_SMG")] = { id = "clip_drum", weapon = "WEAPON_SMG", item = "dclip"},
	[GetHashKey("WEAPON_ASSAULTRIFLE")] = { id = "clip_drum", weapon = "WEAPON_ASSAULTRIFLE", item = "dclip"},
	[GetHashKey("WEAPON_CARBINERIFLE")] = { id = "clip_box", weapon = "WEAPON_CARBINERIFLE", item = "dclip"},
	[GetHashKey("WEAPON_COMBATPDW")] = { id = "clip_drum", weapon = "WEAPON_COMBATPDW", item = "dclip"},
	[GetHashKey("WEAPON_SPECIALCARBINE")] = { id = "clip_drum", weapon = "WEAPON_SPECIALCARBINE", item = "dclip"}
}

local PlayerProps = {}

Emotes = {
	["soda"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Soda", AnimationOptions =
	{
		Prop = 'prop_ecola_can',
		PropBone = 28422,
		PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0},
		EmoteLoop = false,
		Drunk     = false,
		EmoteMoving = true,
	}},
	["coffee"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Coffee", AnimationOptions =
	{
		Prop = 'p_amb_coffeecup_01',
		PropBone = 28422,
		PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
		EmoteLoop = false,
		Drunk     = false,
		EmoteMoving = true,
	}},
	["tea"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Tea", AnimationOptions =
	{
		Prop = 'prop_plastic_cup_02',
		PropBone = 28422,
		PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
		EmoteLoop = true,
		Drunk     = false,
		EmoteMoving = true,
	}},
	["donut"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Donut", AnimationOptions =
   {
       Prop = 'prop_amb_donut',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
	   EmoteMoving = false,
	   Drunk     = false,
       EmoteDuration = 4500
   }},
   ["whiskey"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Whiskey", AnimationOptions =
   {
       Prop = 'prop_drink_whisky',
       PropBone = 28422,
       PropPlacement = {0.01, -0.01, -0.06, 0.0, 0.0, 0.0},
	   EmoteLoop = false,
	   Drunk     = true,
       EmoteMoving = true,
   }},
   ["sandwich"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Sandwich", AnimationOptions =
   {
       Prop = 'prop_sandwich_01',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
	   EmoteMoving = true,
	   Drunk     = false,
       EmoteDuration = 4500
   }},
   ["wine"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Wine", AnimationOptions =
   {
       Prop = 'prop_drink_redwine',
       PropBone = 18905,
       PropPlacement = {0.10, -0.03, 0.03, -100.0, 0.0, -10.0},
	   EmoteMoving = true,
	   Drunk     = true,
       EmoteLoop = false
   }},
   ["beer"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Beer", AnimationOptions =
   {
       Prop = 'prop_amb_beer_bottle',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	   EmoteLoop = false,
	   Drunk     = true,
       EmoteMoving = true,
   }},
   ["smoke"] = {"Scenario", "WORLD_HUMAN_SMOKING", "Smoke"}
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_basicneeds:playAnim')
AddEventHandler('esx_basicneeds:playAnim', function(name)
	local name = name

	OnEmotePlay(Emotes[name])
	
	if name == "soda" or name == "coffee" or name == "tea" or name == "whiskey" or name == "wine" or name == "beer" then
		Citizen.Wait(15000)
		DestroyAllProps()
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end
	if name == "donut" or name == "sandwich" then
		Citizen.Wait(4000)
		DestroyAllProps()
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end
	if name == "smoke" then
		Citizen.Wait(60000)
		DestroyAllProps()
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end
end)

RegisterNetEvent('esx_customItems:useClipcli')
AddEventHandler('esx_customItems:useClipcli', function()

		local ped = GetPlayerPed(-1)
		if IsPedArmed(ped, 4) then
			hash= GetSelectedPedWeapon(ped)
			
			if hash~=nil then
			TriggerServerEvent('esx_customItems:remove', "clip")
			AddAmmoToPed(GetPlayerPed(-1), hash, 25)
			ESX.ShowNotification("Shoma ba movafaghiat az kheshab estefade kardid")
			else
			ESX.ShowNotification("hash aslahe mored nazar namaloom ast")
			end
			
		else
			ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
		end

end)

RegisterNetEvent('esx_customItems:useArmor')
AddEventHandler('esx_customItems:useArmor', function()

	TriggerEvent("mythic_progbar:client:progress", {
		name = "armor_putin",
		duration = 5000,
		label = "Dar hale poshidan armor",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
            animDict = "rcmfanatic3",
            anim = "kneel_idle_a",
        },
        prop = {
            model = "prop_bodyarmour_03",
        }
	}, function(status)
		
		if not status then

			ClearPedTasksImmediately(GetPlayerPed(-1))
			ESX.TriggerServerCallback('esx_customItems:removeArmor', function(doesHave)
				if doesHave then
					TriggerEvent('skinchanger:getSkin', function(skin)
						if skin.sex == 0 then
						  TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 4,  ['bproof_2'] = 1})
						elseif skin.sex == 1 then
						  TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 3,  ['bproof_2'] = 1,})
						end
					end)
					SetPedArmour(GetPlayerPed(-1), 50)
					ESX.ShowNotification("~h~Shoma ba movafaghiat ~g~Armor ~w~use kardid!")
				else
					ESX.ShowNotification("~h~Shoma armor nadarid!")
				end
			end)
		
		elseif status then
		  ClearPedTasksImmediately(GetPlayerPed(-1))
		end
		
	end)

end)

RegisterNetEvent('esx_customItems:useTint')
AddEventHandler('esx_customItems:useTint', function(info)
	local ped = GetPlayerPed(-1)

	if IsPedArmed(ped, 4) then
		
		local currentweapon = GetSelectedPedWeapon(ped)
		  SetPedWeaponTintIndex(ped, currentweapon, info.color)
		  TriggerServerEvent('esx_customItems:remove', info.name)
		  ESX.ShowNotification("~h~Shoma ba movafaghiat 1x ~g~" .. info.label .. " ~w~use kardid!")
		
	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end

end)

RegisterNetEvent('esx_customItems:useExtendedMagazine')
AddEventHandler('esx_customItems:useExtendedMagazine', function()
	local ped = GetPlayerPed(-1)

	if IsPedArmed(ped, 4) then
		
		local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
		if extendedClips[weapon] then
			TriggerServerEvent('esx_customItems:addComponent', extendedClips[weapon])
		else
			ESX.ShowNotification("In aslahe extended magazine ra support nemikonad!")
		end
		
	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end
end)

RegisterNetEvent('esx_customItems:useDrumMagazine')
AddEventHandler('esx_customItems:useDrumMagazine', function()
	local ped = GetPlayerPed(-1)

	if IsPedArmed(ped, 4) then
		
		local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
		if drumMagazines[weapon] then
			TriggerServerEvent('esx_customItems:addComponent', drumMagazines[weapon])
		else
			ESX.ShowNotification("In aslahe Drum magazine ra support nemikonad!")
		end
		
	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end

end)

RegisterNetEvent('esx_customItems:useSilencer')
AddEventHandler('esx_customItems:useSilencer', function()
	local ped = GetPlayerPed(-1)

	if IsPedArmed(ped, 4) then
		
		local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
		if silencers[weapon] then
			TriggerServerEvent('esx_customItems:addComponent', silencers[weapon])
		else
			ESX.ShowNotification("In aslahe silencer ra support nemikonad!")
		end
		
	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end
end)

RegisterNetEvent('esx_customItems:useFlashlight')
AddEventHandler('esx_customItems:useFlashlight', function()
	local ped = GetPlayerPed(-1)

	if IsPedArmed(ped, 4) then
		
		local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
		if flashlights[weapon] then
			TriggerServerEvent('esx_customItems:addComponent', flashlights[weapon])
		else
			ESX.ShowNotification("In aslahe flashlight ra support nemikonad!")
		end
		
	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end
end)

RegisterNetEvent('esx_customItems:useGrip')
AddEventHandler('esx_customItems:useGrip', function()
	local ped = GetPlayerPed(-1)

	if IsPedArmed(ped, 4) then
		
		local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
		if grips[weapon] then
			TriggerServerEvent('esx_customItems:addComponent', grips[weapon])
		else
			ESX.ShowNotification("In aslahe grip ra support nemikonad!")
		end
		
	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end
end)

RegisterCommand('deattach', function(source, args)
	local ped = GetPlayerPed(-1)

	if IsPedArmed(ped, 4) then
		
		if not args[1] then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar argument aval chizi vared nakardid!")
			return
		end

		local input = string.lower(args[1])
		local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))

		if input == "silencer" then
			if silencers[weapon] then
				TriggerServerEvent('esx_customItems:removeComponent', silencers[weapon], false)
			else
				ESX.ShowNotification("In aslahe silencer ra support nemikonad!")
			end
		elseif input == "eclip" then
			if extendedClips[weapon] then
				TriggerServerEvent('esx_customItems:removeComponent', extendedClips[weapon], false)
			else
				ESX.ShowNotification("In aslahe extended magazine ra support nemikonad!")
			end
		elseif input == "dclip" then
			if drumMagazines[weapon] then
				TriggerServerEvent('esx_customItems:removeComponent', drumMagazines[weapon], false)
			else
				ESX.ShowNotification("In aslahe Drum magazine ra support nemikonad!")
			end
		elseif input == "flashlight" then
			if flashlights[weapon] then
				TriggerServerEvent('esx_customItems:removeComponent', flashlights[weapon], false)
			else
				ESX.ShowNotification("In aslahe flashlight ra support nemikonad!")
			end
		elseif input == "grip" then
			if grips[weapon] then
				TriggerServerEvent('esx_customItems:removeComponent', grips[weapon], false)
			else
				ESX.ShowNotification("In aslahe grip ra support nemikonad!")
			end
		elseif input == "all" then
			TriggerServerEvent('esx_customItems:removeComponent', weapons[weapon], true)
		else
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Argument vared shode eshtebah ast!")
		end
		
	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end

end, false)

RegisterNetEvent('esx_customItems:useYusuf')
AddEventHandler('esx_customItems:useYusuf', function()
					local inventory = ESX.GetPlayerData().inventory
				local yusuf = 0
					for i=1, #inventory, 1 do
					  if inventory[i].name == 'yusuf' then
						yusuf = inventory[i].count
					  end
					end
			
			local ped = PlayerPedId()
			local currentWeaponHash = GetSelectedPedWeapon(ped)

					if currentWeaponHash == GetHashKey("WEAPON_PISTOL") then
						GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE"))
						TriggerServerEvent('esx_customItems:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL50") then
						GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_PISTOL50_VARMOD_LUXE"))
						TriggerServerEvent('esx_customItems:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")
						
					elseif currentWeaponHash == GetHashKey("WEAPON_APPISTOL") then
						GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_APPISTOL"), GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE"))  
						TriggerServerEvent('esx_customItems:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")
						
					elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYPISTOL") then
						GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_HEAVYPISTOL_VARMOD_LUXE"))
						TriggerServerEvent('esx_customItems:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_SMG") then
						GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_SMG_VARMOD_LUXE"))
						TriggerServerEvent('esx_customItems:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_MICROSMG") then
						GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_MICROSMG"), GetHashKey("COMPONENT_MICROSMG_VARMOD_LUXE"))
						TriggerServerEvent('esx_customItems:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") then
						GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"))
						TriggerServerEvent('esx_customItems:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")
						
					elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
						GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_CARBINERIFLE_VARMOD_LUXE"))
						TriggerServerEvent('esx_customItems:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")
						
					elseif currentWeaponHash == GetHashKey("WEAPON_ADVANCEDRIFLE") then
						GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ADVANCEDRIFLE"), GetHashKey("COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE"))
						TriggerServerEvent('esx_customItems:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")
					
					else 
						ESX.ShowNotification("Aslahe mored nazar ghabeliat estefade kardan az skin talaee ra nadarad")
					end
end)

RegisterNetEvent('esx_customItems:useBlowtorch')
AddEventHandler('esx_customItems:useBlowtorch', function()
					local inventory = ESX.GetPlayerData().inventory
				local blowtorch = 0
					for i=1, #inventory, 1 do
					  if inventory[i].name == 'blowtorch' then
						blowtorch = inventory[i].count
					  end
					end
					

			local vehicle = ESX.Game.GetVehicleInDirection(4)
			if DoesEntityExist(vehicle) then
				local playerPed = GetPlayerPed(-1)

				CheckVehicle = true
				checkvehicle(vehicle)

				  TriggerServerEvent('esx_customItems:remove', "blowtorch")
                  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
                  SetVehicleAlarm(vehicle, true)
                  StartVehicleAlarm(vehicle)
                  SetVehicleAlarmTimeLeft(vehicle, 40000)
                  TriggerEvent("mythic_progbar:client:progress", {
                    name = "hijack_vehicle",
                    duration = 60000,
                    label = "LockPick kardan mashin",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }
				}, function(status)
					
                    if not status then

                      SetVehicleDoorsLocked(vehicle, 1)
                      SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                      ClearPedTasksImmediately(playerPed)
              
					  ESX.ShowNotification("Mashin baz shod")
					  CheckVehicle = false
                    elseif status then
					  ClearPedTasksImmediately(playerPed)
					  CheckVehicle = false
					end
					
                end)

           else
            ESX.ShowNotification("Hich mashini nazdik shoma nist")
          end

end)

RegisterNetEvent('esx_customItems:checkVehicleDistance')
AddEventHandler('esx_customItems:checkVehicleDistance', function(vehicle)

	CheckVehicle = true
	checkvehicle(vehicle)

end)

RegisterNetEvent('esx_customItems:checkVehicleStatus')
AddEventHandler('esx_customItems:checkVehicleStatus', function(status)

	CheckVehicle = status

end)

function addDrunk()
	drunkMuliplier = drunkMuliplier + 1
	if drunkMuliplier == 5 then
		overdose()
		drunkMuliplier = 0
	end
end

function overdose()

	local playerPed = GetPlayerPed(-1)

	RequestAnimSet("move_injured_generic") 
	while not HasAnimSetLoaded("move_injured_generic") do
	Citizen.Wait(0)
	end    

	ClearPedTasksImmediately(playerPed)
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(playerPed, true)
	SetPedMovementClipset(playerPed, "move_injured_generic", true)
	SetPedIsDrunk(playerPed, true)
	Citizen.Wait(30000)
	clearEffects()
	
end

function clearEffects()
	Citizen.CreateThread(function()

		local playerPed = GetPlayerPed(-1)

		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedIsDrunk(playerPed, false)
		SetPedMotionBlur(playerPed, false)
	
	  end)
end

function checkvehicle(vehicle)
	Citizen.CreateThread(function()
		while CheckVehicle do
		  Citizen.Wait(2000)
		
		  local coords = GetEntityCoords(GetPlayerPed(-1))
		  local NearVehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  4.0,  0,  71)
			if vehicle ~= NearVehicle then
				ESX.ShowNotification("Mashin mored nazar az shoma ~r~door ~s~shod!")
				TriggerEvent("mythic_progbar:client:cancel")
				CheckVehicle = false
			end

		end
	  end)

end

function OnEmotePlay(EmoteName)
	if not DoesEntityExist(GetPlayerPed(-1)) then
	  return false
	end
  
	  if IsPedArmed(GetPlayerPed(-1), 7) then
		SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
	  end
  
	ChosenDict,ChosenAnimation,ename = table.unpack(EmoteName)
	AnimationDuration = -1
  
	if PlayerHasProp then
	  DestroyAllProps()
	end
  
	if ChosenDict == "Expression" then
	  SetFacialIdleAnimOverride(PlayerPedId(), ChosenAnimation, 0)
	  return
	end
  
	if ChosenDict == "MaleScenario" or "Scenario" then
	  CheckGender()
	  if ChosenDict == "MaleScenario" then
		if PlayerGender == "male" then
		  ClearPedTasks(GetPlayerPed(-1))
		  TaskStartScenarioInPlace(GetPlayerPed(-1), ChosenAnimation, 0, true)
		  IsInAnimation = true
		else
		  EmoteChatMessage("This emote is male only, sorry!")
		end return
	  elseif ChosenDict == "ScenarioObject" then
		BehindPlayer = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
		ClearPedTasks(GetPlayerPed(-1))
		TaskStartScenarioAtPosition(GetPlayerPed(-1), ChosenAnimation, BehindPlayer['x'], BehindPlayer['y'], BehindPlayer['z'], GetEntityHeading(PlayerPedId()), 0, 1, false)
		IsInAnimation = true
		return
	  elseif ChosenDict == "Scenario" then
		ClearPedTasks(GetPlayerPed(-1))
		TaskStartScenarioInPlace(GetPlayerPed(-1), ChosenAnimation, 0, true)
		IsInAnimation = true
	  return end 
	end

	  LoadAnim(ChosenDict)
	  if EmoteName.AnimationOptions.Drunk == true then
		addDrunk()
	  end
  
	  if EmoteName.AnimationOptions then
		if EmoteName.AnimationOptions.EmoteLoop then
		  MovementType = 1
		if EmoteName.AnimationOptions.EmoteMoving then
		  MovementType = 51
		end
	elseif EmoteName.AnimationOptions.EmoteMoving then
	  MovementType = 51
	end
	else
	  MovementType = 0
	end
  
	if EmoteName.AnimationOptions then
	  if EmoteName.AnimationOptions.EmoteDuration == nil then 
		EmoteName.AnimationOptions.EmoteDuration = -1
	  else
		AnimationDuration = EmoteName.AnimationOptions.EmoteDuration
	  end
  
	  if EmoteName.AnimationOptions.Prop then
		PropName = EmoteName.AnimationOptions.Prop
		PropBone = EmoteName.AnimationOptions.PropBone
		PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(EmoteName.AnimationOptions.PropPlacement)
		if EmoteName.AnimationOptions.SecondProp then
		  SecondPropName = EmoteName.AnimationOptions.SecondProp
		  SecondPropBone = EmoteName.AnimationOptions.SecondPropBone
		  SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6 = table.unpack(EmoteName.AnimationOptions.SecondPropPlacement)
		  SecondPropEmote = true
		else
		  SecondPropEmote = false
		end
  
		AddPropToPlayer(PropName, PropBone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6)
		if SecondPropEmote then
		  AddPropToPlayer(SecondPropName, SecondPropBone, SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6)
		end
	  end
	end
  
	TaskPlayAnim(GetPlayerPed(-1), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
	IsInAnimation = true
	MostRecentDict = ChosenDict
	MostRecentAnimation = ChosenAnimation
	return true
  end

  CheckGender = function()
	local hashSkinMale = GetHashKey("mp_m_freemode_01")
	local hashSkinFemale = GetHashKey("mp_f_freemode_01")
  
	if GetEntityModel(PlayerPedId()) == hashSkinMale then
	  PlayerGender = "male"
	elseif GetEntityModel(PlayerPedId()) == hashSkinFemale then
	  PlayerGender = "female"
	end
  end
  
  LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
	  RequestAnimDict(dict)
	  Citizen.Wait(1)
	end
  end
  
  LoadPropDict = function(model)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
	  Citizen.Wait(1)
	end
  end

  AddPropToPlayer = function(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
	local Player = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(Player))
  
	if not HasModelLoaded(prop1) then
	  LoadPropDict(prop1)
	end
  
	prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
	table.insert(PlayerProps, prop)
	PlayerHasProp = true
  end

  DestroyAllProps = function()
	for _,v in pairs(PlayerProps) do
	  DeleteEntity(v)
	end
	PlayerHasProp = false
  end