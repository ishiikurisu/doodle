local level_view = { }

function level_view.construct(love)
    local self = { }
    local stuff = { "door", "floor", "goal", "item", "person", "player", "wall"  }
    self.sprites = { }

    for _, it in pairs(stuff) do
        self.sprites[it] = love.graphics.newImage("art/" .. it .. ".png")
    end

    return self
end

function level_view.new(love)
    local self = level_view.construct(love)

    -- READING FUNCTIONS
    self.update = function(love)
        return { }
    end

    -- DRAWING FUNCTIONS
    self.draw = function(love, data)
        local side = 32
        local margin = 50

        love.graphics.setBackgroundColor(0, 0, 0)
        for y, line in pairs(data) do
            for x, it in pairs(line) do
                love.graphics.draw(self.sprites["floor"],
                                   margin + x*side, margin + y*side,
                                   0, 1, 1, 0, 0)
                if it ~= "floor" then
                    love.graphics.draw(self.sprites[it],
                                       margin + x*side, margin + y*side,
                                       0, 1, 1, 0, 0)
                end
            end
        end
    end

    return self
end

return level_view
