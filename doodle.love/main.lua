util = require "util"
start = require "controller/mainmenu_controller"

function love.load()
    love.window.setTitle("Example stuff") -- TODO move this to conf.lua
    controller = start:new()
end

function love.keyreleased(key)
    controller:push(key)
end

function love.update(dt)
    controller = controller:update(dt)
end

function love.draw()
    controller:draw()
end
