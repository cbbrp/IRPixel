local ESX = nil
local PlayerData = {}
local FlyLicense = false
local Blips = {}
local CreatedBlips = {
	
	["police"] = {

	},

	["ambulance"] = {

	},

	["government"] = {

	},

	["doc"] = {
		 
	},

	["mecano"] = {

	},

	["taxi"] = {

	},

	["weazel"] = {

	}

}
local colorIndex = {["police"] = 38, ["ambulance"] = 49, ["doc"] = 31, ["taxi"] = 73, ["mecano"] = 25, ["weazel"] = 62}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('esx_tracker:CheckLicense', function(doeshaveLicense)
		FlyLicense = doeshaveLicense
	end)

	if PlayerData.job.name == "police" or PlayerData.job.name == "government" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "doc" then
		ESX.TriggerServerCallback('esx_tracker:getBlips', function(newBlips)
			if newBlips then
				Blips = newBlips
				Citizen.Wait(5000)
				if PlayerData.job.name == "police" then
					RequestBlip("police")
					RequestBlip("doc")
					RequestBlip("ambulance")
				elseif PlayerData.job.name == "government" then
					RequestBlip("government")
					RequestBlip("police")
					RequestBlip("doc")
					RequestBlip("ambulance")
					RequestBlip("mecano")
					RequestBlip("taxi")
					RequestBlip("weazel")
				elseif PlayerData.job.name == "doc" then
					RequestBlip("doc")
					RequestBlip("police")
					RequestBlip("ambulance")
				elseif PlayerData.job.name == "ambulance" then
					RequestBlip("ambulance")
					RequestBlip("police")
				end

			end
		end)
	end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	  PlayerData.job = job
	  if PlayerData.job.name ~= "police" and PlayerData ~= "government" and PlayerData.job.name ~= "doc" and PlayerData.job.name ~= "ambulance" then
		  for k,v in pairs(CreatedBlips) do

			for _, existingBlip in pairs(CreatedBlips[k]) do
				RemoveBlip(existingBlip)
			end

		  end
	  end
end)

RegisterNetEvent('esx_tracker:updateTable')
AddEventHandler('esx_tracker:updateTable', function(newBlips)
	while PlayerData.job == nil do
		Citizen.Wait(100)
	end

	if PlayerData.job.name == "police" or PlayerData.job.name == "government" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "doc" then
		Blips = newBlips
	end
end)

RegisterNetEvent('esx_tracker:flyLicense')
AddEventHandler('esx_tracker:flyLicense', function(status)
	if type(status) ~= "boolean" then
		return
	end

	FlyLicense = status
end)

RegisterNetEvent('esx_tracker:updateBlips')
AddEventHandler('esx_tracker:updateBlips', function(passedJob)
	if PlayerData.job.name == "government" then
		RequestBlip("government")
		RequestBlip("police")
		RequestBlip("doc")
		RequestBlip("ambulance")
		RequestBlip("mecano")
		RequestBlip("taxi")
		RequestBlip("weazel")
	elseif PlayerData.job.name == "police" then
		RequestBlip("police")
		RequestBlip("ambulance")
		RequestBlip("doc")
		RequestDelete("mecano")
		RequestDelete("taxi")
		RequestDelete("government")
	elseif PlayerData.job.name == "ambulance" then
		RequestBlip("police")
		RequestBlip("ambulance")
		RequestDelete("mecano")
		RequestDelete("taxi")
		RequestDelete("doc")
		RequestDelete("government")
	elseif PlayerData.job.name == "doc" then
		RequestBlip("police")
		RequestBlip("ambulance")
		RequestBlip("doc")
		RequestDelete("mecano")
		RequestDelete("taxi")
		RequestDelete("government")
	end
end)

function RequestBlip(passedJob)
	-- Refresh all blips
	for _, existingBlip in pairs(CreatedBlips[passedJob]) do
		RemoveBlip(existingBlip)
	end
	
	-- Clean the blip table
	CreatedBlips[passedJob] = {}
	
	-- print(ESX.dump(Blips[passedJob]))
	for k,v in pairs(Blips[passedJob]) do

		local id = GetPlayerFromServerId(v.id)
		if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
			createBlip(id, colorIndex[v.job.name], v.name, v.job.name)
		end

	end
		
end

function RequestDelete(job)
	for _, existingBlip in pairs(CreatedBlips[job]) do
		RemoveBlip(existingBlip)
	end
end

function createBlip(id, color, name, job)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then 
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) 
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
		SetBlipNameToPlayerName(blip, id)
		SetBlipScale(blip, 0.85)
		SetBlipColour(blip, color)
		SetBlipCategory(blip, 2)
		SetBlipAsShortRange(blip, true)


		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(name)
		EndTextCommandSetBlipName(blip)
		
		table.insert(CreatedBlips[job], blip)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		if not FlyLicense then
			local ped = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn(ped)
			local class = GetVehicleClass(vehicle)
			if class == 15 or class == 16 then
				if GetPedInVehicleSeat(vehicle, -1) == ped  then
					exports["esx_vehiclecontrol"]:EngineHandler(true)
				end
			end
		end

	end
end)