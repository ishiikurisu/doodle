local util = require "util"
local lc = require "level_controller"

function love.load()
    local name = "   joe frank  "
    print("<" .. name .. ">")
    print("<" .. util.chomp(name) .. ">")
    
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
