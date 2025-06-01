local ESX
local blips = {}
local isPolice = false

CreateThread(function()
    while not ESX do
        ESX = exports["es_extended"]:getSharedObject()
        Wait(100)
    end

    -- Start job checker
    CreateThread(CheckJobLoop)
    -- Start blip loop
    CreateThread(UpdateBlipsLoop)
end)

function RemoveAllPoliceBlips()
    for _, blip in pairs(blips) do
        RemoveBlip(blip)
    end
    blips = {}
end

function CheckJobLoop()
    while true do
        Wait(5000)
        ESX.TriggerServerCallback('policeblips:getJob', function(job)
            local wasPolice = isPolice
            isPolice = job == 'police'

            if wasPolice and not isPolice then
                RemoveAllPoliceBlips()
            end
        end)
    end
end

function UpdateBlipsLoop()
    while true do
        Wait(100)
        if isPolice then
            ESX.TriggerServerCallback('policeblips:getCopsWithCoords', function(cops)
                RemoveAllPoliceBlips()
                for _, cop in pairs(cops) do
                    if cop.id ~= GetPlayerServerId(PlayerId()) and cop.coords then
                        local blip = AddBlipForCoord(cop.coords.x, cop.coords.y, cop.coords.z)
                        SetBlipSprite(blip, 1)
                        SetBlipScale(blip, 0.85)
                        SetBlipColour(blip, 3)
                        SetBlipAsShortRange(blip, false)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Police: " .. cop.name)
                        EndTextCommandSetBlipName(blip)
                        table.insert(blips, blip)
                    end
                end
            end)
        end
    end
end
