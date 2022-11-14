RMenu.Add("popo_weazel", "menu", RageUI.CreateMenu(_U('Weazel'), "~b~".._U('categorie')))
RMenu:Get("popo_weazel", "menu").Closed = function()
end

RMenu.Add("popo_weazel", "stock", RageUI.CreateMenu("Stock", "Stock"))
RMenu:Get("popo_weazel", "stock").Closed = function()
end

RMenu.Add("popo_weazel", "Equipment", RageUI.CreateSubMenu(RMenu:Get("popo_weazel", "menu"), "Equipement", nil))
RMenu:Get("popo_weazel", "Equipment").Closed = function()end

RMenu.Add("popo_weazel", "announce", RageUI.CreateSubMenu(RMenu:Get("popo_weazel", "menu"), "Annonce", nil))
RMenu:Get("popo_weazel", "announce").Closed = function()end

RMenu.Add("popo_weazel", "rdv", RageUI.CreateMenu(_U('Weazel'), "~b~".._U('rdv')))
RMenu:Get("popo_weazel", "rdv").Closed = function()
end

local vehicle = nil
local nomprenom = nil
local num = nil
local motif = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10000)
    end
    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
  blockinput = true
  
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
  
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
	blockinput = false
		return result
	else
		Citizen.Wait(500)
	blockinput = false
		return nil
	end
  end

