local util = require "util"
local level_model = { }

function level_model.new(name)
    local this = { }
    this.tabletop = level_model.load(name)

    this.draw = function()
        local outlet = ""

        for _, line in ipairs(this.tabletop) do
            for _, it in pairs(line) do
                outlet = outlet .. it .. " "
            end
            outlet = outlet .. "\n"
        end

        return outlet
    end

    return this
end

function level_model.load(name)
    local path = "assets/" .. name .. ".txt"
    local fh = io.open(path)
    local x = 1
    local y = 1
    local raw = fh:read("*line")
    local splitted = util.split(raw, " ")
    local stuff = { }
    local tabletop = { }
    y = tonumber(splitted[1])
    x = tonumber(splitted[2])

    for j = 1, y do
        raw = fh:read("*line")
        splitted = util.split(raw, " ")
        stuff = { }

        for i = 1, x do
            table.insert(stuff, splitted[i])
        end
        table.insert(tabletop, stuff)
    end

    fh:close()
    return tabletop
end

return level_model
