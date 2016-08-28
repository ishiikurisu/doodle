local player_model = require "player_model"
local util = require "util"
local level_model = { }

function level_model.new(name)
    local self = { }
    self.raw_data = level_model.load(name)
    self.tabletop = level_model.parse(self.raw_data)
    self.dimensions = level_model.find_dimensions(self)
    self.player = level_model.find_player(self)
    self.direction = "right" -- TODO Create a player object and add this to their state
    self.items = { } -- TODO Create a player object and add this to their state

    -- ######################
    -- # UPDATING FUNCTIONS #
    -- ######################
    self.update = function(act)
        local dx = 0
        local dy = 0
        local ly = self.dimensions.y
        local lx = self.dimensions.x

        -- Turning actions into side effects
        dx, dy = self.act_to_effect(act)
        if (act == "left") or (act == "right") or (act == "left") or (act == "right") then
            self.direction = act
        elseif act == "space" or act == " " then
            self.pickup_item()
        end

        -- Applying changes if possible
        if self.is_walking_possible(self.player.x, self.player.y, dx, dy, lx, ly) then
            self.tabletop[self.player.y][self.player.x] = "floor"
            self.tabletop[self.player.y+dy][self.player.x+dx] = "player"
            self.player.y = self.player.y + dy
            self.player.x = self.player.x + dx
        end

        return self
    end

    self.act_to_effect = function(act)
        local dx = 0
        local dy = 0

        if act == "up" then
            dy = -1
        elseif act == "down" then
            dy = 1
        elseif act == "left" then
            dx = -1
        elseif act == "right" then
            dx = 1
        end

        return dx, dy
    end

    self.pickup_item = function()
        local dx = 0
        local dy = 0
        local x = self.player.x
        local y = self.player.y

        dx, dy = self.act_to_effect(self.direction)
        if self.tabletop[y+dy][x+dx] == "item" then
            table.insert(self.items, "item")
            self.tabletop[y+dy][x+dx] = "floor"
        end

    end

    self.is_walking_possible = function(x, y, dx, dy, lx, ly)
        local fact = true

        fact = fact and (x + dx > 0)
        fact = fact and (x + dx <= lx)
        fact = fact and (y + dy > 0)
        fact = fact and (y + dy <= ly)
        fact = fact and (self.tabletop[y+dy][x+dx] == "floor")

        return fact
    end

    -- #####################
    -- # DRAWING FUNCTIONS #
    -- #####################
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

-- #########################
-- # CONSTRUCTOR FUNCTIONS #
-- #########################
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

function level_model.find_dimensions(self)
    local dimensions = { }
    dimensions.y = #self.tabletop
    dimensions.x = #(self.tabletop[1])
    return dimensions
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
