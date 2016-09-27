local player_model = { }

function player_model.new(inlet)
    local self = { }
    self.x, self.y = player_model.parse(inlet)
    self.direction = "down"
    self.items = { }

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

    return self
end

function player_model.parse(inlet)
    local data = util.split(inlet, " ")
    local x = tonumber(data[1])
    local y = tonumber(data[2])
    return x, y
end

return player_model
