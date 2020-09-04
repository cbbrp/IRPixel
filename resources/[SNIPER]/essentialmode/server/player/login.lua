function LoadUser(identifier, source, licenseNotRequired)
	local Source = source
	db.retrieveUser(identifier, function(user, isJson)
		if user then
			if isJson then
				user = json.decode(user)
			end
			user.protectedInventory = {}
			if user.inventory then 
				user.inventory = json.decode(user.inventory)
			else
				user.inventory = {} 
			end

			-- user inventory
			for i=1, #user.inventory do
				local item = ESX.Items[user.inventory[i].item]
				if item then
					table.insert(user.protectedInventory, {
						name = user.inventory[i].item,
						count = user.inventory[i].count,
						label = item.label,
						limit = item.limit,
						usable = ESX.UsableItemsCallbacks[user.inventory[i].item] ~= nil,
						rare = item.rare,
						canRemove = item.canRemove
					})
				else
					print(('es_extended: invalid item "%s" ignored!'):format(user.inventory[i].item))
				end
			end

			local userData = {
				divisions = {},
			}

			-- Divisions
				if user.divisions ~= nil then

					local divisions = json.decode(user.divisions)
					userData.divisions = {}

					-- Do you know tha way?
						for k,v in pairs(divisions) do
							userData.divisions[k] = {}
							for k2,v2 in pairs(v) do
								if ESX.DoesDivisionExist(k, k2, v2) then
									userData.divisions[k][k2] = v2
								else
									print(('es_extended: ignoring adding division %s in %s with grade %s to %s because does not exist'):format(k2, k, v2, GetPlayerName(source)))
								end
							end
						end

				else
					userData.divisions = {}
				end
			


			if user.license or licenseNotRequired then
				Users[source] = CreatePlayer(Source, user.permission_level, user.money, user.bank, user.identifier, user.license, user.group, user.roles or "", user.protectedInventory, user.job, user.job_grade, user.gang, user.gang_grade, user.loadout, user.playerName, user.position, user.status, userData.divisions)				
				Identifiers[user.identifier] = source

				TriggerClientEvent('esx:playerLoaded', Source, {
					identifier   = Users[Source].identifier,
					inventory    = Users[Source].inventory,
					job          = Users[Source].job,
					divisions    = Users[Source].divisions,
					gang		 = Users[Source].gang,
					loadout      = Users[Source].loadout,
					lastPosition = Users[Source].coords,
					money        = Users[Source].money,
					status		 = Users[Source].status,
					name		 = Users[Source].name,
					dead		 = user.is_dead
				})
				
				TriggerEvent('esx:playerLoaded', Source, Users[Source])

				local new = '.'
				if not user.playerName or not user.dateofbirth then 
					TriggerClientEvent('registerForm', Source, true)
					new = ', and he/she is new player!' 
				else
					TriggerClientEvent('registerForm', Source, false)					
				end
				print('User: ('.. source .. '), Identifier: (' .. Users[source].identifier .. '), Name: (' .. Users[source].name .. '), money: ('.. Users[source].money .. '), Bank: (' .. Users[source].bank .. '), Permission: ('.. Users[source].permission_level .. ')'.. new)

				for k,v in pairs(commandSuggestions) do
					TriggerClientEvent('chat:addSuggestion', Source, settings.defaultSettings.commandDelimeter .. k, v.help, v.params)
				end
			else
				local license

				for k,v in ipairs(GetPlayerIdentifiers(Source))do
					if string.sub(v, 1, string.len("license:")) == "license:" then
						license = v
						break
					end
				end

				if license then
					db.updateUser(user.identifier, {license = license}, function()
						LoadUser(user.identifier, Source, false)
					end)
				else
					LoadUser(user.identifier, Source, false, true)
				end
			end
		else
			local license
			for k,v in ipairs(GetPlayerIdentifiers(Source))do
				if string.sub(v, 1, string.len("license:")) == "license:" then
					license = v
					break
				end
			end
			db.createUser(identifier, license, function()
				LoadUser(identifier, Source, true)
			end)
		end
	end)
end

-- Exported function
ESX.getPlayerFromId = function(id)
	return Users[tonumber(id)]
end

-- Returns all EssentialMode user objects
AddEventHandler('es:getPlayers', function(cb)
	cb(Users)
end)

-- Same as above just easier was we know the ID already now.
AddEventHandler("es:setPlayerDataId", function(user, k, v, cb)
	db.updateUser(user, {[k] = v}, function(d)
		cb(true)
	end)
end)

RegisterNetEvent("es:newName")
AddEventHandler("es:newName", function(newName)
	Users[source].set("name", newName)
end)

-- Returns the user if all checks completed, if the first if check fails then you're in a bit of trouble
AddEventHandler("es:getPlayerFromId", function(user, cb)
	if(Users)then
		if(Users[user])then
			cb(Users[user])
		else
			cb(nil)
		end
	else
		cb(nil)
	end
end)

-- Same as above but uses the DB to get a user instead of memory.
AddEventHandler("es:getPlayerFromIdentifier", function(identifier, cb)
	db.retrieveUser(identifier, function(user)
		cb(user)
	end)
end)

-- Function to save player money to the database every 60 seconds.
ESX.savePlayerMoney = function()
	for k,v in pairs(Users)do
		if Users[k] ~= nil then
			db.updateUser(v.get('identifier'), {
				money 		= v.money, 
				bank 		= v.bank, 
				position 	= v.lastPosition, 
				inventory 	= v.inventory, 
				loadout 	= v.loadout}
			)
		end
		Wait(300)
	end
end