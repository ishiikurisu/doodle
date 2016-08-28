local util = require "util"
local player_model = { }

function player_model.new(inlet)
    local self = { }
    self = player_model.parse(self, inlet)
    
    -- TODO Add update function
    
    return self
end

function player_model.parse(self, inlet)
    local data = util.split(inlet, " ")
    self.x = tonumber(data[1])
    self.y = tonumber(data[2])
    self.rate = tonumber(data[3])
    return self
end

return player_model