RegisterNetEvent('StarterCar:PlayerLoaded', function()
    local playerId = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    if not xPlayer.getMeta('StarterCar') then
        xPlayer.setMeta('StarterCar', {claimed = false})
    end

end)

RegisterNetEvent('StarterCar', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMeta('StarterCar').claimed then
        return DropPlayer(source, '¡Stop hacking with executor men...!')
    end
    
    ESX.OneSync.SpawnVehicle(Config.Car, Config.CarSpawn, Config.Heading, {}, function(NetworkId)
        Wait(100) 
        local vehicle = NetworkGetEntityFromNetworkId(NetworkId)
        local playerPed = GetPlayerPed(xPlayer.source)

        if DoesEntityExist(vehicle) then
            for _ = 1, 100 do
                Wait(0)
                SetPedIntoVehicle(playerPed, vehicle, -1)

                if GetVehiclePedIsIn(playerPed, false) == vehicle then
                    break
                end
            end
            
        end
    end)
end)

lib.callback.register('getVehicleData', function(source, info)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)', {xPlayer.identifier, info.plate, json.encode(info)})    
    xPlayer.setMeta('StarterCar', {claimed = true})

    if xPlayer.getMeta('StarterCar').claimed then
        return true
    else
        return false
    end
end)