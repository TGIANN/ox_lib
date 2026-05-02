--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---@param model string | number The model to spawn
---@param coords vector3 Spawn coordinate
---@param doorFlag? boolean Set true to spawn door models in network mode.
---@param heading? number Heading of the object
---@param rotation? vector3 Rotation of the object; defaults to no rotation.
---@param orphanMode? EntityOrphanMode Server-side cleanup behavior for the entity.
lib.createObject = function(model, coords, doorFlag, heading, rotation, orphanMode)
    assert(coords and coords.x and coords.y and coords.z, 'Invalid coordinates vector3 provided')
    assert(doorFlag == nil or type(doorFlag) == 'boolean', 'Invalid doorFlag provided, expected boolean')
    assert(heading == nil or type(heading) == 'number', 'Invalid heading provided, expected number')
    assert(rotation == nil or (rotation.x and rotation.y and rotation.z), 'Invalid rotation vector3 provided')

    local object = lib.spawnEntity('object', model, function(modelHash)
        return CreateObject(modelHash, coords.x, coords.y, coords.z, true, true, doorFlag or false)
    end, orphanMode)

    if object == 0 then return 0 end

    if heading then
        SetEntityHeading(object, heading + 0.0)
    end

    if rotation then
        SetEntityRotation(object, rotation.x + 0.0, rotation.y + 0.0, rotation.z + 0.0, 2, true)
    end

    return object
end

return lib.createObject
