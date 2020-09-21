ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function createLog(identifier, item_name, inventory_name, quantity, remaining_item) 

	MySQL.Async.execute('INSERT INTO lmdev_inv_items(identifier, item_name, inventory_name, quantity) VALUES (@i, @item, @inventory_name, @q)', {
		['@inventory_name'] = inventory_name,
		['@item']      = item_name,
		['@i']          = identifier,
		['@q']          = quantity
	})
end

function getLogs(callback) 
	MySQL.Async.fetchAll('SELECT CONCAT(users.firstname," ",users.lastname) AS NAME, lmdev_inv_items.item_name, lmdev_inv_items.quantity, lmdev_inv_items.created_at FROM lmdev_inv_items INNER JOIN users ON users.identifier = lmdev_inv_items.identifier', {}, function(results) 
		callback(results)
	end)
end


function Set (list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end

RegisterServerEvent("esx_policejob:getStockItem")
AddEventHandler("esx_policejob:getStockItem", function(itemName, count)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
			createLog(xPlayer.getIdentifier(), itemName, 'society_police', count, (inventoryItem.count - count))
		end
	end)
end)

RegisterServerEvent("lmdev:get_police_logs")
AddEventHandler("lmdev:get_police_logs", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local police_grades = Set(Config.allowedPosition)

	if(xPlayer ~= nil and (xPlayer.getJob().name == "police" and police_grades[xPlayer.getJob().grade_name])) then
		getLogs(function(result)
			TriggerClientEvent('sent_police_logs', _source, result)
		end)
	else 
		TriggerClientEvent('sent_police_logs', _source, false)
	end
end)

RegisterCommand("viewPoliceLogs", function(source, args) 
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local police_grades = Set(Config.allowedPosition)

	if xPlayer ~= nil then
		TriggerClientEvent('ViewLogs', _source, (xPlayer.getJob().name == "police" and police_grades[xPlayer.getJob().grade_name]))
	end
	
end)
