local gameover_controller = require "controller/gameover_controller"
local level_model = require "model/level_model"
local level_view = require "view/level_view"
local level_controller = {
    actions = { },
    level = nil,
    view = nil,
    born = 0
}
level_controller.__index = level_controller

function level_controller:new(inlet)
    local c = { }
    setmetatable(c, level_controller)
    c.level = level_model:new(inlet)
    c.view = level_view:new(love)
    return c
end

function level_controller:push(action)
    table.insert(self.actions, action)
    return self
end

function level_controller:update(dt)
    self.born = self.born + dt

    if self.level.game_over == true then
        local next_level = self.level.next_level
        local next_controller = gameover_controller:new()

        if next_level ~= nil then
            next_controller = level_controller:new(love, next_level)
        end

        return next_controller
    end

    self.level = self.level:live(self.born)
    for _, action in pairs(self.actions) do
        if action == "escape" then
            love.event.quit()
        else
            self.level = self.level:update(action, self.born)
        end
    end

    self.actions = { }
    return self
end

-- DRAW FUNCTIONS
function level_controller:draw()
    -- love.graphics.print(self.level.draw())
    self.view.draw(love, self.level:create_board())
end

return level_controller
