local gameover_controller = require "controller/gameover_controller"
local level_model = require "model/level_model"
local level_view = require "view/level_view"
local level_controller = { }

function level_controller.new(love, inlet)
    local self = { }
    self.actions = { }
    self.level = level_model.new(inlet)
    self.view = level_view.new(love)
    self.born = 0

    -- UPDATE FUNCTIONS
    self.push = function(action)
        table.insert(self.actions, action)
        return self
    end

    self.update = function(love, dt)
        self.born = self.born + dt

        if self.level.game_over == true then
            return gameover_controller.new()
        end

        self.level = self.level.live(self.born)
        for _, action in pairs(self.actions) do
            if action == "escape" then
                love.event.quit()
            else
                self.level = self.level.update(action, self.born)
            end
        end

        self.actions = { }
        return self
    end

    -- DRAW FUNCTIONS
    self.draw = function(love)
        -- love.graphics.print(self.level.draw())
        self.view.draw(love, self.level.create_board())
    end

    return self
end

return level_controller
