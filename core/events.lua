Events = { class_name = "Events", data = nil }

function Events:new(o)
    o = o or {}
    o.data = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Events:listen(channel, entity, func)
    if self.data[channel] == nil then
        self.data[channel] = {}
    end
    if self.data[channel][entity] == nil then
        self.data[channel][entity] = {}
    end
    table.insert(self.data[channel][entity], func)
end

function Events:invoke(channel, args)
    if self.data[channel] == nil then
        return
    end
    for key, value in pairs(self.data[channel]) do
        for k, v in pairs(value) do
            v(key, args)
        end
    end
end

function Events:deafen(channel, entity, func)
    if self.data[channel] == nil then
        return
    end
    if self.data[channel][entity] == nil then
        return
    end
    local found, key = table.contains(self.data[channel][entity], func)
    if found then
        table.remove(self.data[channel][entity], key)
    end
end

function Events:remove(channel, entity)
    if self.data[channel] == nil then
        return
    end
    local found, key = table.contains(self.data[channel], entity)
    if found then
        table.remove(self.data[channel], key)
    end
end

function Events:removeAll(entity)
    for key, value in pairs(self.data) do
        local found, index = table.contains(value, entity)
        if found then
            table.remove(value, index)
        end
    end
end

function Events:reset()
    self.data = {}
end
