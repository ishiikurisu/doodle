local util = require "util"
local door_model = { }

function door_model.new(inlet)
    local self = door_model.construct(inlet)
    self.last_place = nil
    return self
end

function door_model.construct(inlet)
    local self = { }
    local data = util.split(util.chomp(inlet), " ")

    self.x = tonumber(data[1])
    self.y = tonumber(data[2])
    self.destiny = data[3]

    return self
end

return door_model
