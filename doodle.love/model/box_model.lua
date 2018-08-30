local box_model = { }
box_model.__index = box_model

function box_model:new()
    local m = { }
    setmetatable(m, box_model)
    return m
end

return box_model
