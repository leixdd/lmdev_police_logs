local ESX	 = nil

isView = false

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('ViewLogs')
AddEventHandler('ViewLogs', function(allowed)
    
    if (allowed) then
        
        if(isView) then
            isView = false
        else
            isView = true
        end
        
        SendNUIMessage({ action = 'viewLogs', on = isView })

    else 
       -- exports['mythic_notify']:DoHudText('error', 'Only High rank officials could access this')
            TriggerEvent("pNotify:SendNotification", {text = "Only High rank officials could access this",
            layout = "centerLeft",
            timeout = 2000,
            progressBar = false,
            type = "error",
            animation = {
                open = "gta_effects_fade_in",
                close = "gta_effects_fade_out"
            }})
            end

end)

RegisterNetEvent('sent_police_logs')
AddEventHandler('sent_police_logs', function(res)
    
    if(res == false) then
     --   exports['mythic_notify']:DoHudText('error', 'Only High rank officials could access this')
            TriggerEvent("pNotify:SendNotification", {text = "Only High rank officials could access this",
            layout = "centerLeft",
            timeout = 2000,
            progressBar = false,
            type = "error",
            animation = {
                open = "gta_effects_fade_in",
                close = "gta_effects_fade_out"
            }})
    else 
        SendNUIMessage({ action = 'policeLogs', result = json.encode(res) })
       -- SetNuiFocus(true, true)
    end
end)

RegisterNUICallback('getLogs', function(data, cb)
    TriggerServerEvent('lmdev:get_police_logs')
    cb('OK')
    SetNuiFocus(true, true)
end)

RegisterNUICallback('exit_logs', function(data, cb)
    SetNuiFocus(false, false)
    isView = false
    SendNUIMessage({ action = 'viewLogs', on = isView })
    cb('OK')
end)