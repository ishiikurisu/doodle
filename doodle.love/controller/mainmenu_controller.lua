local level_controller = require "controller/level_controller"
local mainmenu_view = require "view/mainmenu_view"
local mainmenu_controller = { }
mainmenu_controller.__index = mainmenu_controller

function mainmenu_controller:new()
    local c = { }
    setmetatable(c, mainmenu_controller)
    c.born = 0
    c.actions = { }
    c.view = mainmenu_view:new()
    c.index = 1
    c.options = { "new game", "load game", "quit" }
    return c
end

function mainmenu_controller:push(action)
    table.insert(self.actions, action)
    return self
end

function mainmenu_controller:update(dt)
    for _, action in pairs(self.actions) do
        if action == "escape" then
            love.event.quit()
        elseif action == "down" then
            if self.index < #self.options then
                self.index = self.index + 1
            end
        elseif action == "up" then
            if self.index > 1 then
                self.index = self.index - 1
            end
        elseif action == "space" or action == " " then
            local selected = self.options[self.index]
            if selected == "new game" then
                return level_controller:new("level")
            elseif selected == "load game" then
                return level_controller:new("level")
            else -- quit
                love.event.quit()
            end
        end
    end

    self.actions = { }
    return self
end

function mainmenu_controller:draw()
    local data = { }
    local chosen = false

    for i, option in pairs(self.options) do
        if self.index == i then
            chosen = true
        else
            chosen = false
        end
        table.insert(data, { chosen = chosen, option = option })
    end

    self.view:draw(data)
end

return mainmenu_controller
