local gameover_controller = require "controller/gameover_controller"
local level_model = require "model/level_model"
local level_view = require "view/level_view"
local level_controller = { }
level_controller.__index = level_controller

function level_controller:new(inlet)
    local c = { }
    setmetatable(c, level_controller)
    c.actions = { }
    c.born = 0
    c.level = level_model:new(inlet)
    c.view = level_view:new()
    return c
end

function level_controller:push(action)
    table.insert(self.actions, action)
    return self
end

function level_controller:update(dt)
    self.born = self.born + dt
    local next_controller = self

    if self.level.game_over == true then
        local next_level = self.level.next_level
        if next_level ~= nil and #next_level > 0 then
            next_controller = level_controller:new(next_level)
        end
    else
        next_controller.level:live(self.born)
        for _, action in pairs(next_controller.actions) do
            if action == "escape" then
                love.event.quit()
            else
                next_controller.level = self.level:update(action, self.born)
            end
        end
        next_controller.actions = { }
    end

    return next_controller
end

-- DRAW FUNCTIONS
function level_controller:draw()
    -- love.graphics.print(self.level:draw())
    self.view:draw(self.level:create_board())
end

return level_controller
