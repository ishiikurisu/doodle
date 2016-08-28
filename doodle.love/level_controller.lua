local level_model = require "level_model"
local level_view = require "level_view"
local level_controller = { }

function level_controller.new()
    local this = { }
    this.level = level_model.new("level")
    this.view = level_view.new()

    this.update = function(love)
        local actions = this.view.update(love)
        local act = " "

        for _, action in pairs(actions) do
            act = action
        end

        if act == "down" then
            love.graphics.setColor(20, 159, 200)
        elseif act == "up" then
            love.graphics.setColor(50, 0, 150)
        elseif act == "left" then
            love.graphics.setColor(70, 159, 100)
        elseif act == "right" then
            love.graphics.setColor(150, 159, 50)
        else
            love.graphics.setColor(200, 200, 200)
        end

        this.level = this.level.update(act)
        return this
    end

    this.draw = function(love)
        love.graphics.print(this.level.draw())
        this.view.draw(love, this.level.tabletop)
    end

    return this
end

return level_controller
