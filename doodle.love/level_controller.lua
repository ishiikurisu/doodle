local level_model = require "level_model"
local level_controller = { }

function level_controller.new()
    local this = { }
    this.level = level_model.new("level")

    this.update = function()
        return this
    end

    this.draw = function(love)
        love.graphics.print(this.level.draw())
    end

    return this
end

return level_controller
