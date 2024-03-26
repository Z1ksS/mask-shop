local display = false
local playerInsideMarker = false
local lastMenuCloseTime = 0
local menuReopenDelay = 2000

local originalPedVariation = {}
local wasSomethingBought = false

RegisterNUICallback('chooseMask', function(data, cb)
   local player_ped = PlayerPedId()
   
   local maskID = tonumber(data.mask)
   local textureID = tonumber(data.texture) - 1
   SetPedComponentVariation(player_ped, 1, maskID, textureID, 1)
   cb('ok')
end)

RegisterNUICallback('chooseColor', function(data, cb)
   local player_ped = PlayerPedId()

   local maskID = tonumber(data.mask)
   local textureID = tonumber(data.texture) - 1

   SetPedComponentVariation(player_ped, 1, maskID, textureID, 1)
   cb('ok')
end)

function SendNotification(type) 
   SendNUIMessage({
      call = 'notification',
      type = type
   })
end 

RegisterNUICallback('buyMask', function(data, cb)
   if MaskStore.PlayerCash <= data.maskParams.price then 
      SendNotification('notEnoughMoney')
      cb('error')

      return
   end 

   if originalPedVariation and (originalPedVariation[1] == tonumber(data.selectedMask) and (originalPedVariation[2] + 1) == tonumber(data.maskParams.active)) then
      SendNotification('alreadyBought')
      cb('error')

      return
   end

   SetPedComponentVariation(player_ped, 1, data.selectedMask, data.maskParams.active, 1)
   SendNotification('success') 

   wasSomethingBought = true

   originalPedVariation = {
      GetPedDrawableVariation(PlayerPedId(), 1),
      GetPedTextureVariation(PlayerPedId(), 1),
   }

   cb('ok')
end)

function SetDisplay(bool)
   display = bool

   SetNuiFocus(bool, bool)

   local maskList = {}
   local playerPed = PlayerPedId()
   local drawableVariations = GetNumberOfPedDrawableVariations(playerPed, 1)

   for i = 0, 5 do
      local maskTextures = {}
      local textureVariations = GetNumberOfPedTextureVariations(playerPed, 1, i)
      for j = 0, textureVariations - 1 do
         table.insert(maskTextures, j)
      end

      table.insert(maskList, { label = "Mask " .. i + 1, textures = maskTextures, price = math.random(800, 1500), weight = randomFloat(0.3, 0.8) })
   end

   SendNUIMessage({
      call = 'mask_store_open',
      show = display,
      masksList = maskList -- unfinished try to send masks and their textures on web client
   })
end

RegisterCommand("openview", function()
   SetDisplay(not display)
   CreationCamHead(display)
   FreezeEntityPosition(PlayerPedId(), display)

   originalPedVariation = {
      GetPedDrawableVariation(PlayerPedId(), 1),
      GetPedTextureVariation(PlayerPedId(), 1),
   }
end)

RegisterNUICallback('closeUI', function(data, cb)
   local player_ped = PlayerPedId()

   SetNuiFocus(false, false)
   SetDisplay(false)
   CreationCamHead(false)
   FreezeEntityPosition(player_ped, false)
   
   local currentMask = GetPedDrawableVariation(PlayerPedId(), 1)
   local currentText = GetPedTextureVariation(PlayerPedId(), 1)


   if not wasSomethingBought and originalPedVariation then
      if (currentMask ~= originalPedVariation[1] or currentText ~= originalPedVariation[2]) or (currentMask == nil and currentText == nil) then 
         SetPedComponentVariation(player_ped, 1, originalPedVariation[1], originalPedVariation[2], 1)
      end 
      originalPedVariation = {}
   end 

   wasSomethingBought = false

   lastMenuCloseTime = GetGameTimer()

   cb("closed")
end)

function InitMarkersAndBlips()
   for _, marker in pairs(MaskStore.markersTbl) do
      -- Add blip
      local blip = AddBlipForCoord(marker.pos.x, marker.pos.y, marker.pos.z)
      SetBlipScale(blip, 1.0)
      SetBlipSprite(blip, 362)
      SetBlipColour(blip, 2)
      SetBlipAlpha(blip, 255)
      AddTextEntry("MaskStore", "Mask Store")
      BeginTextCommandSetBlipName("MaskStore")
      EndTextCommandSetBlipName(blip)
      SetBlipCategory(blip, 2)
      SetBlipAsShortRange(blip, true)
   end

   Citizen.CreateThread(
      function()
         while true do
            Citizen.Wait(1)
            for k, marker in pairs(MaskStore.markersTbl) do
               -- Draw marker
               DrawMarker(
                  marker.markerID,
                  marker.pos.x,
                  marker.pos.y,
                  marker.pos.z - 0.75,
                  0.0,
                  0.0,
                  0.0,
                  0.0,
                  0.0,
                  0.0,
                  marker.scale,
                  marker.scale,
                  marker.scale,
                  marker.rgba[1],
                  marker.rgba[2],
                  marker.rgba[3],
                  marker.rgba[4],
                  false,
                  true,
                  2,
                  nil,
                  nil,
                  false
               )

               local playerCoord = GetEntityCoords(PlayerPedId(), false)
               local localVector = vector3(marker.pos.x, marker.pos.y, marker.pos.z)

               if Vdist2(playerCoord, localVector) < marker.scale * 1.15 and not display and (GetGameTimer() - lastMenuCloseTime) > menuReopenDelay then
                  FreezeEntityPosition(PlayerPedId(), true)

                  Citizen.Wait(100)

                  SetDisplay(not display)
                  CreationCamHead(display)
               end
            end
         end
      end
   )
end

Citizen.CreateThread(InitMarkersAndBlips)