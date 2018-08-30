local gameover_view = require "view/gameover_view"
local gameover_controller = { }
gameover_controller.__index  = gameover_controller

function gameover_controller:new()
    local c = { }
    setmetatable(c, gameover_controller)
    c.actions = { }
    c.view = gameover_view:new()
    return c
end

function gameover_controller:push(action)
    table.insert(self.actions, action)
    return self
end

function gameover_controller:update(dt)
    for _, action in pairs(self.actions) do
        if action == "space" or action == " " then
            return start:new()
        end
    end

    self.actions = { }
    return self
end

function gameover_controller:draw()
    self.view:draw()
end

return gameover_controller
