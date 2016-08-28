local util = require "util"
local lc = require "level_controller"

function love.load()
    love.window.setTitle("Example stuff")
    controller = lc.new("level")
end

function love.keyreleased(key)
    controller.push(key)
end

function love.update()
    controller = controller.update(love)
end

function love.draw()
    controller.draw(love)
end
