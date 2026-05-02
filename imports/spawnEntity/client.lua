--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---Load `model`, run `spawn` to create the entity, then release the model.
---Used internally by `lib.createObject`, `lib.createPed`, and `lib.createVehicle`.
---@async
---@param model string | number Model name or precomputed hash.
---@param spawn fun(modelHash: number): number Native spawner returning the entity handle.
---@param timeout? number Milliseconds to wait for the model to load. Defaults to 10000.
---@return number entity Entity handle, or 0 on failure.
function lib.spawnEntity(model, spawn, timeout)
    assert(type(model) == 'string' or type(model) == 'number', 'Invalid model provided, expected string or number')
    assert(type(spawn) == 'function', 'Invalid spawn provided, expected function')
    assert(timeout == nil or type(timeout) == 'number', 'Invalid timeout provided, expected number')

    local modelHash = lib.requestModel(model, timeout or 10000)
    local entity = spawn(modelHash)

    SetModelAsNoLongerNeeded(modelHash)

    if entity == 0 or not DoesEntityExist(entity) then return 0 end

    return entity
end

return lib.spawnEntity
