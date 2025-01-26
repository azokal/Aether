require("Aether.utils")

---Database is Class used to preload data and storage data during the game runtime
---@class Database
---@field public class_name string The class name
---@field public datas table? The data storage
Database = { class_name = "Database", datas = nil }

---Add the init function to Database
require("Aether.data.init")

---Database constructor
---@param o table? Table model used for the copy
---@return Database database The Database instance
function Database:new(o)
    o = o or {}
    o.datas = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---Load a new file in Database
---@param input string Prefix for the key
---@param path string File's path to load
---@param data table? Append new data to his data
function Database:load(input, path, data)
    local d = data or self.datas

    if d[input] == nil then
        d[input] = {}
    end
    require(path)
    config(d[input], self)
end

---Get data from specified datapath
---@param datapath string Datapath with "." separator
---@return any data The specified data
function Database:get(datapath)
    ---@type table
    local ret = self.datas
    local p = datapath:split(".")
    for i = 1, #p, 1 do
        ret = ret[p[i]]
    end
    return ret
end

return Database
