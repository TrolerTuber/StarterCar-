local coords = Config.ReceivedCarPoint

CreateThread(function()
  while not ESX.PlayerLoaded do
      Wait(500)
  end    

  Wait(500)

  
  TriggerServerEvent('StarterCar:PlayerLoaded')
end)

local point = lib.points.new({
    coords = coords,
    distance = 20,
})

local marker = lib.marker.new({
    coords = coords,
    type = 1,
    color = { r = 0, g = 110, b = 255, a = 100 },
    width = 1.3,
    height = 0.3,
})

local function draw3DText(coords, text, scale)
    local x, y, z = table.unpack(coords)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(vec3(camCoords.x, camCoords.y, camCoords.z) - coords)

    scale = (scale or 1.0) * (1.0 / dist) * 2.0
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextCentre(1)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

function point:nearby()
    marker:draw()
    draw3DText(vector3(coords.x, coords.y, coords.z + 1.5), Config.FloatingText, 0.8)

    if self.currentDistance < 1.5 then
        if not lib.isTextUIOpen() then
            lib.showTextUI(Config.UIText)
        end

        if IsControlJustPressed(0, 51) then          
            if ESX.PlayerData.metadata.StarterCar.claimed then
                return ESX.ShowNotification(Config.ClaimedCar)
            end

            TriggerServerEvent('StarterCar')

            while not IsPedInAnyVehicle(ESX.PlayerData.ped, false) do
                Wait(100)
            end

            local pedIsIn = GetVehiclePedIsIn(ESX.PlayerData.ped, false)
            local info = ESX.Game.GetVehicleProperties(pedIsIn)
            local cb = lib.callback.await('getVehicleData', false, info)

            if cb then
                ESX.ShowNotification(Config.ReceivedCar)
            else
                return
            end
        end
    else
        local isOpen, currentText = lib.isTextUIOpen()
        if isOpen and currentText == Config.UIText then
            lib.hideTextUI()
        end
    end
end