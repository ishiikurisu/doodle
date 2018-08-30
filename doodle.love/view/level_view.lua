local level_view = {
    sprites = { }
}
level_view.__index = level_view

function level_view:new()
    local v = { }
    setmetatable(v, level_view)

    for it in love.filesystem.lines("art/assets.txt") do
        v.sprites[it] = love.graphics.newImage("art/" .. it .. ".png")
    end

    return v
end


-- READING FUNCTIONS
function level_view:update()
    return { }
end

-- DRAWING FUNCTIONS
function level_view:draw(data)
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

return level_view
