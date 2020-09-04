--local weatherType = "EXTRASUNNY"
local crouched = false
local passengerDriveBy = true

-- Citizen.CreateThread(function()
--     while true do
--         N_0x4757f00bc6323cfe(-1553120962, 0.0) --undocumented damage modifier. 1st argument is hash, 2nd is modified (0.0-1.0)
--         Wait(0)
--     end
-- end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5) -- prevent crashing

		-- These natives have to be called every frame.
		SetVehicleDensityMultiplierThisFrame(0.0) -- set traffic density to 0 
		SetPedDensityMultiplierThisFrame(0.0) -- set npc/ai peds density to 0
		SetRandomVehicleDensityMultiplierThisFrame(0.0) -- set random vehicles (car scenarios / cars driving off from a parking spot etc.) to 0
		SetParkedVehicleDensityMultiplierThisFrame(0.0) -- set random parked vehicles (parked car scenarios) to 0
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0) -- set random npc/ai peds or scenario peds to 0
		SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
		SetRandomBoats(false) -- Stop random boats from spawning in the water.
		RemovePeskyVehicles(player, 3000.0)
		--SetWeatherTypeNowPersist(weatherType)
        --SetWeatherTypeNow(weatherType)
        --SetOverrideWeather(weatherType)
		SetCreateRandomCops(false) -- disable random cops walking/driving around.
		SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
		SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
		
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
	end
end)

--[[Citizen.CreateThread(function()
	while true do
	    Citizen.Wait(0)
	    SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        RemovePeskyVehicles(player, 3000.0)
		SetWeatherTypeNowPersist(weatherType)
        SetWeatherTypeNow(weatherType)
        SetOverrideWeather(weatherType)
	end
end)]]
-- no ped

function RemovePeskyVehicles(player, range)
    local pos = GetEntityCoords(playerPed) 

    RemoveVehiclesFromGeneratorsInArea(
        pos.x - range, pos.y - range, pos.z - range, 
        pos.x + range, pos.y + range, pos.z + range
    );
end

-- No Drive By
Citizen.CreateThread(function()
	while true do
		Wait(1)

		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
	end
end)

--no r key
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5) -- A Short Daily of 5 MS
		if IsPedArmed(GetPlayerPed(-1), 6) then
			DisableControlAction(0, 140, true) -- Disable the Light Dmg Contr ol
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		end
	end
end)

--crouch
Citizen.CreateThread( function()
    while true do 
        Citizen.Wait( 1 )

        local ped = GetPlayerPed( -1 )

        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
            DisableControlAction( 0, 36, true ) -- INPUT_DUCK  

            if ( not IsPauseMenuActive() ) then 
                if ( IsDisabledControlJustPressed( 0, 36 ) ) then 
                    RequestAnimSet( "move_ped_crouched" )

                    while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
                        Citizen.Wait( 100 )
                    end 

                    if ( crouched == true ) then 
                        ResetPedMovementClipset( ped, 0 )
                        crouched = false 
                    elseif ( crouched == false ) then
                        SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
                        crouched = true 
                    end 
                end
            end 
        end 
    end
end )

--pvp

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		SetCanAttackFriendly(GetPlayerPed(-1), true, false)
		NetworkSetFriendlyFireOption(true)
	end
end)

--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetVehicleDensityMultiplierThisFrame(0.0) -- removes people walking around
        SetPedDensityMultiplierThisFrame(0.0) -- remove vehicles driving
    end
end)]]