--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---@alias SeatPosition
---| -2 # SF_ANY
---| -1 # SF_FrontDriverSide
---| 0 # SF_FrontPassengerSide
---| 1 # SF_BackDriverSide
---| 2 # SF_BackPassengerSide
---| 3 # SF_AltFrontDriverSide
---| 4 # SF_AltFrontPassengerSide
---| 5 # SF_AltBackDriverSide
---| 6 # SF_AltBackPassengerSide

if cache.game == 'redm' then
    ---**RedM build** — calls the 9-argument `CREATE_VEHICLE` native
    ---(`modelHash, x, y, z, heading, isNetwork, bScriptHostVeh, bDontAutoCreateDraftAnimals, p8`).
    ---@param model string | number The model to spawn
    ---@param coords vector3 Spawn coordinate
    ---@param heading? number Heading to face towards, in degrees.
    ---@param isNetwork? boolean Whether to create a network vehicle. If false, the vehicle exists only locally.
    ---@param bScriptHostVeh? boolean Pin the vehicle to the script host in the R* network model.
    ---@param bDontAutoCreateDraftAnimals? boolean Skip automatic creation of draft animals (e.g. horses on a wagon).
    ---@param p8? boolean Undocumented RedM parameter; passed as `false` if omitted.
    lib.createVehicle = function(model, coords, heading, isNetwork, bScriptHostVeh, bDontAutoCreateDraftAnimals, p8)
        assert(coords and coords.x and coords.y and coords.z, 'Invalid coordinates vector3 provided')
        assert(heading == nil or type(heading) == 'number', 'Invalid heading provided, expected number')
        assert(isNetwork == nil or type(isNetwork) == 'boolean', 'Invalid isNetwork flag provided, expected boolean')
        assert(bScriptHostVeh == nil or type(bScriptHostVeh) == 'boolean', 'Invalid bScriptHostVeh flag provided, expected boolean')
        assert(bDontAutoCreateDraftAnimals == nil or type(bDontAutoCreateDraftAnimals) == 'boolean', 'Invalid bDontAutoCreateDraftAnimals flag provided, expected boolean')
        assert(p8 == nil or type(p8) == 'boolean', 'Invalid p8 flag provided, expected boolean')

        local headingValue = heading and heading + 0.0 or 0.0

        return lib.spawnEntity(model, function(modelHash)
            return CreateVehicle(modelHash, coords.x, coords.y, coords.z, headingValue, isNetwork or false, bScriptHostVeh or false, bDontAutoCreateDraftAnimals or false, p8 or false)
        end)
    end
else
    ---**GTA5/FiveM build** — calls the 7-argument `CREATE_VEHICLE` native
    ---(`modelHash, x, y, z, heading, isNetwork, netMissionEntity`).
    ---@param model string | number The model to spawn
    ---@param coords vector3 Spawn coordinate
    ---@param heading? number Heading to face towards, in degrees.
    ---@param isNetwork? boolean Whether to create a network vehicle. If false, the vehicle exists only locally.
    ---@param netMissionEntity? boolean Pin the vehicle to the script host in the R* network model.
    ---@param seat? SeatPosition The SeatPosition for any vehicle seat.
    ---@param properties? table A table of vehicle properties to set on the vehicle after spawning. See `lib.setVehicleProperties` for more details.
    lib.createVehicle = function(model, coords, heading, isNetwork, netMissionEntity, seat, properties)
        assert(coords and coords.x and coords.y and coords.z, 'Invalid coordinates vector3 provided')
        assert(heading == nil or type(heading) == 'number', 'Invalid heading provided, expected number')
        assert(isNetwork == nil or type(isNetwork) == 'boolean', 'Invalid isNetwork flag provided, expected boolean')
        assert(netMissionEntity == nil or type(netMissionEntity) == 'boolean', 'Invalid netMissionEntity flag provided, expected boolean')
        assert(seat == nil or type(seat) == 'number', 'Invalid seat provided, expected number')
        assert(properties == nil or type(properties) == 'table', 'Invalid properties provided, expected table')

        local headingValue = heading and heading + 0.0 or 0.0

        local vehicle = lib.spawnEntity(model, function(modelHash)
            return CreateVehicle(modelHash, coords.x, coords.y, coords.z, headingValue, isNetwork or false, netMissionEntity or false)
        end)

        if vehicle == 0 then return 0 end

        if seat then
            TaskWarpPedIntoVehicle(cache.ped, vehicle, seat)
        end

        if properties then
            lib.setVehicleProperties(vehicle, properties)
        end

        return vehicle
    end
end

return lib.createVehicle
