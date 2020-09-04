-- these are all internal variables, there's nothing interesting here
ESX = nil

local NumberCharset = {}
local Charset = {}

local currentExecuting = 0

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- customize the plate generator here
function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. ' ' .. GetRandomNumber(Config.PlateNumbers))

		MySQL.Async.fetchScalar('SELECT plate FROM owned_vehicles WHERE LOWER(plate) = @plate', {
			['@plate'] = string.lower(generatedPlate)
		}, function (plate)
			if not plate then
				doBreak = true
			else
				Citizen.Wait(2)
			end
		end)

		if doBreak then
			break
		end
	end

	return generatedPlate
end


function GetRandomNumber(length)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end