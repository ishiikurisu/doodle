local level_controller = require "controller/level_controller"
local mainmenu_view = require "view/mainmenu_view"
local mainmenu_controller = {
    born = 0,
    actions = { },
    view = mainmenu_view:new(),
    index = 0,
    options = { "new game", "load game", "quit" }
}

function mainmenu_controller:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function mainmenu_controller:push(action)
    table.insert(self.actions, action)
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

    self.view:draw(love, data)
end

return mainmenu_controller
