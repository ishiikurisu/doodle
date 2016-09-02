local mainmenu_view = { }

function mainmenu_view.new()
    local self = { }

    -- READING FUNCTIONS
    self.update = function(love)
        return { }
    end

    -- DRAWING FUNCTIONS
    self.draw = function(love, data)
        love.graphics.print(data)
    end

    return self
end

return mainmenu_view