--open the stock menu in RageUI--
local function openStockMenu()
	RageUI.Visible(RMenu:Get("popo_weazel","stock"), true)
	Citizen.CreateThread(function()
		while true do
			RageUI.IsVisible(RMenu:Get("popo_weazel","stock"),true,true,true,function()
				RageUI.Button(_U('get_stock'), _U('get_stock'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
                    if (s) then
						RageUI.CloseAll()
						OpenGetStocksMenu()
                    end
                end)
				RageUI.Button(_U('put_stock'), _U('put_stock'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
                    if (s) then
						RageUI.CloseAll()
						OpenPutStocksMenu()
                    end
                end)
			end, function()end)
			Citizen.Wait(0)
		end
	end)
end

--open the boss menu in RageUI--
local function openBossMenu()
	TriggerEvent('esx_society:openBossMenu', 'weazel', function(data, menu)
		menu.close()
	end)
end

local function facture()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
		title =  _U('name_billing')
	}, function(data, menu)

		local amount = tonumber(data.value)

		if amount == nil or amount <= 0 then
			ESX.ShowNotification("Montant invalide")
		else
			menu.close()

			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification("Pas de joueur")
			else
				local playerPed        = GetPlayerPed(-1)

				Citizen.CreateThread(function()
					TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
					Citizen.Wait(5000)
					ClearPedTasks(playerPed)
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_weazel', 'Weazel News', amount)
				end)
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

--open the F6 menu in RageUI--
local function openweazelmenu()
	local cat = 0

	RageUI.Visible(RMenu:Get("popo_weazel","menu"), true)
	Citizen.CreateThread(function()
		while true do
			local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
			local playerserverid = GetPlayerServerId(closestPlayer)
			local closestPlayerPed = GetPlayerPed(closestPlayer)
      		--ESX.ShowNotification("INTENTANDO CARGAR2 A: ".. GetPlayerName(ESX.Game.GetClosestPlayer()) .. " Estado: " .. tostring(IsPedDeadOrDying(closestPlayerPed)))
			RageUI.IsVisible(RMenu:Get("popo_weazel","menu"),true,true,true,function()
                RageUI.Button(_U('Equipment'), _U('Equipment'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
					if (s) then
					end
                end, RMenu:Get("popo_weazel", "Equipment"))
				RageUI.Button(_U('billing'), _U('billing'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
					if (s) then
						RageUI.CloseAll()
						facture()
					end
                end)
				RageUI.Button(_U('announce'), _U('announce'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
					if (s) then
					end
				end, RMenu:Get("popo_weazel", "announce"))
            end, function()end)
			RageUI.IsVisible(RMenu:Get("popo_weazel","announce"),true,true,true,function()
				RageUI.Button(_U('open_weazel'), _U('open_weazel'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
					if (s) then
						TriggerServerEvent('p0p0_weazel:open')
					end
                end)
				RageUI.Button(_U('close_weazel'), _U('close_weazel'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
					if (s) then
						TriggerServerEvent('p0p0_weazel:close')
					end
                end)
				RageUI.Button(_U('recruit_weazel'), _U('recruit_weazel'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
					if (s) then
						TriggerServerEvent('p0p0_weazel:recrutement')
					end
                end)
			end, function()end)
			RageUI.IsVisible(RMenu:Get("popo_weazel","Equipment"),true,true,true,function()
				RageUI.Button(_U('micro'), _U('micro'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
					if (s) then
						TriggerEvent('Mic:ToggleMic')
					end
                end)
				RageUI.Button(_U('micro_perche'), _U('micro_perche'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
					if (s) then
						TriggerEvent('Mic:ToggleBMic')
					end
                end)
				RageUI.Button(_U('cam'), _U('cam'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
					if (s) then
						TriggerEvent('Cam:ToggleCam')
					end
                end)
			end, function()end)
			Citizen.Wait(0)
		end
	end)
end

--boss marker--
Citizen.CreateThread(function()
    while true do
		local interval = 1
        Citizen.Wait(interval)
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'weazel' and ESX.PlayerData.job.grade_name == 'boss' then 

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.bosspos)
            if dist <= 15.0 then
			interval = 200
            DrawMarker(20, Config.bosspos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
			interval = 1
            if dist <= 1.0 then
                	AddTextEntry("try", _U('open'))
					DisplayHelpTextThisFrame("try", false)
                if IsControlJustPressed(1,51) then
                    openBossMenu()
                end
            end
        end
    end
end)

--stock marker--
Citizen.CreateThread(function()
    while true do
		local interval = 1
        Citizen.Wait(interval)
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'weazel' then 

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.stockpos)
            if dist <= 15.0 then
			interval = 200
            DrawMarker(20, Config.stockpos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
			interval = 1
            if dist <= 1.0 then
                	AddTextEntry("stock", _U('open_stock'))
					DisplayHelpTextThisFrame("stock", false)
                if IsControlJustPressed(1,51) then
                    openStockMenu()
                end
            end
        end
    end
end)

--F6 pressed ?--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'weazel' then 
			if IsControlJustReleased(0 ,167) then
				openweazelmenu()
			end
		end
	end
end)

function OpenGetStocksMenu()

	ESX.TriggerServerCallback('popo_weazel_job:getStockItems', function(items)

		print(json.encode(items))

		local elements = {}

		for i=1, #items, 1 do
			if (items[i].count ~= 0) then
				table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
				title    = 'Weazel News Stock',
				align    = 'top-left',
				elements = elements
			}, function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
						title = _U('quantity')
					}, function(data2, menu2)
		
						local count = tonumber(data2.value)

						if count == nil or count <= 0 then
							ESX.ShowNotification(_U('invalid_quantity'))
						else
							menu2.close()
							menu.close()
							OpenGetStocksMenu()

							TriggerServerEvent('popo_weazel_job:getStockItems', itemName, count)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
			end, function(data, menu)
				menu.close()
			end)
	end)
end

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('popo_weazel_job:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do

			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
				title    = _U('inventory'),
				elements = elements
			}, function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
						title = _U('quantity')
					}, function(data2, menu2)

						local count = tonumber(data2.value)

						if count == nil or count <= 0 then
							ESX.ShowNotification(_U('invalid_quantity'))
						else
							menu2.close()
							menu.close()
							OpenPutStocksMenu()

							TriggerServerEvent('popo_weazel_job:putStockItems', itemName, count)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
			end, function(data, menu)
				menu.close()
			end)
	end)
end

--garage marker--
Citizen.CreateThread(function()
    while true do
		local interval = 1
        Citizen.Wait(interval)
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'weazel' then 

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.garage_pos)
            if dist <= 1.0 then
			interval = 200
            DrawMarker(20, Config.garage_pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
			interval = 1
            if dist <= 1.0 then
                	AddTextEntry("garage", _U('open_garage'))
					DisplayHelpTextThisFrame("garage", false)
                if IsControlJustPressed(1,51) then
					local model = GetHashKey("newsvan")
                    RequestModel(model)
                    while not HasModelLoaded(model) do
						RequestModel(model)
						Citizen.Wait(10)
					end
                    vehicle = CreateVehicle(model, -547.6240, -927.3491, 22.86, 248.63, true, true)
					SetEntityAsMissionEntity(vehicle, true, true)
					SetVehicleNumberPlateText(vehicle, "WEAZEL") 
                end
            end
        end
    end
end)

--garage suppr marker--
Citizen.CreateThread(function()
    while true do
		local interval = 1
        Citizen.Wait(interval)
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'weazel' then 

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.garagesuppr_pos)
            if dist <= 1.0 then
			interval = 200
            DrawMarker(20, Config.garagesuppr_pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
			interval = 1
            if dist <= 1.0 then
                	AddTextEntry("garagesuppr", _U('close_garage'))
					DisplayHelpTextThisFrame("garagesuppr", false)
                if IsControlJustPressed(1,51) then
					DeleteVehicle(vehicle)
    				FreezeEntityPosition(PlayerPedId(), false)
                end
            end
        end
    end
end)

--open the secretariat menu in RageUI--
local function openrdvMenu()
	RageUI.Visible(RMenu:Get("popo_weazel","rdv"), true)
	Citizen.CreateThread(function()
		while true do
			RageUI.IsVisible(RMenu:Get("popo_weazel","rdv"),true,true,true,function()
				RageUI.Button("Prénom et Nom", "Prénom et Nom", {RightLabel = nomprenom}, true,function(h,a,s)
					if (s) then
						local name = KeyboardInput("POPO_BOX_NAME","Prénom et Nom", "", 150)
						if name and name ~= "" then
							nomprenom = tostring(name)
						end
						name = nil
					end
				end)
				RageUI.Button("Numéro de téléphone", "Numéro de téléphone", {RightLabel = num}, true,function(h,a,s)
					if (s) then
						local name = KeyboardInput("POPO_BOX_NUM", "Numéro de téléphone", "", 150)
						if name and name ~= "" then
							num = tostring(name)
						end
						name = nil
					end
				end)
				RageUI.Button("Motif du Rendez-vous", "Motif du Rendez-vous", {RightLabel = motif}, true,function(h,a,s)
					if (s) then
						local name = KeyboardInput("POPO_BOX_MOTIF", _U('name'), "", 150)
						if name and name ~= "" then
							motif = tostring(name)
						end
						name = nil
					end
				end)
				RageUI.Button("Valider la demande", "Valider la demande", {RightLabel = "~g~>>>"}, true,function(h,a,s)
					if (s) then
						if motif == nil or num == nil or nomprenom == nil then
							ESX.ShowNotification("~r~Il nous manque des informations !")
						else
							RageUI.CloseAll()
							TriggerServerEvent('p0p0_weazel:rdv', nomprenom, num, motif)
							ESX.ShowNotification("Votre demande à bien était reçu par le ~r~Weazel News~s~ !")
							nomprenom = nil
							motif = nil
							num = nil
						end
					end
                end)
			end, function()end)
			Citizen.Wait(0)
		end
	end)
end

--secretariat marker--
Citizen.CreateThread(function()
    while true do
		local interval = 1
        Citizen.Wait(interval)

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.secretariat)
            if dist <= 15.0 then
				interval = 200
            end
			interval = 1
            if dist <= 1.0 then
                	AddTextEntry("secretariat", _U('secretariat'))
					DisplayHelpTextThisFrame("secretariat", false)
                if IsControlJustPressed(1,51) then
                    openrdvMenu()
                end
            end
    end
end)

--garage hélico marker--
Citizen.CreateThread(function()
    while true do
		local interval = 1
        Citizen.Wait(interval)
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'weazel' then 

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.garagehelico_pos)
            if dist <= 1.0 then
			interval = 200
            DrawMarker(20, Config.garagehelico_pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
			interval = 1
            if dist <= 1.0 then
                	AddTextEntry("garageh", _U('open_garage'))
					DisplayHelpTextThisFrame("garageh", false)
                if IsControlJustPressed(1,51) then
					local model = GetHashKey("newsfrog")
                    RequestModel(model)
                    while not HasModelLoaded(model) do
						RequestModel(model)
						Citizen.Wait(10)
					end
                    vehicle = CreateVehicle(model, Config.garagehelicosupprr_pos, 265.987, true, true)
					SetEntityAsMissionEntity(vehicle, true, true)
					SetVehicleNumberPlateText(vehicle, "WEAZEL") 
                end
            end
        end
    end
end)

--garage hélico suppr marker--
Citizen.CreateThread(function()
    while true do
		local interval = 1
        Citizen.Wait(interval)
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'weazel' then 

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.garagehelicosupprr_pos)
            if dist <= 1.0 then
			interval = 200
            DrawMarker(20, Config.garagehelicosupprr_pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
			interval = 1
            if dist <= 1.0 then
                	AddTextEntry("garagehsuppr", _U('close_garage'))
					DisplayHelpTextThisFrame("garagehsuppr", false)
                if IsControlJustPressed(1,51) then
					DeleteVehicle(vehicle)
    				FreezeEntityPosition(PlayerPedId(), false)
                end
            end
        end
    end
end)

--display blip--
Citizen.CreateThread(function()

    local blip = AddBlipForCoord(Config.Blip.Pos.x, Config.Blip.Pos.y, Config.Blip.Pos.z)
  
    SetBlipSprite (blip, Config.Blip.Sprite)
    SetBlipDisplay(blip, Config.Blip.Display)
    SetBlipScale  (blip, Config.Blip.Scale)
    SetBlipColour (blip, Config.Blip.Colour)
    SetBlipAsShortRange(blip, true)
  
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('Weazel'))
    EndTextCommandSetBlipName(blip)
  
end)