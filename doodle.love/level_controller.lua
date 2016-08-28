local level_model = require "level_model"
local level_view = require "level_view"
local level_controller = { }

function level_controller.new()
    local this = { }
    this.actions = { }
    this.level = level_model.new("level")
    this.view = level_view.new()

    -- UPDATE FUNCTIONS
    this.push = function(action)
        table.insert(this.actions, action)
        return this
    end

    this.update = function(love)
        for _, action in pairs(this.actions) do
            this.level = this.level.update(action)
        end
        this.actions = { }
        return this
    end

    -- DRAWING FUNCTIONS
    this.draw = function(love)
        love.graphics.print(this.level.draw())
        this.view.draw(love, this.level.tabletop)
    end

    return this
end

return level_controller
