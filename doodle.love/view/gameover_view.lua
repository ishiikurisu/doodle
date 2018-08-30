local gameover_view = { }
gameover_view.__index = gameover_view

function gameover_view:new()
    local v = {}
    setmetatable(v, gameover_view)
    return v
end

function gameover_view:draw()
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setColor(248, 247, 240)
    love.graphics.print("Game over!", 50, 50)
end


return gameover_view
