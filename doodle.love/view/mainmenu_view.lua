local mainmenu_view = { }

function mainmenu_view.new()
    local self = { }

    -- READING FUNCTIONS
    self.update = function(love)
        return { }
    end

    -- DRAWING FUNCTIONS
    self.draw = function(love, data)
        local side = 50
        local chosen = false
        local option = " "

        love.graphics.setBackgroundColor(0, 0, 0)
        for i, box in ipairs(data) do
            chosen = box.chosen
            option = box.option

            if chosen == true then
                love.graphics.setColor(254, 221, 0)
            else
                love.graphics.setColor(248, 247, 240)
            end

            love.graphics.print(option, side, side*i)
        end
    end

    return self
end

return mainmenu_view
