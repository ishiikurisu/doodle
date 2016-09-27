local player_model = { }

function player_model.construct(inlet)
    local self = { }
    local data = util.split(inlet, " ")

    self.x = tonumber(data[1])
    self.y = tonumber(data[2])
    self.direction = "down"
    self.items = { }

    return self
end

function player_model.new(inlet)
    local self = player_model.construct(inlet)

    self.walk = function(dx, dy)
        self.x = self.x + dx
        self.y = self.y + dy
    end

    self.give_item = function(item)
        table.insert(self.items, item)
    end

    self.set_direction = function(direction)
        self.direction = direction
    end

    self.count_items = function()
        return #self.items
    end

    self.draw = function()
        return "player_" .. self.direction
    end

    return self
end

return player_model
