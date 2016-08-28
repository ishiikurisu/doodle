local level_model = { }

function level_model.new(name)
    local this = { }
    this.tabletop = level_model.load(name)

    this.draw = function()
        return this.tabletop
    end

    return this
end

function level_model.load(name)
    local path = "assets/" .. name .. ".txt"
    return path
end

return level_model
