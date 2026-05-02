--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

if cache.game == 'redm' then
    ---**RedM build** — calls the 9-argument `CREATE_OBJECT` native
    ---(`modelHash, x, y, z, isNetwork, bScriptHostObj, dynamic, p7, p8`).
    ---@param model string | number The model to spawn
    ---@param coords vector3 Spawn coordinate
    ---@param isNetwork? boolean Whether to create a network object. If false, the object exists only locally.
    ---@param bScriptHostObj? boolean Pin the object to the script host in the R* network model.
    ---@param dynamic? boolean Whether the object should be dynamic (physics-driven, can move).
    ---@param p7? boolean Undocumented RedM parameter; passed as `false` if omitted.
    ---@param p8? boolean Undocumented RedM parameter; passed as `false` if omitted.
    ---@param heading? number Heading of the object
    ---@param rotation? vector3 Rotation of the object; defaults to no rotation.
    lib.createObject = function(model, coords, isNetwork, bScriptHostObj, dynamic, p7, p8, heading, rotation)
        assert(coords and coords.x and coords.y and coords.z, 'Invalid coordinates vector3 provided')
        assert(isNetwork == nil or type(isNetwork) == 'boolean', 'Invalid isNetwork flag provided, expected boolean')
        assert(bScriptHostObj == nil or type(bScriptHostObj) == 'boolean', 'Invalid bScriptHostObj flag provided, expected boolean')
        assert(dynamic == nil or type(dynamic) == 'boolean', 'Invalid dynamic flag provided, expected boolean')
        assert(p7 == nil or type(p7) == 'boolean', 'Invalid p7 flag provided, expected boolean')
        assert(p8 == nil or type(p8) == 'boolean', 'Invalid p8 flag provided, expected boolean')
        assert(heading == nil or type(heading) == 'number', 'Invalid heading provided, expected number')
        assert(rotation == nil or (rotation.x and rotation.y and rotation.z), 'Invalid rotation vector3 provided')

        local object = lib.spawnEntity(model, function(modelHash)
            return CreateObject(modelHash, coords.x, coords.y, coords.z, isNetwork or false, bScriptHostObj or false, dynamic or false, p7 or false, p8 or false)
        end)

        if object == 0 then return 0 end

        if heading then
            SetEntityHeading(object, heading + 0.0)
        end

        if rotation then
            SetEntityRotation(object, rotation.x + 0.0, rotation.y + 0.0, rotation.z + 0.0, 2, true)
        end

        return object
    end
else
    ---**GTA5/FiveM build** — calls the 7-argument `CREATE_OBJECT` native
    ---(`modelHash, x, y, z, isNetwork, netMissionEntity, doorFlag`).
    ---@param model string | number The model to spawn
    ---@param coords vector3 Spawn coordinate
    ---@param isNetwork? boolean Whether to create a network object. If false, the object exists only locally.
    ---@param netMissionEntity? boolean Pin the object to the script host in the R* network model.
    ---@param doorFlag? boolean Set true to spawn door models in network mode.
    ---@param heading? number Heading of the object
    ---@param rotation? vector3 Rotation of the object; defaults to no rotation.
    lib.createObject = function(model, coords, isNetwork, netMissionEntity, doorFlag, heading, rotation)
        assert(coords and coords.x and coords.y and coords.z, 'Invalid coordinates vector3 provided')
        assert(isNetwork == nil or type(isNetwork) == 'boolean', 'Invalid isNetwork flag provided, expected boolean')
        assert(netMissionEntity == nil or type(netMissionEntity) == 'boolean', 'Invalid netMissionEntity flag provided, expected boolean')
        assert(doorFlag == nil or type(doorFlag) == 'boolean', 'Invalid doorFlag provided, expected boolean')
        assert(heading == nil or type(heading) == 'number', 'Invalid heading provided, expected number')
        assert(rotation == nil or (rotation.x and rotation.y and rotation.z), 'Invalid rotation vector3 provided')

        local object = lib.spawnEntity(model, function(modelHash)
            return CreateObject(modelHash, coords.x, coords.y, coords.z, isNetwork or false, netMissionEntity or false, doorFlag or false)
        end)

        if object == 0 then return 0 end

        if heading then
            SetEntityHeading(object, heading + 0.0)
        end

        if rotation then
            SetEntityRotation(object, rotation.x + 0.0, rotation.y + 0.0, rotation.z + 0.0, 2, true)
        end

        return object
    end
end

return lib.createObject
