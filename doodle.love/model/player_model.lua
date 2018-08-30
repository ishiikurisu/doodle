local player_model = { }
player_model.__index = player_model

function player_model:new(inlet)
    local m = { }
    local data = util.split(inlet, " ")
    setmetatable(m, player_model)

    m.x = tonumber(data[1])
    m.y = tonumber(data[2])
    m.direction = "down"
    m.items = { }

    return m
end

function player_model:walk(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function player_model:give_item(item)
    table.insert(self.items, item)
end

function player_model:set_direction(direction)
    self.direction = direction
end

function player_model:count_items()
    return #self.items
end

function player_model:draw()
    return "player_" .. self.direction
end

return player_model
