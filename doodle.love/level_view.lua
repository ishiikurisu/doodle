local level_view = { }

function level_view.new()
    local this = { }

    -- READING FUNCTIONS
    this.update = function(love)
        local possible = { "up", "down", "left", "right" }
        local actions = { }

        for _, action in pairs(possible) do
            -- TODO change to key release
            if love.keyboard.isDown(action) then
                table.insert(actions, action)
            end
        end

        return actions
    end

    -- DRAWING FUNCTIONS
    this.draw = function(love, data)
        local side = 50
        local off = 100

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
                love.graphics.rectangle("fill", off + x*side, off + y*side, side - 10, side - 10)
            end
        end
    end

    return this
end

return level_view
