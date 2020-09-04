-- Define the variable used to open/close the tab
local tabEnabled = false
local tabLoaded = true --false
local PlayerData = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	Citizen.Wait(10)
	PlayerData = ESX.GetPlayerData()
end)


function REQUEST_NUI_FOCUS(bool)
    SetNuiFocus(bool, bool) -- focus, cursor
    if bool == true then
        SendNUIMessage({showtab = true, steamid = PlayerData.identifier })
    else
        SendNUIMessage({hidetab = true})
    end
    return bool
end

RegisterNUICallback(
    "tablet-bus",
    function(data)
        -- Do tablet hide shit
        if data.load then
            tabLoaded = true
        elseif data.hide then
						ClearPedTasks(GetPlayerPed(-1))
            SetNuiFocus(false, false) -- Don't REQUEST_NUI_FOCUS here
            tabEnabled = false
        elseif data.resteamid then
	        	print('no steamid')
						PlayerData = ESX.GetPlayerData()
						SendNUIMessage({steamid = PlayerData.identifier})
        end
    end
)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3500)
		PlayerData = ESX.GetPlayerData()
		SendNUIMessage({steamid = PlayerData.identifier})
	end
end)

Citizen.CreateThread(
    function()
        -- Wait for nui to load or just timeout
        local l = 0
        local timeout = false
        while not tabLoaded do
            Citizen.Wait(0)
            l = l + 1
            if l > 500 then
                tabLoaded = true --
                timeout = true
            end
        end

        if timeout == true then
        -- return ---- Quit
        end


        REQUEST_NUI_FOCUS(false) -- This is just in case the resources restarted whilst the NUI is focused.
        while true do
            -- Control ID 20 is the 'Z' key by default
            -- 244 = M
            -- 48 = Arrow / dpad down
            -- Use https://wiki.fivem.net/wiki/Controls to find a different key
            if ( IsControlJustPressed(0, 20) ) then
                tabEnabled = not tabEnabled -- Toggle tablet visible state
                REQUEST_NUI_FOCUS(tabEnabled)
                Citizen.Wait(0)
								if not IsPedInAnyVehicle(GetPlayerPed(-1),  false) then
									TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_MOBILE", 0, true);
								end
            end
            if (tabEnabled) then
                local ped = GetPlayerPed(-1)
                DisableControlAction(0, 1, tabEnabled) -- LookLeftRight
                DisableControlAction(0, 2, tabEnabled) -- LookUpDown
                DisableControlAction(0, 24, tabEnabled) -- Attack
                DisablePlayerFiring(ped, tabEnabled) -- Disable weapon firing
                DisableControlAction(0, 142, tabEnabled) -- MeleeAttackAlternate
                DisableControlAction(0, 106, tabEnabled) -- VehicleMouseControlOverride
            end
            Citizen.Wait(0)
        end
end)
