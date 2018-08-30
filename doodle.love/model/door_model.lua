local door_model = {
    last_place = nil,
    x = 0,
    y = 0,
    destiny = ""
}
door_model.__index = door_model

function door_model:new(inlet)
    local m = {}
    setmetatable(m, door_model)
    local data = util.split(util.chomp(inlet), " ")
    m.x = tonumber(data[1])
    m.y = tonumber(data[2])
    m.destiny = data[3]
    return m
end

return door_model
