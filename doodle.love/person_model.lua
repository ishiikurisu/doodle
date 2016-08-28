local util = require "util"
local player_model = { }

function player_model.new(inlet)
    local self = { }
    self = player_model.parse(self, inlet)
    
    -- ######################
    -- # UPDATING FUNCTIONS #
    -- ######################
    self.is_update_time = function(moment)
        local fact = false
        
        if moment - self.last_moment > self.rate then
            fact = true
            self.last_moment = moment
        end
        
        return fact
    end
    
    self.get_direction = function()
        local directions = { "left", "right", "up", "down" }
        return directions[love.math.random(1, 4)]
    end
    
    self.walk = function(dx, dy)
        self.x = self.x + dx
        self.y = self.y + dy
    end
    
    return self
end

function player_model.parse(self, inlet)
    local data = util.split(inlet, " ")
    self.x = tonumber(data[1])
    self.y = tonumber(data[2])
    self.rate = tonumber(data[3])
    self.last_moment = 0
    return self
end

return player_model