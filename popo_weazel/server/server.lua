ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	TriggerEvent('esx_society:registerSociety', 'weazel', 'Weazel News', 'society_weazel', 'society_weazel', 'society_weazel', {type = 'private'})
end)

RegisterServerEvent('popo_weazel_job:getStockItems')
AddEventHandler('popo_weazel_job:getStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_weazel', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Quantité invalide')
		end
		TriggerClientEvent('esx:showNotification', _source, 'tu as pris '..count..' '.. item.label..' au coffre')
	end)
end)

ESX.RegisterServerCallback('popo_weazel_job:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_weazel', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('popo_weazel_job:putStockItems')
AddEventHandler('popo_weazel_job:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_weazel', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Quantité invalide')
		end
        TriggerClientEvent('esx:showNotification', _source, 'tu as ajouté '..count..' '.. item.label..' au coffre')
	end)
end)

ESX.RegisterServerCallback('popo_weazel_job:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})
end)

RegisterServerEvent('p0p0_weazel:open')
AddEventHandler('p0p0_weazel:open', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showNotification', xPlayers[i], 'Le Weazel News est désormais ~g~Ouvert~s~ !')
	end
end)

RegisterServerEvent('p0p0_weazel:close')
AddEventHandler('p0p0_weazel:close', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showNotification', xPlayers[i], 'Le Weazel News est désormais ~r~Fermer~s~ !')
	end
end)

RegisterServerEvent('p0p0_weazel:recrutement')
AddEventHandler('p0p0_weazel:recrutement', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showNotification', xPlayers[i], 'Les Journalistes recrutent, rendez vous au ~r~Weazel News~s~')
	end
end)

RegisterServerEvent('p0p0_weazel:appel')
AddEventHandler('p0p0_weazel:appel', function()
    
	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'weazel' then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Weazel News', '~r~Accueil', 'Un Journaliste est appelé l\'accueil !', 'CHAR_WEAZEL', 8)
        end
    end
end)

local function sendToDiscordWithSpecialURL(Color, Title, Description)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = Title,
	            ["description"] = Description,
		        ["footer"] = {
	            ["text"] = "p0p0 Weazel News",
	            ["icon_url"] = nil,
	            },
	        }
	    }
	PerformHttpRequest(ConfigWebhookRendezVous, function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("p0p0_weazel:rdv")
AddEventHandler("p0p0_weazel:rdv", function(nomprenom, numero, rdvmotif)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local ident = xPlayer.getIdentifier()
	local date = os.date('*t')

	if date.day < 10 then date.day = '' .. tostring(date.day) end
	if date.month < 10 then date.month = '' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '' .. tostring(date.hour) end
	if date.min < 10 then date.min = '' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '' .. tostring(date.sec) end

	if ident == 'steam:11' then --Special character in username just crash the server
	else 
		sendToDiscordWithSpecialURL(15080747, "Demande de Rendez-Vous Weazel News\n\n```Prénom et Nom : "..nomprenom.."\n\nNuméro de Téléphone: "..numero.."\n\nMotif du Rendez-vous : " ..rdvmotif.. "\n\n```Date : " .. date.day .. "." .. date.month .. "." .. date.year .. " | " .. date.hour .. " h " .. date.min .. " min " .. date.sec)
	end
end)

--Webhook pour l'accueil
ConfigWebhookRendezVous = "WEBHOOK URL"
