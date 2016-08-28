local level_model = require "level_model"
local level_view = require "level_view"
local level_controller = { }

function level_controller.new()
    local this = { }
    this.level = level_model.new("level")
    this.view = level_view.new()

    this.update = function(love)
        return this
    end

    this.draw = function(love)
        love.graphics.print(this.level.draw())
        this.view.draw(love, this.level.tabletop)
    end

    return this
end

return level_controller
