local lc = require "level_controller"

function love.load()
    controller = lc.new()
end

function love.update()
    controller = controller.update(love)
end

function love.draw()
    controller.draw(love)
end
