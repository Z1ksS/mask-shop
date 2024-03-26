local isCameraActive = false
local currentRotation = 0
local zoomLevel = 10 

function UpdateCamera() -- camera update on input
    while isCameraActive do
       Citizen.Wait(0)
 
       if isCameraActive then 
            local cam = GetRenderingCam()

            local angle = math.rad(currentRotation)
            local coordsPly = GetEntityCoords(PlayerPedId())

            --local newCamX = coordsPly.x + (math.cos(angle) * 0.5)
            --local newCamY = coordsPly.y + (math.sin(angle) * 0.5)

            --PointCamAtCoord(cam, newCamX, newCamY, coordsPly.z + 0.65)

            local zoomFactor = zoomLevel / 10
            SetCamFov(cam, zoomFactor * 45) -- 45 is default POV value
       end 
    end 
end 
 
function CreationCamHead(bool) -- create camera infront of player face
    isCameraActive = true
    Citizen.CreateThread(UpdateCamera)
     local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')
 
     local coordsCam = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.65, 0.65)
     local coordsPly = GetEntityCoords(PlayerPedId())
     SetCamCoord(cam, coordsCam)
     PointCamAtCoord(cam, coordsPly['x'], coordsPly['y'], coordsPly['z']+0.65)
 
     SetCamActive(cam, true)
     RenderScriptCams(bool, true, 500, true, true)
end

RegisterNUICallback('rotateCamera', function(data, cb)
    currentRotation = currentRotation + data.rotation 
    cb('ok')
end)
 
 RegisterNUICallback('zoomCamera', function(data, cb)
    zoomLevel = zoomLevel + data.zoom 
    cb('ok')
end)