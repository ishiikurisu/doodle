local gameover_view = require "view/gameover_view"
local gameover_controller = {
    actions = { },
    view = gameover_view:new()
}
gameover_controller.__index  = gameover_controller

function gameover_controller:new(c)
    c = c or {}
    setmetatable(c, gameover_controller)
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
