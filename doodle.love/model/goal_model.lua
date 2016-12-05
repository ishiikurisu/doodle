local goal_model = { }

function goal_model.construct(inlet)
    local self = { }
    local data = util.split(inlet, " ")

    self.x = tonumber(data[1])
    self.y = tonumber(data[2])
    self.required_items = tonumber(data[3])
    self.next_level = data[4]

    return self
end

function goal_model.new(inlet)
    local self = goal_model.construct(inlet)
    return self
end

return goal_model
