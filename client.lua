local ESX
local blips = {}
local isPolice = false

CreateThread(function()
    while not ESX do
        ESX = exports["es_extended"]:getSharedObject()
        Wait(100)
    end

    -- Start monitoring job and blips
    CreateThread(MonitorJob)
    CreateThread(UpdatePoliceBlips)
end)

function MonitorJob()
    while true do
        Wait(10000)
        ESX.TriggerServerCallback('policeblips:getJob', function(job)
            local wasPolice = isPolice
            isPolice = job == 'police'

            if wasPolice and not isPolice then
                ClearAllBlips()
            end
        end)
    end
end

function UpdatePoliceBlips()
    while true do
        Wait(100) -- Reduced frequency for performance

        if not isPolice then goto continue end

        ESX.TriggerServerCallback('policeblips:getCopsWithCoords', function(cops)
            local activeIds = {}

            for _, cop in ipairs(cops) do
                if cop.id ~= GetPlayerServerId(PlayerId()) and cop.coords then
                    activeIds[cop.id] = true

                    if blips[cop.id] then
                        SetBlipCoords(blips[cop.id], cop.coords.x, cop.coords.y, cop.coords.z)
                    else
                        local blip = AddBlipForCoord(cop.coords.x, cop.coords.y, cop.coords.z)
                        SetBlipSprite(blip, 1)
                        SetBlipScale(blip, 0.85)
                        SetBlipColour(blip, 3)
                        SetBlipAsShortRange(blip, false)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Police: " .. cop.name .. " (" .. cop.grade .. ")")
                        EndTextCommandSetBlipName(blip)
                        blips[cop.id] = blip
                    end
                end
            end

            -- Remove blips for cops no longer online
            for id, blip in pairs(blips) do
                if not activeIds[id] then
                    RemoveBlip(blip)
                    blips[id] = nil
                end
            end
        end)

        ::continue::
    end
end

function ClearAllBlips()
    for _, blip in pairs(blips) do
        RemoveBlip(blip)
    end
    blips = {}
end
