--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---Server-side entity cleanup mode. Used by `SetEntityOrphanMode`.
---@alias EntityOrphanMode
---| 0 # DeleteWhenNotRelevant — default; deletes when no player is relevant.
---| 1 # DeleteOnOwnerDisconnect — deletes when the original owner disconnects.
---| 2 # KeepEntity — never deleted by server relevancy checks.

---Spawn a server-side entity, wait for it to materialize, then apply an orphan mode.
---Used internally by `lib.createObject`, `lib.createPed`, and `lib.createVehicle`.
---@async
---@param assetType string Label used in error messages, e.g. 'object', 'ped', 'vehicle'.
---@param model string | number Model name or precomputed hash.
---@param spawn fun(modelHash: number): number Native spawner returning the entity handle.
---@param orphanMode? EntityOrphanMode Defaults to 2 (KeepEntity).
---@param timeout? number Milliseconds to wait for the entity to exist. Defaults to 5000.
---@return number entity Entity handle, or 0 on failure.
function lib.spawnEntity(assetType, model, spawn, orphanMode, timeout)
    assert(type(model) == 'string' or type(model) == 'number', 'Invalid model provided, expected string or number')
    assert(type(spawn) == 'function', 'Invalid spawn provided, expected function')
    assert(orphanMode == nil or (type(orphanMode) == 'number' and orphanMode >= 0 and orphanMode <= 2), 'Invalid orphanMode provided, expected number between 0 and 2')
    assert(timeout == nil or type(timeout) == 'number', 'Invalid timeout provided, expected number')

    local modelHash = type(model) == 'number' and model or joaat(model)
    local entity = spawn(modelHash)

    if entity == 0 then return 0 end

    -- Spawning can lag in high-population sessions; wait until the entity
    -- actually exists before continuing or giving up.
    local success, err = pcall(lib.waitFor, function()
        if DoesEntityExist(entity) then return true end
    end, ('failed to spawn %s %s'):format(assetType, model), timeout or 5000)

    if not success then
        lib.print.error(err)
        return 0
    end

    SetEntityOrphanMode(entity, orphanMode or 2)

    return entity
end

return lib.spawnEntity
