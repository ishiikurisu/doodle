local player_model = require "player_model"
local util = require "util"
local level_model = { }

function level_model.new(name)
    local self = { }
    self.raw_data = level_model.load(name)
    self.tabletop = level_model.parse(self.raw_data)
    self.player = level_model.find_player(self)

    -- UPDATING FUNCTIONS
    self.update = function(act)
        local dx = 0
        local dy = 0
        local ly = #self.tabletop
        local lx = #(self.tabletop[1])

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
        if self.is_action_possible(self.player.x, self.player.y, dx, dy, lx, ly) then
            self.tabletop[self.player.y][self.player.x] = "floor"
            self.tabletop[self.player.y+dy][self.player.x+dx] = "player"
            self.player.y = self.player.y + dy
            self.player.x = self.player.x + dx
        end

        return self
    end

    self.is_action_possible = function(x, y, dx, dy, lx, ly)
        local outlet = true

        outlet = outlet and (x + dx > 0)
        outlet = outlet and (x + dx <= lx)
        outlet = outlet and (y + dy > 0)
        outlet = outlet and (y + dy <= ly)
        outlet = outlet and (self.tabletop[y+dy][x+dx] == "floor")

        return outlet
    end

    -- DRAWING FUNCTIONS
    self.draw = function()
        local outlet = ""

        for _, line in ipairs(self.tabletop) do
            for _, it in pairs(line) do
                outlet = outlet .. it .. " "
            end
            outlet = outlet .. "\n"
        end

        return outlet
    end

    return self
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

function level_model.find_player(self)
    local player = { }

    for j, line in ipairs(self.tabletop) do
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
