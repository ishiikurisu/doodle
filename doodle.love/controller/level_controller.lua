local level_model = require "model/level_model"
local level_view = require "view/level_view"
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
        
        if self.level.game_over == true then
            return start.new()
        end
        
        self.level = self.level.live(moment)
        for _, action in pairs(self.actions) do
            if action == "escape" then
                love.event.quit()
            else
                self.level = self.level.update(action, moment)
            end
        end
        self.actions = { }
        return self
    end

    -- DRAW FUNCTIONS
    self.draw = function(love)
        love.graphics.print(self.level.draw())
        self.view.draw(love, self.level.tabletop)
    end

    return self
end

return level_controller
