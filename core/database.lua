require("Aether.utils")

Database = { class_name = "Database", datas = nil }

require("data.init")

function Database:new(o, w, h)
    o = o or {}
    o.datas = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Database:load(input, path, data)
    data = data or self.datas

    if data[input] == nil then
        data[input] = {}
    end
    require(path)
    config(data[input], self)
end

function Database:get(datapath)
    local ret = self.datas
    local p = datapath:split(".")
    for i = 1, #p, 1 do
        ret = ret[p[i]]
    end
    return ret
end
