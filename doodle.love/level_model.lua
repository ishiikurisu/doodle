local util = require "util"
local level_model = { }

function level_model.new(name)
    local this = { }
    this.raw_data = level_model.load(name)
    this.tabletop = level_model.parse(this.raw_data)
    this.player = level_model.find_player(this)

    -- UPDATING FUNCTIONS
    this.update = function(act)
        local dx = 0
        local dy = 0
        local ly = #this.tabletop
        local lx = #(this.tabletop[1])

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
            this.tabletop[this.player.y][this.player.x] = "floor"
            this.tabletop[this.player.y+dy][this.player.x+dx] = "player"
            this.player.y = this.player.y + dy
            this.player.x = this.player.x + dx
        end

        return this
    end

    this.is_action_possible = function(x, y, dx, dy, lx, ly)
        local outlet = true

        outlet = outlet and (x + dx > 0)
        outlet = outlet and (x + dx <= lx)
        outlet = outlet and (y + dy > 0)
        outlet = outlet and (y + dy <= ly)
        outlet = outlet and (this.tabletop[y+dy][x+dx] == "floor")

        return outlet
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
    local path = "assets/" .. name .. ".yml"
    local fh = io.open(path)
    local raw = fh:read("*line")
    local outlet = { }

    raw = fh:read("*line")
    while raw ~= "..." do
        stuff = util.split(raw, ":")
        outlet[stuff[1]] = stuff[2]
        raw = fh:read("*line")
    end

    fh:close()
    return outlet
end

function level_model.parse(raw)
    local tabletop = { }
    local dx = tonumber(raw["x"])
    local dy = tonumber(raw["y"])
    local line = { }
    local data = " "

    -- placing floor everywheres
    for y = 1, dy do
        line = { }
        for x = 1, dx do
            table.insert(line, "floor")
        end
        table.insert(tabletop, line)
    end
    raw["x"] = nil
    raw["y"] = nil

    -- placing the rest of stuff
    for it, raw_data in pairs(raw) do
        data = util.split(raw_data, " ")
        dx = tonumber(data[1])
        dy = tonumber(data[2])
        tabletop[dy][dx] = it
    end

    return tabletop
end

function level_model.find_player(this)
    local player = { }

    for j, line in ipairs(this.tabletop) do
        for i, it in ipairs(line) do
            if it == "player" then
                player.x = i
                player.y = j
            end
        end
    end

    return player
end

return level_model
