local level_view = { }

function level_view.new()
    local self = { }

    -- READING FUNCTIONS
    self.update = function(love)
        return { }
    end

    -- DRAWING FUNCTIONS
    self.draw = function(love, data)
        local side = 50
        local off = 100
        local margin = 10

        love.graphics.setBackgroundColor(0, 0, 0)
        for y, line in pairs(data) do
            for x, it in pairs(line) do
                if it == "wall" then
                    love.graphics.setColor(15, 16, 17)
                elseif it == "player" then
                    love.graphics.setColor(150, 58, 30)
                elseif it == "person" then
                    love.graphics.setColor(20, 159, 200)
                elseif it == "item" then
                    love.graphics.setColor(0, 171, 132)
                elseif it == "door" then
                    love.graphics.setColor(157, 120, 76)
                else -- floor
                    love.graphics.setColor(248, 247, 240)
                end
                love.graphics.rectangle("fill",
                                        off + x*side,
                                        off + y*side,
                                        side - margin,
                                        side - margin)
            end
        end
    end

    return self
end

return level_view
