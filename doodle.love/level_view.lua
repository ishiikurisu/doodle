local level_view = { }

function level_view.new()
    local this = { }

    -- READING FUNCTIONS
    this.update = function(love)
        return { }
    end

    -- DRAWING FUNCTIONS
    this.draw = function(love, data)
        local side = 50
        local off = 10
        local margin = 10

        love.graphics.setBackgroundColor(0, 0, 0)
        for y, line in pairs(data) do
            for x, it in pairs(line) do
                if it == "w" then -- wall
                    love.graphics.setColor(15, 16, 17)
                elseif it == "u" then -- player
                    love.graphics.setColor(150, 58, 30)
                elseif it == "p" then -- npc
                    love.graphics.setColor(20, 159, 200)
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

    return this
end

return level_view
