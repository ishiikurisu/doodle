local util = require "util"
local level_model = { }

function level_model.new(name)
    local this = { }
    this.tabletop = level_model.load(name)
    this.player = { }
    this.player.x = 0
    this.player.y = 0

    -- UPDATING FUNCTIONS
    this.update = function(act)
        local dx = 0
        local dy = 0
        local ly = #this.tabletop
        local lx = #(this.tabletop[1])

        -- Discovering where the player is
        for j, line in ipairs(this.tabletop) do
            for i, it in ipairs(line) do
                if it == "u" then
                    this.player.x = i
                    this.player.y = j
                end
            end
        end

        -- Turning actions into side effects
        if act == "up" then
            dy = -1
        elseif act == "down" then
            dy = 1
        elseif act == "left" then
            dx = -1
        elseif act == "right" then
            dx = 1
        end

        -- Applying changes if possible
        if this.is_action_possible(this.player.x, this.player.y, dx, dy, lx, ly) then
            this.tabletop[this.player.y][this.player.x] = "f"
            this.tabletop[this.player.y+dy][this.player.x+dx] = "u"
        end

        return this
    end

    this.is_action_possible = function(x, y, dx, dy, lx, ly)
        c1 = x + dx > 0
        c2 = x + dx <= lx
        c3 = y + dy > 0
        c4 = y + dy <= ly
        return c1 and c2 and c3 and c4
    end

    -- DRAWING FUNCTIONS
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
    local raw = fh:read("*line")
    local splitted = util.split(raw, " ")
    local y = tonumber(splitted[1])
    local x = tonumber(splitted[2])
    local stuff = { }
    local tabletop = { }

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
