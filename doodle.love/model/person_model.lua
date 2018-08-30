local person_model = {
    x = 0,
    y = 0,
    rate = 1,
    last_moment = 0
}
person_model.__index = person_model

function person_model:new(inlet)
    local m = { }
    local data = util.split(inlet, " ")
    setmetatable(m, person_model)
    m.x = tonumber(data[1])
    m.y = tonumber(data[2])
    m.rate = tonumber(data[3])
    return m
end

-- ####################
-- # UPDATE FUNCTIONS #
-- ####################
function person_model:is_update_time(moment)
    local fact = false
    local wait = moment - self.last_moment

    if (wait > self.rate) and (self.rate > 0) then
        fact = true
        self.last_moment = moment
    end

    return fact
end

function person_model:get_direction()
    local directions = { "left", "right", "up", "down" }
    return directions[love.math.random(1, 4)]
end

function person_model:walk(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

return person_model
