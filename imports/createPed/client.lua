--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

if cache.game == 'redm' then
    ---**RedM build** — calls the 9-argument `CREATE_PED` native
    ---(`modelHash, x, y, z, heading, isNetwork, bScriptHostPed, p7, p8`).
    ---RedM has no `pedType` parameter.
    ---@param model string | number The model to spawn
    ---@param coords vector3 Spawn coordinate
    ---@param heading? number Heading of the ped
    ---@param isNetwork? boolean Whether to create a network ped. If false, the ped exists only locally.
    ---@param bScriptHostPed? boolean Pin the ped to the script host in the R* network model.
    ---@param p7? boolean Undocumented RedM parameter; passed as `false` if omitted.
    ---@param p8? boolean Undocumented RedM parameter; passed as `false` if omitted.
    lib.createPed = function(model, coords, heading, isNetwork, bScriptHostPed, p7, p8)
        assert(coords and coords.x and coords.y and coords.z, 'Invalid coordinates vector3 provided')
        assert(heading == nil or type(heading) == 'number', 'Invalid heading provided, expected number')
        assert(isNetwork == nil or type(isNetwork) == 'boolean', 'Invalid isNetwork flag provided, expected boolean')
        assert(bScriptHostPed == nil or type(bScriptHostPed) == 'boolean', 'Invalid bScriptHostPed flag provided, expected boolean')
        assert(p7 == nil or type(p7) == 'boolean', 'Invalid p7 flag provided, expected boolean')
        assert(p8 == nil or type(p8) == 'boolean', 'Invalid p8 flag provided, expected boolean')

        local headingValue = heading and heading + 0.0 or 0.0

        return lib.spawnEntity(model, function(modelHash)
            return CreatePed(modelHash, coords.x, coords.y, coords.z, headingValue, isNetwork or false, bScriptHostPed or false, p7 or false, p8 or false)
        end)
    end
else
    ---**GTA5/FiveM build** — calls the 8-argument `CREATE_PED` native
    ---(`pedType, modelHash, x, y, z, heading, isNetwork, bScriptHostPed`).
    ---@param pedType number AI behavior type. 4 = CIVMALE, 5 = CIVFEMALE, etc.
    ---@param model string | number The model to spawn
    ---@param coords vector3 Spawn coordinate
    ---@param heading? number Heading of the ped
    ---@param isNetwork? boolean Whether to create a network ped. If false, the ped exists only locally.
    ---@param bScriptHostPed? boolean Pin the ped to the script host in the R* network model.
    lib.createPed = function(pedType, model, coords, heading, isNetwork, bScriptHostPed)
        assert(type(pedType) == 'number', 'Invalid pedType provided, expected number')
        assert(coords and coords.x and coords.y and coords.z, 'Invalid coordinates vector3 provided')
        assert(heading == nil or type(heading) == 'number', 'Invalid heading provided, expected number')
        assert(isNetwork == nil or type(isNetwork) == 'boolean', 'Invalid isNetwork flag provided, expected boolean')
        assert(bScriptHostPed == nil or type(bScriptHostPed) == 'boolean', 'Invalid bScriptHostPed flag provided, expected boolean')

        local headingValue = heading and heading + 0.0 or 0.0

        return lib.spawnEntity(model, function(modelHash)
            return CreatePed(pedType, modelHash, coords.x, coords.y, coords.z, headingValue, isNetwork or false, bScriptHostPed or false)
        end)
    end
end

return lib.createPed
