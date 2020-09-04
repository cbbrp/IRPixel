ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local spots = {
   {
	   coords = {x = -1701.01, y = -880.47, z = 7.95},
	   heading = 319.7,
	   vehicle = {
		   plate = "N/A",
		   hash = "N/A"
	   },
	   occupied = false
   },
   {
	coords = {x = -1698.64, y = -882.56, z = 7.95},
	heading = 319.7,
	vehicle = {
		plate = "N/A",
		hash = "N/A"
	},
	occupied = false
   },
   {
	coords = {x = -1696.37, y = -884.49, z = 7.95},
	heading = 318.52,
	vehicle = {
		plate = "N/A",
		hash = "N/A"
	},
	occupied = false
   },
   {
	coords = {x = -1693.91, y = -886.53, z = 7.95},
	heading = 320.18,
	vehicle = {
		plate = "N/A",
		hash = "N/A"
	},
	occupied = false
   },
   {
	coords = {x = -1691.41, y = -888.42, z = 7.95},
	heading = 320.33,
	vehicle = {
		plate = "N/A",
		hash = "N/A"
	},
	occupied = false
   },
   {
	coords = {x = -1698.17, y = -890.42, z = 7.95},
	heading = 319.17,
	vehicle = {
		plate = "N/A",
		hash = "N/A"
	},
	occupied = false
   }
}

function FindFreeSlot()
	for i,v in ipairs(spots) do
		if not v.occupied then
			return i
		end
	end

	return false
end

function spawnit(index, hash, plate)

	local vehicle = CreateVehicle(hash, spots[index].coords.x, spots[index].coords.y, spots[index].coords.z, spots[index].heading, true, false)
	if vehicle then

		local exist = DoesEntityExist(vehicle)
		while not exist do
			Wait(250)
			exist = DoesEntityExist(vehicle)
		end
		spots[index].vehicle.vehicle = vehicle
		
		SetVehicleNumberPlateText(vehicle, plate)
		FreezeEntityPosition(vehicle, true)
		TriggerClientEvent("esx_highend:applyUpgrades", -1, NetworkGetNetworkIdFromEntity(vehicle), nil)

	else
		print("Creation Failed")
	end
end

function assign(index, hash, plate)
	 spots[index].occupied = true
	 spots[index].vehicle.plate = plate
	 spots[index].vehicle.hash = hash
	 spawnit(index, hash, plate)
end

RegisterCommand("ci", function(source, args)
	if args[1] and args[2] then
		local index = FindFreeSlot()

		if index then
			assign(index, GetHashKey(args[1]), args[2])
		else
			print("no free slot")
		end
		
	end
 end, false)