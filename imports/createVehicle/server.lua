--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---Vehicle category for `CreateVehicleServerSetter` (GTA5 only).
---@alias VehicleType
---| 'automobile'
---| 'bike'
---| 'boat'
---| 'heli'
---| 'plane'
---| 'submarine'
---| 'trailer'
---| 'train'

if cache.game == 'redm' then
    ---**RedM build** — calls the CFX `CREATE_VEHICLE` server native
    ---(`modelHash, x, y, z, heading, isNetwork, netMissionEntity`).
    ---`vehicleType`, `properties`, and `seat` from the GTA5 wrapper are not
    ---available on RedM (`setVehicleProperties` and `CreateVehicleServerSetter`
    ---are GTA5-only).
    ---@param model string | number The model to spawn
    ---@param coords vector3 Spawn coordinate
    ---@param heading? number Heading to face towards, in degrees.
    ---@param orphanMode? EntityOrphanMode Server-side cleanup behavior for the entity.
    lib.createVehicle = function(model, coords, heading, orphanMode)
        assert(coords and coords.x and coords.y and coords.z, 'Invalid coordinates vector3 provided')
        assert(heading == nil or type(heading) == 'number', 'Invalid heading provided, expected number')

        local headingValue = heading and heading + 0.0 or 0.0

        return lib.spawnEntity('vehicle', model, function(modelHash)
            return CreateVehicle(modelHash, coords.x, coords.y, coords.z, headingValue, true, true)
        end, orphanMode)
    end
else
    ---**GTA5/FiveM build** — calls `CreateVehicleServerSetter` with the supplied
    ---`vehicleType`. Optionally applies vehicle properties and warps a player
    ---into a seat after the entity exists.
    ---@param model string | number The model to spawn
    ---@param coords vector3 Spawn coordinate
    ---@param heading? number Heading to face towards, in degrees.
    ---@param vehicleType? VehicleType Vehicle category; defaults to `'automobile'`.
    ---@param properties? table Properties applied via `lib.setVehicleProperties` after spawning.
    ---@param seat? { source:number, seat:SeatPosition } If provided, the source will be warped into the specified seat after spawning.
    ---@param orphanMode? EntityOrphanMode Server-side cleanup behavior for the entity.
    lib.createVehicle = function(model, coords, heading, vehicleType, properties, seat, orphanMode)
        assert(coords and coords.x and coords.y and coords.z, 'Invalid coordinates vector3 provided')
        assert(heading == nil or type(heading) == 'number', 'Invalid heading provided, expected number')
        assert(vehicleType == nil or type(vehicleType) == 'string', 'Invalid vehicleType provided, expected string')
        assert(properties == nil or type(properties) == 'table', 'Invalid properties provided, expected table')

        local headingValue = heading and heading + 0.0 or 0.0

        local vehicle = lib.spawnEntity('vehicle', model, function(modelHash)
            return CreateVehicleServerSetter(modelHash, vehicleType or 'automobile', coords.x, coords.y, coords.z, headingValue)
        end, orphanMode)

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
