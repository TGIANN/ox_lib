--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---@param pedType number AI behavior type. 4 = CIVMALE, 5 = CIVFEMALE, etc. Ignored on RedM (`Unused` per the native docs).
---@param model string | number The model to spawn
---@param coords vector3 Spawn coordinate
---@param heading? number Heading of the ped
---@param orphanMode? EntityOrphanMode Server-side cleanup behavior for the entity.
lib.createPed = function(pedType, model, coords, heading, orphanMode)
    assert(type(pedType) == 'number', 'Invalid pedType provided, expected number')
    assert(coords and coords.x and coords.y and coords.z, 'Invalid coordinates vector3 provided')
    assert(heading == nil or type(heading) == 'number', 'Invalid heading provided, expected number')

    local headingValue = heading and heading + 0.0 or 0.0

    return lib.spawnEntity('ped', model, function(modelHash)
        return CreatePed(pedType, modelHash, coords.x, coords.y, coords.z, headingValue, true, true)
    end, orphanMode)
end

return lib.createPed
