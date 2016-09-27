local gameover_view = require "view/gameover_view"
local gameover_controller = { }

function gameover_controller.construct()
    local self = { }

    self.actions = { }
    self.view = gameover_view.new()

    return self
end

function gameover_controller.new()
    local self = gameover_controller.construct()

    self.push = function(action)
        table.insert(self.actions, action)
        return self
    end

    self.update = function(love, dt)
        for _, action in pairs(self.actions) do
            if action == "space" or action == " " then
                return start.new()
            end
        end

        self.actions = { }
        return self
    end

    self.draw = function(love)
        self.view.draw(love)
    end

    return self
end

return gameover_controller
