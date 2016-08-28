local player_model = require "player_model"
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
        local x = self.player.x
        local y = self.player.y
        local ly = self.dimensions.y
        local lx = self.dimensions.x
        dx, dy = self.act_to_effect(act)
        if (act == "left") or (act == "right") or (act == "up") or (act == "down") then
            self.direction = act
        elseif act == "space" or act == " " then
            self.pickup_item()
        end

        -- Applying changes if possible
        if self.is_in_bounds(x, y, dx, dy, lx, ly) and self.tabletop[y+dy][x+dx] == "floor" then
            self.tabletop[y][x] = "floor"
            self.tabletop[y+dy][x+dx] = "player"
            self.player.y = y + dy
            self.player.x = x + dx
        end

        return self
    end

    self.act_to_effect = function(act)
        local dx = 0
        local dy = 0

        return dx, dy
    end

    self.pickup_item = function()
        local dx = 0
        local dy = 0
        local x = self.player.x
        local y = self.player.y

        dx, dy = self.act_to_effect(self.direction)
        if self.is_in_bounds(x, y, dx, dy, self.dimensions.x, self.dimensions.y) then
            if self.tabletop[y+dy][x+dx] == "item" then
                table.insert(self.items, "item")
                self.tabletop[y+dy][x+dx] = "floor"
            end
    self.is_in_bounds = function(x, y, dx, dy, lx, ly)
        local fact = true

        fact = fact and (x + dx > 0)
        fact = fact and (x + dx <= lx)
        fact = fact and (y + dy > 0)
        fact = fact and (y + dy <= ly)

        return fact
    -- #####################
    -- # DRAWING FUNCTIONS #
    -- #####################
    self.draw = function()
        for _, line in ipairs(self.tabletop) do
    return self
-- #########################
-- # CONSTRUCTOR FUNCTIONS #
-- #########################
    -- Reading and parsing every line
        table.insert(outlet, { stuff[1], stuff[2] } )
    local dx = 0
    local dy = 0

    -- Get dimensions
    for _, box in pairs(raw) do
        if box[1] == "x" then
            dx = tonumber(box[2])
        elseif box[1] == "y" then
            dy = tonumber(box[2])
        end
    end
    for _ = 1, dy do
        for _ = 1, dx do

    -- Place stuff
    for _, box in pairs(raw) do
        if (box[1] ~= "x") and (box[1] ~= "y") then
            -- parse location
            line = util.split(box[2], " ")
            dx = tonumber(line[1])
            dy = tonumber(line[2])
            -- store thing in memory
            tabletop[dy][dx] = box[1]
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
