local util = require "util"
local name = "  joe frank    "
print("<" .. name .. ">")
local eaten = util.chomp(name)
print("<" .. eaten .. ">")
