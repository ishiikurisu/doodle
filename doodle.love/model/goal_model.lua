local goal_model = {
    x = 0,
    y = 0,
    required_items = 0,
    next_level = ""
}
goal_model.__index = goal_model

function goal_model:new(inlet)
    local m = { }
    local data = util.split(inlet, " ")
    setmetatable(m, goal_model)
    m.x = tonumber(data[1])
    m.y = tonumber(data[2])
    m.required_items = tonumber(data[3])
    m.next_level = data[4]

    return m
end

return goal_model
