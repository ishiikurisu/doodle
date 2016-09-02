local level_controller = require "controller/level_controller"
local mainmenu_view = require "view/mainmenu_view"
local mainmenu_controller = { }

function mainmenu_controller.construct()
    local self = { }
    
    self.born = 0
    self.actions = { }
    self.view = mainmenu_view.new()
    self.index = 1
    self.options = { "new game", "load game", "quit" }
    
    return self
end

function mainmenu_controller.new()
    local self = mainmenu_controller.construct()
    
    -- ####################
    -- # UPDATE FUNCTIONS #
    -- ####################
    self.push = function(action)
        table.insert(self.actions, action)
    end
    
    self.update = function(love)
        local selected = "quit"
        
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
                selected = self.options[self.index]
                if selected == "new game" then
                    return level_controller.new("level")
                elseif selected == "load game" then
                    return level_controller.new("level")
                else -- quit
                    love.event.quit()
                end
            end
        end
        
        return self
    end
    
    -- ##################
    -- # DRAW FUNCTIONS #
    -- ##################
    self.draw = function(love)
        local data = { }
        local chosen = false
        
        for i, option in ipairs(self.options) do
            if self.index == i then
                chosen = true
            else
                chosen = false
            end
            table.insert(data, { chosen = chosen, option = option })
        end
        
        self.view.draw(love, data)
    end
    
    return self
end

return mainmenu_controller