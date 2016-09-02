local gameover_view = { }

function gameover_view.new()
    local self = { }

    self.draw = function(love)
        love.graphics.setBackgroundColor(0, 0, 0)
        love.graphics.setColor(248, 247, 240)
        love.graphics.print("Game over!", 50, 50)
    end

    return self
end

return gameover_view
