local level_model = require "level_model"
local level_view = require "level_view"
local level_controller = { }

function level_controller.new(inlet)
    local self = { }
    self.actions = { }
    self.level = level_model.new(inlet)
    self.view = level_view.new()
    self.born = 0

    -- UPDATE FUNCTIONS
    self.push = function(action)
        table.insert(self.actions, action)
        return self
    end

    self.update = function(love)
        local moment = love.timer.getTime() - self.born
        
        self.level = self.level.live(moment)
        for _, action in pairs(self.actions) do
            if action == "escape" then
                love.event.quit()
            end
            self.level = self.level.update(action, moment)
        end
        self.actions = { }
        return self
    end

    -- DRAWING FUNCTIONS
    self.draw = function(love)
        love.graphics.print(self.level.draw())
        self.view.draw(love, self.level.tabletop)
    end

    return self
end

return level_controller
