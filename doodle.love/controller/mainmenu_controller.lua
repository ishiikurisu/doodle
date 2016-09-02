local level_controller = require "controller/level_controller"
local mainmenu_view = require "view/mainmenu_view"
local mainmenu_controller = { }

function mainmenu_controller.construct()
    local self = { }
    
    self.born = 0
    self.actions = { }
    self.view = mainmenu_view.new()
    self.index = 1
    
    return self
end

function mainmenu_controller.new()
    local self = mainmenu_controller.construct()
    
    self.push = function(action)
        table.insert(self.actions, action)
    end
    
    self.update = function(love)
        for _, action in pairs(self.actions) do
            if action == "escape" then
                love.event.quit()
            elseif action == "z" then
                return level_controller.new("level")
            end
        end
        
        return self
    end
    
    self.draw = function(love)
        self.view.draw(love, "Hello Joe!")
    end
    
    return self
end

return mainmenu_controller