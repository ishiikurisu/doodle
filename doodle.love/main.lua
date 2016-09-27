util = require "util"
start = require "controller/mainmenu_controller"

function love.load()
    love.window.setTitle("Example stuff") -- TODO move this to conf.lua
    controller = start.new()
    controller.born = love.timer.getTime()
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
